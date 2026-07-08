<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.Model.CartItem" %>
<%@ page import="com.tap.Model.Menu" %>
<%@ page import="com.tap.DAO.MenuDAO" %>
<%@ page import="com.tap.DAOImple.MenuDAOImple" %>

<%
    // SECURITY & DATA INTEGRITY
    Integer userId = (Integer) session.getAttribute("loggedInUserId");
    if (userId == null) { response.sendRedirect("Login.html"); return; }

    List<CartItem> cartItems = (List<CartItem>) session.getAttribute("cartItems");
    if (cartItems == null || cartItems.isEmpty()) { response.sendRedirect("cart.jsp"); return; }

    MenuDAO menuDAO = new MenuDAOImple();
    double subTotal = 0.0;
    for (CartItem item : cartItems) {
        Menu m = menuDAO.getMenu(item.getMenuId());
        if(m != null) subTotal += (m.getPrice() * item.getQuantity());
    }
    
    double tax = subTotal * 0.05; 
    double deliveryFee = (subTotal > 299) ? 0.0 : 40.0;
    double packagingFee = 10.0;
    double grandTotal = subTotal + tax + deliveryFee + packagingFee;
    session.setAttribute("checkoutTotal", grandTotal);
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Secure Checkout | MealMate</title>
    <meta name="description" content="Complete your order securely on MealMate.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .mm-checkout-page {
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 24px 80px;
            display: grid;
            grid-template-columns: 1.3fr 1fr;
            gap: 30px;
            align-items: start;
        }

        /* Section cards */
        .mm-checkout-section {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 28px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
        }

        .mm-section-head {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 24px;
        }

        .mm-section-num {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--accent-orange));
            color: white;
            font-size: 14px;
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }

        .mm-section-head h2 {
            font-size: 18px;
            font-weight: 800;
            color: var(--text-primary);
        }

        /* Address type tabs */
        .mm-addr-types {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }

        .mm-addr-type {
            padding: 12px;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            cursor: pointer;
            text-align: center;
            font-size: 13px;
            font-weight: 700;
            color: var(--text-secondary);
            transition: all 0.2s ease;
        }

        .mm-addr-type:hover,
        .mm-addr-type.active {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-glow);
        }

        .mm-addr-type .addr-icon { font-size: 20px; display: block; margin-bottom: 4px; }

        /* Input grid */
        .mm-input-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }

        .mm-input-grid .mm-form-group {
            margin-bottom: 0;
        }

        .mm-input-grid .full-width {
            grid-column: 1 / -1;
        }

        .mm-label {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            display: block;
            margin-bottom: 6px;
        }

        .mm-input, .mm-textarea {
            width: 100%;
            padding: 13px 16px;
            background: var(--bg-tertiary);
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            color: var(--text-primary);
            font-size: 14px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            transition: all 0.3s ease;
        }

        .mm-input:focus, .mm-textarea:focus {
            border-color: var(--primary);
            background: var(--bg-secondary);
            box-shadow: 0 0 0 3px var(--primary-glow);
            outline: none;
        }

        .mm-input::placeholder, .mm-textarea::placeholder { color: var(--text-muted); }

        .mm-textarea { resize: vertical; min-height: 80px; }

        /* Payment options */
        .mm-pay-option {
            border: 2px solid var(--border-color);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 12px;
            transition: all 0.3s ease;
        }

        .mm-pay-option.active {
            border-color: var(--primary);
            box-shadow: 0 4px 15px rgba(255,71,87,0.1);
        }

        .mm-pay-header {
            padding: 16px 20px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--bg-secondary);
        }

        .mm-pay-info {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .mm-pay-icon {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            background: var(--bg-tertiary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            box-shadow: var(--shadow-sm);
        }

        .mm-pay-title { font-size: 15px; font-weight: 700; color: var(--text-primary); }
        .mm-pay-subtitle { font-size: 12px; color: var(--text-muted); margin-top: 2px; }

        .mm-pay-radio {
            width: 22px;
            height: 22px;
            border: 2px solid var(--border-color);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            transition: all 0.2s ease;
        }

        .mm-pay-option.active .mm-pay-radio {
            border-color: var(--primary);
        }

        .mm-pay-option.active .mm-pay-radio::after {
            content: '';
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--primary);
        }

        .mm-pay-body {
            display: none;
            padding: 0 20px 20px;
            border-top: 1px dashed var(--border-color);
            margin-top: 8px;
            animation: slideDown 0.3s ease;
        }

        .mm-pay-option.active .mm-pay-body { display: block; }

        .mm-upi-apps {
            display: flex;
            gap: 10px;
            margin-bottom: 14px;
            flex-wrap: wrap;
        }

        .mm-upi-app {
            flex: 1;
            min-width: 70px;
            padding: 10px 8px;
            border: 1.5px solid var(--border-color);
            border-radius: 10px;
            text-align: center;
            cursor: pointer;
            font-size: 12px;
            font-weight: 700;
            color: var(--text-secondary);
            transition: all 0.2s ease;
        }

        .mm-upi-app:hover, .mm-upi-app.selected {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-glow);
        }

        .mm-upi-app-icon { font-size: 22px; display: block; margin-bottom: 4px; }

        input[type="radio"] { display: none; }

        /* Place order button */
        .mm-place-order-btn {
            width: 100%;
            padding: 18px;
            background: linear-gradient(135deg, var(--primary), var(--accent-orange));
            color: white;
            border: none;
            border-radius: 14px;
            font-size: 17px;
            font-weight: 800;
            cursor: pointer;
            margin-top: 24px;
            font-family: 'Plus Jakarta Sans', sans-serif;
            box-shadow: 0 8px 25px rgba(255,71,87,0.3);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s ease;
        }

        .mm-place-order-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 12px 35px rgba(255,71,87,0.4);
        }

        .mm-trust-text {
            text-align: center;
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
        }

        /* Order summary right side */
        .mm-order-summary {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            padding: 28px;
            position: sticky;
            top: 90px;
            box-shadow: var(--shadow-sm);
        }

        .mm-order-summary-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 20px;
            padding-bottom: 14px;
            border-bottom: 1px solid var(--border-color);
        }

        .mm-receipt-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
            font-size: 14px;
        }

        .mm-receipt-qty {
            background: rgba(255,71,87,0.1);
            color: var(--primary);
            border-radius: 6px;
            padding: 2px 8px;
            font-size: 12px;
            font-weight: 800;
            margin-right: 8px;
        }

        .mm-receipt-name { color: var(--text-secondary); font-weight: 500; }
        .mm-receipt-price { color: var(--text-primary); font-weight: 700; }

        .mm-receipt-divider {
            height: 1px;
            background: var(--border-color);
            margin: 16px 0;
        }

        .mm-receipt-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 10px;
        }

        .mm-receipt-total {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
            font-weight: 900;
            color: var(--text-primary);
            margin-top: 14px;
            padding-top: 14px;
            border-top: 2px solid var(--border-color);
        }

        @media (max-width: 900px) {
            .mm-checkout-page { grid-template-columns: 1fr; }
            .mm-order-summary { position: static; }
            .mm-input-grid { grid-template-columns: 1fr; }
            .mm-addr-types { grid-template-columns: 1fr 1fr 1fr; }
        }
    </style>
