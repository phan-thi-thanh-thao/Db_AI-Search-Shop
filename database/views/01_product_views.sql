-- View sản phẩm với thông tin đầy đủ
CREATE VIEW products.product_details AS
SELECT 
    p.id,
    p.name,
    p.slug,
    p.description,
    p.base_price,
    p.sale_price,
    p.sku,
    p.status,
    c.name as category_name,
    c.slug as category_slug,
    b.name as brand_name,
    b.slug as brand_slug,
    p.created_at,
    p.updated_at
FROM products.products p
LEFT JOIN products.categories c ON p.category_id = c.id
LEFT JOIN products.brands b ON p.brand_id = b.id;

-- View sản phẩm với tồn kho
CREATE VIEW products.products_with_stock AS
SELECT 
    p.*,
    COALESCE(SUM(s.quantity), 0) as total_stock,
    COALESCE(SUM(s.reserved_quantity), 0) as total_reserved,
    COALESCE(SUM(s.quantity - s.reserved_quantity), 0) as available_stock
FROM products.product_details p
LEFT JOIN inventory.stock s ON p.id = s.product_id
GROUP BY p.id, p.name, p.slug, p.description, p.base_price, p.sale_price, 
         p.sku, p.status, p.category_name, p.category_slug, 
         p.brand_name, p.brand_slug, p.created_at, p.updated_at;

-- View sản phẩm bán chạy
CREATE VIEW products.bestsellers AS
SELECT 
    p.id,
    p.name,
    p.slug,
    p.base_price,
    p.sale_price,
    COUNT(oi.id) as order_count,
    SUM(oi.quantity) as total_sold,
    SUM(oi.total_price) as total_revenue
FROM products.products p
JOIN orders.order_items oi ON p.id = oi.product_id
JOIN orders.orders o ON oi.order_id = o.id
WHERE o.status IN ('confirmed', 'processing', 'shipped', 'delivered')
AND o.created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.id, p.name, p.slug, p.base_price, p.sale_price
ORDER BY total_sold DESC;