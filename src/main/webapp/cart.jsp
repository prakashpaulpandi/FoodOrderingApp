<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.Model.Cart" %>
<%@ page import="com.tap.Model.CartItem" %>
<%@ page import="com.tap.Model.Menu" %>
<%@ page import="com.tap.DAO.MenuDAO" %>
<%@ page import="com.tap.DAOImple.MenuDAOImple" %>

<%
    // 1. SECURITY CHECK
    Integer userId = (Integer) session.getAttribute("loggedInUserId");
    if (userId == null) {
        response.sendRedirect("Login.html");
        return;
    }
    
    String userName = (String) session.getAttribute("loggedInUserName");
    String firstName = (userName != null && userName.contains(" ")) ? userName.substring(0, userName.indexOf(" ")) : userName;

    // 2. RETRIEVE CART ITEMS
    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
    
    // 3. DAO SETUP
    MenuDAO menuDAO = new MenuDAOImple();
    double grandTotal = 0.0;
    double deliveryFee = 0.0;
    double gst = 0.0;
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart | MealMate</title>
    <meta name="description" content="Review your cart items and proceed to checkout on MealMate.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .mm-cart-layout {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 24px 80px;
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 30px;
            align-items: start;
        }

        .mm-cart-header {
            font-size: 26px;
            font-weight: 900;
            color: var(--text-primary);
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .mm-cart-count {
            font-size: 14px;
            font-weight: 700;
            background: var(--primary);
            color: white;
            border-radius: 20px;
            padding: 4px 12px;
        }

        /* Cart item row */
        .mm-cart-item {
            display: flex;
            align-items: center;
            gap: 16px;
            padding: 18px 0;
            border-bottom: 1px solid var(--border-color);
            transition: all 0.2s ease;
        }

        .mm-cart-item:last-child { border-bottom: none; }

        .mm-cart-item:hover { background: rgba(255,71,87,0.02); border-radius: 12px; padding-left: 8px; padding-right: 8px; margin: 0 -8px; }

        .mm-cart-item-img {
            width: 70px;
            height: 70px;
            border-radius: 12px;
            object-fit: cover;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .mm-cart-item-info { flex: 1; }

        .mm-cart-item-name {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .mm-cart-item-price {
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .mm-cart-qty-form {
            display: flex;
            align-items: center;
            gap: 0;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            overflow: hidden;
            background: var(--bg-secondary);
        }

        .mm-cqty-btn {
            width: 34px;
            height: 34px;
            border: none;
            background: transparent;
            font-size: 18px;
            font-weight: 700;
            color: var(--text-secondary);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
        }

        .mm-cqty-btn:hover { background: var(--primary); color: white; }
        .mm-cqty-btn[name="action"][value="decrease"]:hover { background: #FF4757; }

        .mm-cqty-val {
            min-width: 30px;
            text-align: center;
            font-size: 15px;
            font-weight: 800;
            color: var(--text-primary);
        }

        .mm-cart-item-subtotal {
            font-size: 16px;
            font-weight: 800;
            color: var(--text-primary);
            min-width: 80px;
            text-align: right;
        }

        /* Coupon section */
        .mm-coupon-section {
            margin: 24px 0;
            padding: 18px 20px;
            background: var(--bg-tertiary);
            border: 1.5px dashed var(--border-color);
            border-radius: 14px;
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .mm-coupon-icon {
            font-size: 22px;
            flex-shrink: 0;
        }

        .mm-coupon-input {
            flex: 1;
            border: none;
            background: transparent;
            font-size: 14px;
            font-weight: 600;
            color: var(--text-primary);
            outline: none;
        }

        .mm-coupon-input::placeholder { color: var(--text-muted); }

        .mm-coupon-btn {
            background: var(--primary);
            color: white;
            border: none;
            padding: 8px 18px;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .mm-coupon-btn:hover { background: var(--primary-dark); }

        /* Summary card */
        .mm-summary-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 28px;
            position: sticky;
            top: 90px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
        }

        .mm-summary-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 20px;
            padding-bottom: 16px;
            border-bottom: 1px solid var(--border-color);
        }

        .mm-summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
            font-size: 14px;
            color: var(--text-secondary);
        }

        .mm-summary-row.grand {
            font-size: 18px;
            font-weight: 900;
            color: var(--text-primary);
            padding-top: 14px;
            border-top: 2px dashed var(--border-color);
            margin-top: 6px;
        }

        .mm-summary-free {
            color: #2ED573;
            font-weight: 700;
        }

        .mm-savings-badge {
            background: rgba(46,213,115,0.1);
            border: 1px solid rgba(46,213,115,0.25);
            border-radius: 10px;
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 16px 0;
            font-size: 13px;
            font-weight: 700;
            color: #1a9e52;
        }

        .mm-checkout-btn {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, var(--primary), var(--accent-orange));
            color: white;
            border: none;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 20px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            box-shadow: 0 6px 20px rgba(255,71,87,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
        }

        .mm-checkout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(255,71,87,0.4);
            color: white;
        }

        .mm-cart-actions {
            display: flex;
            gap: 12px;
            margin-top: 16px;
        }

        .mm-clear-btn, .mm-continue-btn {
            flex: 1;
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
            font-family: 'Plus Jakarta Sans', sans-serif;
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        .mm-clear-btn {
            background: rgba(255,71,87,0.08);
            color: var(--primary);
            border: 1.5px solid rgba(255,71,87,0.2);
        }

        .mm-clear-btn:hover { background: var(--primary); color: white; }

        .mm-continue-btn {
            background: var(--bg-tertiary);
            color: var(--text-secondary);
            border: 1.5px solid var(--border-color);
        }

        .mm-continue-btn:hover { border-color: var(--primary); color: var(--primary); }

        /* Trust badges */
        .mm-trust-row {
            display: flex;
            justify-content: center;
            gap: 16px;
            margin-top: 16px;
            flex-wrap: wrap;
        }

        .mm-trust-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 11px;
            color: var(--text-muted);
            font-weight: 600;
        }

        /* Empty cart */
        .mm-empty-cart {
            grid-column: 1 / -1;
            text-align: center;
            padding: 80px 24px;
            background: var(--bg-secondary);
            border-radius: 24px;
            border: 1px solid var(--border-color);
        }

        .mm-empty-cart-icon { font-size: 80px; margin-bottom: 20px; display: block; opacity: 0.7; }

        @media (max-width: 900px) {
            .mm-cart-layout { grid-template-columns: 1fr; }
            .mm-summary-card { position: static; }
        }
    </style>
</head>
<body class="page-wrapper">

    <nav class="mm-navbar">
        <a href="home.jsp" class="mm-logo">MealMate</a>
        <div class="mm-nav-actions">
            <span class="mm-greeting">Hi, <b><%= firstName != null ? firstName : "Foodie" %></b></span>
            <a href="home.jsp" class="mm-nav-link"><i class="fa-solid fa-house"></i> Home</a>
            <a href="HistoryServlet" class="mm-nav-link"><i class="fa-solid fa-receipt"></i> Orders</a>
            <button class="mm-theme-toggle" id="themeToggle">🌙</button>
            <a href="LogoutServlet" class="mm-logout-btn">Logout</a>
        </div>
    </nav>

    <div class="mm-cart-layout">

        <% if (cartItems != null && !cartItems.isEmpty()) {
            // Calculate totals
            for (CartItem cItem : cartItems) {
                Menu cMenu = menuDAO.getMenu(cItem.getMenuId());
                if (cMenu != null) grandTotal += cMenu.getPrice() * cItem.getQuantity();
            }
            gst = grandTotal * 0.05;
            deliveryFee = grandTotal > 299 ? 0 : 40;
            double finalTotal = grandTotal + gst + deliveryFee;
        %>

        <!-- LEFT: CART ITEMS -->
        <div>
            <h1 class="mm-cart-header">
                <i class="fa-solid fa-bag-shopping" style="color:var(--primary);"></i>
                Your Cart
                <span class="mm-cart-count"><%= cartItems.size() %> items</span>
            </h1>

            <div class="mm-card">
                <% for (CartItem item : cartItems) {
                    Menu menuItem = menuDAO.getMenu(item.getMenuId());
                    if (menuItem != null) {
                        double subtotal = menuItem.getPrice() * item.getQuantity();
                %>
                <div class="mm-cart-item">
                    <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=200" alt="<%= menuItem.getItemName() %>" class="mm-cart-item-img">
                    <div class="mm-cart-item-info">
                        <div class="mm-cart-item-name"><%= menuItem.getItemName() %></div>
                        <div class="mm-cart-item-price">₹<%= menuItem.getPrice() %> per item</div>
                    </div>
                    <div class="mm-cart-qty-form">
                        <form action="UpdateCartServlet" method="POST" style="display:contents;">
                            <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                            <button type="submit" name="action" value="decrease" class="mm-cqty-btn">−</button>
                            <span class="mm-cqty-val"><%= item.getQuantity() %></span>
                            <button type="submit" name="action" value="increase" class="mm-cqty-btn">+</button>
                        </form>
                    </div>
                    <div class="mm-cart-item-subtotal">₹<%= String.format("%.0f", subtotal) %></div>
                </div>
                <% } } %>
            </div>

            <!-- Coupon Section -->
            <div class="mm-coupon-section">
                <span class="mm-coupon-icon">🎫</span>
                <input type="text" class="mm-coupon-input" placeholder="Enter coupon code (e.g. NEWUSER50)">
                <button class="mm-coupon-btn" onclick="window.MealMate && MealMate.Toast.show('Coupon applied! Saved ₹50', 'success')">Apply</button>
            </div>

            <div class="mm-cart-actions">
                <form action="UpdateCartServlet" method="POST" style="flex:1;">
                    <button type="submit" name="action" value="clear" class="mm-clear-btn" style="width:100%;">
                        <i class="fa-solid fa-trash"></i> Clear Cart
                    </button>
                </form>
                <a href="home.jsp" class="mm-continue-btn">
                    <i class="fa-solid fa-plus"></i> Add More Items
                </a>
            </div>
        </div>

        <!-- RIGHT: ORDER SUMMARY -->
        <div class="mm-summary-card">
            <h2 class="mm-summary-title">Bill Details</h2>

            <div class="mm-summary-row">
                <span>Item Total</span>
                <span>₹<%= String.format("%.2f", grandTotal) %></span>
            </div>
            <div class="mm-summary-row">
                <span>Delivery Charge</span>
                <% if (deliveryFee == 0) { %>
                <span class="mm-summary-free">FREE</span>
                <% } else { %>
                <span>₹<%= String.format("%.2f", deliveryFee) %></span>
                <% } %>
            </div>
            <div class="mm-summary-row">
                <span>GST & Taxes (5%)</span>
                <span>₹<%= String.format("%.2f", gst) %></span>
            </div>
            <div class="mm-summary-row">
                <span>Packaging Charges</span>
                <span>₹10.00</span>
            </div>

            <div class="mm-savings-badge">
                <span>🎉</span>
                <span>You are saving ₹<%= deliveryFee == 0 ? "40" : "0" %> on delivery!</span>
            </div>

            <div class="mm-summary-row grand">
                <span>To Pay</span>
                <span>₹<%= String.format("%.2f", finalTotal + 10) %></span>
            </div>

            <a href="checkout.jsp" class="mm-checkout-btn">
                <i class="fa-solid fa-lock"></i>
                Proceed to Checkout
                <i class="fa-solid fa-arrow-right"></i>
            </a>

            <div class="mm-trust-row">
                <span class="mm-trust-item"><i class="fa-solid fa-shield-halved" style="color:#2ED573;"></i> Secure</span>
                <span class="mm-trust-item"><i class="fa-solid fa-truck" style="color:#1E90FF;"></i> Fast Delivery</span>
                <span class="mm-trust-item"><i class="fa-solid fa-rotate-left" style="color:#FF6B35;"></i> Easy Refund</span>
            </div>
        </div>

        <% } else { %>
        <!-- EMPTY CART -->
        <div class="mm-empty-cart">
            <span class="mm-empty-cart-icon">🛒</span>
            <h2 style="font-size:26px;font-weight:900;color:var(--text-primary);margin-bottom:12px;">Your cart is empty!</h2>
            <p style="color:var(--text-muted);font-size:15px;margin-bottom:32px;">Looks like you haven't added anything yet.<br>Find something delicious to order!</p>
            <a href="home.jsp" class="mm-btn-primary">
                <i class="fa-solid fa-utensils"></i> Browse Restaurants
            </a>
        </div>
        <% } %>
    </div>

    <script src="js/script.js"></script>
</body>
</html>