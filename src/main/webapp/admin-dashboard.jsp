<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.Model.Order, com.tap.Model.OrderItem, com.tap.Model.Menu" %>
<%@ page import="com.tap.DAO.OrderItemDAO, com.tap.DAOImple.OrderItemDAOImple" %>
<%@ page import="com.tap.DAO.MenuDAO, com.tap.DAOImple.MenuDAOImple" %>

<%
    // Security and Data Fetching
    String role = (String) session.getAttribute("userRole");
    if (role == null || !role.equalsIgnoreCase("Admin")) { response.sendRedirect("home.jsp"); return; }
    
    List<Order> allOrders = (List<Order>) request.getAttribute("allOrders");
    if (allOrders == null) { response.sendRedirect("AdminDashboardServlet"); return; }
    
    OrderItemDAO itemDAO = new OrderItemDAOImple();
    MenuDAO menuDAO = new MenuDAOImple();

    // --- REAL-TIME ANALYTICS ENGINE ---
    int totalOrders = allOrders.size();
    int activeOrders = 0;
    double totalRevenue = 0.0;
    
    for (Order o : allOrders) {
        String stat = o.getStatus() != null ? o.getStatus() : "Pending";
        if (stat.equalsIgnoreCase("Pending") || stat.equalsIgnoreCase("Preparing") || stat.equalsIgnoreCase("Out for Delivery") || stat.equalsIgnoreCase("Out_for_Delivery") || stat.equalsIgnoreCase("PLACED") || stat.equalsIgnoreCase("PREPARING") || stat.equalsIgnoreCase("OUT_FOR_DELIVERY")) {
            activeOrders++;
        }
        if (stat.equalsIgnoreCase("Delivered") || stat.equalsIgnoreCase("Reviewed") || stat.equalsIgnoreCase("DELIVERED")) {
            totalRevenue += o.getTotalAmount();
        }
    }
    
    String loggedInUserName = (String) session.getAttribute("loggedInUserName");
    String avatarName = (loggedInUserName != null && loggedInUserName.length() > 0) ? loggedInUserName.substring(0, 1).toUpperCase() : "A";
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Command Center | MealMate</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .admin-ticket-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 20px;
        }

        .admin-ticket {
            border: 1px solid var(--border-color);
            background: var(--bg-secondary);
            border-radius: 16px;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .admin-ticket:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-md);
        }

        .admin-ticket-header {
            background: var(--bg-tertiary);
            padding: 16px 20px;
            border-bottom: 1px dashed var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .admin-ticket-body {
            padding: 20px;
            flex-grow: 1;
        }

        .admin-food-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            font-size: 14px;
            border-bottom: 1px solid var(--bg-tertiary);
            padding-bottom: 8px;
        }

        .admin-food-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
            margin-bottom: 0;
        }

        .admin-qty {
            font-weight: 800;
            color: var(--primary);
            background: rgba(255, 71, 87, 0.1);
            padding: 2px 8px;
            border-radius: 6px;
            font-size: 12px;
            margin-right: 8px;
        }

        .admin-ticket-footer {
            padding: 16px 20px;
            background: var(--bg-tertiary);
            border-top: 1px solid var(--border-color);
        }

        .admin-ticket.status-pending { border-left: 5px solid #ffc312; }
        .admin-ticket.status-preparing { border-left: 5px solid #1e90ff; }
        .admin-ticket.status-out { border-left: 5px solid #a29bfe; }
    </style>
</head>
<body class="mm-admin-layout page-wrapper">

    <!-- SIDEBAR -->
    <aside class="mm-sidebar">
        <div class="mm-sidebar-header">
            <div class="mm-sidebar-logo">🍽️ MealMate</div>
            <div class="mm-sidebar-subtitle">Command Center</div>
        </div>
        <nav class="mm-sidebar-nav">
            <a href="AdminDashboardServlet" class="active"><i class="fa-solid fa-chart-simple"></i> Dashboard</a>
            <a href="admin-menu.jsp"><i class="fa-solid fa-utensils"></i> Manage Menu</a>
            <a href="profile.jsp"><i class="fa-solid fa-user-gear"></i> Settings</a>
            <a href="home.jsp"><i class="fa-solid fa-globe"></i> View Site</a>
        </nav>
        <div class="mm-sidebar-footer">
            <div class="mm-admin-profile">
                <div class="mm-admin-avatar"><%= avatarName %></div>
                <div class="mm-admin-info">
                    <h4><%= loggedInUserName %></h4>
                    <p>Platform Admin</p>
                </div>
            </div>
            <a href="LogoutServlet" style="display: flex; align-items: center; gap: 8px; color: var(--primary); font-weight: 700; font-size: 13px; text-decoration: none;">
                <i class="fa-solid fa-right-from-bracket"></i> Sign Out
            </a>
        </div>
    </aside>

    <!-- MAIN ADMIN CONTENT -->
    <main class="mm-admin-content">
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 style="font-size: 28px; font-weight: 900; color: var(--text-primary);">Dashboard</h1>
                <p style="color: var(--text-muted); font-size: 14px; margin-top: 4px;">Welcome back! Here's a live check of today's cravings.</p>
            </div>
            <div>
                <button class="mm-theme-toggle" id="themeToggle" style="width: 44px; height: 44px; font-size: 20px;">🌙</button>
            </div>
        </div>

        <!-- STATS GRID -->
        <div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 24px; margin-bottom: 40px;">
            <div class="mm-stat-card">
                <div class="mm-stat-icon blue"><i class="fa-solid fa-box-archive"></i></div>
                <div>
                    <div class="mm-stat-label">Total Orders</div>
                    <div class="mm-stat-value"><%= totalOrders %></div>
                </div>
            </div>
            <div class="mm-stat-card">
                <div class="mm-stat-icon orange"><i class="fa-solid fa-spinner"></i></div>
                <div>
                    <div class="mm-stat-label">Active Orders</div>
                    <div class="mm-stat-value"><%= activeOrders %></div>
                </div>
            </div>
            <div class="mm-stat-card">
                <div class="mm-stat-icon green"><i class="fa-solid fa-indian-rupee-sign"></i></div>
                <div>
                    <div class="mm-stat-label">Revenue</div>
                    <div class="mm-stat-value">₹<%= String.format("%.2f", totalRevenue) %></div>
                </div>
            </div>
        </div>

        <h2 class="mm-section-title" style="margin-bottom: 24px;">Live Kitchen Queue</h2>
        
        <div class="admin-ticket-grid">
            <% 
                for (Order o : allOrders) { 
                    String status = o.getStatus() != null ? o.getStatus() : "Pending";
                    // Hide delivered/cancelled orders from the kitchen queue to keep it clutter free
                    if (status.equalsIgnoreCase("Delivered") || status.equalsIgnoreCase("Reviewed") || status.equalsIgnoreCase("DELIVERED") || status.equalsIgnoreCase("Cancelled") || status.equalsIgnoreCase("CANCELLED")) {
                        continue; 
                    }
                    
                    String statusClass = "status-pending";
                    if (status.equalsIgnoreCase("Preparing") || status.equalsIgnoreCase("PREPARING")) statusClass = "status-preparing";
                    else if (status.equalsIgnoreCase("Out for Delivery") || status.equalsIgnoreCase("OUT_FOR_DELIVERY")) statusClass = "status-out";
            %>
                <div class="admin-ticket <%= statusClass %> animate-fade-in">
                    <div class="admin-ticket-header">
                        <span style="font-weight: 800; color: var(--text-primary);">Order #<%= o.getOrderId() %></span>
                        <span style="font-size: 13px; font-weight: 700; color: var(--primary);">₹<%= o.getTotalAmount() %></span>
                    </div>

                    <div class="admin-ticket-body">
                        <% 
                            List<OrderItem> items = itemDAO.getOrderItemsByOrderId(o.getOrderId());
                            if (items != null) {
                                for (OrderItem item : items) {
                                    Menu menuItem = menuDAO.getMenu(item.getMenuId());
                                    String itemName = (menuItem != null) ? menuItem.getItemName() : "Item";
                        %>
                                    <div class="admin-food-item">
                                        <div><span class="admin-qty"><%= item.getQuantity() %>x</span> <%= itemName %></div>
                                    </div>
                        <%      }
                            } 
                        %>
                    </div>

                    <div class="admin-ticket-footer">
                        <form action="UpdateStatusServlet" method="POST" style="display: flex; flex-direction: column; gap: 10px;">
                            <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                            
                            <select name="newStatus" class="mm-input" style="padding: 10px; font-size: 13px; font-weight: 600;">
                                <option value="PLACED" <%= status.equalsIgnoreCase("PLACED") || status.equalsIgnoreCase("Pending") ? "selected" : "" %>>Pending</option>
                                <option value="PREPARING" <%= status.equalsIgnoreCase("PREPARING") || status.equalsIgnoreCase("Preparing") ? "selected" : "" %>>Preparing</option>
                                <option value="OUT_FOR_DELIVERY" <%= status.equalsIgnoreCase("OUT_FOR_DELIVERY") || status.equalsIgnoreCase("Out for Delivery") ? "selected" : "" %>>Out for Delivery</option>
                                <option value="DELIVERED" <%= status.equalsIgnoreCase("DELIVERED") || status.equalsIgnoreCase("Delivered") ? "selected" : "" %>>Delivered</option>
                                <option value="CANCELLED" <%= status.equalsIgnoreCase("CANCELLED") || status.equalsIgnoreCase("Cancelled") ? "selected" : "" %>>Cancel Order</option>
                            </select>
                            
                            <button type="submit" class="mm-btn-primary" style="padding: 10px 14px; font-size: 13px; width: 100%; justify-content: center; box-shadow: none;">
                                <i class="fa-solid fa-check"></i> Save Status
                            </button>
                        </form>
                    </div>
                </div>
            <% } %> 
        </div> 
    </main>

    <script src="js/script.js"></script>
</body>
</html>