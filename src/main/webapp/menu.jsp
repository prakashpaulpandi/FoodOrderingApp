<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.DAO.RestaurantDAO" %>
<%@ page import="com.tap.DAOImple.RestaurantDAOImple" %>
<%@ page import="com.tap.DAO.MenuDAO" %>
<%@ page import="com.tap.DAOImple.MenuDAOImple" %>
<%@ page import="com.tap.Model.Restaurant" %>
<%@ page import="com.tap.Model.Menu" %>
<%@ page import="com.tap.DAO.UserDAO" %>
<%@ page import="com.tap.DAOImple.UserDAOImple" %>
<%@ page import="com.tap.Model.User" %>

<%
    // 1. SECURITY CHECK
    Integer userId = (Integer) session.getAttribute("loggedInUserId");
    if (userId == null) {
        response.sendRedirect("Login.html");
        return;
    }

    String userName = (String) session.getAttribute("loggedInUserName");
    String firstName = (userName != null && userName.contains(" ")) ? userName.substring(0, userName.indexOf(" ")) : userName;

    // 2. GET RESTAURANT ID FROM URL
    String restIdParam = request.getParameter("restaurantId");
    if (restIdParam == null || restIdParam.isEmpty()) {
        response.sendRedirect("home.jsp");
        return;
    }

    int restaurantId = Integer.parseInt(restIdParam);

    // 3. FETCH DATABASE DATA
    RestaurantDAO restaurantDAO = new RestaurantDAOImple();
    Restaurant currentRestaurant = restaurantDAO.getRestaurant(restaurantId);

    MenuDAO menuDAO = new MenuDAOImple();
    List<Menu> menuList = menuDAO.getMenusByRestaurant(restaurantId);
%>

