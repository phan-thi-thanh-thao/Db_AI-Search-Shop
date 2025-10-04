-- Dữ liệu mẫu cho categories
INSERT INTO products.categories (id, name, slug, description) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Áo Nam', 'ao-nam', 'Các loại áo dành cho nam giới'),
('550e8400-e29b-41d4-a716-446655440002', 'Áo Nữ', 'ao-nu', 'Các loại áo dành cho nữ giới'),
('550e8400-e29b-41d4-a716-446655440003', 'Quần Nam', 'quan-nam', 'Các loại quần dành cho nam giới'),
('550e8400-e29b-41d4-a716-446655440004', 'Quần Nữ', 'quan-nu', 'Các loại quần dành cho nữ giới'),
('550e8400-e29b-41d4-a716-446655440005', 'Phụ Kiện', 'phu-kien', 'Phụ kiện thời trang');

-- Dữ liệu mẫu cho brands
INSERT INTO products.brands (id, name, slug, description) VALUES
('660e8400-e29b-41d4-a716-446655440001', 'Nike', 'nike', 'Thương hiệu thể thao nổi tiếng'),
('660e8400-e29b-41d4-a716-446655440002', 'Adidas', 'adidas', 'Thương hiệu thể thao Đức'),
('660e8400-e29b-41d4-a716-446655440003', 'Zara', 'zara', 'Thương hiệu thời trang Tây Ban Nha'),
('660e8400-e29b-41d4-a716-446655440004', 'H&M', 'hm', 'Thương hiệu thời trang Thụy Điển'),
('660e8400-e29b-41d4-a716-446655440005', 'Uniqlo', 'uniqlo', 'Thương hiệu thời trang Nhật Bản');

-- Dữ liệu mẫu cho admin user
INSERT INTO users.users (id, email, password_hash, full_name, role) VALUES
('770e8400-e29b-41d4-a716-446655440001', 'admin@shop.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewdBPj/RK.s5uDfS', 'Admin User', 'admin');

-- Sample products
INSERT INTO products.products (id, name, slug, description, category_id, brand_id, base_price, sku) VALUES
('880e8400-e29b-41d4-a716-446655440001', 'Áo Thun Nike Basic', 'ao-thun-nike-basic', 'Áo thun cotton 100% thoáng mát', '550e8400-e29b-41d4-a716-446655440001', '660e8400-e29b-41d4-a716-446655440001', 299000, 'NIKE-TEE-001'),
('880e8400-e29b-41d4-a716-446655440002', 'Quần Jean Zara Slim', 'quan-jean-zara-slim', 'Quần jean slim fit thời trang', '550e8400-e29b-41d4-a716-446655440003', '660e8400-e29b-41d4-a716-446655440003', 799000, 'ZARA-JEAN-001');