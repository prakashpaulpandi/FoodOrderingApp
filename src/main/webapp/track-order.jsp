<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.Model.Order" %>

<%
    Order order = (Order) request.getAttribute("trackOrder");
    if (order == null) { response.sendRedirect("HistoryServlet"); return; }

    String currentStatus = order.getStatus() != null ? order.getStatus() : "Pending";
    
    // Determine the active progress step
    int step = 1; // Default: Order Placed
    boolean isCancelled = currentStatus.equalsIgnoreCase("Cancelled");
    
    if (!isCancelled) {
        if (currentStatus.equalsIgnoreCase("Preparing")) step = 2;
        else if (currentStatus.equalsIgnoreCase("Out for Delivery") || currentStatus.equalsIgnoreCase("Out_for_Delivery")) step = 3;
        else if (currentStatus.equalsIgnoreCase("Delivered") || currentStatus.equalsIgnoreCase("Reviewed")) step = 4;
    }
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Order | MealMate</title>
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
            padding: 20px;
        }

        .mm-tracking-card {
            max-width: 600px;
            width: 100%;
            padding: 40px;
        }

        .mm-tracking-header {
            text-align: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 24px;
            margin-bottom: 30px;
        }

        .mm-tracking-header h1 {
            font-size: 24px;
            font-weight: 900;
        }

        .mm-tracking-header p {
            color: var(--text-muted);
            font-size: 13px;
            margin-top: 4px;
        }

        .mm-delivery-guy-card {
            background: var(--bg-tertiary);
            border-radius: 14px;
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 30px;
            border: 1px solid var(--border-color);
        }

        .mm-delivery-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--accent-orange));
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            box-shadow: var(--shadow-sm);
        }

        .mm-delivery-info {
            flex: 1;
        }

        .mm-delivery-name {
            font-size: 14px;
            font-weight: 800;
            color: var(--text-primary);
        }

        .mm-delivery-status {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 2px;
        }

        .mm-delivery-call {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: rgba(46, 213, 115, 0.1);
            color: #2ed573;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            transition: all 0.2s ease;
            border: 1px solid rgba(46, 213, 115, 0.2);
        }

        .mm-delivery-call:hover {
            background: #2ed573;
            color: white;
        }
    </style>
</head>
<body class="page-wrapper">

    <div class="mm-card mm-tracking-card animate-scale-in">
        <div class="mm-tracking-header">
            <h1>Track Your Order</h1>
            <p>Order ID: #<%= order.getOrderId() %> &nbsp;•&nbsp; Total Amount: <b>₹<%= String.format("%.2f", order.getTotalAmount()) %></b></p>
        </div>

        <% if (isCancelled) { %>
            <div class="mm-timeline">
                <div class="mm-timeline-step active cancelled">
                    <div class="mm-timeline-dot" style="background: var(--primary); border-color: var(--primary); color: white;">
                        <i class="fa-solid fa-xmark"></i>
                    </div>
                    <div class="mm-timeline-step-title" style="color: var(--primary);">Order Cancelled</div>
                    <div class="mm-timeline-step-desc">This order was cancelled. Please feel free to place a new order.</div>
                </div>
            </div>
        <% } else { %>
            <!-- Delivery agent simulation box for outstanding look -->
            <% if (step >= 3) { %>
                <div class="mm-delivery-guy-card reveal visible">
                    <div class="mm-delivery-avatar">🛵</div>
                    <div class="mm-delivery-info">
                        <div class="mm-delivery-name">Ramesh Kumar</div>
                        <div class="mm-delivery-status">Your delivery partner is near your location</div>
                    </div>
                    <a href="tel:9876543210" class="mm-delivery-call" title="Call delivery partner">
                        <i class="fa-solid fa-phone"></i>
                    </a>
                </div>
            <% } %>

            <div class="mm-timeline">
                
                <div class="mm-timeline-step <%= step >= 1 ? "active" : "" %>">
                    <div class="mm-timeline-dot">
                        <i class="fa-solid fa-file-invoice"></i>
                    </div>
                    <div class="mm-timeline-step-title">Order Placed</div>
                    <div class="mm-timeline-step-desc">We have received your order and are confirming details.</div>
                </div>

                <div class="mm-timeline-step <%= step >= 2 ? "active" : "" %>">
                    <div class="mm-timeline-dot">
                        <i class="fa-solid fa-fire-burner"></i>
                    </div>
                    <div class="mm-timeline-step-title">Kitchen Preparing</div>
                    <div class="mm-timeline-step-desc">Our chefs are preparing your delicious meals right now.</div>
                </div>

                <div class="mm-timeline-step <%= step >= 3 ? "active" : "" %>">
                    <div class="mm-timeline-dot">
                        <i class="fa-solid fa-motorcycle"></i>
                    </div>
                    <div class="mm-timeline-step-title">Out for Delivery</div>
                    <div class="mm-timeline-step-desc">Your order is on the way. Our delivery partner is rushing to you.</div>
                </div>

                <div class="mm-timeline-step <%= step >= 4 ? "active" : "" %>">
                    <div class="mm-timeline-dot">
                        <i class="fa-solid fa-circle-check"></i>
                    </div>
                    <div class="mm-timeline-step-title">Delivered</div>
                    <div class="mm-timeline-step-desc">Enjoy your meal! Please rate us on your order history page.</div>
                </div>

            </div>
        <% } %>

        <a href="HistoryServlet" class="mm-btn-primary" style="margin-top: 40px; width: 100%; justify-content: center;">
            <i class="fa-solid fa-arrow-left"></i> Return to Order History
        </a>
    </div>

    <script src="js/script.js"></script>
</body>
</html>