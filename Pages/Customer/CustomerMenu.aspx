<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerMenu.aspx.vb" Inherits="Pages_Customer_CustomerMenu" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" %>
<%@ Import Namespace="System" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Container -->
    <div class="content-container">
        <!-- Content Header -->
        <div class="content-header">
            <h1>Our Menu</h1>
            <p>Explore our delicious offerings and place your order</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-group">
                <h2>Menu Categories</h2>
                <div class="filter-scroll">
                    <div class="filter-tabs" id="categoryTabs" runat="server">
                        <div class="filter-tab active" data-category="">All Categories</div>
                        <asp:Repeater ID="CategoryRepeater" runat="server">
                            <ItemTemplate>
                                <div class="filter-tab" data-category='<%# Eval("category_id") %>'>
                                    <%# Eval("category") %>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>

            <div class="filter-group">
                <h2>Menu Types</h2>
                <div class="filter-scroll">
                    <div class="filter-tabs" id="typeTabs" runat="server">
                        <div class="filter-tab active" data-type="">All Types</div>
                        <asp:Repeater ID="TypeRepeater" runat="server">
                            <ItemTemplate>
                                <div class="filter-tab" data-type='<%# Eval("type_id") %>'>
                                    <%# Eval("type") %>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>
            </div>
        </div>

        <!-- Menu Grid -->
        <div class="menu-grid-container">
            <asp:Repeater ID="MenuRepeater" runat="server">
                <ItemTemplate>
                    <div class="menu-card" data-category='<%# Eval("category_id") %>' data-type='<%# Eval("type_id") %>'>
                        <div class="menu-image-container">
                            <img src='<%# GetImageUrl(Eval("image").ToString()) %>' 
                                 alt='<%# Eval("name") %>' class="menu-image" 
                                 onerror="this.src='../../Assets/Images/default-food.jpg'" />
                        </div>
                        <div class="menu-details">
                            <div class="menu-name"><%# Eval("name") %></div>
                            <div class="menu-description"><%# Eval("description") %></div>
                            <div class="menu-price">PHP <%# Format(CDec(Eval("price")), "0.00") %></div>
                            <div class="menu-meta">
                                <span class="category-tag"><%# Eval("category") %></span>
                                <span class="type-tag"><%# Eval("type") %></span>
                            </div>
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn minus" onclick="updateQuantity(this, -1)">-</button>
                                <input type="number" class="quantity-input" value="1" min="1" max="99" />
                                <button type="button" class="quantity-btn plus" onclick="updateQuantity(this, 1)">+</button>
                            </div>
                            <button type="button" class="add-to-cart-btn" 
                                    data-item-id="<%# Eval("item_id") %>"
                                    onclick="addToCart(this)"
                                    <%# GetAvailabilityAttribute(Eval("availability")) %>>
                                <%# GetAvailabilityText(Eval("availability")) %>
                            </button>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay">
        <div class="loading-spinner"></div>
    </div>

    <style type="text/css">
        .content-container {
            padding: 20px;
            max-width: 1400px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
        }

        .menu-grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
            padding: 20px 0;
        }

        .menu-card {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
            border: 1px solid #eee;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }

        .menu-image-container {
            position: relative;
            padding-top: 66.67%; /* 3:2 Aspect Ratio */
            overflow: hidden;
            border-bottom: 1px solid #eee;
        }

        .menu-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .menu-card:hover .menu-image {
            transform: scale(1.05);
        }

        .menu-details {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }

        .menu-name {
            font-size: 18px;
            font-weight: 600;
            color: #2C3E50;
            margin-bottom: 8px;
        }

        .menu-description {
            font-size: 14px;
            color: #666;
            margin-bottom: 12px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            height: 40px;
        }

        .menu-price {
            font-size: 20px;
            font-weight: 600;
            color: #619F2B;
            margin-bottom: 12px;
        }

        .menu-meta {
            display: flex;
            gap: 8px;
            margin-bottom: 15px;
            flex-wrap: wrap;
        }

        .category-tag, .type-tag {
            font-size: 12px;
            padding: 4px 8px;
            border-radius: 12px;
            background-color: #f0f0f0;
            color: #666;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 15px;
            background-color: #f8f8f8;
            padding: 8px;
            border-radius: 8px;
        }

        .quantity-btn {
            width: 32px;
            height: 32px;
            border: none;
            background-color: #619F2B;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            transition: background-color 0.3s ease;
        }

        .quantity-btn:hover {
            background-color: #4F8022;
        }

        .quantity-input {
            width: 50px;
            height: 32px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }

        .add-to-cart-btn {
            width: 100%;
            padding: 12px;
            background-color: #619F2B;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-top: auto;
        }

        .add-to-cart-btn:hover {
            background-color: #4F8022;
            transform: translateY(-2px);
        }

        .add-to-cart-btn:disabled {
            background-color: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        @media (max-width: 768px) {
            .menu-grid-container {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 15px;
                padding: 10px 0;
            }

            .menu-details {
                padding: 15px;
            }

            .menu-name {
                font-size: 16px;
            }

            .menu-price {
                font-size: 18px;
            }
        }

        /* Filter Styles */
        .filter-section {
            margin: 20px 0;
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .filter-group {
            margin-bottom: 20px;
        }

        .filter-group:last-child {
            margin-bottom: 0;
        }

        .filter-group h2 {
            font-size: 18px;
            color: #2C3E50;
            margin-bottom: 15px;
            font-weight: 600;
        }

        .filter-scroll {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            scrollbar-width: thin;
            scrollbar-color: #619F2B #f0f0f0;
            padding-bottom: 5px;
        }

        .filter-scroll::-webkit-scrollbar {
            height: 6px;
        }

        .filter-scroll::-webkit-scrollbar-track {
            background: #f0f0f0;
            border-radius: 10px;
        }

        .filter-scroll::-webkit-scrollbar-thumb {
            background: #619F2B;
            border-radius: 10px;
        }

        .filter-tabs {
            display: flex;
            gap: 10px;
            padding: 5px;
            min-width: min-content;
        }

        .filter-tab {
            padding: 8px 16px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            color: #666;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            white-space: nowrap;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .filter-tab:hover {
            border-color: #619F2B;
            color: #619F2B;
        }

        .filter-tab.active {
            background: #619F2B;
            color: white;
            border-color: #619F2B;
        }

        @media (max-width: 768px) {
            .filter-section {
                padding: 15px;
            }

            .filter-tab {
                padding: 6px 12px;
                font-size: 13px;
            }
        }

        /* Menu Grid Styles */
        .menu-grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 25px;
            padding: 10px 0;
        }

        .menu-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
            height: 100%;
            border: 1px solid #eee;
        }

        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }

        @media (max-width: 768px) {
            .menu-grid-container {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
                gap: 15px;
            }

            .filter-section {
                flex-direction: column;
                gap: 15px;
            }

            .filter-group {
                width: 100%;
            }

            .filter-scroll {
                overflow-x: auto;
                -webkit-overflow-scrolling: touch;
            }

            .filter-tabs {
                padding-bottom: 5px;
            }
        }

        /* Loading Overlay */
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

        /* Alert message styles */
        .alert-message {
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: none;
            animation: fadeIn 0.3s ease;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>

    <script type="text/javascript">
        // Filter functionality
        function initializeFilters() {
            // Get all filter tabs
            var categoryTabs = document.querySelectorAll('#<%=categoryTabs.ClientID%> .filter-tab');
            var typeTabs = document.querySelectorAll('#<%=typeTabs.ClientID%> .filter-tab');
            var menuCards = document.querySelectorAll('.menu-card');

            var activeCategory = '';
            var activeType = '';

            // Function to filter menu items
            function filterMenuItems() {
                menuCards.forEach(function(card) {
                    var cardCategory = card.getAttribute('data-category');
                    var cardType = card.getAttribute('data-type');
                    
                    var categoryMatch = !activeCategory || cardCategory === activeCategory;
                    var typeMatch = !activeType || cardType === activeType;

                    if (categoryMatch && typeMatch) {
                        card.style.display = '';
                    } else {
                        card.style.display = 'none';
                    }
                });
            }

            // Add click handlers to category tabs
            categoryTabs.forEach(function(tab) {
                tab.onclick = function() {
                    categoryTabs.forEach(function(t) { t.classList.remove('active'); });
                    tab.classList.add('active');
                    activeCategory = tab.getAttribute('data-category');
                    filterMenuItems();
                };
            });

            // Add click handlers to type tabs
            typeTabs.forEach(function(tab) {
                tab.onclick = function() {
                    typeTabs.forEach(function(t) { t.classList.remove('active'); });
                    tab.classList.add('active');
                    activeType = tab.getAttribute('data-type');
                    filterMenuItems();
                };
            });
        }

        // Initialize filters when DOM is loaded
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeFilters);
        } else {
            initializeFilters();
        }

        // Add to cart functionality
        function addToCart(button) {
            try {
                // Get the item ID and quantity
                var itemId = parseInt(button.getAttribute('data-item-id'));
                var quantityInput = button.parentElement.querySelector('.quantity-input');
                var quantity = parseInt(quantityInput.value);

                // Validate inputs
                if (isNaN(itemId) || itemId <= 0) {
                    showAlert('Invalid item', false);
                    return;
                }

                if (isNaN(quantity) || quantity < 1) {
                    showAlert('Please enter a valid quantity', false);
                    return;
                }

                // Disable the button and show loading
                button.disabled = true;
                document.querySelector('.loading-overlay').style.display = 'flex';

                // Call the server-side method
                PageMethods.AddToCart(itemId, quantity, function(result) {
                    // Hide loading overlay
                    document.querySelector('.loading-overlay').style.display = 'none';
                    button.disabled = false;

                    if (result.startsWith('Success')) {
                        // Show success message
                        showAlert(result, true);
                        // Reset quantity to 1
                        quantityInput.value = 1;
                    } else {
                        // Show error message
                        showAlert(result, false);
                    }
                }, function(error) {
                    // Hide loading overlay and enable button
                    document.querySelector('.loading-overlay').style.display = 'none';
                    button.disabled = false;
                    
                    // Show error message
                    showAlert('Error adding item to cart: ' + (error.get_message() || 'Unknown error'), false);
                });
            } catch (error) {
                showAlert('Error: ' + error.message, false);
                button.disabled = false;
                document.querySelector('.loading-overlay').style.display = 'none';
            }
        }

        // Alert message functionality
        function showAlert(message, isSuccess) {
            var alertDiv = document.getElementById('<%= alertMessage.ClientID %>');
            var alertLiteral = document.getElementById('<%= AlertLiteral.ClientID %>');

            if (alertDiv && alertLiteral) {
                // Show the alert
                alertDiv.style.display = 'block';
                alertDiv.className = 'alert-message ' + (isSuccess ? 'alert-success' : 'alert-danger');
                alertLiteral.textContent = message;

                // Hide the alert after 3 seconds
                setTimeout(function() {
                    alertDiv.style.display = 'none';
                }, 3000);
            } else {
                // Fallback to alert if elements not found
                alert(message);
            }
        }

        // Quantity control functionality
        function updateQuantity(button, change) {
            try {
                var input = button.parentElement.querySelector('.quantity-input');
                var currentValue = parseInt(input.value) || 1;
                var newValue = currentValue + change;
                
                // Ensure value is between 1 and 99
                newValue = Math.max(1, Math.min(99, newValue));
                input.value = newValue;
            } catch (error) {
                console.error('Error updating quantity:', error);
            }
        }
    </script>

    <style type="text/css">
        /* Toast Notification Styles */
        .toast {
            position: fixed;
            bottom: 20px;
            right: 20px;
            padding: 15px 25px;
            border-radius: 8px;
            color: white;
            font-size: 14px;
            opacity: 0;
            transform: translateY(100%);
            transition: all 0.3s ease;
            z-index: 1001;
        }

        .toast.show {
            opacity: 1;
            transform: translateY(0);
        }

        .toast-success {
            background-color: #619F2B;
        }

        .toast-error {
            background-color: #dc3545;
        }
    </style>
</asp:Content>
