<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.tap.DAO.RestaurantDAO" %>
<%@ page import="com.tap.DAOImple.RestaurantDAOImple" %>
<%@ page import="com.tap.Model.Restaurant" %>

<%
    // 1. SECURITY & SESSION CHECK
    Integer userId = (Integer) session.getAttribute("loggedInUserId");
    if (userId == null) {
        response.sendRedirect("Login.html");
        return;
    }
    
    // Extract first name for a friendly greeting
    String userName = (String) session.getAttribute("loggedInUserName");
    String firstName = (userName != null && userName.contains(" ")) ? userName.substring(0, userName.indexOf(" ")) : userName;

    // 2. FETCH DATABASE DATA
    RestaurantDAO restaurantDAO = new RestaurantDAOImple();
    List<Restaurant> restaurantList = restaurantDAO.getAllRestaurants();

    // 3. INTELLIGENT IMAGE ENGINE
    Map<String, String> imageMap = new HashMap<>();
    imageMap.put("south indian", "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?q=80&w=800");
    imageMap.put("biryani", "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?q=80&w=800");
    imageMap.put("pizza", "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=800");
    imageMap.put("fast food", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800");
    imageMap.put("burger", "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=800");
    imageMap.put("chinese", "https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=800");
    imageMap.put("ice cream", "https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?q=80&w=800");
    imageMap.put("dessert", "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=800");
    imageMap.put("healthy", "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=800");
    imageMap.put("bbq", "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=800");
    imageMap.put("chicken", "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=800");
    imageMap.put("seafood", "https://images.unsplash.com/photo-1534482421-64566f976cfa?q=80&w=800");
    imageMap.put("north indian", "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=800");
    imageMap.put("mughlai", "https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?q=80&w=800");
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MealMate - Order Food Online | Best Restaurants Near You</title>
    <meta name="description" content="Order food online from the best restaurants near you. Fast delivery, great food, amazing deals.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Offers banner */
        .mm-offers-strip {
            background: linear-gradient(90deg, #FF4757, #FF6B35, #FFC312, #2ED573, #1E90FF, #FF4757);
            background-size: 300% 100%;
            animation: gradientShift 8s linear infinite;
            color: white;
            text-align: center;
            padding: 10px;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.5px;
        }
        @keyframes gradientShift { 0% { background-position: 0% 50%; } 100% { background-position: 300% 50%; } }

        /* Stats bar */
        .mm-stats-bar {
            background: var(--bg-secondary);
            border-bottom: 1px solid var(--border-color);
            padding: 12px 5%;
            display: flex;
            gap: 32px;
            justify-content: center;
            flex-wrap: wrap;
        }

        .mm-stats-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: var(--text-muted);
            font-weight: 600;
        }

        .mm-stats-item span:first-child {
            font-size: 18px;
        }

        .mm-stats-item strong {
            color: var(--text-primary);
        }

        /* Hero specific */
        .mm-hero {
            position: relative;
            min-height: 420px;
            display: flex;
            align-items: center;
            background: linear-gradient(135deg, #1A0A0A 0%, #2D0F0F 50%, #1A1A2E 100%);
            overflow: hidden;
        }

        .mm-hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: url('https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=2000&fit=crop') center/cover no-repeat;
            opacity: 0.15;
        }

        .mm-hero-gradient {
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(255,71,87,0.3) 0%, rgba(255,107,53,0.2) 50%, rgba(26,26,46,0.8) 100%);
        }

        .mm-hero-floating-cards {
            position: absolute;
            right: 10%;
            top: 50%;
            transform: translateY(-50%);
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .mm-float-card {
            background: rgba(255,255,255,0.1);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 12px;
            padding: 12px 18px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: white;
            font-size: 13px;
            font-weight: 600;
            animation: floatCard 4s ease-in-out infinite;
        }

        .mm-float-card:nth-child(2) { animation-delay: 1s; }
        .mm-float-card:nth-child(3) { animation-delay: 2s; }

        @keyframes floatCard {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-8px); }
        }

        .mm-float-icon {
            width: 36px; height: 36px;
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            font-size: 18px;
        }

        .mm-float-icon.green { background: rgba(46,213,115,0.2); }
        .mm-float-icon.orange { background: rgba(255,107,53,0.2); }
        .mm-float-icon.blue { background: rgba(30,144,255,0.2); }

        /* Category section */
        .mm-category-scroll {
            display: flex;
            gap: 14px;
            overflow-x: auto;
            padding-bottom: 8px;
            scrollbar-width: none;
        }
        .mm-category-scroll::-webkit-scrollbar { display: none; }

        .mm-cat-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            padding: 18px 16px;
            background: var(--bg-secondary);
            border: 1.5px solid var(--border-color);
            border-radius: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 90px;
            text-decoration: none;
            color: var(--text-secondary);
        }

        .mm-cat-item:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-glow);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255,71,87,0.12);
        }

        .mm-cat-emoji { font-size: 30px; }
        .mm-cat-label { font-size: 12px; font-weight: 700; text-align: center; white-space: nowrap; }

        /* Offer banner cards */
        .mm-offer-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
        }

        .mm-offer-card {
            border-radius: 16px;
            padding: 24px;
            color: white;
            position: relative;
            overflow: hidden;
            min-height: 130px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
        }

        .mm-offer-card::before {
            content: '';
            position: absolute;
            top: -40px;
            right: -40px;
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: rgba(255,255,255,0.1);
        }

        .mm-offer-card::after {
            content: '';
            position: absolute;
            bottom: -20px;
            right: 20px;
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
        }

        .mm-offer-card.red { background: linear-gradient(135deg, #FF4757, #C0392B); }
        .mm-offer-card.orange { background: linear-gradient(135deg, #FF6B35, #E55B2A); }
        .mm-offer-card.green { background: linear-gradient(135deg, #2ED573, #1A8F4A); }

        .mm-offer-percent {
            font-size: 42px;
            font-weight: 900;
            line-height: 1;
            position: relative;
            z-index: 1;
        }

        .mm-offer-text {
            font-size: 14px;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .mm-offer-badge {
            position: absolute;
            top: 14px;
            right: 14px;
            background: rgba(255,255,255,0.2);
            border-radius: 8px;
            padding: 4px 10px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            z-index: 1;
        }

        /* Testimonials */
        .mm-testimonials {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }

        .mm-testimonial-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 24px;
            transition: all 0.3s ease;
        }

        .mm-testimonial-card:hover {
            border-color: var(--primary);
            box-shadow: 0 8px 25px rgba(255,71,87,0.1);
        }

        .mm-test-stars {
            color: #FFC312;
            font-size: 16px;
            margin-bottom: 12px;
        }

        .mm-test-text {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.7;
            margin-bottom: 16px;
            font-style: italic;
        }

        .mm-test-author {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .mm-test-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .mm-test-name { font-size: 14px; font-weight: 700; color: var(--text-primary); }
        .mm-test-order { font-size: 12px; color: var(--text-muted); }

        /* Newsletter */
        .mm-newsletter {
            background: linear-gradient(135deg, #FF4757 0%, #FF6B35 100%);
            border-radius: 24px;
            padding: 50px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .mm-newsletter::before {
            content: '';
            position: absolute;
            top: -80px; right: -80px;
            width: 250px; height: 250px;
            border-radius: 50%;
            background: rgba(255,255,255,0.08);
        }

        .mm-newsletter::after {
            content: '';
            position: absolute;
            bottom: -60px; left: -60px;
            width: 200px; height: 200px;
            border-radius: 50%;
            background: rgba(255,255,255,0.06);
        }

        .mm-newsletter h2 {
            font-size: 28px;
            font-weight: 900;
            margin-bottom: 10px;
            position: relative;
            z-index: 1;
        }

        .mm-newsletter p {
            font-size: 16px;
            opacity: 0.9;
            margin-bottom: 28px;
            position: relative;
            z-index: 1;
        }

        .mm-newsletter-form {
            display: flex;
            max-width: 440px;
            margin: 0 auto;
            gap: 0;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            position: relative;
            z-index: 1;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .mm-newsletter-form input {
            flex: 1;
            padding: 16px 20px;
            border: none;
            outline: none;
            font-size: 14px;
            color: #1A1A2E;
        }

        .mm-newsletter-form button {
            background: linear-gradient(135deg, #FF4757, #C0392B);
            color: white;
            border: none;
            padding: 16px 24px;
            font-weight: 700;
            font-size: 14px;
            cursor: pointer;
        }

        @media (max-width: 768px) {
            .mm-hero-floating-cards { display: none; }
            .mm-newsletter { padding: 36px 24px; }
            .mm-newsletter h2 { font-size: 22px; }
        }
    </style>
</head>
<body class="page-wrapper">

    <!-- OFFERS STRIP -->
    <div class="mm-offers-strip">
        🔥 50% OFF on first 3 orders | Use code: NEWUSER50 &nbsp;&nbsp;|&nbsp;&nbsp; 🚀 Free delivery on orders above ₹299 &nbsp;&nbsp;|&nbsp;&nbsp; 🎉 Weekend Special: Extra 20% OFF
    </div>

    <!-- NAVBAR -->
    <nav class="mm-navbar">
        <a href="home.jsp" class="mm-logo">MealMate</a>

        <form class="mm-nav-search" action="SearchServlet" method="GET">
            <i class="fa-solid fa-magnifying-glass mm-nav-search-icon"></i>
            <input type="text" name="searchQuery" placeholder="Search restaurants, cuisines, dishes...">
        </form>

        <div class="mm-nav-actions">
            <span class="mm-greeting">Hi, <b><%= firstName != null ? firstName : "Foodie" %></b></span>
            <a href="home.jsp" class="mm-nav-link"><i class="fa-solid fa-house"></i> Home</a>
            <a href="HistoryServlet" class="mm-nav-link"><i class="fa-solid fa-receipt"></i> Orders</a>
            <a href="profile.jsp" class="mm-nav-link"><i class="fa-solid fa-user"></i> Profile</a>
            <a href="cart.jsp" class="mm-cart-btn"><i class="fa-solid fa-bag-shopping"></i> Cart</a>
            <button class="mm-theme-toggle" id="themeToggle" title="Toggle dark/light mode">🌙</button>
            <a href="LogoutServlet" class="mm-logout-btn">Logout</a>
        </div>
    </nav>

    <!-- HERO SECTION -->
    <section class="mm-hero">
        <div class="mm-hero-gradient"></div>
        <div class="mm-hero-content" style="position:relative;z-index:1;padding:60px 5%;max-width:650px;">
            <div class="mm-hero-badge">
                <span>🌟</span> #1 Food Delivery Platform
            </div>
            <h1 style="color:white;font-size:clamp(28px,4vw,50px);font-weight:900;line-height:1.15;margin-bottom:16px;text-shadow:0 2px 20px rgba(0,0,0,0.3);">
                Hungry, <%= firstName != null ? firstName : "there" %>?<br>
                <span style="background:linear-gradient(135deg,#FFC312,#FF6B35);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text;">
                    Great food awaits!
                </span>
            </h1>
            <p style="color:rgba(255,255,255,0.85);font-size:17px;margin-bottom:32px;">
                Order from 500+ restaurants. Delivered in 30 mins or less.
            </p>
            <form class="mm-hero-search" action="SearchServlet" method="GET">
                <input type="text" name="searchQuery" placeholder="🔍 Biryani, Pizza, Burger...">
                <button type="submit"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
            </form>
            <div style="display:flex;gap:24px;margin-top:24px;flex-wrap:wrap;">
                <span style="color:rgba(255,255,255,0.7);font-size:13px;font-weight:600;display:flex;align-items:center;gap:6px;">
                    <span style="color:#2ED573;">✓</span> 30-min delivery
                </span>
                <span style="color:rgba(255,255,255,0.7);font-size:13px;font-weight:600;display:flex;align-items:center;gap:6px;">
                    <span style="color:#2ED573;">✓</span> 500+ restaurants
                </span>
                <span style="color:rgba(255,255,255,0.7);font-size:13px;font-weight:600;display:flex;align-items:center;gap:6px;">
                    <span style="color:#2ED573;">✓</span> No hidden charges
                </span>
            </div>
        </div>

        <!-- Floating Cards -->
        <div class="mm-hero-floating-cards">
            <div class="mm-float-card">
                <div class="mm-float-icon green">🛵</div>
                <div>
                    <div style="font-size:12px;opacity:0.7;">Order delivered!</div>
                    <div>Raj's Biryani Palace</div>
                </div>
            </div>
            <div class="mm-float-card">
                <div class="mm-float-icon orange">🍕</div>
                <div>
                    <div style="font-size:12px;opacity:0.7;">New deal!</div>
                    <div>50% OFF Pizza Hut</div>
                </div>
            </div>
            <div class="mm-float-card">
                <div class="mm-float-icon blue">⭐</div>
                <div>
                    <div style="font-size:12px;opacity:0.7;">Top rated</div>
                    <div>Barbeque Nation</div>
                </div>
            </div>
        </div>
    </section>

    <!-- STATS BAR -->
    <div class="mm-stats-bar">
        <div class="mm-stats-item"><span>🍽️</span> <div><strong>500+</strong> Restaurants</div></div>
        <div class="mm-stats-item"><span>⚡</span> <div><strong>30 mins</strong> Avg delivery</div></div>
        <div class="mm-stats-item"><span>😊</span> <div><strong>2M+</strong> Happy customers</div></div>
        <div class="mm-stats-item"><span>🎯</span> <div><strong>98%</strong> On-time delivery</div></div>
        <div class="mm-stats-item"><span>💰</span> <div><strong>Best</strong> Prices</div></div>
    </div>

    <!-- FOOD CATEGORIES -->
    <section class="mm-section">
        <div class="mm-section-header">
            <div>
                <h2 class="mm-section-title">What's on your mind?</h2>
                <p class="mm-section-subtitle">Browse by cuisine or dish type</p>
            </div>
        </div>
        <div class="mm-category-scroll">
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🍕</span><span class="mm-cat-label">Pizza</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🍔</span><span class="mm-cat-label">Burgers</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🍜</span><span class="mm-cat-label">Chinese</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🍛</span><span class="mm-cat-label">Biryani</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🥞</span><span class="mm-cat-label">South Indian</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🍣</span><span class="mm-cat-label">Sushi</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🌮</span><span class="mm-cat-label">Wraps</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🍦</span><span class="mm-cat-label">Ice Cream</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">☕</span><span class="mm-cat-label">Cafe</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🥗</span><span class="mm-cat-label">Healthy</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🔥</span><span class="mm-cat-label">BBQ</span></a>
            <a href="home.jsp" class="mm-cat-item"><span class="mm-cat-emoji">🫕</span><span class="mm-cat-label">Thali</span></a>
        </div>
    </section>

    <!-- SPECIAL OFFERS -->
    <section class="mm-section" style="padding-top:0;">
        <div class="mm-section-header">
            <div>
                <h2 class="mm-section-title">Hot Deals For You</h2>
                <p class="mm-section-subtitle">Limited time offers — grab them fast!</p>
            </div>
        </div>
        <div class="mm-offer-cards">
            <div class="mm-offer-card red">
                <div class="mm-offer-badge">Today Only</div>
                <div class="mm-offer-percent">50% OFF</div>
                <div class="mm-offer-text">On your first 3 orders | Code: NEWUSER50</div>
            </div>
            <div class="mm-offer-card orange">
                <div class="mm-offer-badge">Weekends</div>
                <div class="mm-offer-percent">20% OFF</div>
                <div class="mm-offer-text">Weekend special on all pizza orders</div>
            </div>
            <div class="mm-offer-card green">
                <div class="mm-offer-badge">Free Delivery</div>
                <div class="mm-offer-percent">₹0</div>
                <div class="mm-offer-text">Free delivery on orders above ₹299</div>
            </div>
        </div>
    </section>

    <!-- RESTAURANTS SECTION -->
    <section class="mm-section" style="padding-top:0;">
        <div class="mm-section-header">
            <div>
                <h2 class="mm-section-title reveal">Restaurants Near You</h2>
                <p class="mm-section-subtitle reveal">Delivering to your location in Chennai</p>
            </div>
            <a href="home.jsp" class="mm-see-all">See all <i class="fa-solid fa-arrow-right"></i></a>
        </div>

        <div class="mm-restaurant-grid">
            <%
                String[] badgeTypes = {"", "20% OFF", "TRENDING", "NEW", "POPULAR", "TOP RATED", "BESTSELLER", ""};
                String[] badgeClasses = {"", "offer", "trending", "new", "offer", "trending", "new", ""};
                int cardIndex = 0;

                if (restaurantList != null && !restaurantList.isEmpty()) {
                    for (Restaurant r : restaurantList) {
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
            <article class="mm-restaurant-card reveal">
                <div class="mm-card-image-wrap">
                    <div class="mm-card-bg" style="background-image:url('<%= currentImageUrl %>');width:100%;height:100%;background-size:cover;background-position:center;transition:transform 0.6s ease;"></div>
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
            <%
                    }
                } else {
            %>
            <div class="mm-empty-state" style="grid-column:1/-1;">
                <span class="mm-empty-icon">🏪</span>
                <h3 class="mm-empty-title">No restaurants found</h3>
                <p class="mm-empty-desc">Make sure you've run the database script in MySQL Workbench.</p>
            </div>
            <%
                }
            %>
        </div>
    </section>

    <!-- TESTIMONIALS -->
    <section class="mm-section" style="background:var(--bg-tertiary);max-width:100%;padding:60px 5%;">
        <div style="max-width:1280px;margin:0 auto;">
            <div class="mm-section-header">
                <div>
                    <h2 class="mm-section-title">What our foodies say</h2>
                    <p class="mm-section-subtitle">Real reviews from real customers</p>
                </div>
            </div>
            <div class="mm-testimonials">
                <div class="mm-testimonial-card reveal">
                    <div class="mm-test-stars">★★★★★</div>
                    <p class="mm-test-text">"MealMate is absolutely incredible! The delivery is always fast and the food arrives hot. Best food delivery app I've ever used!"</p>
                    <div class="mm-test-author">
                        <img src="https://ui-avatars.com/api/?name=Priya+Sharma&background=FF4757&color=fff&size=80" alt="Priya" class="mm-test-avatar">
                        <div>
                            <div class="mm-test-name">Priya Sharma</div>
                            <div class="mm-test-order">🍛 Ordered Hyderabadi Biryani</div>
                        </div>
                    </div>
                </div>
                <div class="mm-testimonial-card reveal">
                    <div class="mm-test-stars">★★★★★</div>
                    <p class="mm-test-text">"The variety of restaurants is amazing. I can find anything from South Indian to Italian. My go-to app for ordering food!"</p>
                    <div class="mm-test-author">
                        <img src="https://ui-avatars.com/api/?name=Arjun+Kumar&background=FF6B35&color=fff&size=80" alt="Arjun" class="mm-test-avatar">
                        <div>
                            <div class="mm-test-name">Arjun Kumar</div>
                            <div class="mm-test-order">🍕 Ordered Margherita Pizza</div>
                        </div>
                    </div>
                </div>
                <div class="mm-testimonial-card reveal">
                    <div class="mm-test-stars">★★★★★</div>
                    <p class="mm-test-text">"The offers and discounts are unbeatable! I always find great deals and the food quality is consistently excellent."</p>
                    <div class="mm-test-author">
                        <img src="https://ui-avatars.com/api/?name=Meera+Nair&background=2ED573&color=fff&size=80" alt="Meera" class="mm-test-avatar">
                        <div>
                            <div class="mm-test-name">Meera Nair</div>
                            <div class="mm-test-order">🍔 Ordered Zinger Burger</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- NEWSLETTER -->
    <section class="mm-section" style="padding-top:0;">
        <div class="mm-newsletter reveal">
            <h2>🎉 Get Exclusive Offers!</h2>
            <p>Subscribe to our newsletter and get 20% off on your next order</p>
            <div class="mm-newsletter-form">
                <input type="email" placeholder="Enter your email address...">
                <button type="button">Subscribe</button>
            </div>
        </div>
    </section>

    <!-- FOOTER -->
    <footer class="mm-footer">
        <div class="mm-footer-grid">
            <div>
                <div class="mm-footer-brand">🍽️ MealMate</div>
                <p class="mm-footer-desc">Your favorite food, delivered fast. Connecting you with the best restaurants in your city since 2024.</p>
                <div class="mm-footer-social">
                    <a href="#" title="Facebook"><i class="fa-brands fa-facebook-f"></i></a>
                    <a href="#" title="Twitter"><i class="fa-brands fa-x-twitter"></i></a>
                    <a href="#" title="Instagram"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#" title="YouTube"><i class="fa-brands fa-youtube"></i></a>
                </div>
            </div>
            <div>
                <h4 class="mm-footer-heading">Company</h4>
                <ul class="mm-footer-links">
                    <li><a href="#">→ About Us</a></li>
                    <li><a href="#">→ Careers</a></li>
                    <li><a href="#">→ Press</a></li>
                    <li><a href="#">→ Blog</a></li>
                </ul>
            </div>
            <div>
                <h4 class="mm-footer-heading">For Foodies</h4>
                <ul class="mm-footer-links">
                    <li><a href="home.jsp">→ Restaurants</a></li>
                    <li><a href="HistoryServlet">→ My Orders</a></li>
                    <li><a href="profile.jsp">→ My Profile</a></li>
                    <li><a href="#">→ Rewards</a></li>
                </ul>
            </div>
            <div>
                <h4 class="mm-footer-heading">Support</h4>
                <ul class="mm-footer-links">
                    <li><a href="#">→ Help Center</a></li>
                    <li><a href="#">→ Privacy Policy</a></li>
                    <li><a href="#">→ Terms of Service</a></li>
                    <li><a href="#">→ Contact Us</a></li>
                </ul>
            </div>
        </div>
        <div class="mm-footer-bottom">
            <span>© 2024 MealMate. All rights reserved.</span>
            <span>Made with ❤️ for food lovers</span>
        </div>
    </footer>

    <script src="js/script.js"></script>
    <script>
        // Hover effect on restaurant cards
        document.querySelectorAll('.mm-restaurant-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
                const bg = this.querySelector('.mm-card-bg');
                if (bg) bg.style.transform = 'scale(1.08)';
            });
            card.addEventListener('mouseleave', function() {
                const bg = this.querySelector('.mm-card-bg');
                if (bg) bg.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>