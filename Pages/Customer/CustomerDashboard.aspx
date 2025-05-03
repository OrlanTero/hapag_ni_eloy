<%@ Page Title="HAPAG - Home" Language="VB" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" AutoEventWireup="false" CodeFile="CustomerDashboard.aspx.vb" Inherits="Pages_Customer_CustomerDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        /* Hero Section Styles */
        .hero-section {
            position: relative;
            overflow: hidden;
            padding: 100px 0 70px;
            width: 100%;
            box-sizing: border-box;
            margin: 0 auto;
            background-color: #ffffff;
            border-bottom: 1px solid #f0f0f0;
            background-image: 
                linear-gradient(to right, rgba(255,255,255,0.95), rgba(255,255,255,0.8)), 
                url('../../Assets/Images/background-pattern.png');
            background-size: cover;
            background-position: center;
        }
        
        .hero-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            max-width: 1400px;
            margin: 0 auto;
            position: relative;
            z-index: 5;
        }
        
        .hero-text {
            flex: 1;
            z-index: 2;
            padding-right: 30px;
        }
        
        .hero-text h1 {
            font-size: 48px;
            margin-bottom: 20px;
            color: #333;
            font-weight: 800;
            line-height: 1.2;
            position: relative;
            display: inline-block;
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        .hero-text h1::after {
            content: "";
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 80px;
            height: 4px;
            background-color: #FFC107;
        }
        
        .hero-text p {
            font-size: 18px;
            line-height: 1.6;
            color: #666;
            margin-bottom: 25px;
            max-width: 90%;
            animation: fadeIn 0.8s ease-out forwards;
            animation-delay: 0.2s;
        }
        
        .text-highlight {
            position: relative;
            display: inline-block;
            color: #FFC107;
            font-weight: 900;
        }
        
        .browse-btn {
            display: inline-block;
            background-color: #FFC107;
            color: #333;
            padding: 14px 34px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: bold;
            margin-top: 30px;
            transition: all 0.3s ease;
            box-shadow: 0 6px 15px rgba(255, 193, 7, 0.25);
            position: relative;
            overflow: hidden;
            z-index: 1;
            animation: fadeIn 0.8s ease-out 0.4s forwards;
            opacity: 0;
        }
        
        .browse-btn::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 0;
            height: 100%;
            background-color: #FF9800;
            transition: width 0.3s ease;
            z-index: -1;
            border-radius: 30px;
        }
        
        .browse-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 152, 0, 0.4);
            color: #fff;
        }
        
        .browse-btn:hover::before {
            width: 100%;
        }
        
        .hero-images {
            flex: 1;
            position: relative;
            height: 400px;
        }
        
        .yellow-circle {
            position: absolute;
            right: -80px;
            top: -100px;
            width: 450px;
            height: 450px;
            background-color: #FFC107;
            border-radius: 50%;
            z-index: 1;
            opacity: 0.8;
        }
        
        .food-image {
            position: absolute;
            top: 0;
            right: 0;
            z-index: 2;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            width: 100%;
        }
        
        .food-image img {
            max-height: 380px;
            filter: drop-shadow(0 15px 20px rgba(0,0,0,0.15));
            transform: scale(1.05);
            transition: transform 0.5s ease;
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0% { transform: translateY(0px) scale(1.05); }
            50% { transform: translateY(-15px) scale(1.05); }
            100% { transform: translateY(0px) scale(1.05); }
        }
        
        /* Info Badges Styles */
        .info-badges {
            display: flex;
            justify-content: space-between;
            max-width: 1400px;
            margin: -30px auto 0;
            padding: 0 20px;
            position: relative;
            z-index: 10;
        }
        
        .info-badge {
            flex: 1;
            margin: 0 15px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
            padding: 30px 25px;
            text-align: center;
            transition: all 0.4s ease;
            border-bottom: 4px solid #FFC107;
        }
        
        .info-badge:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.12);
        }
        
        .info-badge i {
            font-size: 40px;
            color: #FFC107;
            margin-bottom: 20px;
            display: inline-block;
            transition: transform 0.3s ease;
        }
        
        .info-badge:hover i {
            transform: scale(1.2);
        }
        
        .info-badge h3 {
            font-size: 20px;
            margin-bottom: 12px;
            color: #333;
        }
        
        .info-badge p {
            font-size: 15px;
            color: #666;
            line-height: 1.6;
        }
        
        /* Special Offers Section Styles */
        .special-offers-section {
            padding: 120px 0 90px;
            width: 100%;
            box-sizing: border-box;
            background-color: #fff;
            position: relative;
            background-image: 
                linear-gradient(rgba(255, 255, 255, 0.9), rgba(255, 255, 255, 0.9)), 
                url('../../Assets/Images/pattern-bg.png');
            background-size: cover;
        }
        
        .special-offers-container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 20px;
            position: relative;
            font-size: 40px;
            color: #333;
            font-weight: bold;
            letter-spacing: 1px;
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        .subtitle {
            text-align: center;
            max-width: 700px;
            margin: 0 auto 60px;
            color: #666;
            font-size: 18px;
            line-height: 1.6;
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        .menu-items {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 30px;
        }
        
        .menu-item {
            border: none;
            border-radius: 18px;
            overflow: hidden;
            transition: transform 0.4s, box-shadow 0.4s;
            background-color: white;
            position: relative;
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
            animation: fadeIn 0.6s ease-out forwards;
        }
        
        .menu-item:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .menu-tag {
            position: absolute;
            top: 15px;
            right: 15px;
            background-color: #FFC107;
            color: #333;
            font-size: 13px;
            font-weight: bold;
            padding: 6px 12px;
            border-radius: 20px;
            z-index: 5;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .item-image {
            height: 220px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }
        
        .item-image::after {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(to bottom, rgba(0,0,0,0.05) 0%, rgba(0,0,0,0.2) 100%);
        }
        
        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }
        
        .menu-item:hover .item-image img {
            transform: scale(1.15);
        }
        
        .item-details {
            padding: 25px;
            text-align: center;
            position: relative;
        }
        
        .item-details::before {
            content: "";
            position: absolute;
            top: 0;
            left: 50%;
            transform: translateX(-50%);
            width: 50px;
            height: 3px;
            background-color: #FFC107;
            border-radius: 3px;
        }
        
        .item-name {
            text-transform: uppercase;
            font-weight: bold;
            margin-bottom: 12px;
            font-size: 18px;
            color: #333;
        }
        
        .item-price {
            color: #FFC107;
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: bold;
        }
        
        .add-to-cart-btn {
            background-color: #FFC107;
            color: #333;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: block;
            width: auto;
            margin: 0 auto;
            font-weight: bold;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 0.5px;
        }
        
        .add-to-cart-btn:hover {
            background-color: #FF9800;
            transform: translateY(-3px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
            color: #fff;
        }
        
        .see-more-btn {
            display: block;
            background-color: transparent;
            color: #333;
            text-align: center;
            padding: 16px 36px;
            width: 220px;
            margin: 60px auto 0;
            text-decoration: none;
            border-radius: 30px;
            font-weight: bold;
            transition: all 0.3s ease;
            border: 2px solid #FFC107;
            position: relative;
            overflow: hidden;
            z-index: 1;
        }
        
        .see-more-btn::before {
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 0;
            height: 100%;
            background-color: #FFC107;
            transition: width 0.3s ease;
            z-index: -1;
        }
        
        .see-more-btn:hover {
            color: #333;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 193, 7, 0.3);
        }
        
        .see-more-btn:hover::before {
            width: 100%;
        }
        
        /* Testimonial Section Styles */
        .testimonial-section {
            background-color: #f9f9f9;
            padding: 100px 0;
            margin-top: 70px;
            position: relative;
            overflow: hidden;
        }
        
        .testimonial-section::before,
        .testimonial-section::after {
            content: "";
            position: absolute;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background-color: rgba(255, 193, 7, 0.1);
            z-index: 1;
        }
        
        .testimonial-section::before {
            top: -150px;
            left: -150px;
        }
        
        .testimonial-section::after {
            bottom: -150px;
            right: -150px;
        }
        
        .testimonial-container {
            max-width: 900px;
            margin: 0 auto;
            text-align: center;
            padding: 0 20px;
            position: relative;
            z-index: 2;
        }
        
        .testimonial-text {
            font-size: 24px;
            font-style: italic;
            color: #444;
            line-height: 1.7;
            margin-bottom: 40px;
            position: relative;
            padding: 0 40px;
        }
        
        .testimonial-text::before, 
        .testimonial-text::after {
            content: "\201C"; /* Unicode escape for opening quotation mark */
            font-size: 80px;
            color: #FFC107;
            font-family: Georgia, serif;
            position: absolute;
            line-height: 0;
            opacity: 0.4;
        }
        
        .testimonial-text::before {
            left: 0;
            top: 30px;
        }
        
        .testimonial-text::after {
            content: "\201D"; /* Unicode escape for closing quotation mark */
            right: 0;
            bottom: 0;
        }
        
        .testimonial-author {
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
            font-size: 20px;
        }
        
        .testimonial-role {
            color: #FFC107;
            font-size: 16px;
            font-weight: 500;
            margin-bottom: 0;
        }
        
        .testimonial-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 0 auto 30px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            border: 3px solid #FFC107;
        }
        
        .testimonial-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        /* Responsive Styles */
        @media (max-width: 768px) {
            .hero-section {
                padding: 50px 0;
            }
            
            .hero-content {
                flex-direction: column;
                padding: 30px 20px;
            }
            
            .hero-text {
                padding-right: 0;
            text-align: center;
                margin-bottom: 40px;
            }
            
            .hero-text h1 {
                font-size: 36px;
            }
            
            .yellow-circle {
                width: 300px;
                height: 300px;
                float:right;
            }
            
            .menu-items {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .info-badges {
                flex-direction: column;
                margin-top: 30px;
            }
            
            .info-badge {
                margin: 10px 0;
            }
        }
        
        @media (max-width: 480px) {
            .menu-items {
                grid-template-columns: 1fr;
            }
            
            .hero-text h1 {
                font-size: 30px;
            }
            
            .testimonial-text {
                font-size: 18px;
                padding: 0 20px;
            }
        }
        
        /* General Page Improvements */
        html {
            scroll-behavior: smooth;
        }
        
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            overflow-x: hidden;
        }
        
        ::selection {
            background-color: #FFC107;
            color: #333;
        }
        
        /* Animation Keyframes */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        /* Apply animations to elements */
        .hero-text h1, 
        .hero-text p {
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        .hero-text p {
            animation-delay: 0.2s;
        }
        
        .hero-text .browse-btn {
            animation: fadeIn 0.8s ease-out 0.4s forwards;
            opacity: 0;
        }
        
        .special-offers-section .section-title,
        .special-offers-section .subtitle {
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        .menu-item {
            animation: fadeIn 0.6s ease-out forwards;
        }
        
        .menu-item:nth-child(1) { animation-delay: 0.1s; }
        .menu-item:nth-child(2) { animation-delay: 0.2s; }
        .menu-item:nth-child(3) { animation-delay: 0.3s; }
        .menu-item:nth-child(4) { animation-delay: 0.4s; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="hero-section">
        <div class="hero-content">
            <div class="hero-text">
                <h1>Savor the taste of <span class="text-highlight">home</span> at HAPAG</h1>
                <p>Experience authentic Filipino cuisine made with the freshest ingredients and traditional recipes. Our dishes are crafted with love to bring you the true flavors of the Philippines.</p>
                <a href="CustomerMenu.aspx" class="browse-btn">Browse our menu <i class="fas fa-arrow-right" style="margin-left: 8px;"></i></a>
            </div>
            <div class="hero-images">
                <div class="yellow-circle"></div>
                <div class="food-image">
                    <img src="../../Assets/Images/f1.png" alt="Delicious Food" />
                </div>
            </div>
        </div>
    </div>
    
    <div class="info-badges">
        <div class="info-badge">
            <i class="fas fa-utensils"></i>
            <h3>Authentic Cuisine</h3>
            <p>We prepare traditional Filipino dishes with authentic recipes and fresh ingredients.</p>
        </div>
        <div class="info-badge">
            <i class="fas fa-shipping-fast"></i>
            <h3>Fast Delivery</h3>
            <p>Enjoy your favorite dishes delivered right to your doorstep quickly and reliably.</p>
                        </div>
        <div class="info-badge">
            <i class="fas fa-star"></i>
            <h3>Quality Service</h3>
            <p>We pride ourselves on providing excellent customer service and high-quality food.</p>
                            </div>
                        </div>
    
    <div class="special-offers-section">
        <div class="special-offers-container">
            <h2 class="section-title no-underline">SPECIAL OFFERS</h2>
            <p class="subtitle">Enjoy these limited-time special offers with exclusive discounts on our most popular dishes.</p>
            <div class="menu-items">
                <div class="menu-item">
                    <div class="menu-tag">Popular</div>
                    <div class="item-image">
                        <img src="../../Assets/Images/default-food.jpg" alt="Adobong Manok" />
                    </div>
                    <div class="item-details">
                        <div class="item-name">ADOBONG MANOK</div>
                        <div class="item-price">PHP 60.00</div>
                        <asp:LinkButton ID="AddToCart1" runat="server" CssClass="add-to-cart-btn" CommandArgument="1" OnClick="AddToCart_Click">
                            <i class="fas fa-shopping-cart"></i> Add to Cart
                    </asp:LinkButton>
                </div>
                </div>
                
                <div class="menu-item">
                    <div class="menu-tag">Best Seller</div>
                    <div class="item-image">
                        <img src="../../Assets/Images/default-food.jpg" alt="Sinigang na Hipon" />
                    </div>
                    <div class="item-details">
                        <div class="item-name">SINIGANG NA HIPON</div>
                        <div class="item-price">PHP 45.00</div>
                        <asp:LinkButton ID="AddToCart2" runat="server" CssClass="add-to-cart-btn" CommandArgument="2" OnClick="AddToCart_Click">
                            <i class="fas fa-shopping-cart"></i> Add to Cart
                        </asp:LinkButton>
                    </div>
                    </div>
                    
                <div class="menu-item">
                    <div class="item-image">
                        <img src="../../Assets/Images/default-food.jpg" alt="Kare Kare" />
                    </div>
                    <div class="item-details">
                        <div class="item-name">KARE KARE</div>
                        <div class="item-price">PHP 55.00</div>
                        <asp:LinkButton ID="AddToCart3" runat="server" CssClass="add-to-cart-btn" CommandArgument="3" OnClick="AddToCart_Click">
                            <i class="fas fa-shopping-cart"></i> Add to Cart
                        </asp:LinkButton>
                    </div>
                </div>
                
                <div class="menu-item">
                    <div class="menu-tag">New</div>
                    <div class="item-image">
                        <img src="../../Assets/Images/default-food.jpg" alt="Tinolang Manok" />
                    </div>
                    <div class="item-details">
                        <div class="item-name">TINOLANG MANOK</div>
                        <div class="item-price">PHP 45.00</div>
                        <asp:LinkButton ID="AddToCart4" runat="server" CssClass="add-to-cart-btn" CommandArgument="4" OnClick="AddToCart_Click">
                            <i class="fas fa-shopping-cart"></i> Add to Cart
                        </asp:LinkButton>
                    </div>
                </div>
            </div>
            
            <a href="CustomerMenu.aspx" class="see-more-btn">See Full Menu <i class="fas fa-chevron-right" style="margin-left: 5px;"></i></a>
        </div>
    </div>
    
    <div class="testimonial-section">
        <div class="testimonial-container">
            <div class="testimonial-avatar">
                <img src="../../Assets/Images/images.jpg" alt="Customer Avatar" onerror="this.src='../../Assets/Images/default-avatar.jpg'" />
            </div>
            <div class="testimonial-text">
                The food from HAPAG reminds me of my grandmother's cooking. The authentic flavors and fresh ingredients bring back fond memories of family gatherings.
            </div>
            <div class="testimonial-author">Maria Leonra Theresa</div>
            <div class="testimonial-role">Loyal Customer</div>
        </div>
    </div>
</asp:Content>
