<%@ Page Title="HAPAG - Transaction History" Language="VB" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" AutoEventWireup="false" CodeFile="CustomerTransactionHistory.aspx.vb" Inherits="Pages_Customer_CustomerTransactionHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <!-- Ensure jQuery is loaded -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        // Format dates as MM/DD/YYYY
        function formatDates() {
            // Add date validation
            var startDate = document.getElementById('<%= StartDatePicker.ClientID %>');
            var endDate = document.getElementById('<%= EndDatePicker.ClientID %>');
            
            if (startDate && endDate) {
                // Ensure proper date format on blur
                startDate.addEventListener('blur', function() {
                    validateDateFormat(this);
                });
                
                endDate.addEventListener('blur', function() {
                    validateDateFormat(this);
                });
            }
        }
        
        function validateDateFormat(input) {
            var value = input.value;
            // Check if it's a valid date format
            var dateRegex = /^(\d{1,2})\/(\d{1,2})\/(\d{4})$/;
            
            if (!dateRegex.test(value) && value !== '') {
                alert('Please enter the date in MM/DD/YYYY format');
                input.focus();
            }
        }
        
        // Register events when the page loads
        $(document).ready(function() {
            formatDates();
            
            // Also ensure the loading overlay is hidden initially
            $('.loading-overlay').hide();
        });
    </script>
    <style type="text/css">
        /* Transaction History Page Styles */
        .content-container {
            padding: 40px 20px;
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
            box-sizing: border-box;
            min-height: calc(100vh - 300px);
            animation: fadeIn 0.6s ease-out forwards;
        }
        
        .content-header {
            margin-bottom: 30px;
            text-align: center;
        }
        
        .content-header h1 {
            color: #2C3E50;
            font-size: 36px;
            margin-bottom: 15px;
            position: relative;
            display: inline-block;
        }
        
        .content-header h1::after {
            content: "";
            position: absolute;
            bottom: -10px;
            left: 0;
            width: 100%;
            height: 3px;
            background-color: #FFC107;
        }
        
        .content-header p {
            color: #666;
            font-size: 18px;
            max-width: 800px;
            margin: 0 auto;
        }
        
        /* Transaction Filter Section */
        .filter-section {
            background-color: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .filter-label {
            font-weight: 600;
            color: #333;
            margin-right: 10px;
        }
        
        .filter-controls {
            display: flex;
            gap: 15px;
            align-items: center;
            flex-wrap: wrap;
        }
        
        .date-range {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .date-input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-family: inherit;
        }
        
        .filter-btn {
            background-color: #FFC107;
            color: #333;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .filter-btn:hover {
            background-color: #FF9800;
            transform: translateY(-2px);
        }
        
        .reset-btn {
            background-color: #f1f1f1;
            color: #666;
        }
        
        .reset-btn:hover {
            background-color: #e0e0e0;
        }
        
        /* Transaction Cards */
        .transaction-container {
            display: flex;
            flex-direction: column;
            gap: 25px;
        }
        
        .transaction-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, 0.08);
            overflow: hidden;
            transition: transform 0.3s, box-shadow 0.3s;
            border-left: 4px solid #FFC107;
        }
        
        .transaction-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.12);
        }
        
        .transaction-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #eee;
        }
        
        .transaction-id {
            font-size: 18px;
            font-weight: 700;
            color: #2C3E50;
        }
        
        .transaction-date {
            color: #666;
            font-size: 14px;
        }
        
        .transaction-info {
            padding: 20px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        
        .transaction-details, .payment-details, .delivery-details {
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            height: 100%;
        }
        
        .details-title {
            font-weight: 700;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #FFC107;
            padding-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .details-title i {
            color: #FFC107;
        }
        
        .details-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .details-label {
            font-weight: 600;
            color: #555;
        }
        
        .details-value {
            color: #333;
            text-align: right;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        
        .order-items-section {
            padding: 0 20px 20px;
        }
        
        .order-items-title {
            font-weight: 700;
            margin-bottom: 15px;
            color: #333;
            border-bottom: 2px solid #FFC107;
            padding-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .order-items-title i {
            color: #FFC107;
        }
        
        .order-items-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 15px;
        }
        
        .order-item {
            display: flex;
            align-items: center;
            padding: 10px;
            background-color: #f9f9f9;
            border-radius: 8px;
            gap: 12px;
            transition: transform 0.2s;
        }
        
        .order-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .item-image {
            width: 50px;
            height: 50px;
            border-radius: 8px;
            object-fit: cover;
        }
        
        .item-details {
            flex: 1;
        }
        
        .item-name {
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
            font-size: 14px;
        }
        
        .item-meta {
            display: flex;
            justify-content: space-between;
            color: #666;
            font-size: 12px;
        }
        
        .total-section {
            padding: 15px 20px;
            background-color: #f8f9fa;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            border-top: 1px solid #eee;
        }
        
        .total-label {
            font-weight: 700;
            margin-right: 15px;
            color: #333;
        }
        
        .total-amount {
            font-size: 18px;
            font-weight: 700;
            color: #FFC107;
        }
        
        .empty-transactions {
            text-align: center;
            padding: 50px 20px;
            background-color: #f9f9f9;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .empty-transactions i {
            font-size: 48px;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-transactions h2 {
            color: #666;
            margin-bottom: 10px;
        }
        
        .empty-transactions p {
            color: #888;
            margin-bottom: 20px;
        }
        
        .browse-menu-btn {
            display: inline-block;
            background-color: #FFC107;
            color: #333;
            padding: 10px 20px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }
        
        .browse-menu-btn:hover {
            background-color: #FF9800;
            transform: translateY(-2px);
        }
        
        .reorder-btn {
            background-color: #FFC107;
            color: #333;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        
        .reorder-btn:hover {
            background-color: #FF9800;
            transform: translateY(-2px);
            color: #333;
            text-decoration: none;
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
            z-index: 1000;
        }
        
        .loading-spinner {
            width: 50px;
            height: 50px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #FFC107;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Responsive styles */
        @media (max-width: 992px) {
            .transaction-info {
                grid-template-columns: 1fr 1fr;
            }
        }
        
        @media (max-width: 768px) {
            .transaction-info {
                grid-template-columns: 1fr;
            }
            
            .transaction-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .filter-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }
            
            .filter-controls {
                width: 100%;
            }
            
            .date-range {
                flex-direction: column;
                align-items: flex-start;
                width: 100%;
            }
            
            .date-input {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="content-container">
        <!-- Content Header -->
        <div class="content-header">
            <h1><i class="fas fa-history"></i> Transaction History</h1>
            <p>View your past transactions and order details</p>
        </div>

        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <div class="filter-label">Filter Transactions:</div>
            <div class="filter-controls">
                <div class="date-range">
                    <asp:TextBox ID="StartDatePicker" runat="server" CssClass="date-input" placeholder="MM/DD/YYYY"></asp:TextBox>
                    <span>to</span>
                    <asp:TextBox ID="EndDatePicker" runat="server" CssClass="date-input" placeholder="MM/DD/YYYY"></asp:TextBox>
                </div>
                <asp:Button ID="FilterButton" runat="server" Text="Apply Filter" CssClass="filter-btn" OnClick="FilterButton_Click" />
                <asp:Button ID="ResetButton" runat="server" Text="Reset" CssClass="filter-btn reset-btn" OnClick="ResetButton_Click" />
            </div>
        </div>

        <!-- Empty Transactions Panel -->
        <asp:Panel ID="EmptyTransactionsPanel" runat="server" CssClass="empty-transactions" Visible="false">
            <i class="fas fa-receipt"></i>
            <h2>No transactions yet</h2>
            <p>You haven't completed any orders yet. Start ordering delicious food!</p>
            <a href="CustomerMenu.aspx" class="browse-menu-btn">Browse Menu</a>
        </asp:Panel>

        <!-- Transactions Panel -->
        <asp:Panel ID="TransactionsPanel" runat="server" CssClass="transaction-container">
            <asp:Repeater ID="TransactionsRepeater" runat="server" OnItemDataBound="TransactionsRepeater_ItemDataBound">
                <ItemTemplate>
                    <div class="transaction-card">
                        <div class="transaction-header">
                            <div class="transaction-id">
                                Order #<%# Eval("order_id") %>
                                <span class="status-badge status-completed"><%# Eval("status") %></span>
                            </div>
                            <div class="transaction-date"><%# If(Eval("order_date") IsNot DBNull.Value, Format(Eval("order_date"), "MMMM dd, yyyy hh:mm tt"), "N/A") %></div>
                        </div>
                        
                        <div class="transaction-info">
                            <div class="transaction-details">
                                <div class="details-title">
                                    <i class="fas fa-info-circle"></i> Order Details
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Order ID:</div>
                                    <div class="details-value"><%# Eval("order_id") %></div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Order Date:</div>
                                    <div class="details-value"><%# If(Eval("order_date") IsNot DBNull.Value, Format(Eval("order_date"), "MMM dd, yyyy"), "N/A") %></div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Status:</div>
                                    <div class="details-value"><%# Eval("status") %></div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Items:</div>
                                    <div class="details-value">
                                        <asp:Literal ID="TotalItemsLiteral" runat="server"></asp:Literal>
                                    </div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Subtotal:</div>
                                    <div class="details-value">PHP <%# If(Eval("subtotal") IsNot DBNull.Value, Format(Eval("subtotal"), "0.00"), "0.00") %></div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Shipping Fee:</div>
                                    <div class="details-value">PHP <%# If(Eval("shipping_fee") IsNot DBNull.Value, Format(Eval("shipping_fee"), "0.00"), "0.00") %></div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Tax:</div>
                                    <div class="details-value">PHP <%# If(Eval("tax") IsNot DBNull.Value, Format(Eval("tax"), "0.00"), "0.00") %></div>
                                </div>
                            </div>
                            
                            <div class="payment-details">
                                <div class="details-title">
                                    <i class="fas fa-credit-card"></i> Payment Details
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Payment Method:</div>
                                    <div class="details-value">Cash on Delivery</div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Transaction ID:</div>
                                    <div class="details-value">
                                        <asp:Literal ID="ReferenceNumberLiteral" runat="server"></asp:Literal>
                                    </div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Sender:</div>
                                    <div class="details-value">
                                        <asp:Literal ID="SenderNameLiteral" runat="server"></asp:Literal>
                                    </div>
                                </div>
                                <div class="details-group total">
                                    <div class="details-label">Total Amount:</div>
                                    <div class="details-value">PHP <%# If(Eval("total_amount") IsNot DBNull.Value, Format(Eval("total_amount"), "0.00"), "0.00") %></div>
                                </div>
                            </div>
                            
                            <div class="delivery-details">
                                <div class="details-title">
                                    <i class="fas fa-truck"></i> Delivery Details
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Service:</div>
                                    <div class="details-value">Standard Delivery</div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Driver:</div>
                                    <div class="details-value">Delivery Partner</div>
                                </div>
                                <div class="details-row">
                                    <div class="details-label">Status:</div>
                                    <div class="details-value"><%# Eval("status") %></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="order-items-section">
                            <div class="order-items-title">
                                <i class="fas fa-utensils"></i> Order Items
                            </div>
                            <div class="order-items-list">
                                <asp:Repeater ID="OrderItemsRepeater" runat="server">
                                    <ItemTemplate>
                                        <div class="order-item">
                                            <img src='<%# GetImageUrl(If(Eval("image") IsNot DBNull.Value, Eval("image").ToString(), "")) %>' alt='<%# If(Eval("name") IsNot DBNull.Value, Eval("name"), "Menu Item") %>' class="item-image" onerror="this.src='../../Assets/Images/default-food.jpg'" />
                                            <div class="item-details">
                                                <div class="item-name"><%# If(Eval("name") IsNot DBNull.Value, Eval("name"), "Menu Item") %></div>
                                                <div class="item-meta">
                                                    <span>Qty: <%# If(Eval("quantity") IsNot DBNull.Value, Eval("quantity"), "1") %></span>
                                                    <span>PHP <%# If(Eval("price") IsNot DBNull.Value, Format(Eval("price"), "0.00"), "0.00") %></span>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </div>
                        
                        <div class="transaction-footer">
                            <div class="total-section">
                                <!-- Show reorder button only for completed orders -->
                                <asp:LinkButton ID="ReorderButton" runat="server" CssClass="reorder-btn" CommandName="Reorder" CommandArgument='<%# Eval("order_id") %>' Visible='<%# Eval("status").ToString().ToLower() = "completed" %>'>
                                    <i class="fas fa-redo"></i> Reorder Items
                                </asp:LinkButton>
                                
                                <!-- Show confirm button only for pending/preparing orders -->
                                <asp:LinkButton ID="ConfirmButton" runat="server" CssClass="reorder-btn" CommandName="Confirm" CommandArgument='<%# Eval("order_id") %>' Visible='<%# Eval("status").ToString().ToLower() = "pending" OrElse Eval("status").ToString().ToLower() = "preparing" %>'>
                                    <i class="fas fa-check"></i> Confirm Order
                                </asp:LinkButton>
                                
                                <div class="total-label">Total Amount:</div>
                                <div class="total-amount">PHP <%# If(Eval("total_amount") IsNot DBNull.Value, Format(Eval("total_amount"), "0.00"), "0.00") %></div>
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
</asp:Content>
