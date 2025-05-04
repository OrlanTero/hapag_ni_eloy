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
            <!-- Search and Price Filter Row -->
            <div class="search-price-row">
                <div class="search-container">
                    <input type="text" id="searchInput" class="search-input" placeholder="Search menu items..." />
                    <button type="button" id="searchButton" class="search-button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
                
                <div class="price-filter-container">
                    <span class="price-label">Price Range:</span>
                    <div class="price-slider-container">
                        <input type="range" id="minPriceSlider" min="1" max="5000" value="1" step="50" class="price-slider" />
                        <input type="range" id="maxPriceSlider" min="1" max="5000" value="5000" step="50" class="price-slider" />
                        <div class="price-slider-track"></div>
                    </div>
                    <div class="price-inputs">
                        <div class="price-input-group">
                            <span>₱</span>
                            <input type="number" id="minPrice" min="1" max="5000" value="1" class="price-input" />
                        </div>
                        <span class="price-separator">-</span>
                        <div class="price-input-group">
                            <span>₱</span>
                            <input type="number" id="maxPrice" min="1" max="5000" value="5000" class="price-input" />
                        </div>
                        <button type="button" id="applyPriceFilter" class="apply-price-btn">Apply</button>
                    </div>
                </div>
            </div>
            
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

        <!-- Results Summary -->
        <div class="results-summary">
            Showing <span id="visibleItemCount">0</span> of <span id="totalItemCount">0</span> items
        </div>

        <!-- Menu Grid -->
        <div class="menu-grid-container">
            <asp:Repeater ID="MenuRepeater" runat="server">
                <ItemTemplate>
                    <div class="menu-card" 
                         data-category='<%# Eval("category_id") %>' 
                         data-type='<%# Eval("type_id") %>'
                         data-price='<%# Eval("price") %>'
                         data-name='<%# Eval("name").ToString().ToLower() %>'
                         data-description='<%# Eval("description").ToString().ToLower() %>'>
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

        <!-- No Results Message -->
        <div id="noResultsMessage" class="no-results-message" style="display: none;">
            <i class="fas fa-search"></i>
            <h3>No menu items found</h3>
            <p>Try adjusting your filters or search term</p>
            <button type="button" id="resetFiltersBtn" class="reset-filters-btn">Reset All Filters</button>
        </div>

        <!-- Pagination Controls -->
        <div class="pagination-container">
            <div class="pagination-info">
                Page <span id="currentPage">1</span> of <span id="totalPages">1</span>
            </div>
            <div class="pagination-controls">
                <button type="button" id="prevPageBtn" class="pagination-btn" disabled>
                    <i class="fas fa-chevron-left"></i> Previous
                </button>
                <div id="pageNumbers" class="page-numbers"></div>
                <button type="button" id="nextPageBtn" class="pagination-btn">
                    Next <i class="fas fa-chevron-right"></i>
                </button>
            </div>
            <div class="items-per-page">
                <label for="itemsPerPage">Items per page:</label>
                <select id="itemsPerPage" class="items-per-page-select">
                    <option value="12">12</option>
                    <option value="24">24</option>
                    <option value="36">36</option>
                    <option value="48">48</option>
                </select>
            </div>
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

        /* Search and Price Filter Styles */
        .search-price-row {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 25px;
        }

        .search-container {
            flex: 1;
            min-width: 250px;
            display: flex;
            position: relative;
        }

        .search-input {
            flex: 1;
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        .search-input:focus {
            border-color: #619F2B;
            box-shadow: 0 0 0 2px rgba(97, 159, 43, 0.2);
            outline: none;
        }

        .search-button {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #666;
            font-size: 18px;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .search-button:hover {
            color: #619F2B;
        }

        .price-filter-container {
            flex: 1;
            min-width: 300px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .price-label {
            font-weight: 600;
            color: #2C3E50;
            font-size: 16px;
        }

        .price-slider-container {
            position: relative;
            height: 30px;
            width: 100%;
        }

        .price-slider {
            position: absolute;
            pointer-events: none;
            -webkit-appearance: none;
            appearance: none;
            width: 100%;
            height: 5px;
            background: transparent;
            z-index: 3;
        }

        .price-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            pointer-events: auto;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: #619F2B;
            cursor: pointer;
            border: 2px solid white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .price-slider::-moz-range-thumb {
            pointer-events: auto;
            width: 18px;
            height: 18px;
            border-radius: 50%;
            background: #619F2B;
            cursor: pointer;
            border: 2px solid white;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }

        .price-slider-track {
            position: absolute;
            top: 15px;
            transform: translateY(-50%);
            height: 5px;
            background: #e0e0e0;
            width: 100%;
            z-index: 1;
            border-radius: 3px;
        }

        .price-inputs {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .price-input-group {
            display: flex;
            align-items: center;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 0 10px;
            overflow: hidden;
        }

        .price-input {
            width: 70px;
            padding: 8px 5px;
            border: none;
            font-size: 14px;
            background: transparent;
        }

        .price-input:focus {
            outline: none;
        }

        .price-separator {
            font-weight: 600;
            color: #666;
        }

        .apply-price-btn {
            padding: 8px 15px;
            background: #619F2B;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .apply-price-btn:hover {
            background: #4F8022;
        }

        /* Results Summary */
        .results-summary {
            margin: 15px 0;
            color: #666;
            font-size: 14px;
        }

        /* No Results Message */
        .no-results-message {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            margin: 30px 0;
        }

        .no-results-message i {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 15px;
        }

        .no-results-message h3 {
            font-size: 24px;
            color: #2C3E50;
            margin-bottom: 10px;
        }

        .no-results-message p {
            color: #666;
            margin-bottom: 20px;
        }

        .reset-filters-btn {
            padding: 10px 20px;
            background: #619F2B;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .reset-filters-btn:hover {
            background: #4F8022;
        }

        /* Pagination Styles */
        .pagination-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-top: 30px;
            padding: 15px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        .pagination-info {
            color: #666;
            font-size: 14px;
        }

        .pagination-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .pagination-btn {
            padding: 8px 15px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            color: #2C3E50;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .pagination-btn:hover:not(:disabled) {
            border-color: #619F2B;
            color: #619F2B;
        }

        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .page-numbers {
            display: flex;
            gap: 5px;
        }

        .page-number {
            width: 35px;
            height: 35px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .page-number:hover {
            background: #f0f0f0;
        }

        .page-number.active {
            background: #619F2B;
            color: white;
        }

        .items-per-page {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .items-per-page-select {
            padding: 6px 10px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .items-per-page-select:focus {
            border-color: #619F2B;
            outline: none;
        }

        @media (max-width: 768px) {
            .search-price-row {
                flex-direction: column;
                gap: 15px;
            }

            .pagination-container {
                flex-direction: column;
                align-items: flex-start;
            }

            .page-numbers .page-number:nth-child(n+4):nth-child(-n+7) {
                display: none;
            }
        }
    </style>

    <script type="text/javascript">
        // Filter functionality
        function initializeFilters() {
            // Get all filter tabs
            var categoryTabs = document.querySelectorAll('#<%=categoryTabs.ClientID%> .filter-tab');
            var typeTabs = document.querySelectorAll('#<%=typeTabs.ClientID%> .filter-tab');
            var menuCards = document.querySelectorAll('.menu-card');
            
            // Search and price filter elements
            var searchInput = document.getElementById('searchInput');
            var searchButton = document.getElementById('searchButton');
            var minPriceSlider = document.getElementById('minPriceSlider');
            var maxPriceSlider = document.getElementById('maxPriceSlider');
            var minPriceInput = document.getElementById('minPrice');
            var maxPriceInput = document.getElementById('maxPrice');
            var applyPriceBtn = document.getElementById('applyPriceFilter');
            var resetFiltersBtn = document.getElementById('resetFiltersBtn');
            
            // Pagination elements
            var itemsPerPageSelect = document.getElementById('itemsPerPage');
            var currentPageSpan = document.getElementById('currentPage');
            var totalPagesSpan = document.getElementById('totalPages');
            var prevPageBtn = document.getElementById('prevPageBtn');
            var nextPageBtn = document.getElementById('nextPageBtn');
            var pageNumbersDiv = document.getElementById('pageNumbers');
            
            // Count elements
            var visibleItemCountSpan = document.getElementById('visibleItemCount');
            var totalItemCountSpan = document.getElementById('totalItemCount');
            var noResultsMessage = document.getElementById('noResultsMessage');
            
            // Filter state
            var activeCategory = '';
            var activeType = '';
            var minPrice = 1;
            var maxPrice = 5000;
            var searchTerm = '';
            
            // Pagination state
            var currentPage = 1;
            var itemsPerPage = 12;
            
            // Initialize counts
            totalItemCountSpan.textContent = menuCards.length;
            
            // Function to filter menu items
            function filterMenuItems() {
                var visibleCount = 0;
                
                menuCards.forEach(function(card) {
                    var cardCategory = card.getAttribute('data-category');
                    var cardType = card.getAttribute('data-type');
                    var cardPrice = parseFloat(card.getAttribute('data-price'));
                    var cardName = card.getAttribute('data-name');
                    var cardDescription = card.getAttribute('data-description');
                    
                    var categoryMatch = !activeCategory || cardCategory === activeCategory;
                    var typeMatch = !activeType || cardType === activeType;
                    var priceMatch = cardPrice >= minPrice && cardPrice <= maxPrice;
                    var searchMatch = !searchTerm || 
                                     cardName.includes(searchTerm) || 
                                     cardDescription.includes(searchTerm);

                    if (categoryMatch && typeMatch && priceMatch && searchMatch) {
                        card.dataset.filtered = 'true';
                        visibleCount++;
                    } else {
                        card.dataset.filtered = 'false';
                    }
                    
                    // Initially hide all cards
                    card.style.display = 'none';
                });
                
                visibleItemCountSpan.textContent = visibleCount;
                
                // Show no results message if needed
                if (visibleCount === 0) {
                    noResultsMessage.style.display = 'block';
                } else {
                    noResultsMessage.style.display = 'none';
                }
                
                // Update pagination
                updatePagination(visibleCount);
                
                // Display current page
                displayCurrentPage();
            }
            
            // Function to update pagination controls
            function updatePagination(visibleCount) {
                // Calculate total pages
                var totalPages = Math.max(1, Math.ceil(visibleCount / itemsPerPage));
                
                // Update page display
                totalPagesSpan.textContent = totalPages;
                
                // Adjust current page if needed
                if (currentPage > totalPages) {
                    currentPage = totalPages;
                }
                currentPageSpan.textContent = currentPage;
                
                // Update buttons state
                prevPageBtn.disabled = currentPage <= 1;
                nextPageBtn.disabled = currentPage >= totalPages;
                
                // Generate page numbers
                pageNumbersDiv.innerHTML = '';
                var startPage = Math.max(1, currentPage - 2);
                var endPage = Math.min(totalPages, startPage + 4);
                
                // Always show first page
                if (startPage > 1) {
                    addPageNumber(1);
                    if (startPage > 2) {
                        var ellipsis = document.createElement('span');
                        ellipsis.className = 'page-ellipsis';
                        ellipsis.textContent = '...';
                        pageNumbersDiv.appendChild(ellipsis);
                    }
                }
                
                // Add page numbers
                for (var i = startPage; i <= endPage; i++) {
                    addPageNumber(i);
                }
                
                // Always show last page
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
                        var ellipsis = document.createElement('span');
                        ellipsis.className = 'page-ellipsis';
                        ellipsis.textContent = '...';
                        pageNumbersDiv.appendChild(ellipsis);
                    }
                    addPageNumber(totalPages);
                }
            }
            
            // Helper to add page number
            function addPageNumber(pageNum) {
                var pageNumber = document.createElement('div');
                pageNumber.className = 'page-number' + (pageNum === currentPage ? ' active' : '');
                pageNumber.textContent = pageNum;
                pageNumber.onclick = function() {
                    currentPage = pageNum;
                    currentPageSpan.textContent = currentPage;
                    displayCurrentPage();
                    
                    // Update buttons state
                    prevPageBtn.disabled = currentPage <= 1;
                    nextPageBtn.disabled = currentPage >= parseInt(totalPagesSpan.textContent);
                    
                    // Update active page number
                    document.querySelectorAll('.page-number').forEach(function(pn) {
                        pn.classList.remove('active');
                    });
                    pageNumber.classList.add('active');
                };
                pageNumbersDiv.appendChild(pageNumber);
            }
            
            // Display current page of results
            function displayCurrentPage() {
                var visibleCards = Array.from(menuCards).filter(function(card) {
                    return card.dataset.filtered === 'true';
                });
                
                var startIndex = (currentPage - 1) * itemsPerPage;
                var endIndex = startIndex + itemsPerPage;
                
                visibleCards.forEach(function(card, index) {
                    if (index >= startIndex && index < endIndex) {
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
                    currentPage = 1;
                    filterMenuItems();
                };
            });

            // Add click handlers to type tabs
            typeTabs.forEach(function(tab) {
                tab.onclick = function() {
                    typeTabs.forEach(function(t) { t.classList.remove('active'); });
                    tab.classList.add('active');
                    activeType = tab.getAttribute('data-type');
                    currentPage = 1;
                    filterMenuItems();
                };
            });
            
            // Search functionality
            searchButton.onclick = function() {
                searchTerm = searchInput.value.trim().toLowerCase();
                currentPage = 1;
                filterMenuItems();
            };
            
            searchInput.addEventListener('keyup', function(event) {
                if (event.key === 'Enter') {
                    searchTerm = searchInput.value.trim().toLowerCase();
                    currentPage = 1;
                    filterMenuItems();
                }
            });
            
            // Price slider functionality
            function updatePriceSliderTrack() {
                var sliderTrack = document.querySelector('.price-slider-track');
                var minPercent = ((minPrice - 1) / 4999) * 100;
                var maxPercent = ((maxPrice - 1) / 4999) * 100;
                
                sliderTrack.style.background = 'linear-gradient(to right, #e0e0e0 ' + minPercent + '%, #619F2B ' + minPercent + '%, #619F2B ' + maxPercent + '%, #e0e0e0 ' + maxPercent + '%)';
            }
            
            minPriceSlider.oninput = function() {
                minPrice = parseInt(this.value);
                if (minPrice > maxPrice) {
                    maxPrice = minPrice;
                    maxPriceSlider.value = minPrice;
                    maxPriceInput.value = minPrice;
                }
                minPriceInput.value = minPrice;
                updatePriceSliderTrack();
            };
            
            maxPriceSlider.oninput = function() {
                maxPrice = parseInt(this.value);
                if (maxPrice < minPrice) {
                    minPrice = maxPrice;
                    minPriceSlider.value = maxPrice;
                    minPriceInput.value = maxPrice;
                }
                maxPriceInput.value = maxPrice;
                updatePriceSliderTrack();
            };
            
            minPriceInput.onchange = function() {
                minPrice = parseInt(this.value) || 1;
                if (minPrice < 1) minPrice = 1;
                if (minPrice > 5000) minPrice = 5000;
                if (minPrice > maxPrice) {
                    maxPrice = minPrice;
                    maxPriceSlider.value = minPrice;
                    maxPriceInput.value = minPrice;
                }
                minPriceSlider.value = minPrice;
                this.value = minPrice;
                updatePriceSliderTrack();
            };
            
            maxPriceInput.onchange = function() {
                maxPrice = parseInt(this.value) || 5000;
                if (maxPrice < 1) maxPrice = 1;
                if (maxPrice > 5000) maxPrice = 5000;
                if (maxPrice < minPrice) {
                    minPrice = maxPrice;
                    minPriceSlider.value = maxPrice;
                    minPriceInput.value = maxPrice;
                }
                maxPriceSlider.value = maxPrice;
                this.value = maxPrice;
                updatePriceSliderTrack();
            };
            
            applyPriceBtn.onclick = function() {
                currentPage = 1;
                filterMenuItems();
            };
            
            // Reset filters
            resetFiltersBtn.onclick = function() {
                // Reset category
                categoryTabs.forEach(function(t) { t.classList.remove('active'); });
                categoryTabs[0].classList.add('active');
                activeCategory = '';
                
                // Reset type
                typeTabs.forEach(function(t) { t.classList.remove('active'); });
                typeTabs[0].classList.add('active');
                activeType = '';
                
                // Reset search
                searchInput.value = '';
                searchTerm = '';
                
                // Reset price
                minPrice = 1;
                maxPrice = 5000;
                minPriceSlider.value = 1;
                maxPriceSlider.value = 5000;
                minPriceInput.value = 1;
                maxPriceInput.value = 5000;
                updatePriceSliderTrack();
                
                // Reset pagination
                currentPage = 1;
                
                // Apply filters
                filterMenuItems();
            };
            
            // Pagination controls
            prevPageBtn.onclick = function() {
                if (currentPage > 1) {
                    currentPage--;
                    currentPageSpan.textContent = currentPage;
                    displayCurrentPage();
                    
                    // Update buttons state
                    prevPageBtn.disabled = currentPage <= 1;
                    nextPageBtn.disabled = false;
                    
                    // Update page numbers
                    updatePagination(parseInt(visibleItemCountSpan.textContent));
                }
            };
            
            nextPageBtn.onclick = function() {
                var totalPages = parseInt(totalPagesSpan.textContent);
                if (currentPage < totalPages) {
                    currentPage++;
                    currentPageSpan.textContent = currentPage;
                    displayCurrentPage();
                    
                    // Update buttons state
                    prevPageBtn.disabled = false;
                    nextPageBtn.disabled = currentPage >= totalPages;
                    
                    // Update page numbers
                    updatePagination(parseInt(visibleItemCountSpan.textContent));
                }
            };
            
            itemsPerPageSelect.onchange = function() {
                itemsPerPage = parseInt(this.value);
                currentPage = 1;
                filterMenuItems();
            };
            
            // Initialize price slider track
            updatePriceSliderTrack();
            
            // Initial filtering
            filterMenuItems();
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
