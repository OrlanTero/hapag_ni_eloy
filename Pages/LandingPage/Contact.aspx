<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Contact.aspx.vb" Inherits="Pages_LandingPage_Contact" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Contact Us - Hapag Food Ordering System</title>
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
        
        .contact-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
            display: flex;
            gap: 40px;
            position: relative;
            z-index: 1;
            flex-wrap: wrap;
        }
        
        /* Header section styling */
        .header-section {
            text-align: center;
            margin-bottom: 50px;
            padding: 40px 30px;
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            max-width: 1200px;
            margin: 0 auto 50px;
            position: relative;
            overflow: hidden;
            border-left: 8px solid var(--accent-color);
            border-right: 8px solid var(--accent-color);
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
        
        /* Food image styling */
        .food-image-container {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 30px;
        }
        
        .food-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }
        
        .food-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        
        .food-image:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }
        
        .food-image:hover img {
            transform: scale(1.05);
        }
        
        /* Decorative floating images */
        .floating-image {
            position: absolute;
            z-index: 2;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }
        
        .floating-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .floating-image.circle {
            border-radius: 50%;
        }
        
        .floating-image.top-right {
            top: 100px;
            right: 5%;
            width: 150px;
            height: 150px;
        }
        
        .floating-image.mid-left {
            top: 350px;
            left: 3%;
            width: 180px;
            height: 180px;
        }
        
        /* Contact sections styling */
        .contact-info, .contact-form {
            flex: 1;
            min-width: 300px;
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .contact-info {
            border-left: 5px solid #3498db;
        }
        
        .contact-form {
            border-left: 5px solid var(--accent-color);
        }
        
        .contact-info:hover, .contact-form:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.12);
        }
        
        .contact-info h2, .contact-form h2 {
            color: #2c3e50;
            margin-bottom: 25px;
            font-size: 32px;
            padding-bottom: 15px;
            position: relative;
            display: inline-block;
            font-weight: 700;
        }
        
        .contact-info h2::after, .contact-form h2::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 3px;
            border-radius: 3px;
        }
        
        .contact-info h2 {
            color: #3498db;
        }
        
        .contact-form h2 {
            color: var(--accent-color);
        }
        
        .contact-info h2::after {
            background: #3498db;
        }
        
        .contact-form h2::after {
            background: var(--accent-color);
        }
        
        .contact-info p {
            color: #34495e;
            line-height: 1.8;
            margin-bottom: 25px;
            font-size: 17px;
        }
        
        .contact-details {
            margin-top: 30px;
            position: relative;
        }
        
        .contact-details h3 {
            color: #3498db;
            margin-bottom: 25px;
            font-size: 22px;
            border-left: 4px solid #3498db;
            padding-left: 15px;
            font-weight: 600;
        }
        
        .contact-details ul {
            list-style-type: none;
            padding-left: 0;
        }
        
        .contact-details ul li {
            padding: 18px;
            margin-bottom: 15px;
            color: #34495e;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: var(--transition);
            border-radius: 12px;
            background-color: rgba(255, 255, 255, 0.8);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            position: relative;
            z-index: 1;
        }
        
        .contact-details ul li:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 8px 15px rgba(0,0,0,0.1);
            background-color: rgba(255, 255, 255, 0.9);
        }
        
        .contact-details ul li:last-child {
            margin-bottom: 0;
        }
        
        .contact-details ul li strong {
            color: #2c3e50;
            min-width: 80px;
            display: inline-block;
            font-weight: 600;
        }
        
        .icon-wrapper {
            width: 45px;
            height: 45px;
            min-width: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #3498db;
            border-radius: 50%;
            color: white;
            font-size: 20px;
            box-shadow: 0 4px 8px rgba(52, 152, 219, 0.2);
        }
        
        .form-group {
            margin-bottom: 25px;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 12px;
            color: #2c3e50;
            font-weight: 600;
            font-size: 16px;
            position: relative;
            padding-left: 15px;
        }
        
        .form-group label:before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            width: 3px;
            background-color: var(--accent-color);
            border-radius: 3px;
        }
        
        .form-control {
            width: 100%;
            padding: 16px 18px;
            border: 2px solid #eee;
            border-radius: 12px;
            font-size: 16px;
            transition: all 0.3s ease;
            background-color: rgba(255, 255, 255, 0.9);
        }
        
        .form-control:focus {
            border-color: #FCA418;
            outline: none;
            box-shadow: 0 0 0 3px rgba(252, 164, 24, 0.15);
            transform: translateY(-2px);
        }
        
        .ui-button {
            background-color: #FCA418;
            color: white;
            padding: 16px 30px;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
            position: relative;
            overflow: hidden;
            box-shadow: 0 6px 15px rgba(252, 164, 24, 0.25);
        }
        
        .ui-button:hover {
            background-color: #e59316;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(252, 164, 24, 0.3);
        }
        
        .ui-button:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: all 0.6s ease;
        }
        
        .ui-button:hover:before {
            left: 100%;
        }
        
        /* Social Media Links */
        .social-links {
            display: flex;
            gap: 20px;
            margin-top: 40px;
            justify-content: center;
        }
        
        .social-links a {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 50px;
            height: 50px;
            background-color: #f8f9fa;
            border-radius: 50%;
            color: #3498db;
            font-size: 22px;
            transition: var(--transition);
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            border: 1px solid rgba(52, 152, 219, 0.2);
        }
        
        .social-links a:hover {
            transform: translateY(-5px) rotate(5deg);
            background-color: #3498db;
            color: white;
            box-shadow: 0 8px 15px rgba(52, 152, 219, 0.25);
        }
        
        /* Map Section */
        .map-section {
            margin-top: 60px;
            width: 100%;
            position: relative;
            z-index: 1;
        }
        
        .map-container {
            height: 300px;
            background-color: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 5px solid white;
        }
        
        @media (max-width: 992px) {
            .contact-content {
                gap: 30px;
            }
            
            .contact-info, .contact-form {
                flex: 100%;
            }
            
            .floating-image {
                display: none; /* Hide floating images on smaller screens */
            }
        }
        
        @media (max-width: 768px) {
            .contact-content {
                flex-direction: column;
            }
            .top-navbar {
                padding: 15px 20px;
            }
            .top-navbar .right ul {
                gap: 15px;
            }
            .top-navbar .right ul li {
                padding: 8px 15px;
            }
            .header-section h1 {
                font-size: 2.5rem;
            }
            
            .food-image-container {
                flex-wrap: wrap;
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
                    <a href="About.aspx"><li><span>ABOUT</span></li></a>
                    <a href="Contact.aspx"><li class="active"><span>CONTACT US</span></li></a>
                </ul>
            </div>
            <div class="left">
                <img src="./../../Assets/Images/logo.png" alt="Hapag Logo" />
            </div>
        </div>

        <div class="main-container">
            <div class="header-section">
                <h1>Contact Us</h1>
                <p>We'd love to hear from you! Reach out with any questions, suggestions, or feedback about our Filipino cuisine and services.</p>
            </div>
            
            <div class="contact-content">
                <div class="contact-info">
                    <h2>Get in Touch</h2>
                    <p>Whether you have a question about our authentic Filipino dishes, need help with an order, or want to provide feedback, our friendly team is here to assist you every step of the way.</p>
                    
                    <div class="contact-details">
                        <h3>Contact Information</h3>
                        <ul>
                            <li>
                                <div class="icon-wrapper">📞</div>
                                <div>
                                    <strong>Phone:</strong>
                                    <span>(123) 456-7890</span>
                                </div>
                            </li>
                            <li>
                                <div class="icon-wrapper">📧</div>
                                <div>
                                    <strong>Email:</strong>
                                    <span>hapagfilipinorestaurant@gmail.com</span>
                                </div>
                            </li>
                            <li>
                                <div class="icon-wrapper">📍</div>
                                <div>
                                    <strong>Address:</strong>
                                    <span>123 Hapag Filipino Restaurant, Manila, Philippines</span>
                                </div>
                            </li>
                            <li>
                                <div class="icon-wrapper">⏰</div>
                                <div>
                                    <strong>Hours:</strong>
                                    <span>Monday - Sunday, 8:00 AM - 10:00 PM</span>
                                </div>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="social-links">
                        <a href="#" title="Facebook">f</a>
                        <a href="#" title="Instagram">i</a>
                        <a href="#" title="Twitter">t</a>
                        <a href="#" title="YouTube">y</a>
                    </div>
                </div>

                <div class="contact-form">
                    <h2>Send us a Message</h2>
                    
                    <div class="form-group">
                        <label for="name">Your Name</label>
                        <asp:TextBox ID="name" runat="server" CssClass="form-control" placeholder="Enter your full name"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="email">Email Address</label>
                        <asp:TextBox ID="email" runat="server" CssClass="form-control" placeholder="Enter your email address"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="subject">Subject</label>
                        <asp:TextBox ID="subject" runat="server" CssClass="form-control" placeholder="What is this regarding?"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label for="message">Your Message</label>
                        <asp:TextBox ID="message" runat="server" TextMode="MultiLine" Rows="5" CssClass="form-control" placeholder="Type your message here..."></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <asp:Button ID="submitButton" runat="server" Text="Send Message" CssClass="ui-button" />
                    </div>
                </div>
            </div>
        </div>
    </div>
    </form>
</body>
</html>
