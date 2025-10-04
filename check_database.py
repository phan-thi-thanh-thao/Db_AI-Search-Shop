import psycopg2
import sys

def check_database():
    try:
        # Kết nối database
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            database="ai_fashion_shop",
            user="postgres",
            password="password123"
        )
        cursor = conn.cursor()
        
        print("✅ Kết nối database thành công!")
        
        # Kiểm tra extensions
        cursor.execute("SELECT extname FROM pg_extension WHERE extname IN ('vector', 'pg_trgm', 'uuid-ossp');")
        extensions = cursor.fetchall()
        print(f"✅ Extensions: {[ext[0] for ext in extensions]}")
        
        # Kiểm tra schemas
        cursor.execute("SELECT schema_name FROM information_schema.schemata WHERE schema_name IN ('products', 'users', 'orders', 'ai_search', 'inventory');")
        schemas = cursor.fetchall()
        print(f"✅ Schemas: {[s[0] for s in schemas]}")
        
        # Kiểm tra số lượng bảng
        cursor.execute("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema NOT IN ('information_schema', 'pg_catalog');")
        table_count = cursor.fetchone()[0]
        print(f"✅ Tổng số bảng: {table_count}")
        
        # Kiểm tra dữ liệu mẫu
        cursor.execute("SELECT COUNT(*) FROM products.categories;")
        categories = cursor.fetchone()[0]
        print(f"✅ Categories mẫu: {categories}")
        
        # Kiểm tra functions
        cursor.execute("SELECT COUNT(*) FROM pg_proc WHERE proname LIKE '%search%';")
        functions = cursor.fetchone()[0]
        print(f"✅ AI Search functions: {functions}")
        
        cursor.close()
        conn.close()
        print("\n🎉 Database setup hoàn tất và hoạt động tốt!")
        
    except Exception as e:
        print(f"❌ Lỗi: {e}")
        sys.exit(1)

if __name__ == "__main__":
    check_database()