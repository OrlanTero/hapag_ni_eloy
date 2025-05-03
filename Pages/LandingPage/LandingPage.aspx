<%@ Page Language="VB" AutoEventWireup="false" CodeFile="LandingPage.aspx.vb" Inherits="LandingPage" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 4.1 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Welcome to Our Restaurant</title>
    <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
    <style>
        /* Common styles for sections */
        .section {
            padding: 5rem 2rem;
            position: relative;
        }
        
        .section-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .section-header {
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .section-header h2 {
            font-size: 2.5rem;
            color: #333;
            margin-bottom: 1rem;
            font-weight: 700;
        }
        
        .section-header p {
            font-size: 1.1rem;
            color: #666;
            max-width: 800px;
            margin: 0 auto;
        }
        
        .section-subtitle {
            font-size: 1.8rem;
            color: #333;
            margin-top: 2.5rem;
            margin-bottom: 1.5rem;
            text-align: center;
            font-weight: 600;
        }
        
        /* Menu section styling */
        .menu-section {
            background-color: #f9f9f9;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            padding: 1rem 0;
        }
        
        .menu-item {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .menu-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        
        .menu-item-image {
            width: 100%;
            height: 220px;
            object-fit: cover;
        }
        
        .menu-item-details {
            padding: 1.5rem;
        }
        
        .menu-item-name {
            font-size: 1.4rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 0.8rem;
        }
        
        .menu-item-description {
            font-size: 1rem;
            color: #666;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.5;
        }
        
        .menu-item-price {
            font-size: 1.3rem;
            font-weight: 700;
            color: #619F2B;
        }
        
        .menu-item-category {
            font-size: 0.9rem;
            color: #888;
            margin-top: 0.8rem;
            display: inline-block;
            padding: 0.3rem 0.8rem;
            background: #f0f0f0;
            border-radius: 30px;
        }
        
        /* Offers section styling */
        .offers-section {
            background-color: #fff;
            border-top: 1px solid #eee;
        }
        
        .offers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(340px, 1fr));
            gap: 2rem;
            margin-bottom: 3rem;
        }
        
        .offer-card {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 1px solid #eee;
            position: relative;
            overflow: hidden;
        }
        
        .offer-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        
        .offer-card::before {
            content: "";
            position: absolute;
            top: 0;
            right: 0;
            height: 120px;
            width: 120px;
            background: #f9f9f9;
            transform: rotate(45deg) translate(40px, -80px);
            z-index: 0;
        }
        
        .offer-value {
            font-size: 2.2rem;
            font-weight: bold;
            color: #e74c3c;
            margin-bottom: 1.2rem;
            position: relative;
            z-index: 1;
        }
        
        .offer-title {
            font-size: 1.4rem;
            font-weight: bold;
            color: #333;
            margin-bottom: 0.8rem;
        }
        
        .offer-description {
            color: #666;
            margin-bottom: 1.2rem;
            line-height: 1.5;
        }
        
        .offer-period {
            font-size: 0.9rem;
            color: #888;
            padding-top: 0.8rem;
            border-top: 1px dashed #eee;
            display: flex;
            align-items: center;
        }
        
        .offer-period::before {
            content: "\f073";
            font-family: "FontAwesome";
            margin-right: 0.5rem;
            color: #aaa;
        }
        
        .offer-badge {
            display: inline-block;
            padding: 0.4rem 1rem;
            background-color: #e74c3c;
            color: white;
            border-radius: 30px;
            font-size: 0.9rem;
            margin-bottom: 1.2rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 3px 10px rgba(231, 76, 60, 0.2);
        }
        
        .deal-badge {
            background-color: #3498db;
            box-shadow: 0 3px 10px rgba(52, 152, 219, 0.2);
        }
        
        .promo-badge {
            background-color: #2ecc71;
            box-shadow: 0 3px 10px rgba(46, 204, 113, 0.2);
        }
        
        /* Login prompt styling */
        .login-prompt {
            text-align: center;
            margin-top: 2rem;
            padding: 2rem;
            background: #f5f5f5;
            border-radius: 12px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
        }
        
        .login-prompt p {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 1rem;
        }
        
        .login-prompt a {
            color: #619F2B;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s;
        }
        
        .login-prompt a:hover {
            color: #4a7a23;
            text-decoration: underline;
        }
        
        /* CTA Section */
        .cta-section {
            text-align: center;
            margin-top: 3rem;
        }
        
        .cta-button {
            display: inline-block;
            padding: 1rem 2rem;
            background-color: #619F2B;
            color: white;
            border: none;
            border-radius: 50px;
            font-size: 1.1rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(97, 159, 43, 0.3);
        }
        
        .cta-button:hover {
            background-color: #4a7a23;
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(97, 159, 43, 0.4);
        }
        
        .cta-button.secondary {
            background-color: #f0f0f0;
            color: #666;
            margin: 0 1rem;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        
        .cta-button.secondary:hover {
            background-color: #e0e0e0;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.15);
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .section {
                padding: 3rem 1rem;
            }
            
            .section-header h2 {
                font-size: 2rem;
            }
            
            .menu-grid, .offers-grid {
                grid-template-columns: 1fr;
            }
            
            .offer-card {
                padding: 1.5rem;
            }
        }
    </style>
</head>

<body>
   <div class="root-container">
       <div class="top-navbar">
            <div class="left">
                <img src="./../../Assets/Images/logo.png" alt="Alternate Text" />
            </div>
            <div class="right">
                <ul>
                    <a href="LandingPage.aspx"><li class="active"><span>HOME</span></li></a>
                    <a href="About.aspx"><li><span>ABOUT</span></li></a>
                    <a href="Contact.aspx"><li><span>CONTACT US</span></li></a>
                </ul>
            </div>
       </div>

       <div class="main-container">
            <div class="main-background" style="background-image:url('./../../Assets/Images/backgrounds/land_page_background.png')"></div>
            <div class="main-headline">
                <h1>
                Savor the taste of Home at Hapag
                </h1>
                <p>
                "Authentic Filipino flavors, handcrafted with love and tradition, bringing families together one meal at a time."
                </p>

                <div class="buttons">
                    <a href="./../LoginPortal/CustomerLoginPortal.aspx">
                    <div class="ui-button">
                        <span>LOG IN</span>
                    </div>
                    </a>
                    <a href="./../LoginPortal/RegisterPortal.aspx">
                    <div class="ui-button">
                        <span>SIGN UP</span>
                    </div>
                    </a>
                </div>
            </div>
       </div>

       <form id="form1" runat="server">
           <!-- Menu Section -->
           <div class="section menu-section" id="menuSection" runat="server">
               <div class="section-container">
                   <div class="section-header">
                       <h2>Our Delicious Menu</h2>
                       <p>Explore our wide selection of authentic Filipino dishes</p>
                   </div>
                   
                   <div class="menu-grid">
                       <asp:Repeater ID="MenuRepeater" runat="server">
                           <ItemTemplate>
                               <div class="menu-item">
                                   <img src='<%# GetImageUrl(Eval("image").ToString()) %>' 
                                        alt='<%# Eval("name") %>' 
                                        class="menu-item-image" 
                                        onerror="this.src='../../Assets/Images/default-food.jpg'" />
                                   <div class="menu-item-details">
                                       <div class="menu-item-name"><%# Eval("name") %></div>
                                       <div class="menu-item-description"><%# Eval("description") %></div>
                                       <div class="menu-item-price">PHP <%# Format(CDec(Eval("price")), "0.00") %></div>
                                       <div class="menu-item-category"><%# Eval("category") %></div>
                                   </div>
                               </div>
                           </ItemTemplate>
                       </asp:Repeater>
                   </div>
               </div>
           </div>

           <!-- Special Offers Section -->
           <div class="section offers-section" id="offersSection" runat="server">
               <div class="section-container">
                   <div class="section-header">
                       <h2>Special Offers & Promotions</h2>
                       <p>Take advantage of our current deals and discounts</p>
                   </div>

                   <!-- Discounts -->
                   <h3 class="section-subtitle">Available Discounts</h3>
                   <div class="offers-grid" id="discountsGrid" runat="server">
                       <asp:Repeater ID="DiscountsRepeater" runat="server">
                           <ItemTemplate>
                               <div class="offer-card">
                                   <div class="offer-badge">Discount</div>
                                   <div class="offer-value">
                                       <%# GetValueDisplay(Eval("value"), Eval("value_type")) %>
                                   </div>
                                   <div class="offer-title"><%# Eval("name") %></div>
                                   <div class="offer-description"><%# Eval("description") %></div>
                                   <div class="offer-period">
                                       Valid until: <%# FormatDate(Eval("end_date")) %>
                                   </div>
                               </div>
                           </ItemTemplate>
                       </asp:Repeater>
                   </div>

                   <!-- Deals -->
                   <h3 class="section-subtitle">Special Deals</h3>
                   <div class="offers-grid" id="dealsGrid" runat="server">
                       <asp:Repeater ID="DealsRepeater" runat="server">
                           <ItemTemplate>
                               <div class="offer-card">
                                   <div class="offer-badge deal-badge">Deal</div>
                                   <div class="offer-value">
                                       <%# GetValueDisplay(Eval("value"), Eval("value_type")) %>
                                   </div>
                                   <div class="offer-title"><%# Eval("name") %></div>
                                   <div class="offer-description"><%# Eval("description") %></div>
                                   <div class="offer-period">
                                       Valid until: <%# FormatDate(Eval("valid_until")) %>
                                   </div>
                               </div>
                           </ItemTemplate>
                       </asp:Repeater>
                   </div>

                   <!-- Promotions -->
                   <h3 class="section-subtitle">Current Promotions</h3>
                   <div class="offers-grid" id="promotionsGrid" runat="server">
                       <asp:Repeater ID="PromotionsRepeater" runat="server">
                           <ItemTemplate>
                               <div class="offer-card">
                                   <div class="offer-badge promo-badge">Promotion</div>
                                   <div class="offer-value">
                                       <%# GetValueDisplay(Eval("value"), Eval("value_type")) %>
                                   </div>
                                   <div class="offer-title"><%# Eval("name") %></div>
                                   <div class="offer-description"><%# Eval("description") %></div>
                                   <div class="offer-period">
                                       Valid until: <%# FormatDate(Eval("valid_until")) %>
                                   </div>
                               </div>
                           </ItemTemplate>
                       </asp:Repeater>
                   </div>

                   <br>
                   <div class="login-prompt">
                    <p>Want to place an order? <a href="./../LoginPortal/CustomerLoginPortal.aspx">Login</a> or <a href="./../LoginPortal/RegisterPortal.aspx">Register</a> to get started!</p>
                </div>
               </div>
           </div>
       </form>
   </div>
</body>
</html>

