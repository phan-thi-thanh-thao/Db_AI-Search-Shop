# Database Structure - AI Fashion Shop

## Cấu trúc thư mục

```
database/
├── schemas/           # Định nghĩa bảng và schema
├── migrations/        # Scripts migration
├── seeds/            # Dữ liệu mẫu
├── functions/        # Stored procedures và functions
├── triggers/         # Database triggers
├── indexes/          # Performance indexes
├── views/            # Database views
└── README.md
```

## Các Schema chính

### 1. users - Quản lý người dùng
- `users`: Thông tin người dùng
- `addresses`: Địa chỉ giao hàng

### 2. products - Quản lý sản phẩm
- `categories`: Danh mục sản phẩm
- `brands`: Thương hiệu
- `products`: Sản phẩm chính
- `product_variants`: Biến thể (size, màu)
- `product_images`: Hình ảnh sản phẩm
- `product_attributes`: Thuộc tính sản phẩm

### 3. ai_search - Tìm kiếm AI
- `image_embeddings`: Vector embeddings cho hình ảnh
- `text_embeddings`: Vector embeddings cho text
- `search_history`: Lịch sử tìm kiếm
- `search_cache`: Cache kết quả tìm kiếm

### 4. orders - Quản lý đơn hàng
- `orders`: Đơn hàng
- `order_items`: Chi tiết đơn hàng
- `cart_items`: Giỏ hàng

### 5. inventory - Quản lý kho
- `stock`: Tồn kho
- `stock_movements`: Lịch sử nhập xuất

## Cài đặt

1. Cài đặt PostgreSQL với extension pgvector:
```bash
# Ubuntu/Debian
sudo apt install postgresql-14-pgvector

# hoặc compile từ source
git clone https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install
```

2. Tạo database:
```sql
CREATE DATABASE ai_fashion_shop;
```

3. Chạy migration:
```bash
psql -d ai_fashion_shop -f migrations/001_initial_setup.sql
```

## Tính năng AI Search

### Vector Embeddings
- Sử dụng CLIP model để tạo embeddings 512 chiều
- Hỗ trợ tìm kiếm bằng hình ảnh và text
- Tìm kiếm hybrid kết hợp cả hai

### Functions chính
- `ai_search.search_products_by_image()`: Tìm kiếm bằng hình ảnh
- `ai_search.hybrid_search()`: Tìm kiếm hybrid

### Performance
- Sử dụng IVFFlat index cho vector similarity
- Cache kết quả tìm kiếm
- Full-text search với pg_trgm

## Quản lý tồn kho

### Tự động cập nhật
- Triggers tự động giảm tồn kho khi có đơn hàng
- Functions kiểm tra tồn kho trước khi đặt hàng
- Lịch sử nhập xuất chi tiết

## Monitoring & Optimization

### Indexes quan trọng
- Vector similarity indexes
- Full-text search indexes
- Foreign key indexes
- Composite indexes cho queries phức tạp

### Views hữu ích
- `products.product_details`: Sản phẩm với thông tin đầy đủ
- `products.products_with_stock`: Sản phẩm kèm tồn kho
- `products.bestsellers`: Sản phẩm bán chạy