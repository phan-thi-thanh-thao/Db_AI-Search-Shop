import psycopg2

try:
    conn = psycopg2.connect(
        host="localhost",
        port="5432", 
        database="ai_fashion_shop",
        user="postgres",
        password="password123"
    )
    cursor = conn.cursor()
    
    print("Database connected successfully!")
    
    # Check tables
    cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")
    tables = cursor.fetchall()
    print(f"Tables created: {len(tables)}")
    for table in tables:
        print(f"- {table[0]}")
    
    # Check sample data
    cursor.execute('SELECT COUNT(*) FROM "Category";')
    categories = cursor.fetchone()[0]
    print(f"Categories: {categories}")
    
    cursor.execute('SELECT COUNT(*) FROM "Product";')
    products = cursor.fetchone()[0]
    print(f"Products: {products}")
    
    cursor.close()
    conn.close()
    print("Database setup SUCCESS!")
    
except Exception as e:
    print(f"Error: {e}")