<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= currentRestaurant != null ? currentRestaurant.getName() : "Restaurant Menu" %> | MealMate</title>
    <meta name="description" content="Order from <%= currentRestaurant != null ? currentRestaurant.getName() : "restaurant" %> on MealMate. Fast delivery guaranteed.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .mm-rest-hero {
            position: relative;
            height: 280px;
            overflow: hidden;
            background: linear-gradient(135deg, #1A0A0A, #2D0F0F);
        }
        .mm-rest-hero-bg {
            position: absolute;
            inset: 0;
            background-size: cover;
            background-position: center;
            filter: brightness(0.35) saturate(1.2);
            transition: transform 10s ease;
        }
        .mm-rest-hero-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.85) 0%, rgba(0,0,0,0.3) 60%, transparent 100%);
        }
        .mm-rest-hero-content {
            position: absolute;
            bottom: 0; left: 0; right: 0;
            padding: 32px 5%;
            color: white;
        }
        .mm-rest-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 20px;
            padding: 4px 14px;
            font-size: 12px;
            font-weight: 700;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .mm-rest-name {
            font-size: clamp(24px, 4vw, 40px);
            font-weight: 900;
            margin-bottom: 8px;
            text-shadow: 0 2px 10px rgba(0,0,0,0.5);
        }
        .mm-rest-meta-row {
            display: flex;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap;
        }
        .mm-rest-meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
            opacity: 0.9;
            font-weight: 500;
        }
        .mm-rest-rating-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            background: #2ED573;
            color: white;
            padding: 5px 12px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 800;
        }

        .mm-menu-layout {
            max-width: 1000px;
            margin: 0 auto;
            padding: 32px 24px 80px;
        }
        .mm-menu-filters {
            display: flex;
            gap: 10px;
            margin-bottom: 28px;
            flex-wrap: wrap;
        }
        .mm-filter-btn {
            padding: 8px 18px;
            border: 1.5px solid var(--border-color);
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            color: var(--text-secondary);
            background: var(--bg-secondary);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .mm-filter-btn:hover, .mm-filter-btn.active {
            border-color: var(--primary);
            color: var(--primary);
            background: var(--primary-glow);
        }
        .mm-menu-section-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .mm-menu-section-title::after {
            content: '';
            flex: 1;
            height: 2px;
            background: linear-gradient(90deg, var(--primary), transparent);
        }

        .mm-food-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 16px;
            padding: 20px;
            display: flex;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 14px;
            transition: all 0.3s ease;
            position: relative;
        }
        .mm-food-card:hover {
            border-color: rgba(255,71,87,0.3);
            box-shadow: 0 8px 25px rgba(255,71,87,0.08);
            transform: translateY(-2px);
        }
        .mm-food-img-wrap { position: relative; flex-shrink: 0; }
        .mm-food-img {
            width: 130px;
            height: 130px;
            border-radius: 12px;
            object-fit: cover;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            /* Prevents broken image icon from showing */
            background: linear-gradient(135deg, #f0f0f0, #e0e0e0);
        }
        .mm-food-img-placeholder {
            width: 130px;
            height: 130px;
            border-radius: 12px;
            background: linear-gradient(135deg, var(--bg-tertiary), var(--border-color));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }
        .mm-food-info { flex: 1; }
        .mm-food-name-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 6px;
        }
        .mm-food-name { font-size: 17px; font-weight: 800; color: var(--text-primary); }
        .mm-food-tag {
            font-size: 10px;
            font-weight: 700;
            padding: 3px 8px;
            border-radius: 4px;
            text-transform: uppercase;
        }
        .mm-food-tag.bestseller { background: #FFF3CD; color: #856404; }
        .mm-food-tag.popular { background: #D1ECDF; color: #145523; }
        .mm-food-tag.spicy { background: #F8D7DA; color: #721C24; }
        .mm-food-desc {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.6;
            margin-bottom: 14px;
            max-width: 90%;
        }
        .mm-food-price-row { display: flex; align-items: center; gap: 10px; }
        .mm-food-price { font-size: 20px; font-weight: 900; color: var(--text-primary); }
        .mm-food-price-original { font-size: 14px; color: var(--text-muted); text-decoration: line-through; }

        .mm-cart-form {
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            gap: 10px;
            min-width: 130px;
            align-self: center;
        }
        .mm-qty-control {
            display: flex;
            align-items: center;
            gap: 8px;
            border: 1.5px solid var(--border-color);
            border-radius: 8px;
            overflow: hidden;
            background: var(--bg-tertiary);
        }
        .mm-qty-dec, .mm-qty-inc {
            width: 32px; height: 32px;
            border: none;
            background: transparent;
            font-size: 18px;
            font-weight: 700;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .mm-qty-dec:hover, .mm-qty-inc:hover { background: var(--primary); color: white; }
        .mm-qty-field {
            width: 36px;
            text-align: center;
            border: none;
            background: transparent;
            font-size: 15px;
            font-weight: 800;
            color: var(--text-primary);
            outline: none;
        }
        .mm-add-btn {
            width: 100%;
            padding: 11px;
            background: white;
            color: var(--primary);
            border: 2px solid var(--primary);
            border-radius: 8px;
            font-size: 14px;
            font-weight: 800;
            cursor: pointer;
            transition: all 0.3s ease;
            text-align: center;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .mm-add-btn:hover {
            background: var(--primary);
            color: white;
            box-shadow: 0 4px 15px rgba(255,71,87,0.3);
        }
        .mm-add-btn:active { transform: scale(0.97); }

        .mm-type-indicator {
            width: 16px; height: 16px;
            border-radius: 3px;
            flex-shrink: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .mm-type-indicator.veg { border: 2px solid #2ED573; }
        .mm-type-indicator.veg::after { content: ''; width: 7px; height: 7px; border-radius: 50%; background: #2ED573; }
        .mm-type-indicator.nonveg { border: 2px solid var(--primary); }
        .mm-type-indicator.nonveg::after { content: ''; width: 0; height: 0; border-left: 5px solid transparent; border-right: 5px solid transparent; border-bottom: 8px solid var(--primary); }

        .mm-sticky-cart {
            position: fixed;
            bottom: 24px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 500;
            background: linear-gradient(135deg, var(--primary), var(--accent-orange));
            color: white;
            border: none;
            border-radius: 100px;
            padding: 16px 36px;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 8px 30px rgba(255,71,87,0.4);
            display: flex;
            align-items: center;
            gap: 10px;
            transition: all 0.3s ease;
            text-decoration: none;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }
        .mm-sticky-cart:hover {
            transform: translateX(-50%) translateY(-2px);
            box-shadow: 0 12px 40px rgba(255,71,87,0.5);
            color: white;
        }

        @media (max-width: 600px) {
            .mm-food-card { flex-wrap: wrap; }
            .mm-food-img, .mm-food-img-placeholder { width: 100%; height: 200px; }
            .mm-cart-form { flex-direction: row; width: 100%; min-width: auto; }
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

    <!-- RESTAURANT HERO -->
    <section class="mm-rest-hero">
        <%
            String restCuisine = currentRestaurant != null ? (currentRestaurant.getCuisineType() != null ? currentRestaurant.getCuisineType().toLowerCase() : "") : "";
            String restHeroImg = "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?q=80&w=2000&fit=crop";
            if      (restCuisine.contains("biryani") || restCuisine.contains("mughlai")) restHeroImg = "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?q=80&w=2000&fit=crop";
            else if (restCuisine.contains("pizza"))                                      restHeroImg = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=2000&fit=crop";
            else if (restCuisine.contains("burger") || restCuisine.contains("fast"))    restHeroImg = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=2000&fit=crop";
            else if (restCuisine.contains("south indian"))                               restHeroImg = "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?q=80&w=2000&fit=crop";
            else if (restCuisine.contains("chinese"))                                    restHeroImg = "https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=2000&fit=crop";
            else if (restCuisine.contains("bbq") || restCuisine.contains("grill"))      restHeroImg = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=2000&fit=crop";
            else if (restCuisine.contains("north indian"))                               restHeroImg = "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=2000&fit=crop";
        %>
        <div class="mm-rest-hero-bg" style="background-image:url('<%= restHeroImg %>')"></div>
        <div class="mm-rest-hero-overlay"></div>
        <div class="mm-rest-hero-content">
            <div class="mm-rest-badge">🍽️ <%= currentRestaurant != null ? currentRestaurant.getCuisineType() : "Restaurant" %></div>
            <h1 class="mm-rest-name"><%= currentRestaurant != null ? currentRestaurant.getName() : "Restaurant" %></h1>
            <div class="mm-rest-meta-row">
                <% if (currentRestaurant != null) { %>
                <div class="mm-rest-rating-badge">★ <%= currentRestaurant.getRating() %></div>
                <div class="mm-rest-meta-item"><i class="fa-regular fa-clock"></i> <%= currentRestaurant.getDeliveryTime() %> min</div>
                <div class="mm-rest-meta-item"><i class="fa-solid fa-location-dot"></i> <%= currentRestaurant.getAddress() != null ? currentRestaurant.getAddress() : "Chennai" %></div>
                <div class="mm-rest-meta-item"><i class="fa-solid fa-truck"></i> Free above ₹299</div>
                <% } %>
            </div>
        </div>
    </section>

    <!-- MENU CONTENT -->
    <div class="mm-menu-layout">
        <div class="mm-menu-filters">
            <button class="mm-filter-btn active" type="button" onclick="filterMenu(this,'all')">All</button>
            <button class="mm-filter-btn" type="button" onclick="filterMenu(this,'veg')">🌿 Pure Veg</button>
            <button class="mm-filter-btn" type="button" onclick="filterMenu(this,'bestseller')">🏆 Bestsellers</button>
        </div>

        <div class="mm-menu-section-title">
            <i class="fa-solid fa-fire" style="color:var(--primary);"></i> Order Online
        </div>

        <%
            if (menuList != null && !menuList.isEmpty()) {
                int menuIdx = 0;
                for (Menu item : menuList) {
                    String itemName = item.getItemName().toLowerCase();
                    String itemCat  = item.getCategory() != null ? item.getCategory().toLowerCase() : "";

                    // DEFAULT fallback image (safe, confirmed working)
                    String imgUrl = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=400";

                    // ══ SPECIFIC ITEM NAME MATCHES (most precise first) ══════════════════

                    // Pizza items (Domino's etc.)
                    if      (itemName.contains("margherita"))
                        imgUrl = "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?q=80&w=400";
                    else if (itemName.contains("peppy paneer"))
                        imgUrl = "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?q=80&w=400";
                    else if (itemName.contains("veg supreme"))
                        imgUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=400";
                    else if (itemName.contains("tandoori paneer pizza"))
                        imgUrl = "https://images.unsplash.com/photo-1571407970349-bc81e7e96d47?q=80&w=400";
                    // Garlic bread / breadsticks — FIXED (old URL showed wrong image)
                    else if (itemName.contains("garlic bread") || itemName.contains("breadstick"))
                        imgUrl = "https://images.unsplash.com/photo-1565299507177-b0ac66763828?q=80&w=400";
                    // Dessert items
                    else if (itemName.contains("choco lava") || itemName.contains("lava cake"))
                        imgUrl = "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?q=80&w=400";

                    // Burger King items
                    else if (itemName.contains("whopper"))
                        imgUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400";
                    else if (itemName.contains("double patty"))
                        imgUrl = "https://images.unsplash.com/photo-1550317138-10000687a72b?q=80&w=400";
                    else if (itemName.contains("crispy veg"))
                        imgUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400";
                    else if (itemName.contains("cheesy fries"))
                        imgUrl = "https://images.unsplash.com/photo-1576107232684-1279f390859f?q=80&w=400";

                    // KFC items
                    else if (itemName.contains("hot & crispy") || itemName.contains("hot and crispy") || itemName.contains("4 pc"))
                        imgUrl = "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=400";
                    // Zinger — FIXED (old URL was broken)
                    else if (itemName.contains("zinger"))
                        imgUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400";
                    // Popcorn chicken — FIXED
                    else if (itemName.contains("popcorn"))
                        imgUrl = "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=400";

                    // Subway items
                    else if (itemName.contains("paneer tikka sub") || itemName.contains("tikka sub"))
                        imgUrl = "https://images.unsplash.com/photo-1509722747041-616f39b57569?q=80&w=400";
                    // Aloo patty — FIXED
                    else if (itemName.contains("aloo patty"))
                        imgUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400";
                    else if (itemName.contains("veggie delite"))
                        imgUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400";

                    // McDonald's items
                    else if (itemName.contains("mcveggie") || itemName.contains("mc veggie"))
                        imgUrl = "https://images.unsplash.com/photo-1561758033-d89a9ad46330?q=80&w=400";
                    // McSpicy — FIXED (old URL was broken)
                    else if (itemName.contains("mcspicy") || itemName.contains("mc spicy"))
                        imgUrl = "https://images.unsplash.com/photo-1550317138-10000687a72b?q=80&w=400";
                    // McFlurry — FIXED (old URL was broken)
                    else if (itemName.contains("mcflurry") || itemName.contains("mc flurry"))
                        imgUrl = "https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?q=80&w=400";

                    // South Indian items — FIXED (old idli URL was broken)
                    else if (itemName.contains("masala dosa") || itemName.contains("special dosa"))
                        imgUrl = "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?q=80&w=400";
                    else if (itemName.contains("sambar vada") || itemName.contains("sambhar vada"))
                        imgUrl = "https://images.unsplash.com/photo-1606491956689-2ea866880c84?q=80&w=400";
                    else if (itemName.contains("south indian meals") || itemName.contains("mini meals"))
                        imgUrl = "https://images.unsplash.com/photo-1544025162-8315ea07fc0a?q=80&w=400";

                    // Biryani items
                    else if (itemName.contains("subz-e-falafel") || itemName.contains("falafel biryani"))
                        imgUrl = "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=400";
                    else if (itemName.contains("lazeez") || itemName.contains("bhuna murgh"))
                        imgUrl = "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?q=80&w=400";
                    else if (itemName.contains("hyderabad chicken biryani"))
                        imgUrl = "https://images.unsplash.com/photo-1589302168068-964664d93dc0?q=80&w=400";
                    else if (itemName.contains("hyderabad mutton") || itemName.contains("mutton biryani"))
                        imgUrl = "https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?q=80&w=400";

                    // BBQ / Grill items
                    else if (itemName.contains("cajun spiced potatoes") || itemName.contains("cajun potato"))
                        imgUrl = "https://images.unsplash.com/photo-1576107232684-1279f390859f?q=80&w=400";
                    else if (itemName.contains("tandoori paneer tikka"))
                        imgUrl = "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?q=80&w=400";
                    else if (itemName.contains("chicken tikka skewer") || itemName.contains("tikka skewer"))
                        imgUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=400";

                    // ══ GENERIC KEYWORD FALLBACKS ════════════════════════════════════════
                    else if (itemName.contains("biryani"))
                        imgUrl = "https://images.unsplash.com/photo-1631515243349-e0cb75fb8d3a?q=80&w=400";
                    else if (itemName.contains("pizza"))
                        imgUrl = "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=400";
                    else if (itemName.contains("burger"))
                        imgUrl = "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=400";
                    else if (itemName.contains("dosa"))
                        imgUrl = "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?q=80&w=400";
                    else if (itemName.contains("vada") || itemName.contains("vadai"))
                        imgUrl = "https://images.unsplash.com/photo-1606491956689-2ea866880c84?q=80&w=400";
                    else if (itemName.contains("idli"))
                        imgUrl = "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?q=80&w=400";
                    else if (itemName.contains("paneer"))
                        imgUrl = "https://images.unsplash.com/photo-1631452180519-c014fe946bc7?q=80&w=400";
                    else if (itemName.contains("tikka"))
                        imgUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=400";
                    else if (itemName.contains("chicken"))
                        imgUrl = "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?q=80&w=400";
                    else if (itemName.contains("mutton") || itemName.contains("lamb"))
                        imgUrl = "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=400";
                    else if (itemName.contains("fish") || itemName.contains("prawn") || itemName.contains("seafood"))
                        imgUrl = "https://images.unsplash.com/photo-1534482421-64566f976cfa?q=80&w=400";
                    else if (itemName.contains("noodle") || itemName.contains("chow"))
                        imgUrl = "https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=400";
                    else if (itemName.contains("momo") || itemName.contains("dim sum"))
                        imgUrl = "https://images.unsplash.com/photo-1496116218417-1a781b1c416c?q=80&w=400";
                    else if (itemName.contains("sub") || itemName.contains("wrap") || itemName.contains("sandwich"))
                        imgUrl = "https://images.unsplash.com/photo-1509722747041-616f39b57569?q=80&w=400";
                    else if (itemName.contains("fries"))
                        imgUrl = "https://images.unsplash.com/photo-1576107232684-1279f390859f?q=80&w=400";
                    else if (itemName.contains("salad"))
                        imgUrl = "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?q=80&w=400";
                    // Generic bread — FIXED (old URL showed a person's face!)
                    else if (itemName.contains("bread"))
                        imgUrl = "https://images.unsplash.com/photo-1565299507177-b0ac66763828?q=80&w=400";
                    else if (itemName.contains("dal") || itemName.contains("curry"))
                        imgUrl = "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=400";
                    else if (itemName.contains("rice") || itemName.contains("meals"))
                        imgUrl = "https://images.unsplash.com/photo-1544025162-8315ea07fc0a?q=80&w=400";
                    else if (itemName.contains("ice cream") || itemName.contains("scoop"))
                        imgUrl = "https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?q=80&w=400";
                    else if (itemName.contains("cake") || itemName.contains("brownie"))
                        imgUrl = "https://images.unsplash.com/photo-1606313564200-e75d5e30476c?q=80&w=400";
                    else if (itemName.contains("halwa") || itemName.contains("jamun") || itemName.contains("gulab"))
                        imgUrl = "https://images.unsplash.com/photo-1558961363-fa8fdf82db35?q=80&w=400";
                    else if (itemName.contains("coffee") || itemName.contains("cappuccino") || itemName.contains("latte"))
                        imgUrl = "https://images.unsplash.com/photo-1551030173-122aabc4489c?q=80&w=400";
                    // Juice/shake/lassi — FIXED (old URL was uncertain)
                    else if (itemName.contains("juice") || itemName.contains("shake") || itemName.contains("lassi"))
                        imgUrl = "https://images.unsplash.com/photo-1551030173-122aabc4489c?q=80&w=400";
                    else if (itemName.contains("bbq") || itemName.contains("grill") || itemCat.contains("bbq"))
                        imgUrl = "https://images.unsplash.com/photo-1555939594-58d7cb561ad1?q=80&w=400";
                    else if (itemCat.contains("dessert"))
                        imgUrl = "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=400";
                    else if (itemCat.contains("south indian"))
                        imgUrl = "https://images.unsplash.com/photo-1610192244261-3f33de3f55e4?q=80&w=400";
                    else if (itemCat.contains("north indian"))
                        imgUrl = "https://images.unsplash.com/photo-1585937421612-70a008356fbe?q=80&w=400";
                    else if (itemCat.contains("chinese"))
                        imgUrl = "https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=400";
                    else if (itemCat.contains("fast food"))
                        imgUrl = "https://images.unsplash.com/photo-1561758033-d89a9ad46330?q=80&w=400";

                    String[] tags = {"", "Bestseller", "Popular", "Spicy", "New", "Bestseller", "Popular"};
                    String[] tagClasses = {"", "bestseller", "popular", "spicy", "", "bestseller", "popular"};
                    String tag = tags[menuIdx % tags.length];
                    String tagClass = tagClasses[menuIdx % tagClasses.length];
                    menuIdx++;
        %>
        <div class="mm-food-card reveal">
            <div class="mm-food-img-wrap">
                <img src="<%= imgUrl %>"
                     alt="<%= item.getItemName() %>"
                     class="mm-food-img"
                     loading="lazy"
                     onerror="this.onerror=null;this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=400';">
            </div>

            <div class="mm-food-info">
                <div class="mm-food-name-row">
                    <div class="mm-type-indicator <%= menuIdx % 3 == 0 ? "nonveg" : "veg" %>"></div>
                    <h3 class="mm-food-name"><%= item.getItemName() %></h3>
                    <% if (!tag.isEmpty()) { %><span class="mm-food-tag <%= tagClass %>"><%= tag %></span><% } %>
                </div>
                <p class="mm-food-desc"><%= item.getDescription() != null && !item.getDescription().isEmpty() ? item.getDescription() : "Freshly prepared with premium ingredients. A customer favorite!" %></p>
                <div class="mm-food-price-row">
                    <span class="mm-food-price">₹<%= item.getPrice() %></span>
                    <span class="mm-food-price-original">₹<%= (int)(item.getPrice() * 1.15) %></span>
                </div>
            </div>

            <form action="AddToCartServlet" method="POST" class="mm-cart-form">
                <input type="hidden" name="menuId" value="<%= item.getMenuId() %>">
                <div class="mm-qty-control">
                    <button type="button" class="mm-qty-dec" onclick="changeQty(this,-1)">−</button>
                    <input type="number" name="quantity" class="mm-qty-field" value="1" min="1" max="15" required>
                    <button type="button" class="mm-qty-inc" onclick="changeQty(this,1)">+</button>
                </div>
                <button type="submit" class="mm-add-btn">ADD +</button>
            </form>
        </div>
        <%
                }
            } else {
        %>
        <div class="mm-empty-state">
            <span class="mm-empty-icon">🍽️</span>
            <h3 class="mm-empty-title">Menu coming soon</h3>
            <p class="mm-empty-desc">This restaurant is preparing their menu. Check back soon!</p>
            <a href="home.jsp" class="mm-btn-primary">← Back to Restaurants</a>
        </div>
        <%
            }
        %>
    </div>

    <!-- STICKY CART BUTTON -->
    <a href="cart.jsp" class="mm-sticky-cart">
        <i class="fa-solid fa-bag-shopping"></i> View Cart
        <span style="background:rgba(255,255,255,0.2);border-radius:20px;padding:2px 10px;font-size:12px;">→</span>
    </a>

    <script src="js/script.js"></script>
    <script>
        function changeQty(btn, delta) {
            const form = btn.closest('form');
            const input = form.querySelector('.mm-qty-field');
            let val = parseInt(input.value) || 1;
            val = Math.max(1, Math.min(15, val + delta));
            input.value = val;
        }

        function filterMenu(btn, filter) {
            document.querySelectorAll('.mm-filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
        }

        // Add to cart animation
        document.querySelectorAll('.mm-add-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const original = this.textContent;
                this.textContent = '✓ Added!';
                this.style.background = '#2ED573';
                this.style.color = 'white';
                this.style.borderColor = '#2ED573';
                setTimeout(() => {
                    this.textContent = original;
                    this.style.background = '';
                    this.style.color = '';
                    this.style.borderColor = '';
                }, 1500);
            });
        });
    </script>
</body>
</html>