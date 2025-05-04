<%@ Page Language="VB" AutoEventWireup="true" CodeFile="AdminOrders.aspx.vb" Inherits="Pages_Admin_AdminOrders" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Manage Orders</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <style type="text/css">
        /* Force GCash verification buttons to always be visible */
        .gcash-verification-buttons {
            display: flex !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        .gcash-verification-buttons input[type="submit"],
        .gcash-verification-buttons button,
        .gcash-panel .btn-verify,
        .gcash-panel .btn-cancel {
            display: inline-block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        /* GCash payment section should always be visible */
        .gcash-panel {
            display: block !important;
            visibility: visible !important;
            opacity: 1 !important;
        }
        
        .order-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            padding: 15px;
        }
        
        .order-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .order-id {
            font-weight: bold;
            font-size: 18px;
            color: #333;
        }
        
        .order-date {
            color: #666;
            font-size: 14px;
            margin-bottom: 5px;
        }
        
        .order-status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 14px;
            font-weight: bold;
        }
        
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        
        .status-processing {
            background-color: #cce5ff;
            color: #004085;
        }
        
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
        
        /* New styles for expanded order information */
        .customer-info, .order-details, .delivery-info {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        
        .customer-info h4, .order-details h4, .delivery-info h4 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 8px;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 8px;
        }
        
        .info-label {
            flex: 0 0 120px;
            font-weight: 500;
            color: #555;
        }
        
        .info-value {
            flex: 1;
        }
        
        .order-items {
            margin-bottom: 15px;
            border: 1px solid #eee;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .order-item {
            display: flex;
            padding: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .order-item:last-child {
            border-bottom: none;
        }
        
        .order-item.header {
            background-color: #f2f2f2;
            font-weight: 600;
        }
        
        .item-name {
            flex: 2;
            padding-right: 10px;
        }
        
        .item-quantity {
            flex: 0.5;
            text-align: center;
        }
        
        .item-price, .item-subtotal {
            flex: 1;
            text-align: right;
        }
        
        .order-summary {
            margin-top: 15px;
            padding: 15px;
            background-color: #f5f5f5;
            border-radius: 4px;
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 5px;
        }
        
        .summary-row.total {
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #ddd;
            font-weight: bold;
            font-size: 16px;
        }
        
        .summary-value.discount {
            color: #dc3545;
        }
        
        .order-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 15px;
        }
        
        .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-process {
            background-color: #007bff;
            color: white;
        }
        
        .btn-complete {
            background-color: #28a745;
            color: white;
        }
        
        .btn-cancel {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-delivery {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-process:hover, .btn-complete:hover, .btn-cancel:hover, .btn-delivery:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        
        .search-filter-container {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .search-box {
            flex: 1;
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .status-dropdown {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: white;
        }
        
        /* New styles for View Order functionality */
        .basic-order-info {
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
            margin-bottom: 15px;
        }
        
        .view-details-btn {
            background-color: #17a2b8;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .view-details-btn:hover {
            background-color: #138496;
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .order-details-container {
            border-top: 1px dashed #ddd;
            padding-top: 15px;
            margin-top: 15px;
        }
        
        .text-center {
            text-align: center;
        }
        
        .mt-3 {
            margin-top: 15px;
        }
        
        .btn-accept {
            background-color: #28a745;
            color: white;
        }
        
        .btn-accept:hover {
            background-color: #218838;
        }
        
        .btn-status {
            background-color: #17a2b8;
            color: white;
        }
        
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.5);
        }
        
        .modal-content {
            background-color: #fff;
            margin: 10% auto;
            padding: 20px;
            border-radius: 8px;
            width: 50%;
            max-width: 500px;
            position: relative;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .modal-header h2 {
            margin: 0;
            font-size: 18px;
        }
        
        .close-btn {
            font-size: 24px;
            background: none;
            border: none;
            cursor: pointer;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: 500;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .modal-footer {
            margin-top: 20px;
            text-align: right;
        }
        
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
            margin-left: 10px;
        }
        
        .delivery-info {
            margin-top: 25px;
            padding-top: 15px;
            border-top: 1px solid #f2f2f2;
        }
        
        /* Payment Information Styles */
        .payment-info {
            margin-top: 25px;
            padding-top: 15px;
            border-top: 1px solid #f2f2f2;
        }
        
        .payment-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            margin-bottom: 10px;
        }
        
        /* Style for buttons in the payment info section */
        .payment-actions .action-btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            margin: 5px 0;
            min-width: 120px;
        }
        
        /* Ensure GCash payment buttons are displayed properly */
        .gcash-panel .payment-actions .action-btn {
            display: inline-block !important;
            visibility: visible !important;
        }
        
        /* Make sure the buttons are evenly spaced when in column mode */
        @media (max-width: 768px) {
            .payment-actions {
                flex-direction: column;
            }
            
            .payment-actions .action-btn {
                width: 100%;
                margin: 5px 0;
            }
        }
        
        .btn-verify {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-verify:hover {
            background-color: #45a049;
        }
        
        .status-pending {
            color: #e67e22;
            font-weight: bold;
        }
        
        .status-success {
            color: #4CAF50;
            font-weight: bold;
        }
        
        /* Payment Verification Modal Styles */
        .payment-verification-container {
            margin-bottom: 20px;
        }
        
        .info-section {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .info-section h4 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            font-size: 16px;
        }
        
        .verification-message {
            background-color: #f8f8f8;
            padding: 15px;
            border-radius: 4px;
            border-left: 4px solid #2196F3;
        }
        
        .verification-message p {
            margin: 0;
            color: #555;
            font-size: 14px;
        }
        
        .btn-success {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-success:hover {
            background-color: #45a049;
        }
        
        .btn-danger {
            background-color: #f44336;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #d32f2f;
        }
        
        .modal-content {
            max-width: 600px;
        }
        
        .word-wrap {
            word-wrap: break-word;
            overflow-wrap: break-word;
        }
        
        .payment-info {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        
        .payment-info h4 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #333;
            font-size: 16px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 8px;
        }
        
        .payment-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
            margin-bottom: 10px;
        }
        
        .btn-verify {
            background-color: #4CAF50;
            color: white;
        }
        
        .btn-verify:hover {
            background-color: #45a049;
        }
        
        .status-pending {
            color: #e67e22;
            font-weight: bold;
        }
        
        .status-success {
            color: #4CAF50;
            font-weight: bold;
        }
        
        .payment-actions.hide-buttons {
            display: none !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-container">
        <asp:HiddenField ID="SelectedOrderId" runat="server" />
        <asp:Literal ID="YearLiteral" runat="server" Visible="false"></asp:Literal>
        
                    <div class="content-header">
                        <h1>Manage Orders</h1>
                        <p>View and manage customer orders</p>
                    </div>
                    
                    <div class="alert-message" id="alertMessage" runat="server" visible="false">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
        <div class="search-filter-container">
            <asp:TextBox ID="SearchBox" runat="server" CssClass="search-box" placeholder="Search orders..."></asp:TextBox>
            <asp:Button ID="SearchButton" runat="server" Text="Search" CssClass="btn btn-primary" OnClick="SearchButton_Click" />
            <asp:DropDownList ID="StatusDropDown" runat="server" CssClass="status-dropdown" AutoPostBack="true" OnSelectedIndexChanged="StatusDropDown_SelectedIndexChanged">
                <asp:ListItem Text="All Status" Value=""></asp:ListItem>
                <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                <asp:ListItem Text="Processing" Value="Processing"></asp:ListItem>
                <asp:ListItem Text="Delivering" Value="Delivering"></asp:ListItem>
                <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
            </asp:DropDownList>
                    </div>
                    
                    <div class="orders-container">
            <asp:ListView ID="OrdersListView" runat="server" OnItemCommand="OrdersListView_ItemCommand">
                <LayoutTemplate>
                    <div class="orders-list">
                        <asp:PlaceHolder ID="itemPlaceholder" runat="server"></asp:PlaceHolder>
                                </div>
                </LayoutTemplate>
                            <ItemTemplate>
                                <div class="order-card">
                                    <div class="order-header">
                                        <div>
                                            <div class="order-id">Order #<%# Eval("order_id") %></div>
                                <div class="order-date"><%# Format(Eval("order_date"), "MMMM dd, yyyy hh:mm tt") %></div>
                                            </div>
                            <div class="order-status status-<%# Eval("status").ToString().ToLower() %>">
                                                <%# Eval("status") %>
                            </div>
                        </div>
                        
                        <div class="basic-order-info">
                            <div class="info-row">
                                <div class="info-label">Customer:</div>
                                <div class="info-value"><%# Eval("customer_name") %></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Total Amount:</div>
                                <div class="info-value">PHP <%# Format(Eval("total_amount"), "0.00") %></div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Payment Method:</div>
                                <div class="info-value"><%# Eval("payment_method") %></div>
                            </div>
                            <div class="text-center mt-3">
                                <asp:LinkButton runat="server" ID="ViewDetailsButton" CssClass="btn btn-info view-details-btn"
                                    CommandName="ViewDetails" CommandArgument='<%# Eval("order_id") %>'>
                                    <i class="fas fa-eye"></i> View Order Details
                                </asp:LinkButton>
                            </div>
                        </div>
                        
                        <div id="order-details-<%# Eval("order_id") %>" class="order-details-container details-for-<%# Eval("order_id") %>" style="display:none;">
                            <div class="customer-info">
                                <h4>Customer Information</h4>
                                <div class="info-row">
                                    <div class="info-label">Name:</div>
                                    <div class="info-value"><%# Eval("customer_name") %></div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Contact:</div>
                                    <div class="info-value"><%# Eval("customer_contact") %></div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Address:</div>
                                    <div class="info-value"><%# Eval("customer_address") %></div>
                            </div>
                        </div>
                        
                        <div class="order-details">
                                <h4>Order Details</h4>
                                <div class="info-row">
                                    <div class="info-label">Transaction ID:</div>
                                    <div class="info-value">#<%# Eval("transaction_id") %></div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Payment Method:</div>
                                    <div class="info-value"><%# Eval("payment_method") %></div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Delivery Type:</div>
                                    <div class="info-value"><%# Eval("delivery_type") %></div>
                                </div>
                                <div class="info-row">
                                    <div class="info-label">Discounts:</div>
                                    <div class="info-value"><%# Eval("discount_info") %></div>
                                </div>
                                
                                <h4>Order Items</h4>
                                    <div class="order-items">
                                    <div class="order-item header">
                                        <span class="item-name">Item</span>
                                        <span class="item-quantity">Quantity</span>
                                        <span class="item-price">Price</span>
                                        <span class="item-subtotal">Subtotal</span>
                                    </div>
                                <asp:Repeater ID="OrderItemsRepeater" runat="server" DataSource='<%# GetOrderItems(Eval("order_id")) %>'>
                                            <ItemTemplate>
                                                <div class="order-item">
                                                <span class="item-name"><%# Eval("name") %></span>
                                                <span class="item-quantity"><%# Eval("quantity") %></span>
                                            <span class="item-price">PHP <%# Format(Eval("price"), "0.00") %></span>
                                                <span class="item-subtotal">PHP <%# Format(CDec(Eval("price")) * CDec(Eval("quantity")), "0.00") %></span>
                            </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                        </div>
                        
                                <div class="order-summary">
                                    <div class="summary-row">
                                        <div class="summary-label">Subtotal:</div>
                                        <div class="summary-value">PHP <%# If(String.IsNullOrEmpty(Eval("subtotal").ToString()), Format(Eval("total_amount"), "0.00"), Format(CDec(Eval("subtotal")), "0.00")) %></div>
                                    </div>
                                    <%# If(Eval("discount_info").ToString() <> "None", "<div class=""summary-row""><div class=""summary-label"">Discounts:</div><div class=""summary-value discount"">" + Eval("discount_info").ToString() + "</div></div>", "") %>
                                    <div class="summary-row total">
                                        <div class="summary-label">Total:</div>
                                        <div class="summary-value">PHP <%# Format(Eval("total_amount"), "0.00") %></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="payment-info">
                                <h4>Payment Information</h4>
                                <div class="info-row">
                                    <div class="info-label">Payment Method:</div>
                                    <div class="info-value"><%# Eval("payment_method") %></div>
                                </div>
                                
                                <!-- GCash Payment Information -->
                                <asp:Panel ID="GCashInfoPanel" runat="server" CssClass="gcash-panel" Visible='<%# Eval("payment_method").ToString().ToLower().Contains("gcash") %>'>
                                    <div class="info-row">
                                        <div class="info-label">Reference Number:</div>
                                        <div class="info-value word-wrap">
                                            <%# If(Eval("reference_number") IsNot Nothing AndAlso Eval("reference_number").ToString() <> "", 
                                                 Eval("reference_number").ToString(), "Not provided") %>
                                        </div>
                                    </div>
                                    
                                    <div class="info-row">
                                        <div class="info-label">Sender Name:</div>
                                        <div class="info-value word-wrap">
                                            <%# If(Eval("sender_name") IsNot Nothing AndAlso Eval("sender_name").ToString() <> "", 
                                                 Eval("sender_name").ToString(), "Not provided") %>
                                        </div>
                                    </div>
                                    
                                    <div class="info-row">
                                        <div class="info-label">Sender Number:</div>
                                        <div class="info-value word-wrap">
                                            <%# If(Eval("sender_number") IsNot Nothing AndAlso Eval("sender_number").ToString() <> "", 
                                                 Eval("sender_number").ToString(), "Not provided") %>
                                        </div>
                                    </div>

                                       
                                <div class="info-row">
                                    <div class="info-label">Payment Status:</div>
                                    <div class="info-value <%# If(Eval("transaction_status").ToString() = "Verified", "status-success", If(Eval("transaction_status").ToString() = "Pending" Or Eval("transaction_status").ToString() = "", "status-pending", "")) %>">
                                        <%# If(Eval("transaction_status").ToString() = "Verified", "Verified", If(Eval("transaction_status").ToString() = "Rejected", "Rejected", If(Eval("transaction_status").ToString() = "Pending" Or Eval("transaction_status").ToString() = "", "Pending Verification", Eval("transaction_status").ToString()))) %>
                                        <%# If(Eval("verification_date").ToString() <> "", "<br/><small>(" & Eval("verification_date").ToString() & ")</small>", "") %>
                                    </div>
                                </div>
                                    
                                    <!-- Direct Verification Buttons for GCash - ONLY VISIBLE FOR PENDING ORDERS -->
                                    <div class="payment-actions gcash-verification-buttons" 
                                        Visible='<%# Eval("transaction_status").ToString() <> "Verified" AndAlso Eval("transaction_status").ToString() <> "Rejected" %>'
                                        style="display: flex !important; visibility: visible !important; margin-top: 10px;">
                                        
                                        <!-- PAYMENT VERIFICATION BUTTON -->
                                        <button type="button" 
                                            class="action-btn btn-verify-direct" 
                                            data-order-id='<%# Eval("order_id") %>' 
                                            data-transaction-id='<%# Eval("transaction_id") %>'
                                            data-transaction-status='<%# Eval("transaction_status") %>'
                                            onclick="try { var oid = this.getAttribute('data-order-id'); var tid = this.getAttribute('data-transaction-id'); window.showVerificationModal(oid, tid); return false; } catch(e) { alert('Error: ' + e.message); return false; }"
                                            style="display: inline-block !important; 
                                                   visibility: visible !important; 
                                                   opacity: 1 !important;
                                                   padding: 8px 16px; 
                                                   margin: 10px 10px 10px 0; 
                                                   background-color: #4CAF50 !important; 
                                                   color: white !important; 
                                                   border: none; 
                                                   border-radius: 4px; 
                                                   cursor: pointer;
                                                   font-weight: bold;
                                                   font-size: 14px;">
                                            <i class="fas fa-check-circle"></i> Verify Payment
                                        </button>
                                        
                                        
                                    </div>
                                </asp:Panel>
                             
                            </div>
                            
                            <%# If(Eval("status").ToString() <> "Cancelled", "<div class=""delivery-info""><h4>Delivery Information</h4>" + 
                                If(Eval("driver_name") IsNot Nothing AndAlso Eval("driver_name").ToString() <> "Not assigned", 
                                   "<div class=""info-row""><div class=""info-label"">Driver:</div><div class=""info-value"">" + Eval("driver_name").ToString() + "</div></div>", "") + 
                                If(Eval("delivery_service") IsNot Nothing AndAlso Eval("delivery_service").ToString() <> "Not specified", 
                                   "<div class=""info-row""><div class=""info-label"">Service:</div><div class=""info-value"">" + Eval("delivery_service").ToString() + "</div></div>", "") + 
                                If(Eval("tracking_link") IsNot Nothing AndAlso Eval("tracking_link").ToString() <> "", 
                                   "<div class=""info-row""><div class=""info-label"">Tracking:</div><div class=""info-value""><a href=""" + Eval("tracking_link").ToString() + """ target=""_blank"">View Tracking</a></div></div>", "") + 
                                If(Eval("delivery_notes") IsNot Nothing AndAlso Eval("delivery_notes").ToString() <> "", 
                                   "<div class=""info-row""><div class=""info-label"">Notes:</div><div class=""info-value"">" + Eval("delivery_notes").ToString() + "</div></div>", "") +
                                If(Eval("estimated_time") IsNot Nothing AndAlso Eval("estimated_time").ToString() <> "", 
                                   "<div class=""info-row""><div class=""info-label"">Est. Delivery:</div><div class=""info-value"">" + Eval("estimated_time").ToString() + "</div></div>", "") +
                                "</div>", "") %>
                </div>
                
                            <div class="order-actions">
                            <asp:Button ID="AcceptPaymentButton" runat="server" Text="Accept Payment" CssClass="action-btn btn-accept" 
                                CommandName="AcceptPayment" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Pending" %>' />
                                    
                            <asp:Button ID="ProcessButton" runat="server" Text="Process Order" CssClass="action-btn btn-process" 
                                CommandName="Process" CommandArgument='<%# Eval("order_id") %>' 
                                Visible='<%# Eval("status").ToString() = "Pending" Or Eval("status").ToString() = "Payment Accepted" %>' />
                                
                            <asp:Button ID="UpdateStatusButton" runat="server" Text="Change Status" CssClass="action-btn btn-status" 
                                CommandName="UpdateStatus" CommandArgument='<%# Eval("order_id") %>' />
                                
                            <asp:Button ID="DeliveryButton" runat="server" Text="Update Delivery" CssClass="action-btn btn-delivery" 
                                CommandName="SetDelivery" CommandArgument='<%# Eval("order_id") %>' 
                                Visible='<%# Eval("status").ToString() <> "Cancelled" %>' />
                                    
                                <asp:Button ID="CompleteButton" runat="server" Text="Complete" CssClass="action-btn btn-complete" 
                                    CommandName="Complete" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Processing" %>' />
                                    
                                <asp:Button ID="CancelButton" runat="server" Text="Cancel" CssClass="action-btn btn-cancel" 
                                    CommandName="Cancel" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Pending" %>' />
                        </div>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </div>
        
        <div id="updateStatusModal" class="modal" style="display:none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Update Order Status</h2>
                    <asp:LinkButton runat="server" ID="CloseStatusModalButton" CssClass="close-btn"
                        OnClick="CloseStatusModalButton_Click">&times;</asp:LinkButton>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Select New Status</label>
                        <asp:DropDownList ID="OrderStatusDropDown" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                            <asp:ListItem Text="Payment Accepted" Value="Payment Accepted"></asp:ListItem>
                            <asp:ListItem Text="Processing" Value="Processing"></asp:ListItem>
                            <asp:ListItem Text="Preparing" Value="Preparing"></asp:ListItem>
                            <asp:ListItem Text="Ready for Pickup" Value="Ready"></asp:ListItem>
                            <asp:ListItem Text="Out for Delivery" Value="Delivering"></asp:ListItem>
                            <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                            <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="SaveStatusButton" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="SaveStatusButton_Click" />
                    <asp:Button ID="CancelStatusUpdateButton" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="CloseStatusModalButton_Click" />
                </div>
            </div>
        </div>
        
        <asp:Panel ID="DeliveryModal" runat="server" CssClass="modal" Visible="true" Style="display:none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Update Delivery Information</h2>
                    <asp:LinkButton runat="server" ID="CloseDeliveryModalButton" CssClass="close-btn"
                        OnClick="CloseDeliveryModalButton_Click">&times;</asp:LinkButton>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="DeliveryOrderId" runat="server" />
                    <div class="form-group">
                        <label>Delivery Service</label>
                        <asp:DropDownList ID="DeliveryServiceDropDown" runat="server" CssClass="form-control">
                            <asp:ListItem Text="Select Service" Value=""></asp:ListItem>
                            <asp:ListItem Text="Grab" Value="Grab"></asp:ListItem>
                            <asp:ListItem Text="Lalamove" Value="Lalamove"></asp:ListItem>
                            <asp:ListItem Text="FoodPanda" Value="FoodPanda"></asp:ListItem>
                            <asp:ListItem Text="Hapag" Value="Hapag"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group">
                        <label>Driver Name</label>
                        <asp:TextBox ID="DriverNameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Tracking Link</label>
                        <asp:TextBox ID="TrackingLinkTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Estimated Delivery Time</label>
                        <asp:TextBox ID="EstimatedTimeTextBox" runat="server" CssClass="form-control" placeholder="e.g. 30-45 minutes"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Delivery Notes</label>
                        <asp:TextBox ID="DeliveryNotesTextBox" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="SaveDeliveryButton" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="SaveDeliveryButton_Click" />
                    <asp:Button ID="CancelDeliveryButton" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="CloseDeliveryModalButton_Click" />
                </div>
            </div>
        </asp:Panel>
        
        <asp:Panel ID="PaymentVerificationModal" runat="server" CssClass="modal payment-verification-modal" ClientIDMode="Static" Style="display:none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 9999; padding: 50px;">
            <div class="modal-content" style="max-width: 600px; margin: 0 auto; background: white; padding: 20px; border-radius: 5px; box-shadow: 0 0 10px rgba(0,0,0,0.3);">
                <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #ddd; padding-bottom: 10px; margin-bottom: 15px;">
                    <h2 style="margin: 0; font-size: 20px;">Verify Payment</h2>
                    <button type="button" class="close-btn" onclick="document.getElementById('PaymentVerificationModal').style.display='none';" style="background: none; border: none; font-size: 24px; cursor: pointer;">&times;</button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="PaymentOrderId" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="PaymentTransactionId" runat="server" ClientIDMode="Static" />
                    
                    <div class="payment-verification-container">
                       
                        
                       
                        
                        <div class="verification-message">
                            <p>Please verify the payment details before approving. Once approved, the order status will be updated and the order will be ready for processing.</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" style="margin-top: 20px; text-align: right; padding-top: 15px; border-top: 1px solid #ddd;">
                    <asp:Button ID="ConfirmPaymentButton" runat="server" Text="Confirm Payment" CssClass="btn btn-success" OnClick="ConfirmPaymentButton_Click" style="padding: 8px 16px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;" />
                    <asp:Button ID="RejectPaymentButton" runat="server" Text="Reject Payment" CssClass="btn btn-danger" OnClick="RejectPaymentButton_Click" style="padding: 8px 16px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;" />
                    <asp:Button ID="CancelPaymentVerificationButton" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="ClosePaymentModalButton_Click" style="padding: 8px 16px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;" />
                </div>
            </div>
        </asp:Panel>
        </div>

    <script type="text/javascript">
        // Define showVerificationModal in the global scope first
        window.showVerificationModal = function(orderId, transactionId) {
            console.warn("SHOW VERIFICATION MODAL - Order ID:", orderId, "Transaction ID:", transactionId);
            
            try {
                // Special test case for debugging - if both IDs are 1, enter test mode
                var isTestMode = (orderId === 1 && transactionId === 1);
                if (isTestMode) {
                    console.log("TEST MODE: Showing verification modal with test data");
                }
                
                // Try to convert to integers (if they're strings)
                orderId = parseInt(orderId);
                transactionId = parseInt(transactionId);
                
                if (isNaN(orderId) || isNaN(transactionId)) {
                    console.error("Invalid order ID or transaction ID:", orderId, transactionId);
                    alert("Error: Invalid order ID or transaction ID");
                    return;
                }
                
                // Ensure hidden fields exist
                var fields = ensureHiddenFields();
                var orderIdField = fields.orderIdField;
                var transactionIdField = fields.transactionIdField;
                
                // Set hidden field values
                if (orderIdField && transactionIdField) {
                    orderIdField.value = orderId;
                    transactionIdField.value = transactionId;
                    console.log("Set hidden fields - Order ID:", orderId, "Transaction ID:", transactionId);
                } else {
                    console.error("Hidden fields not found - OrderID:", !!orderIdField, "TransactionID:", !!transactionIdField);
                    if (isTestMode) {
                        console.log("TEST MODE: Continuing despite missing hidden fields");
                    } else {
                        alert("Error: Hidden fields not found. Please refresh the page and try again.");
                        return;
                    }
                }
                
                // Try to get the order data from the DOM first
                var orderData = getOrderDataFromDOM(orderId);
                
                // Option 1: Try to display the existing modal
                var modal = document.getElementById('PaymentVerificationModal');
                if (modal) {
                    console.log("Found modal, setting display to block");
                    
                    // If we have order data from the DOM, populate the modal
                    if (orderData) {
                        updateModalContent(
                            orderId,
                            orderData.customerName,
                            orderData.totalAmount,
                            orderData.paymentMethod,
                            orderData.referenceNumber,
                            orderData.senderName,
                            orderData.senderNumber,
                            orderData.transactionDate,
                            orderData.transactionStatus
                        );
                    }
                    // Otherwise try to trigger server side VerifyPayment command to load data
                    else if (!isTestMode) {
                        console.log("No order data found in DOM, attempting to load from server...");
                        triggerServerVerification(orderId);
                    }
                    
                    // Make sure modal is in the right place and visible
                    if (!document.body.contains(modal)) {
                        console.log("Moving modal to document body");
                        document.body.appendChild(modal);
                    }
                    
                    // Force modal to be visible with important styles
                    modal.style.cssText = "display: block !important; position: fixed !important; z-index: 9999 !important; top: 0 !important; left: 0 !important; right: 0 !important; bottom: 0 !important; background: rgba(0,0,0,0.5) !important; padding: 50px !important;";
                    
                    console.log("Modal should now be visible");
                    
                    // Set a timeout to check if modal is visible
                    setTimeout(function() {
                        if (window.getComputedStyle(modal).display !== 'block') {
                            console.error("Modal still not visible, trying direct style application");
                            
                            // Try to reset all possible hiding styles
                            modal.style.cssText = "display: block !important; visibility: visible !important; opacity: 1 !important; position: fixed !important; z-index: 9999 !important; top: 0 !important; left: 0 !important; right: 0 !important; bottom: 0 !important; background: rgba(0,0,0,0.5) !important; padding: 50px !important;";
                            
                            // If still not visible, try to create a new modal
                            if (window.getComputedStyle(modal).display !== 'block') {
                                console.error("Modal still not visible after retrying, creating fallback");
                                createFallbackModal(orderId, transactionId, orderData);
                            }
                        } else {
                            console.log("Modal is visible, verification can proceed");
                        }
                    }, 100);
                } else {
                    console.error("Verification modal element not found");
                    createFallbackModal(orderId, transactionId, orderData);
                }
            } catch (err) {
                console.error("Error in showVerificationModal:", err);
                alert("An error occurred while trying to show the payment verification modal: " + err.message);
            }
        };
        
        // Helper function to extract order data from the DOM
        function getOrderDataFromDOM(orderId) {
            console.log("Attempting to extract order data from DOM for Order ID:", orderId);
            
            try {
                // Find the order card that matches this order ID
                var orderCards = document.querySelectorAll('.order-card');
                for (var i = 0; i < orderCards.length; i++) {
                    var card = orderCards[i];
                    var orderIdEl = card.querySelector('.order-id');
                    
                    if (orderIdEl) {
                        var idText = orderIdEl.textContent.trim();
                        var idMatch = idText.match(/\d+/);
                        var cardOrderId = idMatch ? idMatch[0] : null;
                        
                        if (cardOrderId == orderId) {
                            console.log("Found matching order card for Order ID:", orderId);
                            
                            // Extract customer name
                            var customerName = "";
                            var customerEl = card.querySelector('.info-value');
                            if (customerEl) {
                                customerName = customerEl.textContent.trim();
                            }
                            
                            // Extract total amount
                            var totalAmount = "";
                            var totalEls = card.querySelectorAll('.info-label');
                            for (var j = 0; j < totalEls.length; j++) {
                                if (totalEls[j].textContent.includes('Total Amount:')) {
                                    var valueEl = totalEls[j].nextElementSibling;
                                    if (valueEl) {
                                        totalAmount = valueEl.textContent.replace('PHP', '').trim();
                                    }
                                    break;
                                }
                            }
                            
                            // Extract payment method
                            var paymentMethod = "GCash";
                            var methodEls = card.querySelectorAll('.info-label');
                            for (var j = 0; j < methodEls.length; j++) {
                                if (methodEls[j].textContent.includes('Payment Method:')) {
                                    var valueEl = methodEls[j].nextElementSibling;
                                    if (valueEl) {
                                        paymentMethod = valueEl.textContent.trim();
                                    }
                                    break;
                                }
                            }
                            
                            // Extract reference number
                            var referenceNumber = "Not provided";
                            var refEls = card.querySelectorAll('.info-label');
                            for (var j = 0; j < refEls.length; j++) {
                                if (refEls[j].textContent.includes('Reference Number:')) {
                                    var valueEl = refEls[j].nextElementSibling;
                                    if (valueEl) {
                                        referenceNumber = valueEl.textContent.trim();
                                    }
                                    break;
                                }
                            }
                            
                            // Extract sender name
                            var senderName = "Not provided";
                            var nameEls = card.querySelectorAll('.info-label');
                            for (var j = 0; j < nameEls.length; j++) {
                                if (nameEls[j].textContent.includes('Sender Name:')) {
                                    var valueEl = nameEls[j].nextElementSibling;
                                    if (valueEl) {
                                        senderName = valueEl.textContent.trim();
                                    }
                                    break;
                                }
                            }
                            
                            // Extract sender number
                            var senderNumber = "Not provided";
                            var numberEls = card.querySelectorAll('.info-label');
                            for (var j = 0; j < numberEls.length; j++) {
                                if (numberEls[j].textContent.includes('Sender Number:')) {
                                    var valueEl = numberEls[j].nextElementSibling;
                                    if (valueEl) {
                                        senderNumber = valueEl.textContent.trim();
                                    }
                                    break;
                                }
                            }
                            
                            // Extract transaction date and status if available
                            var transactionDate = "-";
                            var transactionStatus = "Pending Verification";
                            
                            var statusEls = card.querySelectorAll('.info-label');
                            for (var j = 0; j < statusEls.length; j++) {
                                if (statusEls[j].textContent.includes('Payment Status:')) {
                                    var valueEl = statusEls[j].nextElementSibling;
                                    if (valueEl) {
                                        transactionStatus = valueEl.textContent.trim();
                                    }
                                    break;
                                }
                            }
                            
                            return {
                                orderId: orderId,
                                customerName: customerName,
                                totalAmount: totalAmount,
                                paymentMethod: paymentMethod,
                                referenceNumber: referenceNumber,
                                senderName: senderName,
                                senderNumber: senderNumber,
                                transactionDate: transactionDate,
                                transactionStatus: transactionStatus
                            };
                        }
                    }
                }
                
                console.log("Could not find order data in DOM for Order ID:", orderId);
                return null;
            } catch (err) {
                console.error("Error extracting order data from DOM:", err);
                return null;
            }
        }
        
        // Function to ensure required hidden fields exist
        function ensureHiddenFields() {
            console.log("Checking for required hidden fields");
            
            // Check for PaymentOrderId
            var orderIdField = document.getElementById('PaymentOrderId');
            if (!orderIdField) {
                console.log("Creating missing PaymentOrderId hidden field");
                orderIdField = document.createElement('input');
                orderIdField.type = 'hidden';
                orderIdField.id = 'PaymentOrderId';
                orderIdField.name = 'PaymentOrderId';
                document.body.appendChild(orderIdField);
            }
            
            // Check for PaymentTransactionId
            var transactionIdField = document.getElementById('PaymentTransactionId');
            if (!transactionIdField) {
                console.log("Creating missing PaymentTransactionId hidden field");
                transactionIdField = document.createElement('input');
                transactionIdField.type = 'hidden';
                transactionIdField.id = 'PaymentTransactionId';
                transactionIdField.name = 'PaymentTransactionId';
                document.body.appendChild(transactionIdField);
            }
            
            return {
                orderIdField: orderIdField,
                transactionIdField: transactionIdField
            };
        }
        
        // Run this immediately to ensure fields exist
        ensureHiddenFields();
        
        // Also update button styling as soon as possible
        document.addEventListener('DOMContentLoaded', function() {
            // Add styles to ensure visibility
            var style = document.createElement('style');
            style.textContent = `
                .btn-verify-direct {
                    display: inline-block !important;
                    visibility: visible !important;
                    opacity: 1 !important;
                    padding: 8px 16px !important;
                    margin: 10px 10px 10px 0 !important;
                    background-color: #4CAF50 !important;
                    color: white !important;
                    border: none !important;
                    border-radius: 4px !important;
                    cursor: pointer !important;
                    font-weight: bold !important;
                    font-size: 14px !important;
                }
                
                .gcash-verification-buttons {
                    display: flex !important;
                    visibility: visible !important;
                    opacity: 1 !important;
                    margin-top: 10px !important;
                }
                
                #PaymentVerificationModal {
                    z-index: 9999 !important;
                }
            `;
            document.head.appendChild(style);
        });
    </script>
    
    <script type="text/javascript">
        // Function to create a fallback modal when the real one can't be shown
        function createFallbackModal(orderId, transactionId, orderData) {
            console.warn("CREATING FALLBACK MODAL for Order:", orderId, "Transaction:", transactionId);
            
            var testModal = document.createElement('div');
            testModal.id = 'FallbackVerificationModal';
            testModal.style.cssText = "display: block; position: fixed; z-index: 10000; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); padding: 50px;";
            
            var modalContent = document.createElement('div');
            modalContent.style.cssText = "background: white; padding: 20px; border-radius: 5px; max-width: 600px; margin: 0 auto; position: relative;";
            
            var header = document.createElement('div');
            header.style.cssText = "margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;";
            header.innerHTML = '<h2 style="margin: 0; font-size: 20px; color: #333;">Payment Verification</h2>';
            
            var closeBtn = document.createElement('button');
            closeBtn.innerHTML = '&times;';
            closeBtn.style.cssText = "background: none; border: none; font-size: 24px; cursor: pointer; position: absolute; right: 15px; top: 10px;";
            closeBtn.onclick = function() { document.getElementById('FallbackVerificationModal').remove(); };
            
            // Create content based on available data
            var bodyContent = '';
            
            if (orderData) {
                // We have data, create a detailed view
                bodyContent = `
                    <div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
                        <h4 style="margin-top: 0; color: #333; font-size: 16px;">Order Information</h4>
                        <p style="margin-bottom: 5px;"><strong>Order ID:</strong> ${orderId}</p>
                        <p style="margin-bottom: 5px;"><strong>Customer:</strong> ${orderData.customerName}</p>
                        <p style="margin-bottom: 5px;"><strong>Total Amount:</strong> PHP ${orderData.totalAmount}</p>
                    </div>
                    
                    <div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
                        <h4 style="margin-top: 0; color: #333; font-size: 16px;">Payment Details</h4>
                        <p style="margin-bottom: 5px;"><strong>Payment Method:</strong> ${orderData.paymentMethod}</p>
                        <p style="margin-bottom: 5px;"><strong>Reference Number:</strong> ${orderData.referenceNumber}</p>
                        <p style="margin-bottom: 5px;"><strong>Sender Name:</strong> ${orderData.senderName}</p>
                        <p style="margin-bottom: 5px;"><strong>Sender Number:</strong> ${orderData.senderNumber}</p>
                        <p style="margin-bottom: 5px;"><strong>Current Status:</strong> ${orderData.transactionStatus}</p>
                    </div>
                    
                    <div style="margin-bottom: 20px; padding: 15px; background-color: #e8f4fe; border-radius: 5px; border-left: 4px solid #2196F3;">
                        <h4 style="margin-top: 0; color: #0d47a1; font-size: 16px;">Verification</h4>
                        <p>Please verify the payment details before approving. Once approved, the order status will be updated and the order will be ready for processing.</p>
                    </div>
                `;
            } else {
                // Basic info only
                bodyContent = `
                    <div style="margin-bottom: 20px; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
                        <h4 style="margin-top: 0; color: #333; font-size: 16px;">Order Information</h4>
                        <p style="margin-bottom: 5px;"><strong>Order ID:</strong> ${orderId}</p>
                        <p style="margin-bottom: 5px;"><strong>Transaction ID:</strong> ${transactionId}</p>
                    </div>
                    
                    <div style="margin-bottom: 20px; padding: 15px; background-color: #fff3cd; border-radius: 5px; border-left: 4px solid #ffc107;">
                        <h4 style="margin-top: 0; color: #856404; font-size: 16px;">Emergency Verification</h4>
                        <p>The normal verification modal could not be displayed with complete details. Please use the buttons below to verify or reject this payment.</p>
                    </div>
                `;
            }
            
            var body = document.createElement('div');
            body.innerHTML = bodyContent;
            
            var footer = document.createElement('div');
            footer.style.cssText = "margin-top: 20px; text-align: right; padding-top: 15px; border-top: 1px solid #eee;";
            
            var confirmBtn = document.createElement('button');
            confirmBtn.innerText = 'Confirm Payment';
            confirmBtn.style.cssText = "padding: 8px 16px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;";
            confirmBtn.onclick = function() {
                triggerServerConfirmPayment(orderId, transactionId);
                document.getElementById('FallbackVerificationModal').remove();
            };
            
            var rejectBtn = document.createElement('button');
            rejectBtn.innerText = 'Reject Payment';
            rejectBtn.style.cssText = "padding: 8px 16px; background: #dc3545; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px;";
            rejectBtn.onclick = function() {
                triggerServerRejectPayment(orderId, transactionId);
                document.getElementById('FallbackVerificationModal').remove();
            };
            
            var cancelBtn = document.createElement('button');
            cancelBtn.innerText = 'Cancel';
            cancelBtn.style.cssText = "padding: 8px 16px; background: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer;";
            cancelBtn.onclick = function() { document.getElementById('FallbackVerificationModal').remove(); };
            
            footer.appendChild(confirmBtn);
            footer.appendChild(rejectBtn);
            footer.appendChild(cancelBtn);
            
            modalContent.appendChild(closeBtn);
            modalContent.appendChild(header);
            modalContent.appendChild(body);
            modalContent.appendChild(footer);
            testModal.appendChild(modalContent);
            document.body.appendChild(testModal);
            
            console.log("Fallback modal created and displayed");
        }
        
        // Function to trigger server-side verification
        function triggerServerVerification(orderId) {
            console.warn("TRIGGERING SERVER VERIFICATION for Order ID:", orderId);
            
            try {
                // First try direct data retrieval approach by finding the order card for this order
                var foundData = false;
                
                // Try to find the order card that matches this order ID
                var orderCards = document.querySelectorAll('.order-card');
                for (var i = 0; i < orderCards.length; i++) {
                    var card = orderCards[i];
                    var orderIdEl = card.querySelector('.order-id');
                    
                    if (orderIdEl) {
                        var idText = orderIdEl.textContent.trim();
                        var idMatch = idText.match(/\d+/);
                        var cardOrderId = idMatch ? idMatch[0] : null;
                        
                        if (cardOrderId == orderId) {
                            console.log("Found matching order card for Order ID:", orderId);
                            
                            // Extract data to populate the modal
                            populateVerificationModal(card, orderId);
                            foundData = true;
                            break;
                        }
                    }
                }
                
                if (!foundData) {
                    console.log("Falling back to server postback for data");
                    // Create a hidden form to submit
                    var form = document.createElement('form');
                    form.method = 'post';
                    form.action = window.location.href;
                    form.target = '_self'; // Same window
                    
                    // Set up the event target
                    var eventTarget = document.createElement('input');
                    eventTarget.type = 'hidden';
                    eventTarget.name = '__EVENTTARGET';
                    eventTarget.value = 'OrdersListView';
                    form.appendChild(eventTarget);
                    
                    // Set up the event argument
                    var eventArg = document.createElement('input');
                    eventArg.type = 'hidden';
                    eventArg.name = '__EVENTARGUMENT';
                    eventArg.value = 'VerifyPayment:' + orderId;
                    form.appendChild(eventArg);
                    
                    // Get VIEWSTATE and any other hidden fields
                    var viewstate = document.querySelector('#__VIEWSTATE');
                    if (viewstate) {
                        var viewstateClone = viewstate.cloneNode(true);
                        form.appendChild(viewstateClone);
                    }
                    
                    var viewstateGen = document.querySelector('#__VIEWSTATEGENERATOR');
                    if (viewstateGen) {
                        var viewstateGenClone = viewstateGen.cloneNode(true);
                        form.appendChild(viewstateGenClone);
                    }
                    
                    var eventValidation = document.querySelector('#__EVENTVALIDATION');
                    if (eventValidation) {
                        var eventValidationClone = eventValidation.cloneNode(true);
                        form.appendChild(eventValidationClone);
                    }
                    
                    // Set the hidden fields
                    var orderIdField = document.getElementById('PaymentOrderId');
                    var transactionIdField = document.getElementById('PaymentTransactionId');
                    
                    if (orderIdField) {
                        orderIdField.value = orderId;
                    }
                    
                    // Append the form to body, submit it, and remove it
                    document.body.appendChild(form);
                    
                    console.log("Submitting server verification form");
                    form.submit();
                }
            } catch (err) {
                console.error("Error triggering server verification:", err);
            }
        }
        
        // Function to populate verification modal with data from the order card
        function populateVerificationModal(orderCard, orderId) {
            console.log("Populating verification modal with order data");
            
            try {
                // Get the transaction ID from the order details
                var transactionId = '';
                var infoLabels = orderCard.querySelectorAll('.info-label');
                for (var i = 0; i < infoLabels.length; i++) {
                    if (infoLabels[i].textContent.includes('Transaction ID')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            transactionId = valueEl.textContent.trim().replace('#', '');
                            break;
                        }
                    }
                }
                
                // Get customer name
                var customerName = '';
                infoLabels = orderCard.querySelectorAll('.info-label');
                for (var i = 0; i < infoLabels.length; i++) {
                    if (infoLabels[i].textContent.includes('Customer:') || 
                        infoLabels[i].textContent.includes('Name:')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            customerName = valueEl.textContent.trim();
                            break;
                        }
                    }
                }
                
                // Get total amount
                var totalAmount = '';
                infoLabels = orderCard.querySelectorAll('.info-label');
                for (var i = 0; i < infoLabels.length; i++) {
                    if (infoLabels[i].textContent.includes('Total Amount:')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            totalAmount = valueEl.textContent.trim().replace('PHP', '').trim();
                            break;
                        }
                    }
                }
                
                // Get payment method
                var paymentMethod = '';
                infoLabels = orderCard.querySelectorAll('.info-label');
                for (var i = 0; i < infoLabels.length; i++) {
                    if (infoLabels[i].textContent.includes('Payment Method:')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            paymentMethod = valueEl.textContent.trim();
                            break;
                        }
                    }
                }
                
                // Get reference number, sender name, sender number
                var referenceNumber = 'Not provided';
                var senderName = 'Not provided';
                var senderNumber = 'Not provided';
                var transactionDate = '-';
                var transactionStatus = 'Pending Verification';
                
                infoLabels = orderCard.querySelectorAll('.info-label');
                for (var i = 0; i < infoLabels.length; i++) {
                    if (infoLabels[i].textContent.includes('Reference Number:')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            referenceNumber = valueEl.textContent.trim();
                        }
                    }
                    else if (infoLabels[i].textContent.includes('Sender Name:')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            senderName = valueEl.textContent.trim();
                        }
                    }
                    else if (infoLabels[i].textContent.includes('Sender Number:')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            senderNumber = valueEl.textContent.trim();
                        }
                    }
                    else if (infoLabels[i].textContent.includes('Payment Status:')) {
                        var valueEl = infoLabels[i].nextElementSibling;
                        if (valueEl && valueEl.classList.contains('info-value')) {
                            transactionStatus = valueEl.textContent.trim();
                        }
                    }
                }
                
                // Set transaction ID in the hidden field
                var transactionIdField = document.getElementById('PaymentTransactionId');
                if (transactionIdField) {
                    transactionIdField.value = transactionId;
                }
                
                // Update the modal content
                var modal = document.getElementById('PaymentVerificationModal');
                if (modal) {
                    updateModalContent(
                        orderId,
                        customerName,
                        totalAmount,
                        paymentMethod,
                        referenceNumber,
                        senderName,
                        senderNumber,
                        transactionDate,
                        transactionStatus
                    );
                }
            } catch (err) {
                console.error("Error populating verification modal:", err);
            }
        }
        
        // Function to update modal content with data
        function updateModalContent(orderId, customerName, totalAmount, paymentMethod, referenceNumber, senderName, senderNumber, transactionDate, transactionStatus) {
            console.log("Updating modal content with order data", {
                orderId: orderId,
                customerName: customerName,
                totalAmount: totalAmount,
                paymentMethod: paymentMethod,
                referenceNumber: referenceNumber,
                senderName: senderName,
                senderNumber: senderNumber,
                transactionDate: transactionDate,
                transactionStatus: transactionStatus
            });
            
            try {
                // Direct manual update of all fields in the modal
                var modal = document.getElementById('PaymentVerificationModal');
                if (!modal) {
                    console.error("Modal not found!");
                    return;
                }
                
                // Update each literal using querySelector within the modal
                // Order ID
                var orderIdLiteral = modal.querySelector('#OrderIdLiteral');
                if (orderIdLiteral) {
                    orderIdLiteral.innerHTML = orderId || "N/A";
                } else {
                    console.error("OrderIdLiteral not found");
                }
                
                // Customer Name
                var customerNameLiteral = modal.querySelector('#CustomerNameLiteral');
                if (customerNameLiteral) {
                    customerNameLiteral.innerHTML = customerName || "N/A";
                } else {
                    console.error("CustomerNameLiteral not found");
                }
                
                // Total Amount
                var orderAmountLiteral = modal.querySelector('#OrderAmountLiteral');
                if (orderAmountLiteral) {
                    orderAmountLiteral.innerHTML = totalAmount || "0.00";
                } else {
                    console.error("OrderAmountLiteral not found");
                }
                
                // Payment Method
                var paymentMethodLiteral = modal.querySelector('#PaymentMethodLiteral');
                if (paymentMethodLiteral) {
                    paymentMethodLiteral.innerHTML = paymentMethod || "GCash";
                } else {
                    console.error("PaymentMethodLiteral not found");
                }
                
                // Reference Number
                var referenceNumberLiteral = modal.querySelector('#ReferenceNumberLiteral');
                if (referenceNumberLiteral) {
                    referenceNumberLiteral.innerHTML = referenceNumber || "Not provided";
                } else {
                    console.error("ReferenceNumberLiteral not found");
                }
                
                // Sender Name
                var senderNameLiteral = modal.querySelector('#SenderNameLiteral');
                if (senderNameLiteral) {
                    senderNameLiteral.innerHTML = senderName || "Not provided";
                } else {
                    console.error("SenderNameLiteral not found");
                }
                
                // Sender Number
                var senderNumberLiteral = modal.querySelector('#SenderNumberLiteral');
                if (senderNumberLiteral) {
                    senderNumberLiteral.innerHTML = senderNumber || "Not provided";
                } else {
                    console.error("SenderNumberLiteral not found");
                }
                
                // Transaction Date
                var transactionDateLiteral = modal.querySelector('#TransactionDateLiteral');
                if (transactionDateLiteral) {
                    transactionDateLiteral.innerHTML = transactionDate || "-";
                } else {
                    console.error("TransactionDateLiteral not found");
                }
                
                // Transaction Status
                var transactionStatusLiteral = modal.querySelector('#TransactionStatusLiteral');
                if (transactionStatusLiteral) {
                    transactionStatusLiteral.innerHTML = transactionStatus || "Pending Verification";
                } else {
                    console.error("TransactionStatusLiteral not found");
                }
                
                console.log("Modal content updated successfully");
            } catch (err) {
                console.error("Error updating modal content:", err);
            }
        }
        
        // Make function globally available
        window.updateModalContent = updateModalContent;
        
        // Function to force update modal data if it's empty
        function forceModalDataUpdate() {
            console.log("Force updating modal data if needed");
            
            try {
                // Check if modal is visible
                var modal = document.getElementById('PaymentVerificationModal');
                if (modal && window.getComputedStyle(modal).display === 'block') {
                    console.log("Modal is visible, checking if data needs to be updated");
                    
                    // Check if order ID is available
                    var orderIdField = document.getElementById('PaymentOrderId');
                    if (orderIdField && orderIdField.value) {
                        var orderId = orderIdField.value;
                        
                        // Check if modal data appears to be empty
                        var orderIdLiteral = modal.querySelector('#OrderIdLiteral');
                        if (orderIdLiteral && (!orderIdLiteral.innerHTML || orderIdLiteral.innerHTML.trim() === '' || orderIdLiteral.innerHTML === 'N/A')) {
                            console.log("Modal data appears empty, trying to populate from DOM data");
                            
                            // Try to get data from the DOM
                            var orderData = getOrderDataFromDOM(orderId);
                            if (orderData) {
                                console.log("Found order data in DOM, updating modal");
                                updateModalContent(
                                    orderId,
                                    orderData.customerName,
                                    orderData.totalAmount,
                                    orderData.paymentMethod,
                                    orderData.referenceNumber,
                                    orderData.senderName,
                                    orderData.senderNumber,
                                    orderData.transactionDate,
                                    orderData.transactionStatus
                                );
                            }
                        }
                    }
                }
            } catch (err) {
                console.error("Error in forceModalDataUpdate:", err);
            }
        }
        
        // Set up timers to force update modal data
        document.addEventListener('DOMContentLoaded', function() {
            console.log("Setting up enhanced modal update timers");
            
            // More aggressive timer approach - run checks frequently
            var modalUpdateTimers = [];
            
            // Function to start modal update timers
            function startModalUpdateTimers() {
                console.log("Starting modal update timers");
                
                // Clear any existing timers
                modalUpdateTimers.forEach(function(timer) {
                    clearTimeout(timer);
                });
                modalUpdateTimers = [];
                
                // Run update checks with varying intervals
                for(var i = 1; i <= 10; i++) {
                    var timer = setTimeout(forceModalDataUpdate, i * 500); // every 500ms for 5 seconds
                    modalUpdateTimers.push(timer);
                }
            }
            
            // Start timers immediately
            startModalUpdateTimers();
            
            // Override the showVerificationModal function to ensure modal data is populated
            if (typeof window.showVerificationModal === 'function') {
                console.log("Enhancing showVerificationModal function");
                var originalShowModal = window.showVerificationModal;
                
                window.showVerificationModal = function(orderId, transactionId) {
                    console.log("Enhanced showVerificationModal called with Order ID:", orderId, "Transaction ID:", transactionId);
                    
                    // Call the original function
                    originalShowModal(orderId, transactionId);
                    
                    // Start modal update timers
                    startModalUpdateTimers();
                };
            } else {
                console.log("showVerificationModal is not defined on window - trying to create emergency version");
                
                window.showVerificationModal = function(orderId, transactionId) {
                    console.warn("EMERGENCY VERSION OF MODAL - Order ID:", orderId, "Transaction ID:", transactionId);
                    
                    // Set hidden fields
                    var orderIdField = document.getElementById('PaymentOrderId');
                    var transactionIdField = document.getElementById('PaymentTransactionId');
                    
                    if (orderIdField && transactionIdField) {
                        orderIdField.value = orderId;
                        transactionIdField.value = transactionId;
                        
                        // Try to get the order data from the DOM
                        var orderData = getOrderDataFromDOM(orderId);
                        
                        // Try to show modal
                        var modal = document.getElementById('PaymentVerificationModal');
                        if (modal) {
                            modal.style.display = 'block';
                            
                            // If we have order data, try to update modal content
                            if (orderData && typeof window.updateModalContent === 'function') {
                                window.updateModalContent(
                                    orderId,
                                    orderData.customerName,
                                    orderData.totalAmount,
                                    orderData.paymentMethod,
                                    orderData.referenceNumber,
                                    orderData.senderName,
                                    orderData.senderNumber,
                                    orderData.transactionDate,
                                    orderData.transactionStatus
                                );
                            }
                        }
                    }
                };
            }
            
            // Make updateModalContent globally accessible
            if (typeof updateModalContent === 'function' && typeof window.updateModalContent === 'undefined') {
                console.log("Making updateModalContent globally accessible");
                window.updateModalContent = updateModalContent;
            }
            
            // Add inline click handlers to all verification buttons
            try {
                document.querySelectorAll('.btn-verify-direct').forEach(function(btn) {
                    console.log("Setting up button click handler");
                    btn.setAttribute('onclick', "try { window.showVerificationModal(this.getAttribute('data-order-id'), this.getAttribute('data-transaction-id')); return false; } catch(e) { alert('Error: ' + e.message); return false; }");
                });
            } catch (err) {
                console.error("Error updating buttons:", err);
            }
        });
    </script>
    
    <script type="text/javascript">
        function loadReadyEvents() {
            console.log("Loading ready events for order management");
            
            // Run initially
            ensureVerifyButtonsExist();
            
            // Run again after any AJAX updates
            $(document).ajaxComplete(function (event, xhr, settings) {
                console.log("AJAX completed - checking for missing verify buttons");
                setTimeout(ensureVerifyButtonsExist, 500); // Small delay to ensure DOM is updated
            });
            
            // Monitor for DOM changes that might affect visibility
            var observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    if (mutation.type === 'childList' || mutation.type === 'attributes') {
                        console.log("DOM changed - checking for missing verify buttons");
                        ensureVerifyButtonsExist();
                    }
                });
            });
            
            // Start observing the document with the configured parameters
            observer.observe(document.body, { 
                childList: true,
                subtree: true,
                attributes: true,
                attributeFilter: ['style', 'class']
            });
        }
        
        // Initialize when document is ready
        $(document).ready(function() {
            console.log("Document ready - initializing order management");
            loadReadyEvents();
        });
        
        // Backup initialization for cases where document.ready might have already fired
        if (document.readyState === "complete" || document.readyState === "interactive") {
            console.log("Document already loaded - initializing order management");
            setTimeout(loadReadyEvents, 100);
        }
    </script>
    
    <script type="text/javascript">
        // Emergency modal data update script - runs on its own to ensure modal data is populated
        (function() {
            console.log("Setting up emergency modal data update");
            
            // Function to force update modal data
            function emergencyModalUpdate() {
                var modal = document.getElementById('PaymentVerificationModal');
                if (modal && window.getComputedStyle(modal).display === 'block') {
                    console.log("EMERGENCY UPDATE: Modal is visible, checking if data needs to be updated");
                    
                    // Check if order ID field exists and has a value
                    var orderIdField = document.getElementById('PaymentOrderId');
                    if (orderIdField && orderIdField.value) {
                        var orderId = orderIdField.value;
                        
                        // Check if any modal fields appear empty
                        var orderIdLiteral = modal.querySelector('#OrderIdLiteral');
                        var customerNameLiteral = modal.querySelector('#CustomerNameLiteral');
                        var orderAmountLiteral = modal.querySelector('#OrderAmountLiteral');
                        
                        var needsUpdate = false;
                        
                        if (orderIdLiteral && (!orderIdLiteral.innerHTML || orderIdLiteral.innerHTML.trim() === '')) {
                            console.log("OrderIdLiteral is empty, will update");
                            needsUpdate = true;
                        }
                        
                        if (customerNameLiteral && (!customerNameLiteral.innerHTML || customerNameLiteral.innerHTML.trim() === '')) {
                            console.log("CustomerNameLiteral is empty, will update");
                            needsUpdate = true;
                        }
                        
                        if (orderAmountLiteral && (!orderAmountLiteral.innerHTML || orderAmountLiteral.innerHTML.trim() === '')) {
                            console.log("OrderAmountLiteral is empty, will update");
                            needsUpdate = true;
                        }
                        
                        if (needsUpdate && typeof getOrderDataFromDOM === 'function' && typeof updateModalContent === 'function') {
                            console.log("EMERGENCY UPDATE: Attempting to populate modal data for Order ID:", orderId);
                            
                            // Try to get order data from DOM
                            var orderData = getOrderDataFromDOM(orderId);
                            if (orderData) {
                                console.log("EMERGENCY UPDATE: Found order data, updating modal");
                                updateModalContent(
                                    orderId,
                                    orderData.customerName,
                                    orderData.totalAmount,
                                    orderData.paymentMethod,
                                    orderData.referenceNumber,
                                    orderData.senderName,
                                    orderData.senderNumber,
                                    orderData.transactionDate,
                                    orderData.transactionStatus
                                );
                            } else {
                                console.log("EMERGENCY UPDATE: No order data found in DOM");
                            }
                        }
                    }
                }
            }
            
            // Run emergency update on a frequent timer
            for (var i = 1; i <= 20; i++) {
                setTimeout(emergencyModalUpdate, i * 500); // Check every 500ms for 10 seconds
            }
            
            // Add direct event listener for modal becoming visible
            document.addEventListener('click', function(e) {
                if (e.target && e.target.classList && 
                    (e.target.classList.contains('btn-verify-direct') || 
                     e.target.classList.contains('btn-verify'))) {
                    console.log("Verify button clicked, setting up emergency modal update");
                    
                    // Run multiple checks after verify button click
                    for (var i = 1; i <= 10; i++) {
                        setTimeout(emergencyModalUpdate, i * 300); // Check every 300ms for 3 seconds after click
                    }
                }
            }, true);
        })();
    </script>
    
    <script type="text/javascript">
        // Final emergency script to ensure all required functions are defined globally
        (function() {
            console.log("FINAL VERIFICATION FUNCTION CHECK");
            
            // Function to check all required functions
            function ensureRequiredFunctions() {
                // List of functions that must be globally available
                var requiredFunctions = [
                    'showVerificationModal', 
                    'updateModalContent', 
                    'getOrderDataFromDOM', 
                    'ensureHiddenFields'
                ];
                
                var missingFunctions = [];
                
                // Check each function and log if missing
                requiredFunctions.forEach(function(funcName) {
                    if (typeof window[funcName] !== 'function') {
                        console.error("CRITICAL: " + funcName + " is not defined on window!");
                        missingFunctions.push(funcName);
                    }
                });
                
                if (missingFunctions.length > 0) {
                    console.error("CRITICAL: Missing required functions: " + missingFunctions.join(", "));
                    alert("Critical error: Some verification functions are missing. Will attempt to fix.");
                    
                    // Try to fix missing functions
                    fixMissingFunctions(missingFunctions);
                } else {
                    console.log("All required functions are properly defined.");
                }
                
                // Also check the onclick handlers of the verification buttons
                fixVerificationButtonHandlers();
            }
            
            // Function to fix missing functions
            function fixMissingFunctions(missingFunctions) {
                if (missingFunctions.includes('updateModalContent')) {
                    console.log("Creating emergency version of updateModalContent");
                    window.updateModalContent = function(orderId, customerName, totalAmount, paymentMethod, referenceNumber, senderName, senderNumber, transactionDate, transactionStatus) {
                        console.log("EMERGENCY updateModalContent called with data:", {
                            orderId: orderId,
                            customerName: customerName,
                            totalAmount: totalAmount,
                            paymentMethod: paymentMethod
                        });
                        
                        try {
                            var modal = document.getElementById('PaymentVerificationModal');
                            if (!modal) {
                                console.error("Modal not found!");
                                return;
                            }
                            
                            // Just set any fields we can find
                            var fields = {
                                'OrderIdLiteral': orderId || 'N/A',
                                'CustomerNameLiteral': customerName || 'N/A',
                                'OrderAmountLiteral': totalAmount || '0.00',
                                'PaymentMethodLiteral': paymentMethod || 'GCash',
                                'ReferenceNumberLiteral': referenceNumber || 'Not provided',
                                'SenderNameLiteral': senderName || 'Not provided',
                                'SenderNumberLiteral': senderNumber || 'Not provided',
                                'TransactionDateLiteral': transactionDate || '-',
                                'TransactionStatusLiteral': transactionStatus || 'Pending Verification'
                            };
                            
                            Object.keys(fields).forEach(function(id) {
                                var element = modal.querySelector('#' + id);
                                if (element) {
                                    element.innerHTML = fields[id];
                                }
                            });
                        } catch (err) {
                            console.error("Error in emergency updateModalContent:", err);
                        }
                    };
                }
                
                if (missingFunctions.includes('showVerificationModal')) {
                    console.log("Creating emergency version of showVerificationModal");
                    window.showVerificationModal = function(orderId, transactionId) {
                        console.warn("EMERGENCY showVerificationModal - Order ID:", orderId, "Transaction ID:", transactionId);
                        
                        try {
                            // Set hidden fields
                            var orderIdField = document.getElementById('PaymentOrderId');
                            var transactionIdField = document.getElementById('PaymentTransactionId');
                            
                            if (orderIdField && transactionIdField) {
                                orderIdField.value = orderId;
                                transactionIdField.value = transactionId;
                            }
                            
                            // Show modal
                            var modal = document.getElementById('PaymentVerificationModal');
                            if (modal) {
                                modal.style.display = 'block';
                            } else {
                                alert("Payment verification modal not found!");
                            }
                        } catch (err) {
                            console.error("Error in emergency showVerificationModal:", err);
                            alert("Error showing verification modal: " + err.message);
                        }
                    };
                }
                
                if (missingFunctions.includes('getOrderDataFromDOM')) {
                    console.log("Creating emergency version of getOrderDataFromDOM");
                    window.getOrderDataFromDOM = function(orderId) {
                        console.log("Emergency getOrderDataFromDOM called for order ID:", orderId);
                        return null; // Basic stub that returns null
                    };
                }
                
                if (missingFunctions.includes('ensureHiddenFields')) {
                    console.log("Creating emergency version of ensureHiddenFields");
                    window.ensureHiddenFields = function() {
                        console.log("Emergency ensureHiddenFields called");
                        
                        // Check for PaymentOrderId
                        var orderIdField = document.getElementById('PaymentOrderId');
                        if (!orderIdField) {
                            orderIdField = document.createElement('input');
                            orderIdField.type = 'hidden';
                            orderIdField.id = 'PaymentOrderId';
                            document.body.appendChild(orderIdField);
                        }
                        
                        // Check for PaymentTransactionId
                        var transactionIdField = document.getElementById('PaymentTransactionId');
                        if (!transactionIdField) {
                            transactionIdField = document.createElement('input');
                            transactionIdField.type = 'hidden';
                            transactionIdField.id = 'PaymentTransactionId';
                            document.body.appendChild(transactionIdField);
                        }
                        
                        return {
                            orderIdField: orderIdField,
                            transactionIdField: transactionIdField
                        };
                    };
                }
            }
            
            // Function to fix verification button handlers
            function fixVerificationButtonHandlers() {
                var buttons = document.querySelectorAll('.btn-verify-direct');
                console.log("Found " + buttons.length + " verification buttons to fix");
                
                buttons.forEach(function(btn, index) {
                    console.log("Setting up button #" + index);
                    
                    // Direct inline handler that uses window.showVerificationModal
                    var newHandler = 'try { window.showVerificationModal(this.getAttribute("data-order-id"), this.getAttribute("data-transaction-id")); return false; } catch(e) { console.error("Button click error:", e); alert("Error: " + e.message); return false; }';
                    
                    btn.setAttribute('onclick', newHandler);
                });
            }
            
            // Run the check immediately
            ensureRequiredFunctions();
            
            // Also run after a short delay in case other scripts are still loading
            setTimeout(ensureRequiredFunctions, 500);
            setTimeout(ensureRequiredFunctions, 1500);
        })();
    </script>
</asp:Content>