</head>
<body class="page-wrapper">

    <nav class="mm-navbar">
        <a href="home.jsp" class="mm-logo">MealMate</a>
        <div class="mm-nav-actions">
            <a href="cart.jsp" class="mm-nav-link"><i class="fa-solid fa-arrow-left"></i> Back to Cart</a>
            <button class="mm-theme-toggle" id="themeToggle">🌙</button>
        </div>
    </nav>

    <div class="mm-checkout-page">

        <!-- LEFT: CHECKOUT FORM -->
        <div>
            <form action="OrderServlet" method="POST" id="checkoutForm">

                <!-- Delivery Details -->
                <div class="mm-checkout-section">
                    <div class="mm-section-head">
                        <div class="mm-section-num">1</div>
                        <h2>Delivery Details</h2>
                    </div>

                    <div class="mm-addr-types">
                        <div class="mm-addr-type active" onclick="selectAddrType(this)">
                            <span class="addr-icon">🏠</span> Home
                        </div>
                        <div class="mm-addr-type" onclick="selectAddrType(this)">
                            <span class="addr-icon">💼</span> Work
                        </div>
                        <div class="mm-addr-type" onclick="selectAddrType(this)">
                            <span class="addr-icon">📍</span> Other
                        </div>
                    </div>

                    <div class="mm-input-grid">
                        <div class="mm-form-group">
                            <label class="mm-label">Full Name</label>
                            <input type="text" name="name" class="mm-input" placeholder="Your full name" required>
                        </div>
                        <div class="mm-form-group">
                            <label class="mm-label">Phone Number</label>
                            <input type="tel" name="phone" class="mm-input" placeholder="10-digit number" required pattern="[0-9]{10}">
                        </div>
                        <div class="mm-form-group full-width">
                            <label class="mm-label">Delivery Address</label>
                            <textarea name="address" class="mm-textarea" placeholder="House/Flat No, Street, Area" required></textarea>
                        </div>
                        <div class="mm-form-group">
                            <label class="mm-label">City</label>
                            <input type="text" name="city" class="mm-input" placeholder="City" required>
                        </div>
                        <div class="mm-form-group">
                            <label class="mm-label">Pincode</label>
                            <input type="text" name="pin" class="mm-input" placeholder="6-digit pin" required>
                        </div>
                    </div>
                </div>

                <!-- Payment Method -->
                <div class="mm-checkout-section">
                    <div class="mm-section-head">
                        <div class="mm-section-num">2</div>
                        <h2>Payment Method</h2>
                    </div>

                    <!-- UPI -->
                    <div class="mm-pay-option active" id="wrapper-UPI">
                        <div class="mm-pay-header" onclick="selectPayment('UPI')">
                            <input type="radio" name="paymentMode" value="UPI" id="radio-UPI" checked>
                            <div class="mm-pay-info">
                                <div class="mm-pay-icon">📱</div>
                                <div>
                                    <div class="mm-pay-title">UPI / Google Pay</div>
                                    <div class="mm-pay-subtitle">Instant payment via any UPI app</div>
                                </div>
                            </div>
                            <div class="mm-pay-radio"></div>
                        </div>
                        <div class="mm-pay-body">
                            <p style="font-size:13px;color:var(--text-muted);margin-bottom:12px;">Select your preferred UPI app</p>
                            <div class="mm-upi-apps">
                                <div class="mm-upi-app" onclick="selectUPIApp(this)">
                                    <span class="mm-upi-app-icon">🟢</span> GPay
                                </div>
                                <div class="mm-upi-app" onclick="selectUPIApp(this)">
                                    <span class="mm-upi-app-icon">🟣</span> PhonePe
                                </div>
                                <div class="mm-upi-app" onclick="selectUPIApp(this)">
                                    <span class="mm-upi-app-icon">🔵</span> Paytm
                                </div>
                                <div class="mm-upi-app" onclick="selectUPIApp(this)">
                                    <span class="mm-upi-app-icon">⚪</span> BHIM
                                </div>
                            </div>
                            <input type="text" class="mm-input" placeholder="Or enter UPI ID (e.g. name@okhdfcbank)">
                        </div>
                    </div>

                    <!-- Card -->
                    <div class="mm-pay-option" id="wrapper-CARD">
                        <div class="mm-pay-header" onclick="selectPayment('CARD')">
                            <input type="radio" name="paymentMode" value="ONLINE" id="radio-CARD">
                            <div class="mm-pay-info">
                                <div class="mm-pay-icon">💳</div>
                                <div>
                                    <div class="mm-pay-title">Credit / Debit Card</div>
                                    <div class="mm-pay-subtitle">Visa, MasterCard, RuPay</div>
                                </div>
                            </div>
                            <div class="mm-pay-radio"></div>
                        </div>
                        <div class="mm-pay-body">
                            <div class="mm-form-group" style="margin-bottom:12px;">
                                <label class="mm-label">Card Number</label>
                                <input type="text" class="mm-input" placeholder="0000 0000 0000 0000" maxlength="19">
                            </div>
                            <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:12px;">
                                <div class="mm-form-group" style="margin:0;">
                                    <label class="mm-label">Expiry</label>
                                    <input type="text" class="mm-input" placeholder="MM/YY" maxlength="5">
                                </div>
                                <div class="mm-form-group" style="margin:0;">
                                    <label class="mm-label">CVV</label>
                                    <input type="password" class="mm-input" placeholder="***" maxlength="3">
                                </div>
                            </div>
                            <input type="text" class="mm-input" placeholder="Name on Card">
                            <p style="font-size:12px;color:#2ED573;margin-top:10px;text-align:center;"><i class="fa-solid fa-shield-halved"></i> Your card details are securely encrypted</p>
                        </div>
                    </div>

                    <!-- COD -->
                    <div class="mm-pay-option" id="wrapper-COD">
                        <div class="mm-pay-header" onclick="selectPayment('COD')">
                            <input type="radio" name="paymentMode" value="COD" id="radio-COD">
                            <div class="mm-pay-info">
                                <div class="mm-pay-icon">💵</div>
                                <div>
                                    <div class="mm-pay-title">Cash on Delivery</div>
                                    <div class="mm-pay-subtitle">Pay at your doorstep</div>
                                </div>
                            </div>
                            <div class="mm-pay-radio"></div>
                        </div>
                        <div class="mm-pay-body">
                            <div style="background:var(--bg-tertiary);border-radius:10px;padding:16px;text-align:center;">
                                <span style="font-size:32px;display:block;margin-bottom:10px;">🛵</span>
                                <p style="font-size:14px;font-weight:600;color:var(--text-primary);">Please keep exact change ready.</p>
                                <p style="font-size:13px;color:var(--text-muted);margin-top:6px;">Our delivery partner may not carry large change.</p>
                            </div>
                        </div>
                    </div>

                    <button type="submit" class="mm-place-order-btn" id="placeOrderBtn">
                        <span><i class="fa-solid fa-lock"></i> Place Order Securely</span>
                        <span>₹<%= String.format("%.2f", grandTotal) %> →</span>
                    </button>

                    <p class="mm-trust-text">
                        <i class="fa-solid fa-shield-halved" style="color:#2ED573;"></i>
                        100% Secure & Encrypted Payment
                    </p>
                </div>

            </form>
        </div>

        <!-- RIGHT: ORDER SUMMARY -->
        <div class="mm-order-summary">
            <h2 class="mm-order-summary-title">Order Summary</h2>

            <% for (CartItem item : cartItems) {
                Menu m = menuDAO.getMenu(item.getMenuId());
                if(m != null) { %>
            <div class="mm-receipt-item">
                <div>
                    <span class="mm-receipt-qty"><%= item.getQuantity() %>x</span>
                    <span class="mm-receipt-name"><%= m.getItemName() %></span>
                </div>
                <span class="mm-receipt-price">₹<%= String.format("%.2f", m.getPrice() * item.getQuantity()) %></span>
            </div>
            <% } } %>

            <div class="mm-receipt-divider"></div>

            <div class="mm-receipt-row">
                <span>Item Total</span>
                <span>₹<%= String.format("%.2f", subTotal) %></span>
            </div>
            <div class="mm-receipt-row">
                <span>GST (5%)</span>
                <span>₹<%= String.format("%.2f", tax) %></span>
            </div>
            <div class="mm-receipt-row">
                <span>Delivery</span>
                <% if (deliveryFee == 0) { %><span style="color:#2ED573;font-weight:700;">FREE</span><% } else { %><span>₹<%= String.format("%.2f", deliveryFee) %></span><% } %>
            </div>
            <div class="mm-receipt-row">
                <span>Packaging</span>
                <span>₹<%= String.format("%.2f", packagingFee) %></span>
            </div>

            <div class="mm-receipt-total">
                <span>Total</span>
                <span>₹<%= String.format("%.2f", grandTotal) %></span>
            </div>

            <div style="margin-top:20px;padding:16px;background:rgba(46,213,115,0.08);border:1px solid rgba(46,213,115,0.2);border-radius:12px;font-size:13px;color:#1a9e52;font-weight:600;display:flex;align-items:center;gap:8px;">
                <span>🎉</span>
                <span><% if(deliveryFee == 0){ %>Free delivery applied!</><%} else { %>Add ₹<%= String.format("%.0f", 299 - subTotal) %> more for free delivery<% } %></span>
            </div>
        </div>

    </div>

    <script src="js/script.js"></script>
    <script>
        function selectPayment(method) {
            document.querySelectorAll('.mm-pay-option').forEach(w => w.classList.remove('active'));
            document.getElementById('wrapper-' + method).classList.add('active');
            document.getElementById('radio-' + method).checked = true;
        }

        function selectUPIApp(el) {
            document.querySelectorAll('.mm-upi-app').forEach(a => a.classList.remove('selected'));
            el.classList.add('selected');
        }

        function selectAddrType(el) {
            document.querySelectorAll('.mm-addr-type').forEach(a => a.classList.remove('active'));
            el.classList.add('active');
        }

        document.getElementById('placeOrderBtn').addEventListener('click', function() {
            this.innerHTML = '<span><span style="animation:spin 1s linear infinite;display:inline-block">⟳</span> Placing Order...</span><span>Processing...</span>';
        });
    </script>
</body>
</html>