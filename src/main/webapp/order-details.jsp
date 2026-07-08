<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.Model.Order, com.tap.Model.OrderItem, com.tap.Model.Restaurant, com.tap.Model.Menu" %>
<%@ page import="com.tap.DAO.MenuDAO, com.tap.DAOImple.MenuDAOImple" %>

<%
    // Retrieve the data passed from the Servlet
    Order order = (Order) request.getAttribute("order");
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("orderItems");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    
    // We need MenuDAO to get the names of the food items
    MenuDAO menuDAO = new MenuDAOImple();
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Receipt | MealMate</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            background-color: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .mm-receipt-container {
            max-width: 500px;
            width: 100%;
            padding: 40px;
            position: relative;
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 20px;
            box-shadow: var(--shadow-lg);
        }

        .mm-receipt-header {
            text-align: center;
            border-bottom: 2px dashed var(--border-color);
            padding-bottom: 24px;
            margin-bottom: 24px;
        }

        .mm-receipt-header h1 {
            font-size: 22px;
            font-weight: 900;
            color: var(--text-primary);
        }

        .mm-receipt-header p {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .mm-invoice-meta {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 24px;
            font-size: 13px;
        }

        .mm-invoice-field {
            display: flex;
            flex-direction: column;
        }

        .mm-invoice-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .mm-invoice-value {
            font-weight: 700;
            color: var(--text-primary);
            margin-top: 2px;
        }

        .mm-receipt-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 24px;
        }

        .mm-receipt-table th {
            text-align: left;
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 8px;
        }

        .mm-receipt-table td {
            padding: 12px 0;
            border-bottom: 1px solid var(--bg-tertiary);
            font-size: 14px;
        }

        .mm-receipt-total-sec {
            border-top: 2px dashed var(--border-color);
            padding-top: 20px;
        }

        .mm-receipt-row {
            display: flex;
            justify-content: space-between;
            font-size: 14px;
            color: var(--text-secondary);
            margin-bottom: 8px;
        }

        .mm-receipt-grand {
            display: flex;
            justify-content: space-between;
            font-size: 18px;
            font-weight: 900;
            color: var(--text-primary);
            margin-top: 14px;
        }
    </style>
</head>
<body class="page-wrapper">

    <div class="mm-receipt-container animate-scale-in">
        <% if (order != null && restaurant != null) { %>
            
            <div class="mm-receipt-header">
                <h1><%= restaurant.getName() %></h1>
                <p><i class="fa-solid fa-location-dot"></i> <%= restaurant.getAddress() %></p>
            </div>

            <div class="mm-invoice-meta">
                <div class="mm-invoice-field">
                    <span class="mm-invoice-label">Order ID</span>
                    <span class="mm-invoice-value">#<%= order.getOrderId() %></span>
                </div>
                <div class="mm-invoice-field" style="text-align: right;">
                    <span class="mm-invoice-label">Date & Time</span>
                    <span class="mm-invoice-value"><%= order.getOrderDate() %></span>
                </div>
            </div>

            <table class="mm-receipt-table">
                <thead>
                    <tr>
                        <th>Qty</th>
                        <th>Item Description</th>
                        <th style="text-align: right;">Price</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        if (items != null) {
                            for (OrderItem item : items) {
                                Menu menuItem = menuDAO.getMenu(item.getMenuId());
                                String itemName = (menuItem != null) ? menuItem.getItemName() : "Unknown Item";
                    %>
                    <tr>
                        <td style="font-weight: 800; color: var(--primary); width: 40px;"><%= item.getQuantity() %>x</td>
                        <td style="font-weight: 600; color: var(--text-primary);"><%= itemName %></td>
                        <td style="text-align: right; font-weight: 700; color: var(--text-primary);">₹<%= String.format("%.2f", item.getItemTotal()) %></td>
                    </tr>
                    <%      }
                        } 
                    %>
                </tbody>
            </table>

            <div class="mm-receipt-total-sec">
                <div class="mm-receipt-row">
                    <span>Subtotal</span>
                    <span>₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
                <div class="mm-receipt-row">
                    <span>GST & Delivery Fee</span>
                    <span style="color: #2ed573; font-weight: 600;">Included</span>
                </div>
                <div class="mm-receipt-grand">
                    <span>Total Paid</span>
                    <span>₹<%= String.format("%.2f", order.getTotalAmount()) %></span>
                </div>
            </div>

        <% } else { %>
            <div style="text-align: center; color: var(--primary); padding: 20px 0;">
                <i class="fa-solid fa-triangle-exclamation" style="font-size: 40px; margin-bottom: 12px;"></i>
                <h3>Receipt Not Found</h3>
                <p style="color: var(--text-muted); font-size: 13px; margin-top: 4px;">Oops! We couldn't find this receipt.</p>
            </div>
        <% } %>
        
        <a href="HistoryServlet" class="mm-btn-primary" style="margin-top: 30px; width: 100%; justify-content: center;">
            <i class="fa-solid fa-arrow-left"></i> Back to My Orders
        </a>
    </div>

    <script src="js/script.js"></script>
</body>
</html>