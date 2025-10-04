-- Indexes cho hiệu suất tìm kiếm và truy vấn

-- Users indexes
CREATE INDEX idx_users_email ON users.users(email);
CREATE INDEX idx_users_role ON users.users(role);
CREATE INDEX idx_users_active ON users.users(is_active);

-- Products indexes
CREATE INDEX idx_products_category ON products.products(category_id);
CREATE INDEX idx_products_brand ON products.products(brand_id);
CREATE INDEX idx_products_status ON products.products(status);
CREATE INDEX idx_products_name_trgm ON products.products USING gin(name gin_trgm_ops);
CREATE INDEX idx_products_description_trgm ON products.products USING gin(description gin_trgm_ops);

-- Product variants indexes
CREATE INDEX idx_variants_product ON products.product_variants(product_id);
CREATE INDEX idx_variants_size ON products.product_variants(size);
CREATE INDEX idx_variants_color ON products.product_variants(color);

-- Product images indexes
CREATE INDEX idx_images_product ON products.product_images(product_id);
CREATE INDEX idx_images_variant ON products.product_images(variant_id);
CREATE INDEX idx_images_primary ON products.product_images(is_primary);

-- AI Search indexes (Vector similarity)
CREATE INDEX idx_image_embeddings_vector ON ai_search.image_embeddings USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
CREATE INDEX idx_text_embeddings_vector ON ai_search.text_embeddings USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);
CREATE INDEX idx_search_history_user ON ai_search.search_history(user_id);
CREATE INDEX idx_search_cache_hash ON ai_search.search_cache(query_hash);
CREATE INDEX idx_search_cache_expires ON ai_search.search_cache(expires_at);

-- Orders indexes
CREATE INDEX idx_orders_user ON orders.orders(user_id);
CREATE INDEX idx_orders_status ON orders.orders(status);
CREATE INDEX idx_orders_created ON orders.orders(created_at);
CREATE INDEX idx_order_items_order ON orders.order_items(order_id);
CREATE INDEX idx_cart_user ON orders.cart_items(user_id);

-- Inventory indexes
CREATE INDEX idx_stock_product_variant ON inventory.stock(product_id, variant_id);
CREATE INDEX idx_stock_low_level ON inventory.stock(quantity) WHERE quantity <= min_stock_level;
CREATE INDEX idx_stock_movements_product ON inventory.stock_movements(product_id, variant_id);
CREATE INDEX idx_stock_movements_created ON inventory.stock_movements(created_at);