-- Bảng vector embeddings cho tìm kiếm AI
CREATE TABLE ai_search.image_embeddings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    image_id UUID REFERENCES products.product_images(id) ON DELETE CASCADE,
    embedding vector(512), -- Vector 512 chiều cho CLIP model
    model_version VARCHAR(50) DEFAULT 'clip-vit-b-32',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng text embeddings cho mô tả sản phẩm
CREATE TABLE ai_search.text_embeddings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    product_id UUID REFERENCES products.products(id) ON DELETE CASCADE,
    text_content TEXT NOT NULL,
    embedding vector(512),
    model_version VARCHAR(50) DEFAULT 'clip-vit-b-32',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng lưu trữ lịch sử tìm kiếm
CREATE TABLE ai_search.search_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users.users(id),
    search_type VARCHAR(20) CHECK (search_type IN ('text', 'image', 'hybrid')),
    query_text TEXT,
    query_image_url TEXT,
    results_count INTEGER,
    search_time_ms INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng cache kết quả tìm kiếm
CREATE TABLE ai_search.search_cache (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    query_hash VARCHAR(64) UNIQUE NOT NULL,
    search_type VARCHAR(20) NOT NULL,
    results JSONB NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);