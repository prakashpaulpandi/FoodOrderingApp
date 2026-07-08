<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.DAO.UserDAO, com.tap.DAOImple.UserDAOImple, com.tap.Model.User" %>

<%
    // 1. Security Check
    Integer userId = (Integer) session.getAttribute("loggedInUserId");
    if (userId == null) {
        response.sendRedirect("Login.html");
        return;
    }

    // 2. Fetch fresh user data from the database
    UserDAO userDAO = new UserDAOImple();
    User currentUser = userDAO.getUser(userId);
    
    String successMsg = request.getParameter("success");
    String userName = (String) session.getAttribute("loggedInUserName");
    String firstName = (userName != null && userName.contains(" ")) ? userName.substring(0, userName.indexOf(" ")) : userName;
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | MealMate</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .mm-profile-layout {
            max-width: 1000px;
            margin: 40px auto;
            padding: 0 24px 80px;
            display: grid;
            grid-template-columns: 1fr 2.5fr;
            gap: 30px;
        }

        .mm-profile-sidebar {
            text-align: center;
        }

        .mm-avatar-container {
            position: relative;
            width: 120px;
            height: 120px;
            margin: 0 auto 20px;
        }

        .mm-avatar {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--bg-secondary);
            box-shadow: var(--shadow-md);
        }

        .mm-edit-avatar {
            position: absolute;
            bottom: 5px;
            right: 5px;
            background: var(--primary);
            color: white;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border: 2px solid var(--bg-secondary);
            box-shadow: var(--shadow-sm);
        }

        .mm-user-name {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-primary);
        }

        .mm-user-email {
            color: var(--text-muted);
            font-size: 14px;
            margin-top: 4px;
        }

        .mm-alert-success {
            background: rgba(46, 213, 115, 0.1);
            border: 1px solid rgba(46, 213, 115, 0.2);
            color: #2ed573;
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-weight: 600;
            text-align: center;
        }

        .mm-profile-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 768px) {
            .mm-profile-layout {
                grid-template-columns: 1fr;
            }
            .form-row {
                grid-template-columns: 1fr;
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
            <a href="HistoryServlet" class="mm-nav-link"><i class="fa-solid fa-receipt"></i> Orders</a>
            <a href="cart.jsp" class="mm-cart-btn"><i class="fa-solid fa-bag-shopping"></i> Cart</a>
            <button class="mm-theme-toggle" id="themeToggle">🌙</button>
            <a href="LogoutServlet" class="mm-logout-btn">Logout</a>
        </div>
    </nav>

    <div class="mm-profile-layout">
        
        <!-- SIDEBAR -->
        <div class="mm-card mm-profile-sidebar animate-fade-in">
            <div class="mm-avatar-container">
                <img src="https://ui-avatars.com/api/?name=<%= currentUser.getUserName() %>&background=FF4757&color=fff&size=150" alt="Avatar" class="mm-avatar">
                <div class="mm-edit-avatar" onclick="window.MealMate && MealMate.Toast.show('Avatar uploading is a simulated feature!', 'info')">📷</div>
            </div>
            <h2 class="mm-user-name"><%= currentUser.getUserName() %></h2>
            <p class="mm-user-email"><%= currentUser.getEmail() %></p>
            
            <div style="margin-top: 30px; padding-top: 20px; border-top: 1px solid var(--border-color);">
                <p style="font-size: 13px; color: var(--text-muted); font-weight: 500;">Role: <b><%= currentUser.getRole() %></b></p>
                <% if ("Admin".equalsIgnoreCase(currentUser.getRole())) { %>
                    <a href="AdminDashboardServlet" class="mm-btn-primary" style="margin-top: 15px; width: 100%; padding: 10px; font-size: 13px;">Admin Dashboard</a>
                <% } %>
            </div>
        </div>

        <!-- FORM PANEL -->
        <div class="mm-card animate-fade-in" style="animation-delay: 0.1s;">
            <% if ("true".equals(successMsg)) { %>
                <div class="mm-alert-success mm-alert">
                    <i class="fa-solid fa-circle-check"></i> Profile updated successfully!
                </div>
            <% } %>

            <h2 class="mm-section-title" style="margin-bottom: 25px;">Account Settings</h2>
            
            <form action="UpdateProfileServlet" method="POST" class="mm-profile-form">
                <div class="form-row">
                    <div class="mm-form-group">
                        <label class="mm-label">Full Name</label>
                        <input type="text" name="name" class="mm-input" value="<%= currentUser.getUserName() %>" required>
                    </div>
                    <div class="mm-form-group">
                        <label class="mm-label">Phone Number</label>
                        <input type="tel" name="phone" class="mm-input" value="<%= currentUser.getPhone() %>" required>
                    </div>
                </div>

                <div class="mm-form-group">
                    <label class="mm-label">Email Address (Cannot be changed)</label>
                    <input type="email" class="mm-input" value="<%= currentUser.getEmail() %>" disabled style="background: var(--bg-tertiary); cursor: not-allowed; opacity: 0.7;">
                </div>

                <h2 class="mm-section-title" style="margin-top: 20px; margin-bottom: 10px;">Security</h2>
                
                <div class="mm-form-group">
                    <label class="mm-label">New Password (Leave blank to keep current password)</label>
                    <div class="mm-password-wrap">
                        <input type="password" name="password" class="mm-input" placeholder="Enter new password">
                        <button type="button" class="mm-password-toggle">👁️</button>
                    </div>
                </div>

                <div style="margin-top: 10px;">
                    <button type="submit" class="mm-btn-primary">
                        <i class="fa-solid fa-floppy-disk"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>

    </div>

    <script src="js/script.js"></script>
</body>
</html>