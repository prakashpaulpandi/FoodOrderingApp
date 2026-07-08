<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Ensure the user actually just placed an order
    Object idObj = session.getAttribute("latestOrderId");
    String orderId = (idObj != null) ? idObj.toString() : null;
    if (orderId == null) {
        response.sendRedirect("home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed | MealMate</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--bg-primary);
            padding: 20px;
        }

        .mm-success-card {
            text-align: center;
            max-width: 500px;
            width: 100%;
            padding: 50px 40px;
        }

        .mm-success-icon-container {
            position: relative;
            width: 100px;
            height: 100px;
            margin: 0 auto 30px;
        }

        .mm-success-icon-bg {
            position: absolute;
            inset: 0;
            background: rgba(46, 213, 115, 0.1);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        .mm-success-circle {
            position: absolute;
            inset: 10px;
            background: #2ed573;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 10px 25px rgba(46, 213, 115, 0.3);
            animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            color: white;
            font-size: 36px;
        }

        .mm-order-id-badge {
            background: var(--bg-tertiary);
            border: 1.5px dashed var(--border-color);
            padding: 12px 24px;
            border-radius: 12px;
            font-size: 18px;
            font-weight: 800;
            color: var(--text-primary);
            letter-spacing: 0.5px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin: 24px 0 32px;
        }

        .success-actions {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
    </style>
</head>
<body class="mm-success-page page-wrapper">

    <div class="mm-card mm-success-card animate-scale-in">
        <div class="mm-success-icon-container">
            <div class="mm-success-icon-bg"></div>
            <div class="mm-success-circle">
                <i class="fa-solid fa-check"></i>
            </div>
        </div>
        
        <h1 style="font-size: 30px; font-weight: 900; color: var(--text-primary); margin-bottom: 12px;">Order Confirmed!</h1>
        <p style="color: var(--text-secondary); font-size: 15px; line-height: 1.6; max-width: 380px; margin: 0 auto;">
            Yum! Your delicious food is being prepared and will reach your location shortly.
        </p>
        
        <div class="mm-order-id-badge">
            <span style="font-size: 14px; color: var(--text-muted); font-weight: 600; text-transform: uppercase;">Order ID:</span>
            <span>#<%= orderId %></span>
        </div>
        
        <div class="success-actions">
            <a href="HistoryServlet" class="mm-btn-primary">
                <i class="fa-solid fa-receipt"></i> Track My Order
            </a>
            <a href="home.jsp" class="mm-btn-secondary">
                <i class="fa-solid fa-bag-shopping"></i> Continue Shopping
            </a>
        </div>
    </div>

    <script src="js/script.js"></script>
</body>
</html>