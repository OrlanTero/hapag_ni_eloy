<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerOrders.aspx.vb" Inherits="Pages_Customer_CustomerOrders" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-container">
        <!-- Content Header -->
        <div class="content-header">
            <h1><i class="fas fa-shopping-bag"></i> My Orders</h1>
            <p>View and track your order history</p>
            <div class="refresh-container">
                <asp:Button ID="RefreshButton" runat="server" Text="Refresh Orders" CssClass="refresh-btn" OnClick="RefreshButton_Click" />
            </div>
        </div>

        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>

        <!-- Empty Orders Panel -->
        <asp:Panel ID="EmptyOrdersPanel" runat="server" CssClass="orders-container" Visible="false">
            <div class="empty-orders">
                <i class="fas fa-shopping-bag"></i>
                <h2>No orders yet</h2>
                <p>Start ordering delicious food from our menu!</p>
                <a href="CustomerMenu.aspx" class="browse-menu-btn">Browse Menu</a>
            </div>
        </asp:Panel>

        <!-- Orders Panel -->
        <asp:Panel ID="OrdersPanel" runat="server" CssClass="orders-container">
            <asp:Repeater ID="OrdersRepeater" runat="server" OnItemDataBound="OrdersRepeater_ItemDataBound" OnItemCommand="OrdersRepeater_ItemCommand">
                <ItemTemplate>
                    <div class="order-card">
                        <div class="order-header">
                            <div class="order-info">
                                <h3>Order #<%# Eval("order_id") %></h3>
                                <span class="order-date"><%# Format(Eval("order_date"), "MMMM dd, yyyy hh:mm tt") %></span>
                            </div>
                            <div class="order-status <%# GetStatusClass(Eval("status")) %>">
                                <%# Eval("status") %>
                            </div>
                        </div>
                        
                        <!-- Order Summary -->
                        <div class="order-summary">
                            <div class="summary-row">
                                <span class="summary-label">Items:</span>
                                <span class="summary-value"><asp:Literal ID="ItemCountLiteral" runat="server"></asp:Literal></span>
                            </div>
                            <div class="summary-row">
                                <span class="summary-label">Total:</span>
                                <span class="summary-value total-amount">PHP <%# Format(Eval("total_amount"), "0.00") %></span>
                            </div>
                        </div>

                        <!-- Expandable Sections -->
                        <div class="expandable-sections">
                            <!-- Order Items Section (Collapsible) -->
                            <div class="expandable-section">
                                <div class="section-header" onclick="toggleSection(this)">
                                    <h3 class="order-section-title"><i class="fas fa-utensils"></i> Order Items</h3>
                                    <i class="fas fa-chevron-down toggle-icon"></i>
                                </div>
                                <div class="section-content hidden">
                                    <div class="order-items-container">
                                        <asp:Repeater ID="OrderItemsRepeater" runat="server">
                                            <ItemTemplate>
                                                <div class="order-item">
                                                    <img src='<%# GetImageUrl(Eval("image").ToString()) %>' 
                                                        alt='<%# Eval("name") %>' class="item-image" 
                                                        onerror="this.src='../../Assets/Images/default-food.jpg'" />
                                                    <div class="item-details">
                                                        <h4><%# Eval("name") %></h4>
                                                        <div class="item-info">
                                                            <span class="item-quantity">Qty: <strong><%# Eval("quantity") %></strong></span>
                                                            <span class="item-price">PHP <%# Format(Eval("price"), "0.00") %></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </div>

                            <!-- Discounts and Promotions Section (Collapsible) -->
                            <asp:Panel ID="DiscountsPanel" runat="server" CssClass="expandable-section">
                                <div class="section-header" onclick="toggleSection(this)">
                                    <h3 class="order-section-title"><i class="fas fa-tag"></i> Discounts & Promotions</h3>
                                    <i class="fas fa-chevron-down toggle-icon"></i>
                                </div>
                                <div class="section-content hidden">
                                    <div class="discounts-container">
                                        <asp:Repeater ID="DiscountsRepeater" runat="server">
                                            <ItemTemplate>
                                                <div class="discount-item">
                                                    <div class="discount-info">
                                                        <span class="discount-name"><%# Eval("name") %></span>
                                                        <span class="discount-value">
                                                            <%# If(Eval("discount_type") = 1, 
                                                                Eval("value") & "% off", 
                                                                "PHP " & Format(Eval("value"), "0.00") & " off") %>
                                                        </span>
                                                    </div>
                                                    <div class="discount-amount">
                                                        -PHP <%# Format(Eval("discount_amount"), "0.00") %>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                                    </div>
                                </div>
                            </asp:Panel>

                            <!-- Delivery Info Section (Collapsible) -->
                            <asp:Panel ID="DeliveryInfoPanel" runat="server" CssClass="expandable-section">
                                <div class="section-header" onclick="toggleSection(this)">
                                    <h3 class="order-section-title"><i class="fas fa-truck"></i> Delivery Tracking</h3>
                                    <i class="fas fa-chevron-down toggle-icon"></i>
                                </div>
                                <div class="section-content hidden">
                                    <div class="delivery-details">
                                        <div class="tracking-status">
                                            <div class="tracking-status-label">Current Status:</div>
                                            <div class="tracking-status-value"><%# Eval("status").ToString().ToUpper() %></div>
                                        </div>
                                        
                                        <div class="order-status-description">
                                            <strong>What this means:</strong> 
                                            <span class="status-explanation">
                                                <%# GetStatusExplanation(Eval("status").ToString()) %>
                                            </span>
                                        </div>
                                        
                                        <div class="delivery-item">
                                            <span class="delivery-label">Delivery Service:</span>
                                            <span class="delivery-value"><asp:Literal ID="DeliveryServiceLiteral" runat="server"></asp:Literal></span>
                                        </div>
                                        <div class="delivery-item">
                                            <span class="delivery-label">Driver Name:</span>
                                            <span class="delivery-value"><asp:Literal ID="DriverNameLiteral" runat="server"></asp:Literal></span>
                                        </div>
                                        <asp:Panel ID="TrackingPanel" runat="server" CssClass="delivery-item" Visible="false">
                                            <span class="delivery-label">Tracking Link:</span>
                                            <span class="delivery-value">
                                                <asp:HyperLink ID="TrackingLink" runat="server" Target="_blank" CssClass="tracking-link">
                                                    <i class="fas fa-map-marker-alt"></i> Track Delivery Location
                                                </asp:HyperLink>
                                            </span>
                                        </asp:Panel>
                                        <div class="tracking-note">
                                            <p><i class="fas fa-info-circle"></i> Delivery information will be updated by our staff as your order is processed.</p>
                                        </div>
                                    </div>
                                </div>
                            </asp:Panel>
                        </div>

                        <div class="order-footer">
                            <div class="order-actions">
                                <asp:LinkButton ID="ReorderButton" runat="server" CssClass="reorder-btn" 
                                                CommandName="Reorder" CommandArgument='<%# Eval("order_id") %>'
                                                OnClientClick="return confirm('Would you like to add these items to your cart?');"
                                                Visible='<%# Eval("status").ToString().ToLower() = "completed" %>'>
                                    <i class="fas fa-redo"></i> Reorder
                                </asp:LinkButton>
                                <span style="margin-right: 5px;"></span>
                                <asp:PlaceHolder ID="ConfirmButtonPlaceholder" runat="server"></asp:PlaceHolder>
                                <span style="margin-right: 5px;"></span>
                                <asp:PlaceHolder ID="CancelButtonPlaceholder" runat="server"></asp:PlaceHolder>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </asp:Panel>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay">
        <div class="loading-spinner"></div>
    </div>

    <script type="text/javascript">
        function showAlert(message, isSuccess) {
            var alertDiv = document.getElementById('<%= alertMessage.ClientID %>');
            var alertLiteral = document.getElementById('<%= AlertLiteral.ClientID %>');

            if (alertDiv && alertLiteral) {
                alertDiv.style.display = 'block';
                alertDiv.className = 'alert-message ' + (isSuccess ? 'alert-success' : 'alert-danger');
                alertLiteral.textContent = message;

                setTimeout(function() {
                    alertDiv.style.display = 'none';
                }, 5000);
            } else {
                alert(message);
            }
        }

        function toggleSection(header) {
            // Find the content section next to the header
            var content = header.nextElementSibling;
            
            // Toggle the hidden class
            content.classList.toggle('hidden');
            
            // Rotate the icon
            var icon = header.querySelector('.toggle-icon');
            icon.classList.toggle('rotate-icon');
            
            // If this is the delivery tracking section and it's being expanded,
            // make it more noticeable for a moment
            if (header.querySelector('.order-section-title').innerHTML.includes('Delivery Tracking') && 
                !content.classList.contains('hidden')) {
                var panel = header.closest('.expandable-section');
                panel.classList.add('highlight-briefly');
                
                setTimeout(function() {
                    panel.classList.remove('highlight-briefly');
                }, 1500);
            }
        }

        // Open the relevant section if needed when a new order is created
        function highlightOrder(orderId, immediate) {
            console.log("Highlighting order: " + orderId);
            
            // Find the order card for this order ID
            var orderCards = document.querySelectorAll('.order-card');
            var targetCard = null;
            
            orderCards.forEach(function(card) {
                var headerTitle = card.querySelector('.order-info h3');
                if (headerTitle && headerTitle.innerText.includes(orderId)) {
                    targetCard = card;
                }
            });
            
            if (targetCard) {
                // Add highlight class
                targetCard.classList.add('highlighted-order');
                
                // Scroll to the highlighted order
                var scrollBehavior = immediate === true ? 'auto' : 'smooth';
                
                // First make sure the page has loaded fully
                setTimeout(function() {
                    // Scroll the order into view
                    targetCard.scrollIntoView({ behavior: scrollBehavior, block: 'start' });
                    
                    // Automatically expand all sections for this order
                    var sections = targetCard.querySelectorAll('.section-header');
                    sections.forEach(function(section) {
                        toggleSection(section);
                    });
                    
                    // Make the delivery tracking section more noticeable
                    var trackingSection = targetCard.querySelector('.expandable-section:nth-child(3)');
                    if (trackingSection) {
                        trackingSection.classList.add('highlighted-tracking');
                        
                        // Remove highlight after 8 seconds
                        setTimeout(function() {
                            trackingSection.classList.remove('highlighted-tracking');
                        }, 8000);
                    }
                    
                    // Remove order highlight after 8 seconds
                    setTimeout(function() {
                        targetCard.classList.remove('highlighted-order');
                    }, 8000);
                }, 100);
            }
        }

        // When the page loads, scroll to the top
        window.onload = function() {
            window.scrollTo(0, 0);
        };
    </script>

    <style type="text/css">
        .content-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .content-header {
            margin-bottom: 30px;
            text-align: center;
        }

        .content-header h1 {
            color: #2C3E50;
            font-size: 32px;
            margin-bottom: 10px;
        }

        .content-header p {
            color: #666;
            font-size: 16px;
        }

        .orders-container {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .order-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 15px;
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #eee;
        }

        .order-info h3 {
            margin: 0;
            color: #2C3E50;
            font-size: 18px;
        }

        .order-date {
            color: #666;
            font-size: 14px;
        }

        .order-status {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 14px;
            font-weight: 600;
        }

        .status-pending {
            background-color: #ffeeba;
            color: #856404;
        }

        .status-processing {
            background-color: #b8daff;
            color: #004085;
        }
        
        .status-delivering {
            background-color: #d1ecf1;
            color: #0c5460;
        }
        
        .status-completed {
            background-color: #c3e6cb;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f5c6cb;
            color: #721c24;
        }

        .order-items {
            padding: 15px 20px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .order-section-title {
            margin: 0 0 10px 0;
            font-size: 18px;
            color: #2C3E50;
            padding-bottom: 5px;
            border-bottom: 1px solid #eee;
        }
        
        .order-items-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-height: 200px;
            overflow-y: auto;
            padding-right: 5px;
        }

        .order-item {
            display: flex;
            gap: 12px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .order-item:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .item-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 8px;
        }

        .item-details {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .item-details h4 {
            margin: 0 0 5px 0;
            color: #2C3E50;
            font-size: 16px;
        }
        
        .item-info {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .item-quantity, .item-price {
            margin: 0;
            color: #666;
            font-size: 14px;
        }
        
        .item-price {
            color: #619F2B;
            font-weight: 600;
        }

        .order-footer {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 15px 20px;
            background: #f8f9fa;
        }

        .reorder-btn {
            padding: 8px 16px;
            background-color: #619F2B;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .reorder-btn:hover {
            background-color: #4F8022;
        }

        .empty-orders {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .empty-orders i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-orders h2 {
            margin-bottom: 10px;
            color: #2C3E50;
        }

        .browse-menu-btn {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background-color: #619F2B;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            transition: all 0.3s ease;
        }

        .browse-menu-btn:hover {
            background-color: #4F8022;
            transform: translateY(-2px);
        }

        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.8);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 4px solid #f3f3f3;
            border-top: 4px solid #619F2B;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 768px) {
            .order-summary {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
            
            .summary-row {
                width: 100%;
                justify-content: space-between;
                margin-right: 0;
            }
        }

        /* New Order Summary Styles */
        .order-summary {
            display: flex;
            justify-content: space-between;
            padding: 12px 20px;
            background-color: #fff;
            border-bottom: 1px solid #eee;
            flex-wrap: wrap;
        }

        .summary-row {
            display: flex;
            align-items: center;
            margin-right: 20px;
        }

        .summary-label {
            font-weight: 600;
            color: #555;
            margin-right: 10px;
        }

        .summary-value {
            color: #2C3E50;
        }

        /* Expandable Sections Styles */
        .expandable-sections {
            border-bottom: 1px solid #eee;
        }

        .expandable-section {
            border-bottom: 1px solid #f3f3f3;
        }

        .expandable-section:last-child {
            border-bottom: none;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            cursor: pointer;
            transition: background-color 0.2s ease;
        }

        .section-header:hover {
            background-color: #f9f9f9;
        }

        .section-header .order-section-title {
            margin: 0;
            font-size: 16px;
            color: #2C3E50;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .toggle-icon {
            font-size: 14px;
            color: #666;
            transition: transform 0.3s ease;
        }

        .section-content {
            padding: 15px 20px;
            border-top: 1px solid #f3f3f3;
            max-height: 500px;
            overflow-y: auto;
        }

        .hidden {
            display: none;
        }

        .rotate-icon {
            transform: rotate(180deg);
        }

        /* Modified delivery info panel to match collapsible style */
        .delivery-info-panel {
            margin-top: 0;
            padding: 0;
            background: transparent;
            border-radius: 0;
            box-shadow: none;
            border-left: none;
        }

        /* Modified discounts panel to match collapsible style */
        .discounts-panel {
            margin-top: 0;
            padding: 0;
            background: transparent;
            border-radius: 0;
            box-shadow: none;
            border-left: none;
        }

        .delivery-info-header {
            margin-bottom: 20px;
            font-size: 20px;
            font-weight: 600;
            color: #2C3E50;
            border-bottom: 2px solid #FFC107;
            padding-bottom: 10px;
        }

        .delivery-details {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .tracking-status {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            background-color: #f0f0f0;
            padding: 12px;
            border-radius: 8px;
        }

        .tracking-status-label {
            font-weight: 600;
            margin-right: 10px;
            color: #555;
        }

        .tracking-status-value {
            font-weight: bold;
            text-transform: uppercase;
            color: #FFC107;
            background-color: rgba(255, 193, 7, 0.1);
            padding: 4px 12px;
            border-radius: 20px;
        }
        
        .order-status-description {
            padding: 12px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-bottom: 15px;
            border-left: 3px solid #FFC107;
        }
        
        .status-explanation {
            font-size: 14px;
            color: #555;
            margin-left: 5px;
        }

        .delivery-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .delivery-label {
            font-weight: 600;
            color: #666;
        }

        .delivery-value {
            color: #2C3E50;
            font-weight: 500;
        }

        .tracking-link {
            color: #0d6efd;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 6px 12px;
            background-color: rgba(13, 110, 253, 0.1);
            border-radius: 20px;
            transition: all 0.3s ease;
        }

        .tracking-link:hover {
            background-color: rgba(13, 110, 253, 0.2);
            text-decoration: none;
            transform: translateY(-2px);
        }
        
        .tracking-note {
            margin-top: 10px;
            padding: 10px;
            background-color: rgba(255, 193, 7, 0.1);
            border-left: 4px solid #FFC107;
            border-radius: 4px;
        }
        
        .tracking-note p {
            margin: 0;
            color: #856404;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .refresh-container {
            text-align: center;
            margin-top: 15px;
        }
        
        .refresh-btn {
            padding: 8px 16px;
            background-color: #619F2B;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .refresh-btn:hover {
            background-color: #4F8022;
        }

        /* Add these styles for the confirmation button */
        .confirm-btn-container {
            display: inline-block;
            margin-left: 10px;
        }

        .confirm-btn {
            display: inline-flex;
            align-items: center;
            padding: 8px 16px;
            background-color: #28a745;
            color: white;
            border-radius: 20px;
            text-decoration: none;
            font-size: 14px;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .confirm-btn:hover {
            background-color: #218838;
            color: white;
            text-decoration: none;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        /* Update cancel button styles for consistency */
        .cancel-btn-container {
            display: inline-block;
            margin-left: 10px;
        }

        .cancel-btn {
            display: inline-flex;
            align-items: center;
            padding: 8px 16px;
            background-color: #dc3545;
            color: white;
            border-radius: 20px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .cancel-btn:hover {
            background-color: #c82333;
            color: white;
            text-decoration: none;
        }

        /* Update reorder button style for consistency */
        .reorder-btn {
            display: inline-flex;
            align-items: center;
            padding: 8px 16px;
            background-color: #17a2b8;
            color: white;
            border-radius: 20px;
            text-decoration: none;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .reorder-btn:hover {
            background-color: #138496;
            color: white;
            text-decoration: none;
        }

        /* Highlighted Order Animation */
        @keyframes highlight-pulse {
            0% { box-shadow: 0 0 0 0 rgba(255, 193, 7, 0.7); }
            70% { box-shadow: 0 0 0 10px rgba(255, 193, 7, 0); }
            100% { box-shadow: 0 0 0 0 rgba(255, 193, 7, 0); }
        }
        
        .highlighted-order {
            animation: highlight-pulse 1.5s infinite;
            border: 2px solid #FFC107 !important;
            background-color: rgba(255, 248, 225, 0.7) !important;
        }
        
        /* Highlighted Tracking Panel */
        @keyframes tracking-highlight {
            0% { background-color: rgba(255, 193, 7, 0.3); }
            50% { background-color: rgba(255, 193, 7, 0.1); }
            100% { background-color: rgba(255, 193, 7, 0.3); }
        }
        
        .highlighted-tracking {
            animation: tracking-highlight 2s infinite;
            border-left: 5px solid #FF5722 !important;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(255, 87, 34, 0.4) !important;
            transform: scale(1.02);
            transition: all 0.3s ease;
        }
        
        /* Add a notice for newly placed orders */
        .new-order-notice {
            background-color: #FFC107;
            color: #333;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-weight: bold;
            text-align: center;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .discounts-container {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .discount-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        }

        .discount-info {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .discount-name {
            font-weight: 600;
            color: #2C3E50;
        }

        .discount-value {
            color: #666;
            font-size: 14px;
        }

        .discount-amount {
            font-weight: bold;
            color: #FFC107;
        }
    </style>
</asp:Content> 