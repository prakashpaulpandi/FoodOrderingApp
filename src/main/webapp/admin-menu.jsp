<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.Model.Menu" %>
<%@ page import="com.tap.DAO.MenuDAO, com.tap.DAOImple.MenuDAOImple" %>

<%
    // Security Check: Only allow Admins
    String role = (String) session.getAttribute("userRole");
    if (role == null || !role.equalsIgnoreCase("Admin")) { response.sendRedirect("home.jsp"); return; }
    
    MenuDAO menuDAO = new MenuDAOImple();
    List<Menu> menuList = menuDAO.getAllMenus();
    
    String loggedInUserName = (String) session.getAttribute("loggedInUserName");
    String avatarName = (loggedInUserName != null && loggedInUserName.length() > 0) ? loggedInUserName.substring(0, 1).toUpperCase() : "A";
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Menu | MealMate Admin</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="mm-admin-layout page-wrapper">

    <!-- SIDEBAR -->
    <aside class="mm-sidebar">
        <div class="mm-sidebar-header">
            <div class="mm-sidebar-logo">🍽️ MealMate</div>
            <div class="mm-sidebar-subtitle">Command Center</div>
        </div>
        <nav class="mm-sidebar-nav">
            <a href="AdminDashboardServlet"><i class="fa-solid fa-chart-simple"></i> Dashboard</a>
            <a href="admin-menu.jsp" class="active"><i class="fa-solid fa-utensils"></i> Manage Menu</a>
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

    <!-- MAIN MENU MANAGEMENT CONTENT -->
    <main class="mm-admin-content">
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
            <div>
                <h1 style="font-size: 28px; font-weight: 900; color: var(--text-primary);">Manage Menu</h1>
                <p style="color: var(--text-muted); font-size: 14px; margin-top: 4px;">Add, update, or remove dishes from MealMate menus.</p>
            </div>
            <div>
                <button class="mm-theme-toggle" id="themeToggle" style="width: 44px; height: 44px; font-size: 20px;">🌙</button>
            </div>
        </div>
        
        <!-- Add Item Card -->
        <div class="mm-card animate-fade-in" style="margin-bottom: 32px;">
            <h3 style="font-size: 18px; font-weight: 800; margin-bottom: 20px; color: var(--text-primary);">Add New Menu Item</h3>
            <form action="MenuManagementServlet?action=add" method="POST" style="display: flex; flex-direction: column; gap: 20px;">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px;">
                    <div class="mm-form-group" style="margin: 0;">
                        <label class="mm-label">Restaurant ID</label>
                        <input type="number" name="restaurantId" placeholder="e.g. 1" required class="mm-input">
                    </div>
                    <div class="mm-form-group" style="margin: 0;">
                        <label class="mm-label">Item Name</label>
                        <input type="text" name="itemName" placeholder="e.g. Paneer Butter Masala" required class="mm-input">
                    </div>
                    <div class="mm-form-group" style="margin: 0;">
                        <label class="mm-label">Price (₹)</label>
                        <input type="number" step="0.01" name="price" placeholder="e.g. 250" required class="mm-input">
                    </div>
                    <div class="mm-form-group" style="margin: 0;">
                        <label class="mm-label">Category</label>
                        <input type="text" name="category" placeholder="e.g. Main Course" required class="mm-input">
                    </div>
                    <div class="mm-form-group" style="margin: 0;">
                        <label class="mm-label">Availability</label>
                        <select name="isAvailable" class="mm-input" style="padding: 13px 16px;">
                            <option value="true">Available</option>
                            <option value="false">Unavailable</option>
                        </select>
                    </div>
                </div>
                
                <div class="mm-form-group" style="margin: 0;">
                    <label class="mm-label">Description</label>
                    <input type="text" name="description" placeholder="Short description of ingredients or taste" required class="mm-input">
                </div>
                
                <div>
                    <button type="submit" class="mm-btn-primary">
                        <i class="fa-solid fa-plus"></i> Add Item to Menu
                    </button>
                </div>
            </form>
        </div>

        <!-- Menu List Card -->
        <div class="mm-card animate-fade-in" style="animation-delay: 0.1s; padding: 0; overflow: hidden;">
            <div style="padding: 24px; border-bottom: 1px solid var(--border-color);">
                <h3 style="font-size: 18px; font-weight: 800; color: var(--text-primary);">All Menu Items</h3>
            </div>
            
            <div style="overflow-x: auto;">
                <table class="mm-table">
                    <thead>
                        <tr>
                            <th>Item Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Status</th>
                            <th style="text-align: right;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(menuList != null && !menuList.isEmpty()) { 
                            for(Menu m : menuList) { 
                        %>
                            <tr>
                                <td style="font-weight: 700; color: var(--text-primary);"><%= m.getItemName() %></td>
                                <td><%= m.getCategory() %></td>
                                <td style="font-weight: 700; color: var(--text-primary);">₹<%= String.format("%.2f", m.getPrice()) %></td>
                                <td>
                                    <span class="mm-pill <%= m.isAvailable() ? "delivered" : "cancelled" %>">
                                        <%= m.isAvailable() ? "Available" : "Unavailable" %>
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <form action="MenuManagementServlet?action=delete" method="POST" style="display: inline;">
                                        <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                                        <button type="submit" class="mm-btn-danger">
                                            <i class="fa-solid fa-trash-can"></i> Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 40px; color: var(--text-muted);">
                                    <i class="fa-solid fa-utensils" style="font-size: 30px; display: block; margin-bottom: 12px; opacity: 0.5;"></i>
                                    No menu items found.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script src="js/script.js"></script>
</body>
</html>