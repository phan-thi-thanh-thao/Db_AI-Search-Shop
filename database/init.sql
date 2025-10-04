-- Tạo database theo sơ đồ ERD
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "vector";

-- Bảng Role
CREATE TABLE Role (
    RoleID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    RoleName VARCHAR(50) NOT NULL
);

-- Bảng User
CREATE TABLE "User" (
    UserID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Phone VARCHAR(20),
    RoleID UUID REFERENCES Role(RoleID),
    AddressID UUID
);

-- Bảng Category
CREATE TABLE Category (
    CategoryID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    CategoryName VARCHAR(255) NOT NULL
);

-- Bảng Product
CREATE TABLE Product (
    ProductID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(12,2) NOT NULL,
    Description TEXT,
    CategoryID UUID REFERENCES Category(CategoryID)
);

-- Bảng ProductImage
CREATE TABLE ProductImage (
    ImageID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ProductID UUID REFERENCES Product(ProductID),
    ImageURL TEXT NOT NULL
);

-- Bảng Inventory
CREATE TABLE Inventory (
    InventoryID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ProductID UUID REFERENCES Product(ProductID),
    Size VARCHAR(10),
    Color VARCHAR(50),
    Quantity INTEGER NOT NULL DEFAULT 0
);

-- Bảng Review
CREATE TABLE Review (
    ReviewID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    UserID UUID REFERENCES "User"(UserID),
    ProductID UUID REFERENCES Product(ProductID),
    Rating INTEGER CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    CreateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Cart
CREATE TABLE Cart (
    CartID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    UserID UUID REFERENCES "User"(UserID),
    CreateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng CartItem
CREATE TABLE CartItem (
    CartItemID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    CartID UUID REFERENCES Cart(CartID),
    ProductID UUID REFERENCES Product(ProductID),
    Quantity INTEGER NOT NULL DEFAULT 1
);

-- Bảng Promotion
CREATE TABLE Promotion (
    PromotionID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Code VARCHAR(50) UNIQUE NOT NULL,
    DiscountPercent DECIMAL(5,2),
    ExpiryDate DATE
);

-- Bảng Order
CREATE TABLE "Order" (
    OrderID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    UserID UUID REFERENCES "User"(UserID),
    TotalPrice DECIMAL(12,2) NOT NULL,
    PaymentID UUID,
    ShippingID UUID,
    Status VARCHAR(50) DEFAULT 'pending',
    CreateAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng OrderDetail
CREATE TABLE OrderDetail (
    OrderDetailID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    OrderID UUID REFERENCES "Order"(OrderID),
    ProductID UUID REFERENCES Product(ProductID),
    Quantity INTEGER NOT NULL,
    Price DECIMAL(12,2) NOT NULL
);

-- Bảng Payment
CREATE TABLE Payment (
    PaymentID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    Method VARCHAR(50) NOT NULL,
    Status VARCHAR(50) DEFAULT 'pending',
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng Shipping
CREATE TABLE Shipping (
    ShippingID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    OrderID UUID REFERENCES "Order"(OrderID),
    Address TEXT NOT NULL,
    Status VARCHAR(50) DEFAULT 'preparing',
    ShippingDate TIMESTAMP
);

-- Bảng AISearchHistory (cho tính năng AI search)
CREATE TABLE AISearchHistory (
    SearchID UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    UserID UUID REFERENCES "User"(UserID),
    ImageURL TEXT,
    ResultProductID UUID REFERENCES Product(ProductID),
    SearchDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Thêm foreign key cho User.AddressID (tự tham chiếu)
ALTER TABLE "User" ADD CONSTRAINT fk_user_address 
    FOREIGN KEY (AddressID) REFERENCES "User"(UserID);

-- Thêm foreign key cho Order
ALTER TABLE "Order" ADD CONSTRAINT fk_order_payment 
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID);

ALTER TABLE "Order" ADD CONSTRAINT fk_order_shipping 
    FOREIGN KEY (ShippingID) REFERENCES Shipping(ShippingID);

-- Tạo indexes cho hiệu suất
CREATE INDEX idx_product_category ON Product(CategoryID);
CREATE INDEX idx_product_image ON ProductImage(ProductID);
CREATE INDEX idx_inventory_product ON Inventory(ProductID);
CREATE INDEX idx_review_product ON Review(ProductID);
CREATE INDEX idx_cart_user ON Cart(UserID);
CREATE INDEX idx_order_user ON "Order"(UserID);
CREATE INDEX idx_search_user ON AISearchHistory(UserID);

-- Dữ liệu mẫu
INSERT INTO Role (RoleName) VALUES 
('Admin'), ('Customer'), ('Staff');

INSERT INTO Category (CategoryName) VALUES 
('Áo Nam'), ('Áo Nữ'), ('Quần Nam'), ('Quần Nữ'), ('Phụ Kiện');

INSERT INTO Product (Name, Price, Description, CategoryID) VALUES 
('Áo Thun Basic', 299000, 'Áo thun cotton thoáng mát', (SELECT CategoryID FROM Category WHERE CategoryName = 'Áo Nam')),
('Quần Jean Slim', 799000, 'Quần jean slim fit thời trang', (SELECT CategoryID FROM Category WHERE CategoryName = 'Quần Nam'));

SELECT 'Database tạo thành công theo ERD!' as status;