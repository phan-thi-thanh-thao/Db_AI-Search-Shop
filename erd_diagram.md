# Sơ đồ ERD - AI Fashion Shop Database

```mermaid
erDiagram
    User {
        uuid userid PK
        varchar name
        varchar email UK
        varchar password
        varchar phone
        uuid roleid FK
        uuid addressid FK
    }
    
    Role {
        uuid roleid PK
        varchar rolename
    }
    
    Product {
        uuid productid PK
        varchar name
        decimal price
        text description
        uuid categoryid FK
    }
    
    Category {
        uuid categoryid PK
        varchar categoryname
        text description
    }
    
    Cart {
        uuid cartid PK
        uuid userid FK
        timestamp createdat
    }
    
    CartItem {
        uuid cartitemid PK
        uuid cartid FK
        uuid productid FK
        int quantity
        decimal price
    }
    
    Order {
        uuid orderid PK
        uuid userid FK
        decimal totalamount
        varchar status
        timestamp orderdate
    }
    
    OrderDetail {
        uuid orderdetailid PK
        uuid orderid FK
        uuid productid FK
        int quantity
        decimal price
    }
    
    Payment {
        uuid paymentid PK
        uuid orderid FK
        decimal amount
        varchar method
        varchar status
        timestamp paymentdate
    }
    
    Shipping {
        uuid shippingid PK
        uuid orderid FK
        varchar address
        varchar method
        varchar status
        timestamp shippeddate
    }
    
    Review {
        uuid reviewid PK
        uuid userid FK
        uuid productid FK
        int rating
        text comment
        timestamp reviewdate
    }
    
    ProductImage {
        uuid imageid PK
        uuid productid FK
        varchar imageurl
        varchar alttext
    }
    
    Inventory {
        uuid inventoryid PK
        uuid productid FK
        int stockquantity
        timestamp lastupdated
    }
    
    Promotion {
        uuid promotionid PK
        varchar name
        text description
        decimal discountpercentage
        date startdate
        date enddate
    }
    
    AISearchHistory {
        uuid searchid PK
        uuid userid FK
        text searchquery
        uuid resultproductid FK
        timestamp searchdate
    }

    %% Relationships
    User ||--o{ Role : "has"
    User ||--o{ User : "self-reference address"
    User ||--o{ Cart : "owns"
    User ||--o{ Order : "places"
    User ||--o{ Review : "writes"
    User ||--o{ AISearchHistory : "searches"
    
    Product ||--o{ Category : "belongs to"
    Product ||--o{ CartItem : "in cart"
    Product ||--o{ OrderDetail : "ordered"
    Product ||--o{ Review : "reviewed"
    Product ||--o{ ProductImage : "has images"
    Product ||--o{ Inventory : "stock info"
    Product ||--o{ AISearchHistory : "search result"
    
    Cart ||--o{ CartItem : "contains"
    
    Order ||--o{ OrderDetail : "contains"
    Order ||--|| Payment : "paid by"
    Order ||--|| Shipping : "shipped via"
```

## Mô tả các bảng chính:

### 🧑‍💼 **User Management**
- **User**: Thông tin người dùng
- **Role**: Vai trò (admin, customer, etc.)

### 🛍️ **Product Management**
- **Product**: Sản phẩm thời trang
- **Category**: Danh mục sản phẩm
- **ProductImage**: Hình ảnh sản phẩm
- **Inventory**: Quản lý tồn kho

### 🛒 **Shopping Cart**
- **Cart**: Giỏ hàng của user
- **CartItem**: Sản phẩm trong giỏ hàng

### 📦 **Order Management**
- **Order**: Đơn hàng
- **OrderDetail**: Chi tiết đơn hàng
- **Payment**: Thanh toán
- **Shipping**: Vận chuyển

### ⭐ **Customer Interaction**
- **Review**: Đánh giá sản phẩm
- **AISearchHistory**: Lịch sử tìm kiếm AI

### 🎯 **Marketing**
- **Promotion**: Khuyến mãi