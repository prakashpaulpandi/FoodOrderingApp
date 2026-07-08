<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.Model.Order" %>

<%
    // Security check & User Info
    Integer userId = (Integer) session.getAttribute("loggedInUserId");
    if (userId == null) {
        response.sendRedirect("Login.html");
        return;
    }
    String userName = (String) session.getAttribute("loggedInUserName");
    String firstName = (userName != null && userName.contains(" ")) ? userName.substring(0, userName.indexOf(" ")) : userName;

    // Fetch History
    List<Order> history = (List<Order>) request.getAttribute("orderHistory");
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | MealMate</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .mm-history-layout {
            max-width: 900px;
            margin: 40px auto;
            padding: 0 24px 80px;
        }

        .mm-history-header {
            margin-bottom: 30px;
        }

        .mm-history-header h1 {
            font-size: 28px;
            font-weight: 900;
            color: var(--text-primary);
        }

        .mm-history-header p {
            color: var(--text-muted);
            font-size: 14px;
            margin-top: 4px;
        }

        /* Order card styling */
        .mm-order-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 18px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: var(--shadow-sm);
            display: flex;
            gap: 20px;
            transition: all 0.3s ease;
        }

        .mm-order-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: rgba(255, 71, 87, 0.2);
        }

        .mm-order-icon-wrap {
            width: 70px;
            height: 70px;
            border-radius: 12px;
            background: var(--bg-tertiary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            flex-shrink: 0;
            box-shadow: var(--shadow-sm);
        }

        .mm-order-info {
            flex: 1;
        }

        .mm-order-title {
            font-size: 17px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 6px;
        }

        .mm-order-meta {
            display: flex;
            gap: 16px;
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 500;
            margin-bottom: 12px;
            flex-wrap: wrap;
        }

        .mm-order-meta span {
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .mm-order-right {
            text-align: right;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-width: 150px;
        }

        .mm-order-price {
            font-size: 18px;
            font-weight: 900;
            color: var(--text-primary);
            margin-bottom: 8px;
        }

        .mm-order-actions {
            display: flex;
            flex-direction: column;
            gap: 8px;
            align-items: flex-end;
        }

        .mm-history-btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 8px 16px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .mm-history-btn.track {
            background: rgba(46, 213, 115, 0.1);
            color: #2ed573;
            border: 1px solid rgba(46, 213, 115, 0.2);
        }
        .mm-history-btn.track:hover { background: #2ed573; color: white; }

        .mm-history-btn.reorder {
            background: var(--primary);
            color: white;
            border: none;
        }
        .mm-history-btn.reorder:hover { background: var(--primary-dark); }

        .mm-history-btn.details {
            background: var(--bg-tertiary);
            color: var(--text-secondary);
            border: 1px solid var(--border-color);
        }
        .mm-history-btn.details:hover { border-color: var(--primary); color: var(--primary); }

        .rating-select {
            padding: 6px;
            border-radius: 6px;
            border: 1.5px solid var(--border-color);
            background: var(--bg-secondary);
            color: var(--text-primary);
            font-size: 12px;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .mm-order-card {
                flex-direction: column;
                gap: 16px;
            }
            .mm-order-right {
                text-align: left;
                align-items: flex-start;
                border-top: 1px dashed var(--border-color);
                padding-top: 16px;
            }
            .mm-order-actions {
                align-items: flex-start;
                flex-direction: row;
                flex-wrap: wrap;
                width: 100%;
            }
        }
    </style>
</head>
<body class="page-wrapper">

    <!-- NAVBAR -->
    <nav class="mm-navbar">
        <a href="home.jsp" class="mm-logo">MealMate</a>
        <div class="mm-nav-actions">
            <span class="mm-greeting">Hi, <b><%= firstName != null ? firstName : "Foodie" %></b></span>
            <a href="home.jsp" class="mm-nav-link"><i class="fa-solid fa-house"></i> Home</a>
            <a href="cart.jsp" class="mm-cart-btn"><i class="fa-solid fa-bag-shopping"></i> Cart</a>
            <a href="profile.jsp" class="mm-nav-link"><i class="fa-solid fa-user"></i> Profile</a>
            <button class="mm-theme-toggle" id="themeToggle">🌙</button>
            <a href="LogoutServlet" class="mm-logout-btn">Logout</a>
        </div>
    </nav>

    <div class="mm-history-layout">
        <div class="mm-history-header">
            <h1>Past Orders</h1>
            <p>Review your previous orders, track live status and share ratings.</p>
        </div>
        
        <% if(history != null && !history.isEmpty()) { 
            for(Order o : history) { 
                String statusClass = "pending";
                String currentStatus = (o.getStatus() != null) ? o.getStatus().toLowerCase() : "";
                
                if(currentStatus.contains("delivered") || currentStatus.contains("completed")) statusClass = "delivered";
                else if(currentStatus.contains("preparing")) statusClass = "preparing";
                else if(currentStatus.contains("out_for_delivery") || currentStatus.contains("out")) statusClass = "out-for-delivery";
                else if(currentStatus.contains("cancelled") || currentStatus.contains("failed")) statusClass = "cancelled";
        %>
                <div class="mm-order-card animate-fade-in">
                    <div class="mm-order-icon-wrap">🍔</div>
                    
                    <div class="mm-order-info">
                        <% 
                            com.tap.DAO.OrderItemDAO itemDAO = new com.tap.DAOImple.OrderItemDAOImple();
                            com.tap.DAO.MenuDAO menuDAO = new com.tap.DAOImple.MenuDAOImple();
                            
                            java.util.List<com.tap.Model.OrderItem> items = itemDAO.getOrderItemsByOrderId(o.getOrderId());
                            
                            String itemSummary = "";
                            if (items != null && !items.isEmpty()) {
                                for (com.tap.Model.OrderItem item : items) {
                                    com.tap.Model.Menu menuItem = menuDAO.getMenu(item.getMenuId());
                                    if (menuItem != null) {
                                        itemSummary += item.getQuantity() + "x " + menuItem.getItemName() + ", ";
                                    }
                                }
                                if(itemSummary.length() > 2) {
                                    itemSummary = itemSummary.substring(0, itemSummary.length() - 2); 
                                }
                            }
                            if (itemSummary.isEmpty()) {
                                itemSummary = "Delicious meal from MealMate"; 
                            }
                        %>
                        
                        <h3 class="mm-order-title" title="<%= itemSummary %>">
                            <%= itemSummary %>
                        </h3>
                        
                        <div class="mm-order-meta">
                            <span><i class="fa-solid fa-hashtag"></i> Order #<%= o.getOrderId() %></span>
                            <span><i class="fa-regular fa-calendar-days"></i> <%= o.getOrderDate() %></span>
                        </div>
                        
                        <div>
                            <span class="mm-pill <%= statusClass %>"><%= o.getStatus() %></span>
                        </div>
                    </div>

                    <div class="mm-order-right">
                        <div class="mm-order-price">₹<%= String.format("%.2f", o.getTotalAmount()) %></div>
                        
                        <div class="mm-order-actions">
                            <% 
                                String currentStat = o.getStatus() != null ? o.getStatus() : "";
                                if (!currentStat.equalsIgnoreCase("Delivered") && !currentStat.equalsIgnoreCase("Reviewed") && !currentStat.equalsIgnoreCase("Cancelled")) { 
                            %>
                                <a href="TrackOrderServlet?orderId=<%= o.getOrderId() %>" class="mm-history-btn track">
                                    <i class="fa-solid fa-location-crosshairs"></i> Track Order
                                </a>
                            <% } %>
                            
                            <% if (currentStat.equalsIgnoreCase("Delivered")) { %>
                                <form action="RateOrderServlet" method="POST" style="display: flex; gap: 8px; width: 100%; justify-content: flex-end;">
                                    <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                    <input type="hidden" name="restaurantId" value="<%= o.getRestaurantId() %>">
                                    <select name="rating" class="rating-select">
                                        <option value="5">5 ★</option>
                                        <option value="4">4 ★</option>
                                        <option value="3">3 ★</option>
                                        <option value="2">2 ★</option>
                                        <option value="1">1 ★</option>
                                    </select>
                                    <button type="submit" class="mm-history-btn" style="background: #ffc312; color: #1a1a2d; border: none;">Rate</button>
                                </form>
                            <% } else if (currentStat.equalsIgnoreCase("Reviewed")) { %>
                                <span class="mm-pill reviewed"><i class="fa-solid fa-star"></i> Rated</span>
                            <% } %>

                            <a href="OrderDetailsServlet?orderId=<%= o.getOrderId() %>" class="mm-history-btn details">
                                <i class="fa-solid fa-receipt"></i> Details
                            </a>
                            
                            <form action="ReorderServlet" method="POST" style="width: 100%;">
                                <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                                <input type="hidden" name="restaurantId" value="<%= o.getRestaurantId() %>">
                                <button type="submit" class="mm-history-btn reorder" style="width: 100%; justify-content: center;">
                                    <i class="fa-solid fa-rotate-left"></i> Reorder
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
        <% } } else { %>
            <div class="mm-empty-state animate-scale-in">
                <span class="mm-empty-icon">🧾</span>
                <h2 class="mm-empty-title">No orders found</h2>
                <p class="mm-empty-desc">Looks like you haven't placed any orders yet. Let's find you something delicious!</p>
                <a href="home.jsp" class="mm-btn-primary">
                    <i class="fa-solid fa-utensils"></i> Explore Restaurants
                </a>
            </div>
        <% } %>
    </div>

    <script src="js/script.js"></script>
</body>
</html>