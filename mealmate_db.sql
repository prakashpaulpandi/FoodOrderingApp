-- ====================================================
-- MealMate Database Schema & Sample Data
-- For MySQL Workbench
-- Connection Username: root
-- Connection Password: Root123 (Update DBConnection.java if needed)
-- ====================================================

CREATE DATABASE IF NOT EXISTS mealmate_db;
USE mealmate_db;

-- 1. Create User Table
CREATE TABLE IF NOT EXISTS user (
    userId INT AUTO_INCREMENT PRIMARY KEY,
    userName VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'CUSTOMER',
    createDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lastLoginDate TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
);

-- 2. Create Restaurant Table
CREATE TABLE IF NOT EXISTS restaurant (
    restaurantId INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    cuisineType VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    deliveryTime INT NOT NULL,
    rating DECIMAL(3, 2) NOT NULL DEFAULT 4.0,
    isActive BOOLEAN DEFAULT TRUE,
    adminUserId INT,
    FOREIGN KEY (adminUserId) REFERENCES user(userId) ON DELETE SET NULL
);

-- 3. Create Menu Table
CREATE TABLE IF NOT EXISTS menu (
    menuId INT AUTO_INCREMENT PRIMARY KEY,
    restaurantId INT,
    itemName VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(100),
    isAvailable BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE CASCADE
);

-- 4. Create Orders Table
CREATE TABLE IF NOT EXISTS orders (
    orderId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    restaurantId INT,
    orderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    totalAmount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'PLACED',
    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE,
    FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE CASCADE
);

-- 5. Create Order Item Table
CREATE TABLE IF NOT EXISTS orderitem (
    orderItemId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT,
    menuId INT,
    quantity INT NOT NULL,
    itemTotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE,
    FOREIGN KEY (menuId) REFERENCES menu(menuId) ON DELETE CASCADE
);

-- 6. Create Payment Table
CREATE TABLE IF NOT EXISTS payment (
    paymentId INT AUTO_INCREMENT PRIMARY KEY,
    orderId INT,
    amount DECIMAL(10, 2) NOT NULL,
    paymentMethod VARCHAR(100) NOT NULL,
    paymentStatus VARCHAR(100) NOT NULL,
    FOREIGN KEY (orderId) REFERENCES orders(orderId) ON DELETE CASCADE
);

-- 7. Create Review Table
CREATE TABLE IF NOT EXISTS review (
    reviewId INT AUTO_INCREMENT PRIMARY KEY,
    userId INT,
    restaurantId INT,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    reviewDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE,
    FOREIGN KEY (restaurantId) REFERENCES restaurant(restaurantId) ON DELETE CASCADE
);

-- ====================================================
-- SEED DATA POPULATION
-- ====================================================

-- Insert Sample Users (Admins and Customers)
-- Password formats: Admin@123 for admins, User@123 for customers
INSERT INTO user (userId, userName, password, email, phone, address, role) VALUES
(1, 'Admin MealMate', 'Admin@123', 'admin@mealmate.com', '9876543210', 'MealMate Headquarters, Chennai', 'ADMIN'),
(2, 'Amit Sharma', 'User@123', 'amit@gmail.com', '9876543211', 'Flat 402, Royal Residency, Adyar, Chennai', 'CUSTOMER'),
(3, 'Priya Patel', 'User@123', 'priya@gmail.com', '9876543212', 'Plot 15, Spring Gardens, OMR, Chennai', 'CUSTOMER');

-- Insert Premium Restaurants
INSERT INTO restaurant (restaurantId, name, cuisineType, address, deliveryTime, rating, isActive, adminUserId) VALUES
(1, 'Domino\'s Pizza', 'Pizza, Fast Food, Desserts', 'Adyar, Chennai', 25, 4.4, 1, 1),
(2, 'Pizza Hut', 'Pizza, Fast Food, Italian', 'Velachery, Chennai', 30, 4.2, 1, 1),
(3, 'Burger King', 'Burgers, Fast Food, Beverages', 'Nungambakkam, Chennai', 20, 4.3, 1, 1),
(4, 'KFC', 'Chicken, Fast Food, Burgers', 'T. Nagar, Chennai', 20, 4.1, 1, 1),
(5, 'Subway', 'Healthy Food, Salads, Fast Food', 'OMR, Chennai', 15, 4.5, 1, 1),
(6, 'McDonald\'s', 'Burgers, Fast Food, Desserts', 'Anna Nagar, Chennai', 25, 4.2, 1, 1),
(7, 'A2B - Adyar Ananda Bhavan', 'South Indian, Sweets, Street Food', 'Mylapore, Chennai', 20, 4.6, 1, 1),
(8, 'Behrouz Biryani', 'Biryani, North Indian, Mughlai', 'Guindy, Chennai', 35, 4.4, 1, 1),
(9, 'SS Hyderabad Biryani', 'Biryani, Mughlai, Chinese', 'Kodambakkam, Chennai', 30, 4.5, 1, 1),
(10, 'Barbeque Nation', 'BBQ, North Indian, Buffet', 'Teynampet, Chennai', 40, 4.7, 1, 1);

