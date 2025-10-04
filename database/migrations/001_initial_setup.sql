-- Migration script để setup database từ đầu
-- Chạy theo thứ tự để tạo database hoàn chỉnh

\i schemas/01_init_database.sql
\i schemas/02_users_tables.sql
\i schemas/03_products_tables.sql
\i schemas/04_ai_search_tables.sql
\i schemas/05_orders_tables.sql
\i schemas/06_inventory_tables.sql
\i indexes/01_performance_indexes.sql
\i functions/01_ai_search_functions.sql
\i functions/02_inventory_functions.sql
\i triggers/01_update_timestamps.sql
\i triggers/02_inventory_triggers.sql
\i views/01_product_views.sql
\i seeds/01_sample_data.sql