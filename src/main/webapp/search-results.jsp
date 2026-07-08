<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.tap.Model.Restaurant" %>

<%
    // 1. Get the search results and the search term
    List<Restaurant> results = (List<Restaurant>) request.getAttribute("restaurants");
    String searchQuery = request.getParameter("searchQuery");
    if (searchQuery == null) searchQuery = "";

    // 2. INTELLIGENT IMAGE ENGINE
    Map<String, String> imageMap = new HashMap<>();
    imageMap.put("south indian", "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?q=80&w=800"); 
    imageMap.put("biryani", "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?q=80&w=800"); 
    imageMap.put("pizza", "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=800"); 
    imageMap.put("fast food", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800"); 
    imageMap.put("burgers", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800"); 
    imageMap.put("chinese", "https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=800"); 
    imageMap.put("ice cream", "https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?q=80&w=800"); 
    imageMap.put("desserts", "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=800"); 
    imageMap.put("healthy food", "https://images.unsplash.com/photo-1509722747041-616f39b57569?q=80&w=800"); 
    imageMap.put("bbq", "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800"); 

    String userName = (String) session.getAttribute("loggedInUserName");
    String firstName = (userName != null && userName.contains(" ")) ? userName.substring(0, userName.indexOf(" ")) : userName;
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results | MealMate</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .mm-search-header-sec {
            max-width: 1280px;
            margin: 40px auto 10px;
            padding: 0 24px;
        }

        .mm-search-header-sec h1 {
            font-size: 26px;
            font-weight: 900;
            color: var(--text-primary);
        }

        .mm-search-header-sec span {
            color: var(--primary);
            font-style: italic;
        }
    </style>
</head>
<body class="page-wrapper">

    <!-- NAVBAR -->
    <nav class="mm-navbar">
        <a href="home.jsp" class="mm-logo">MealMate</a>

        <form class="mm-nav-search" action="SearchServlet" method="GET">
            <i class="fa-solid fa-magnifying-glass mm-nav-search-icon"></i>
            <input type="text" name="searchQuery" value="<%= searchQuery %>" placeholder="Search restaurants, cuisines, dishes...">
        </form>

        <div class="mm-nav-actions">
            <span class="mm-greeting">Hi, <b><%= firstName != null ? firstName : "Foodie" %></b></span>
            <a href="home.jsp" class="mm-nav-link"><i class="fa-solid fa-house"></i> Home</a>
            <a href="HistoryServlet" class="mm-nav-link"><i class="fa-solid fa-receipt"></i> Orders</a>
            <a href="cart.jsp" class="mm-cart-btn"><i class="fa-solid fa-bag-shopping"></i> Cart</a>
            <button class="mm-theme-toggle" id="themeToggle">🌙</button>
            <a href="LogoutServlet" class="mm-logout-btn">Logout</a>
        </div>
    </nav>

    <div class="mm-search-header-sec">
        <h1>Search results for: <span>"<%= searchQuery %>"</span></h1>
    </div>

    <!-- MAIN GRID -->
    <main class="mm-section" style="padding-top: 10px;">
        <% if (results != null && !results.isEmpty()) { %>
            <div class="mm-restaurant-grid">
                <%
                    int cardIndex = 0;
                    String[] badgeTypes = {"", "20% OFF", "TRENDING", "NEW", "POPULAR", "TOP RATED", "BESTSELLER", ""};
                    String[] badgeClasses = {"", "offer", "trending", "new", "offer", "trending", "new", ""};

                    for (Restaurant r : results) {
                        String cuisine = r.getCuisineType() != null ? r.getCuisineType().toLowerCase() : "";
                        String currentImageUrl = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=800";
                        
                        for (String key : imageMap.keySet()) {
                            if (cuisine.contains(key)) {
                                currentImageUrl = imageMap.get(key);
                                break;
                            }
                        }
                        
                        String badge = badgeTypes[cardIndex % badgeTypes.length];
                        String badgeClass = badgeClasses[cardIndex % badgeClasses.length];
                        cardIndex++;
                %>
                <article class="mm-restaurant-card reveal visible">
                    <div class="mm-card-image-wrap">
                        <div class="mm-card-bg" style="background-image:url('<%= currentImageUrl %>');"></div>
                        <div class="mm-card-overlay"></div>
                        <% if (!badge.isEmpty()) { %>
                        <span class="mm-card-badge <%= badgeClass %>"><%= badge %></span>
                        <% } %>
                        <div class="mm-card-rating-overlay">
                            <span class="star">★</span> <%= r.getRating() %>
                        </div>
                    </div>
                    <div class="mm-card-body">
                        <div class="mm-card-top">
                            <h3 class="mm-card-name" title="<%= r.getName() %>"><%= r.getName() %></h3>
                        </div>
                        <p class="mm-card-cuisine"><i class="fa-solid fa-utensils" style="color:var(--primary);font-size:11px;margin-right:5px;"></i><%= r.getCuisineType() %></p>
                        <div class="mm-card-footer">
                            <div class="mm-card-meta">
                                <span><i class="fa-regular fa-clock"></i> <%= r.getDeliveryTime() %> min</span>
                                <span><i class="fa-solid fa-location-dot"></i> 2.5 km</span>
                            </div>
                            <a href="menu.jsp?restaurantId=<%= r.getRestaurantId() %>" class="mm-view-btn">Order Now</a>
                        </div>
                    </div>
                </article>
                <% } %>
            </div>
        <% } else { %>
            <div class="mm-empty-state animate-scale-in">
                <span class="mm-empty-icon">🔍</span>
                <h2 class="mm-empty-title">No matching results</h2>
                <p class="mm-empty-desc">We couldn't find any restaurants or cuisines matching "<%= searchQuery %>". Let's explore everything else!</p>
                <a href="home.jsp" class="mm-btn-primary">
                    <i class="fa-solid fa-compass"></i> Explore All Restaurants
                </a>
            </div>
        <% } %>
    </main>

    <script src="js/script.js"></script>
</body>
</html>