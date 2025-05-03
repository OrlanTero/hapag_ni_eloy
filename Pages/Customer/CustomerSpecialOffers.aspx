<%@ Page Title="HAPAG - Special Offers" Language="VB" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" AutoEventWireup="false" CodeFile="CustomerSpecialOffers.aspx.vb" Inherits="Pages_Customer_CustomerSpecialOffers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <style type="text/css">
        .page-hero {
            background-color: #FFC107;
            padding: 50px;
            text-align: center;
            color: #333;
            position: relative;
            overflow: hidden;
        }
        
        .page-hero h1 {
            font-size: 36px;
            margin-bottom: 15px;
            position: relative;
            z-index: 2;
        }
        
        .page-hero p {
            font-size: 18px;
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            z-index: 2;
        }
        
        .offers-container {
            padding: 50px 20px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
        }
        
        .offers-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .offer-card {
            border: 1px solid #eee;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .offer-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        
        .offer-image {
            height: 200px;
            overflow: hidden;
            position: relative;
        }
        
        .offer-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s;
        }
        
        .offer-card:hover .offer-image img {
            transform: scale(1.05);
        }
        
        .offer-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background-color: #FF5722;
            color: white;
            padding: 5px 15px;
            border-radius: 30px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .offer-details {
            padding: 20px;
        }
        
        .offer-title {
            font-size: 20px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }
        
        .offer-description {
            color: #666;
            margin-bottom: 15px;
            font-size: 14px;
            line-height: 1.5;
        }
        
        .offer-value {
            font-size: 18px;
            font-weight: bold;
            color: #FF5722;
            margin-bottom: 15px;
        }
        
        .offer-dates {
            font-size: 13px;
            color: #666;
            margin-bottom: 15px;
        }
        
        .offer-button {
            display: inline-block;
            background-color: #FFC107;
            color: #333;
            padding: 8px 20px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            font-size: 14px;
            transition: background-color 0.3s;
        }
        
        .offer-button:hover {
            background-color: #FF9800;
        }
        
        .no-offers {
            text-align: center;
            padding: 50px 0;
            color: #666;
        }
        
        .no-offers i {
            font-size: 60px;
            color: #ddd;
            margin-bottom: 20px;
            display: block;
        }
        
        @media (max-width: 768px) {
            .offers-container {
                padding: 30px 15px;
            }
            
            .offers-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="page-hero">
        <h1>Special Offers & Promotions</h1>
        <p>Discover our exclusive deals, discounts, and promotions to enjoy your favorite Filipino dishes at the best prices.</p>
        <div class="page-curve"></div>
    </div>
    
    <div class="offers-container">
        <!-- Promotions Section -->
        <h2 class="section-title">Current Promotions</h2>
        <asp:PlaceHolder ID="PromotionsPlaceholder" runat="server">
            <div class="offers-grid">
                <asp:Repeater ID="PromotionsRepeater" runat="server">
                    <ItemTemplate>
                        <div class="offer-card">
                            <div class="offer-image">
                                <img src='<%# GetImageUrl(Eval("image")) %>' alt='<%# Eval("name") %>' />
                                <div class="offer-badge">PROMO</div>
                            </div>
                            <div class="offer-details">
                                <div class="offer-title"><%# Eval("name") %></div>
                                <div class="offer-description"><%# Eval("description") %></div>
                                <div class="offer-value">
                                    <%# GetValueDisplay(Eval("value"), Eval("value_type")) %>
                                </div>
                                <div class="offer-dates">
                                    Valid from <%# FormatDate(Eval("start_date")) %> to <%# FormatDate(Eval("valid_until")) %>
                                </div>
                                <a href="CustomerMenu.aspx" class="offer-button">Shop Now</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="NoPromotionsPlaceholder" runat="server" Visible="false">
            <div class="no-offers">
                <i class="fas fa-exclamation-circle"></i>
                <p>No active promotions found at the moment. Please check back later!</p>
            </div>
        </asp:PlaceHolder>
        
        <!-- Deals Section -->
        <h2 class="section-title">Special Deals</h2>
        <asp:PlaceHolder ID="DealsPlaceholder" runat="server">
            <div class="offers-grid">
                <asp:Repeater ID="DealsRepeater" runat="server">
                    <ItemTemplate>
                        <div class="offer-card">
                            <div class="offer-image">
                                <img src='<%# GetImageUrl(Eval("image")) %>' alt='<%# Eval("name") %>' />
                                <div class="offer-badge">DEAL</div>
                            </div>
                            <div class="offer-details">
                                <div class="offer-title"><%# Eval("name") %></div>
                                <div class="offer-description"><%# Eval("description") %></div>
                                <div class="offer-value">
                                    <%# GetValueDisplay(Eval("value"), Eval("value_type")) %>
                                </div>
                                <div class="offer-dates">
                                    Valid from <%# FormatDate(Eval("start_date")) %> to <%# FormatDate(Eval("valid_until")) %>
                                </div>
                                <a href="CustomerMenu.aspx" class="offer-button">Shop Now</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="NoDealsPlaceholder" runat="server" Visible="false">
            <div class="no-offers">
                <i class="fas fa-exclamation-circle"></i>
                <p>No active deals found at the moment. Please check back later!</p>
            </div>
        </asp:PlaceHolder>
        
        <!-- Discounts Section -->
        <h2 class="section-title">Available Discounts</h2>
        <asp:PlaceHolder ID="DiscountsPlaceholder" runat="server">
            <div class="offers-grid">
                <asp:Repeater ID="DiscountsRepeater" runat="server">
                    <ItemTemplate>
                        <div class="offer-card">
                            <div class="offer-image">
                                <img src="../../Assets/Images/default-food.jpg" alt='<%# Eval("name") %>' />
                                <div class="offer-badge">DISCOUNT</div>
                            </div>
                            <div class="offer-details">
                                <div class="offer-title"><%# Eval("name") %></div>
                                <div class="offer-description"><%# Eval("description") %></div>
                                <div class="offer-value">
                                    <%# GetValueDisplay(Eval("value"), Eval("value_type")) %>
                                </div>
                                <a href="CustomerMenu.aspx" class="offer-button">Shop Now</a>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </asp:PlaceHolder>
        <asp:PlaceHolder ID="NoDiscountsPlaceholder" runat="server" Visible="false">
            <div class="no-offers">
                <i class="fas fa-exclamation-circle"></i>
                <p>No active discounts found at the moment. Please check back later!</p>
            </div>
        </asp:PlaceHolder>
    </div>
</asp:Content> 