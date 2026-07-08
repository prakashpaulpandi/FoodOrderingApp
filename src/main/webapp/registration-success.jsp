<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Successful | MealMate</title>
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
            background: #0f0f1a;
            padding: 20px;
        }

        .mm-success-bg {
            position: fixed;
            inset: 0;
            z-index: 0;
            background: url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=2070&fit=crop') center/cover no-repeat;
            filter: brightness(0.2);
        }

        .mm-success-card {
            position: relative;
            z-index: 1;
            text-align: center;
            max-width: 440px;
            width: 100%;
            padding: 44px 40px;
            background: rgba(255,255,255,0.07);
            backdrop-filter: blur(30px);
            -webkit-backdrop-filter: blur(30px);
            border: 1px solid rgba(255,255,255,0.12);
            box-shadow: 0 30px 80px rgba(0,0,0,0.5);
            border-radius: 24px;
            color: white;
        }

        .mm-success-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(46, 213, 115, 0.15);
            border: 2.5px solid #2ed573;
            color: #2ed573;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin: 0 auto 24px;
            box-shadow: 0 10px 25px rgba(46, 213, 115, 0.2);
            animation: popIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
    </style>
</head>
<body class="page-wrapper">

    <div class="mm-success-bg"></div>

    <div class="mm-success-card animate-scale-in">
        <div class="mm-success-icon">
            <i class="fa-solid fa-circle-check"></i>
        </div>
        <h1 style="font-size: 26px; font-weight: 900; margin-bottom: 12px; color: white;">Success!</h1>
        <p style="color: rgba(255,255,255,0.7); font-size: 15px; line-height: 1.6; margin-bottom: 30px;">
            Welcome to MealMate, ${param.name}! Your account has been created successfully. Let's get you logged in.
        </p>
        
        <a href="Login.html" class="mm-btn-primary" style="width: 100%; justify-content: center; padding: 15px;">
            <i class="fa-solid fa-right-to-bracket"></i> Go to Sign In
        </a>
    </div>

    <script src="js/script.js"></script>
</body>
</html>