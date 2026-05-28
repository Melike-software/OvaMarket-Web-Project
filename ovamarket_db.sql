DROP DATABASE IF EXISTS ovamarket_db;

CREATE DATABASE ovamarket_db;
USE ovamarket_db;

-- 1. KULLANICILAR TABLOSU
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role VARCHAR(20) DEFAULT 'CUSTOMER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. KATEGORİLER TABLOSU
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. ÜRÜNLER TABLOSU
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- 4. SİPARİŞLER TABLOSU
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Beklemede',
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- 5. SİPARİŞ DETAYLARI TABLOSU
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE SET NULL
);

-- TEST VERİLERİ
INSERT INTO users (full_name, email, password, role, phone, address) VALUES 
('Ova Market Yönetici', 'admin@ovamarket.com', 'admin123', 'ADMIN', '05551112233', 'Merkez Ofis'),
('Ahmet Müşteri', 'ahmet@test.com', 'user123', 'CUSTOMER', '05554445566', 'Kastamonu Üniversitesi Kampüsü');

INSERT INTO categories (name, description, is_active) VALUES 
('Manav', 'Taze meyve ve sebzeler', TRUE),
('Süt Ürünleri', 'Peynir, süt, yoğurt ve kahvaltılıklar', TRUE),
('Atıştırmalık', 'Bisküvi, çikolata ve cipsler', TRUE);

INSERT INTO products (category_id, name, description, price, stock, image_url, is_active) VALUES 
(1, 'Amasya Elması (Kg)', 'Kütür  kütür, taze Amasya elması', 45.00, 50, 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400', TRUE),
(1, 'Kuşkonmaz (Demet)', 'Taze ve organik yeşil kuşkonmaz', 30.00, 25, 'https://images.unsplash.com/photo-1595855759920-86582396756a?w=400', TRUE),
(2, 'Tam Yağlı Süt 1L', 'Doğal çiftlik sütü', 35.50, 20, 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400', TRUE),
(2, 'Süzme Peynir 500g', 'Kahvaltıların vazgeçilmezi', 85.00, 15, 'https://images.unsplash.com/photo-1559561853-08451507cbe7?w=400', TRUE),
(3, 'Çikolatalı Gofret', 'Efsane lezzet', 10.00, 100, 'images/gofret.png', TRUE);

SELECT * FROM users;
SELECT id, full_name, email, role FROM users;
SELECT p.id, p.name, p.price, p.stock, c.name AS kateg_adi 
FROM products p 
INNER JOIN categories c ON p.category_id = c.id;