-- Insert Attractive Food Menu Items for Restaurants
-- Domino's Pizza (RestaurantId: 1)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(1, 'Margherita Pizza', 'Classic delight with 100% real mozzarella cheese.', 199.00, 'Pizza', 1),
(1, 'Peppy Paneer Pizza', 'Chunky paneer, crisp capsicum, and spicy red pepper.', 349.00, 'Pizza', 1),
(1, 'Garlic Breadsticks', 'Freshly baked garlic bread with cheesy dip.', 99.00, 'Fast Food', 1),
(1, 'Choco Lava Cake', 'Chocolate lovers delight! Melted chocolate inside a soft cake.', 89.00, 'Desserts', 1);

-- Pizza Hut (RestaurantId: 2)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(2, 'Veg Supreme Pizza', 'Black olives, green capsicum, mushrooms, sweet corn, and tomatoes.', 399.00, 'Pizza', 1),
(2, 'Tandoori Paneer Pizza', 'Spiced paneer, onions, and green chilies with tandoori sauce.', 379.00, 'Pizza', 1),
(2, 'Garlic Bread Supreme', 'Toasted bread topped with garlic butter and melted cheese.', 129.00, 'Fast Food', 1);

-- Burger King (RestaurantId: 3)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(3, 'Whopper Burger', 'Signature flame-grilled patty with fresh tomatoes, lettuce, and mayo.', 169.00, 'Burgers', 1),
(3, 'Crispy Veg Double Patty', 'Crispy double veg patty with delicious cheese and sauce.', 129.00, 'Burgers', 1),
(3, 'Cheesy Fries', 'Crispy golden fries loaded with cheese sauce.', 99.00, 'Fast Food', 1);

-- KFC (RestaurantId: 4)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(4, 'Hot & Crispy Chicken (4 Pc)', 'Signature KFC crispy double breaded fried chicken.', 399.00, 'Chicken', 1),
(4, 'Zinger Burger', 'Crispy chicken fillet with fresh lettuce and creamy mayo.', 149.00, 'Burgers', 1),
(4, 'Chicken Popcorn (Large)', 'Bite-sized sweet and spicy crispy chicken pops.', 199.00, 'Fast Food', 1);

-- Subway (RestaurantId: 5)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(5, 'Paneer Tikka Sub (6 inch)', 'Spiced paneer tikka slices on freshly baked bread with choice of veggies.', 189.00, 'Healthy Food', 1),
(5, 'Aloo Patty Sub (6 inch)', 'Classic crisp potato patty sub with honey mustard sauce.', 149.00, 'Healthy Food', 1),
(5, 'Veggie Delite Sub', 'Loaded with fresh garden vegetables on fresh bread.', 139.00, 'Healthy Food', 1);

-- McDonald's (RestaurantId: 6)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(6, 'McVeggie Burger', 'Delectable veg patty, shredded lettuce, and creamy mayo.', 119.00, 'Burgers', 1),
(6, 'McSpicy Chicken Burger', 'Crispy chicken patty with spicy marinade and lettuce.', 169.00, 'Burgers', 1),
(6, 'McFlurry Oreo', 'Creamy vanilla soft serve with crunchy Oreo cookie bits.', 99.00, 'Desserts', 1);

-- A2B (RestaurantId: 7)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(7, 'Special Masala Dosa', 'Golden crispy dosa stuffed with spiced potato masala and pure ghee.', 110.00, 'South Indian', 1),
(7, 'Sambar Vada (2 Pcs)', 'Fried lentil donuts soaked in piping hot traditional sambar.', 75.00, 'South Indian', 1),
(7, 'Mini South Indian Meals', 'A delicious combination of sambar rice, curd rice, and dry curry.', 150.00, 'South Indian', 1);

-- Behrouz Biryani (RestaurantId: 8)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(8, 'Subz-e-Falafel Biryani', 'Fresh falafel balls layered with aromatic basmati rice and premium spices.', 299.00, 'Biryani', 1),
(8, 'Lazeez Bhuna Murgh Biryani', 'Tender boneless chicken marinated in royal spices and layered with long grain rice.', 389.00, 'Biryani', 1);

-- SS Hyderabad Biryani (RestaurantId: 9)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(9, 'Hyderabad Chicken Biryani', 'Aromatic spiced basmati rice with succulent pieces of chicken.', 240.00, 'Biryani', 1),
(9, 'Hyderabad Mutton Biryani', 'Traditional tender mutton cooked in slow-cooked dum style.', 320.00, 'Biryani', 1);

-- Barbeque Nation (RestaurantId: 10)
INSERT INTO menu (restaurantId, itemName, description, price, category, isAvailable) VALUES
(10, 'Cajun Spiced Potatoes', 'Crispy fried baby potatoes in sweet and spicy Cajun sauce.', 199.00, 'BBQ', 1),
(10, 'Tandoori Paneer Tikka', 'Marinated paneer skewers grilled to perfection in clay oven.', 249.00, 'BBQ', 1),
(10, 'Chicken Tikka Skewers', 'Boneless chicken cubes in traditional red marinade, charcoal grilled.', 299.00, 'BBQ', 1);
