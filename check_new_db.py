import psycopg2

def check_database():
    try:
        conn = psycopg2.connect(
            host="localhost",
            port="5432", 
            database="ai_fashion_shop",
            user="postgres",
            password="password123"
        )
        cursor = conn.cursor()
        
        print("✅ Kết nối database thành công!")
        
        # Kiểm tra các bảng theo ERD
        tables = [
            'Role', 'User', 'Category', 'Product', 'ProductImage',
            'Inventory', 'Review', 'Cart', 'CartItem', 'Promotion',
            'Order', 'OrderDetail', 'Payment', 'Shipping', 'AISearchHistory'
        ]
        
        for table in tables:
            cursor.execute(f'SELECT COUNT(*) FROM "{table}";')
            count = cursor.fetchone()[0]
            print(f"✅ Bảng {table}: {count} records")
        
        # Test dữ liệu mẫu
        cursor.execute('SELECT CategoryName FROM Category;')
        categories = cursor.fetchall()
        print(f"✅ Categories: {[c[0] for c in categories]}")
        
        cursor.execute('SELECT Name, Price FROM Product;')
        products = cursor.fetchall()
        print(f"✅ Products: {[(p[0], p[1]) for p in products]}")
        
        cursor.close()
        conn.close()
        print("\n🎉 Database theo ERD hoạt động hoàn hảo!")
        
    except Exception as e:
        print(f"❌ Lỗi: {e}")

if __name__ == "__main__":
    check_database()