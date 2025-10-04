-- Function tìm kiếm sản phẩm bằng vector similarity
CREATE OR REPLACE FUNCTION ai_search.search_products_by_image(
    query_embedding vector(512),
    similarity_threshold float DEFAULT 0.7,
    limit_count integer DEFAULT 20
)
RETURNS TABLE (
    product_id UUID,
    image_id UUID,
    similarity_score float,
    product_name VARCHAR,
    image_url TEXT,
    price DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.id as product_id,
        pi.id as image_id,
        1 - (ie.embedding <=> query_embedding) as similarity_score,
        p.name as product_name,
        pi.image_url,
        COALESCE(p.sale_price, p.base_price) as price
    FROM ai_search.image_embeddings ie
    JOIN products.product_images pi ON ie.image_id = pi.id
    JOIN products.products p ON pi.product_id = p.id
    WHERE p.status = 'active'
    AND 1 - (ie.embedding <=> query_embedding) >= similarity_threshold
    ORDER BY ie.embedding <=> query_embedding
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- Function tìm kiếm hybrid (text + image)
CREATE OR REPLACE FUNCTION ai_search.hybrid_search(
    text_query TEXT DEFAULT NULL,
    image_embedding vector(512) DEFAULT NULL,
    text_weight float DEFAULT 0.5,
    image_weight float DEFAULT 0.5,
    limit_count integer DEFAULT 20
)
RETURNS TABLE (
    product_id UUID,
    product_name VARCHAR,
    combined_score float,
    image_url TEXT,
    price DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    WITH text_scores AS (
        SELECT 
            te.product_id,
            1 - (te.embedding <=> text_query::vector) as text_score
        FROM ai_search.text_embeddings te
        WHERE text_query IS NOT NULL
    ),
    image_scores AS (
        SELECT 
            pi.product_id,
            MAX(1 - (ie.embedding <=> image_embedding)) as image_score,
            pi.image_url
        FROM ai_search.image_embeddings ie
        JOIN products.product_images pi ON ie.image_id = pi.id
        WHERE image_embedding IS NOT NULL
        GROUP BY pi.product_id, pi.image_url
    )
    SELECT 
        p.id as product_id,
        p.name as product_name,
        (COALESCE(ts.text_score, 0) * text_weight + 
         COALESCE(ims.image_score, 0) * image_weight) as combined_score,
        ims.image_url,
        COALESCE(p.sale_price, p.base_price) as price
    FROM products.products p
    LEFT JOIN text_scores ts ON p.id = ts.product_id
    LEFT JOIN image_scores ims ON p.id = ims.product_id
    WHERE p.status = 'active'
    AND (ts.text_score IS NOT NULL OR ims.image_score IS NOT NULL)
    ORDER BY combined_score DESC
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;