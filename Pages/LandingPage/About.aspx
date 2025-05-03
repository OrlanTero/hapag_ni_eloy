<%@ Page Language="VB" AutoEventWireup="false" CodeFile="About.aspx.vb" Inherits="Pages_LandingPage_About" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>About Hapag Food Ordering System</title>
    <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
    <style>
        :root {
            --primary-color: #619F2B;
            --primary-dark: #4a7a23;
            --secondary-color: #FFC107;
            --accent-color: #FCA418;
            --text-dark: #333;
            --text-medium: #666;
            --text-light: #888;
            --bg-light: #f9f9f9;
            --bg-white: #ffffff;
            --shadow-sm: 0 2px 10px rgba(0,0,0,0.05);
            --shadow-md: 0 4px 15px rgba(0,0,0,0.1);
            --radius-sm: 8px;
            --radius-md: 12px;
            --radius-lg: 20px;
            --transition: all 0.3s ease;
        }
        
        .root-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            background-color: #f8f9fa;
        }
        .top-navbar {
            background: white;
            padding: 15px 50px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            box-sizing: border-box;
            display: flex;
            align-items: center;
            height: 90px;
        }
        .top-navbar .right {
            margin-right: auto;
            margin-left: 30px;
        }
        .top-navbar .left img {
            height: 85px;
            width: auto;
            transition: transform 0.3s ease;
        }
        .top-navbar .left img:hover {
            transform: scale(1.05);
        }
        .top-navbar .right ul {
            display: flex;
            gap: 30px;
            margin: 0;
            padding: 0;
        }
        .top-navbar .right ul li {
            list-style: none;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s ease;
        }
        .top-navbar .right ul li:hover {
            background: #f8f9fa;
            transform: translateY(-2px);
        }
        .top-navbar .right ul li.active {
            background: #FCA418;
            color: white;
        }
        .top-navbar .right ul li.active:hover {
            background: #e59316;
        }
        .top-navbar .right ul a {
            text-decoration: none;
            color: #050505;
        }
        .main-container {
            background-color: #f8f9fa;
            min-height: calc(100vh - 90px);
            margin-top: 90px;
            padding: 50px 0;
            position: relative;
        }
        
        .about-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            position: relative;
            z-index: 1;
        }
        
        .header-section {
            text-align: center;
            margin-bottom: 60px;
            padding: 50px 30px;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            border-left: 8px solid var(--accent-color);
            border-right: 8px solid var(--accent-color);
            position: relative;
            overflow: hidden;
        }
        
        .header-section h1 {
            font-size: 3.5rem;
            color: var(--text-dark);
            margin-bottom: 20px;
            font-weight: 700;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
            position: relative;
            display: inline-block;
        }
        
        .header-section h1::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: var(--accent-color);
            border-radius: 2px;
        }
        
        .header-section p {
            font-size: 1.3rem;
            color: var(--text-medium);
            max-width: 800px;
            margin: 25px auto 0;
            line-height: 1.6;
        }
        
        .header-image {
            position: absolute;
            z-index: -1;
        }
        
        .header-image.top-right {
            top: -60px;
            right: -60px;
            width: 200px;
            height: 200px;
            border-radius: 50%;
            overflow: hidden;
        }
        
        .header-image.top-right img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            opacity: 0.6;
        }
        
        .about-sections-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        
        .about-section {
            background: white;
            border-radius: 15px;
            padding: 40px;
            margin-bottom: 30px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border-left: 5px solid var(--accent-color);
            position: relative;
            overflow: hidden;
        }
        
        .about-section:hover {
            transform: translateY(-7px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.12);
        }
        
        .about-section:nth-child(3), .about-section:nth-child(4) {
            grid-column: span 2;
        }
        
        .about-section:nth-child(1) {
            border-left-color: #3498db;
        }
        
        .about-section:nth-child(2) {
            border-left-color: #2ecc71;
        }
        
        .about-section:nth-child(3) {
            border-left-color: #e74c3c;
        }
        
        .about-section h2 {
            color: #2c3e50;
            margin-bottom: 25px;
            font-size: 32px;
            padding-bottom: 15px;
            position: relative;
            display: inline-block;
            font-weight: 700;
        }
        
        .about-section h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: var(--accent-color);
            border-radius: 3px;
        }
        
        .about-section:nth-child(1) h2::after {
            background: #3498db;
        }
        
        .about-section:nth-child(2) h2::after {
            background: #2ecc71;
        }
        
        .about-section:nth-child(3) h2::after {
            background: #e74c3c;
        }
        
        .about-section p {
            color: #34495e;
            line-height: 1.8;
            margin-bottom: 25px;
            font-size: 17px;
        }
        
        .about-section ul {
            list-style-type: none;
            padding-left: 0;
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .about-section ul li {
            padding: 18px;
            color: #34495e;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 15px;
            background-color: rgba(255, 255, 255, 0.8);
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            transition: var(--transition);
            border-left: 3px solid var(--accent-color);
        }
        
        .about-section:nth-child(1) ul li {
            border-left-color: #3498db;
        }
        
        .about-section:nth-child(2) ul li {
            border-left-color: #2ecc71;
        }
        
        .about-section:nth-child(3) ul li {
            border-left-color: #e74c3c;
        }
        
        .about-section ul li:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
        }
        
        .about-section ul li:last-child {
            border-bottom: none;
        }
        
        .icon-wrapper {
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--accent-color);
            border-radius: 50%;
            color: white;
            font-size: 20px;
        }
        
        .about-section:nth-child(1) .icon-wrapper {
            background-color: #3498db;
        }
        
        .about-section:nth-child(2) .icon-wrapper {
            background-color: #2ecc71;
        }
        
        .about-section:nth-child(3) .icon-wrapper {
            background-color: #e74c3c;
        }
        
        .story-image {
            width: 100%;
            height: 250px;
            background-size: cover;
            background-position: center;
            border-radius: 12px;
            margin: 20px 0;
            box-shadow: 0 6px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
            overflow: hidden;
        }
        
        .story-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .story-image:hover img {
            transform: scale(1.05);
        }
        
        /* Decorative images */
        .food-image {
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
        }
        
        .food-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        
        .food-image:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }
        
        .food-image.circle {
            border-radius: 50%;
        }
        
        .food-image.small {
            width: 150px;
            height: 150px;
        }
        
        .food-image.medium {
            width: 200px;
            height: 200px;
        }
        
        .food-image.large {
            width: 300px;
            height: 300px;
        }
        
        .food-image.position-1 {
            position: absolute;
            top: -80px;
            right: -50px;
            z-index: 1;
        }
        
        .food-image.position-2 {
            position: absolute;
            bottom: -60px;
            left: 10%;
            z-index: 1;
        }
        
        .food-image.position-3 {
            position: absolute;
            top: 40%;
            right: -80px;
            z-index: 1;
        }
        
        .food-image.position-4 {
            position: absolute;
            top: 20%;
            left: -80px;
            z-index: 1;
        }
        
        .food-image.position-5 {
            position: absolute;
            bottom: -100px;
            right: 20%;
            z-index: 1;
        }
        
        .two-column-layout {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .image-with-text {
            display: flex;
            align-items: center;
            gap: 20px;
            margin: 30px 0;
        }
        
        .image-with-text.reverse {
            flex-direction: row-reverse;
        }
        
        .image-with-text .text {
            flex: 1;
        }
        
        .image-with-text .image {
            flex: 1;
            height: 300px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }
        
        .image-with-text .image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .image-with-text:hover .image img {
            transform: scale(1.05);
        }
        
        .floating-images-container {
            position: relative;
            margin: 100px 0;
            height: 400px;
        }
        
        @media (max-width: 992px) {
            .about-sections-container {
                grid-template-columns: 1fr;
            }
            
            .about-section:nth-child(3), .about-section:nth-child(4) {
                grid-column: auto;
            }
            
            .two-column-layout {
                grid-template-columns: 1fr;
            }
            
            .image-with-text {
                flex-direction: column;
            }
            
            .image-with-text.reverse {
                flex-direction: column;
            }
            
            .food-image.position-1,
            .food-image.position-2,
            .food-image.position-3,
            .food-image.position-4,
            .food-image.position-5 {
                display: none;
            }
            
            .floating-images-container {
                height: auto;
                margin: 40px 0;
                display: flex;
                flex-wrap: wrap;
                justify-content: center;
                gap: 20px;
            }
            
            .floating-images-container .food-image {
                position: static;
                margin: 10px;
            }
        }
        
        @media (max-width: 768px) {
            .header-section h1 {
                font-size: 2.5rem;
            }
            .about-section h2 {
                font-size: 26px;
            }
            .about-section ul {
                grid-template-columns: 1fr;
            }
            .top-navbar {
                padding: 15px 20px;
            }
            .top-navbar .right ul {
                gap: 15px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div class="root-container">
        <div class="top-navbar">
            <div class="right">
                <ul>
                    <a href="LandingPage.aspx"><li><span>HOME</span></li></a>
                    <a href="About.aspx"><li class="active"><span>ABOUT</span></li></a>
                    <a href="Contact.aspx"><li><span>CONTACT US</span></li></a>
                </ul>
            </div>
            <div class="left">
                <img src="./../../Assets/Images/logo.png" alt="Hapag Logo" />
            </div>
        </div>

        <div class="main-container">
            <div class="about-content">
                <div class="header-section">
                    <div class="header-image top-right">
                        <img src="./../../Assets/Images/f1.png" alt="Filipino Cuisine" />
                    </div>
                    <h1>About Us</h1>
                    <p>Discover the story behind our commitment to bringing authentic Filipino cuisine to your doorstep with passion, tradition, and innovation.</p>
                </div>
                
                <div class="food-image small circle position-1">
                    <img src="./../../Assets/Images/f1.png" alt="Filipino Food 1" />
                </div>
                
                <div class="about-sections-container">
                    <div class="about-section">
                        <h2>Our Story</h2>
                        <p>Hapag Filipino Restaurant began with a simple dream - to share the rich flavors of Filipino cuisine with food lovers everywhere. Founded by a team of passionate culinary experts with deep roots in Filipino culinary traditions, we set out to create a dining experience that honors our heritage while embracing innovation.</p>
                        <p>Our journey started in a small kitchen with family recipes passed down through generations. Today, we've grown into a beloved establishment known for authentic flavors and warm hospitality.</p>
                    </div>

                    <div class="about-section">
                        <h2>Our Mission</h2>
                        <p>At Hapag Filipino Restaurant, we are dedicated to preserving the rich culinary heritage of the Philippines while making it accessible to everyone through modern technology and exceptional service.</p>
                        <p>We believe food is more than nourishment—it's a celebration of culture, family, and community. Every dish we serve carries with it the stories and traditions of Filipino kitchens, prepared with care and presented with pride.</p>
                        <ul>
                            <li>
                                <div class="icon-wrapper">🌟</div>
                                <span>Bringing authentic Filipino flavors to every table</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">🤝</div>
                                <span>Creating meaningful connections through food</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">♻️</div>
                                <span>Sustainable and responsible business practices</span>
                            </li>
                        </ul>
                    </div>

                    <div class="about-section">
                        <h2>What Sets Us Apart</h2>
                        <ul>
                            <li>
                                <div class="icon-wrapper">✨</div>
                                <span>Wide selection of authentic Filipino dishes made with traditional recipes</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">🚀</div>
                                <span>Easy online ordering system designed for seamless user experience</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">🔒</div>
                                <span>Secure payment processing ensuring customer data protection</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">📱</div>
                                <span>Real-time order tracking from kitchen to your doorstep</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">🚚</div>
                                <span>Efficient delivery service optimized for food freshness</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">🍽️</div>
                                <span>Quality food prepared with fresh, locally-sourced ingredients</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">👥</div>
                                <span>Excellent customer service from our dedicated team</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">⏰</div>
                                <span>Timely delivery you can count on, every time</span>
                            </li>
                            <li>
                                <div class="icon-wrapper">💰</div>
                                <span>Competitive prices without compromising on quality</span>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
