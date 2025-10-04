-- Trigger tự động cập nhật tồn kho khi có đơn hàng
CREATE OR REPLACE FUNCTION inventory.handle_order_stock_change()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Giảm tồn kho khi tạo order item
        PERFORM inventory.update_stock(
            NEW.product_id,
            NEW.variant_id,
            -NEW.quantity,
            'out',
            'order',
            NEW.order_id
        );
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        -- Tăng tồn kho khi xóa order item (hủy đơn)
        PERFORM inventory.update_stock(
            OLD.product_id,
            OLD.variant_id,
            OLD.quantity,
            'in',
            'order_cancelled',
            OLD.order_id
        );
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_order_stock_change
    AFTER INSERT OR DELETE ON orders.order_items
    FOR EACH ROW EXECUTE FUNCTION inventory.handle_order_stock_change();

-- Trigger đảm bảo chỉ có 1 địa chỉ mặc định
CREATE OR REPLACE FUNCTION users.ensure_single_default_address()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.is_default = true THEN
        UPDATE users.addresses 
        SET is_default = false 
        WHERE user_id = NEW.user_id AND id != NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_single_default_address
    BEFORE INSERT OR UPDATE ON users.addresses
    FOR EACH ROW EXECUTE FUNCTION users.ensure_single_default_address();