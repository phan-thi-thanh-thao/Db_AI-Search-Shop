-- Function cập nhật tồn kho
CREATE OR REPLACE FUNCTION inventory.update_stock(
    p_product_id UUID,
    p_variant_id UUID,
    p_quantity_change INTEGER,
    p_movement_type VARCHAR,
    p_reference_type VARCHAR DEFAULT NULL,
    p_reference_id UUID DEFAULT NULL,
    p_user_id UUID DEFAULT NULL
)
RETURNS BOOLEAN AS $$
DECLARE
    current_stock INTEGER;
BEGIN
    -- Lấy số lượng tồn kho hiện tại
    SELECT quantity INTO current_stock 
    FROM inventory.stock 
    WHERE product_id = p_product_id AND variant_id = p_variant_id;
    
    -- Kiểm tra nếu chưa có record thì tạo mới
    IF current_stock IS NULL THEN
        INSERT INTO inventory.stock (product_id, variant_id, quantity)
        VALUES (p_product_id, p_variant_id, GREATEST(0, p_quantity_change));
        current_stock = 0;
    ELSE
        -- Cập nhật tồn kho
        UPDATE inventory.stock 
        SET quantity = GREATEST(0, quantity + p_quantity_change),
            last_updated = CURRENT_TIMESTAMP
        WHERE product_id = p_product_id AND variant_id = p_variant_id;
    END IF;
    
    -- Ghi lại lịch sử nhập xuất
    INSERT INTO inventory.stock_movements (
        product_id, variant_id, movement_type, quantity,
        reference_type, reference_id, created_by
    ) VALUES (
        p_product_id, p_variant_id, p_movement_type, p_quantity_change,
        p_reference_type, p_reference_id, p_user_id
    );
    
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Function kiểm tra tồn kho có đủ không
CREATE OR REPLACE FUNCTION inventory.check_stock_availability(
    p_product_id UUID,
    p_variant_id UUID,
    p_required_quantity INTEGER
)
RETURNS BOOLEAN AS $$
DECLARE
    available_quantity INTEGER;
BEGIN
    SELECT (quantity - reserved_quantity) INTO available_quantity
    FROM inventory.stock
    WHERE product_id = p_product_id AND variant_id = p_variant_id;
    
    RETURN COALESCE(available_quantity, 0) >= p_required_quantity;
END;
$$ LANGUAGE plpgsql;