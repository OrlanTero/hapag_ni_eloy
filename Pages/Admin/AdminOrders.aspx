<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminOrders.aspx.vb" Inherits="Pages_Admin_AdminOrders" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Manage Orders</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <style type="text/css">
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
            margin-bottom: 10px;
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
        
        .order-details {
            margin-top: 15px;
        }
        
        .order-items {
            margin-bottom: 15px;
        }
        
        .order-item {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .item-name {
            font-weight: 500;
        }
        
        .item-quantity {
            color: #666;
        }
        
        .item-price {
            font-weight: bold;
        }
        
        .order-total {
            text-align: right;
            margin-top: 15px;
            font-weight: bold;
            font-size: 18px;
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
        
        .btn-process:hover, .btn-complete:hover, .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
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
                    
        <!-- Search and Filter Controls -->
        <div class="search-filter-container">
            <asp:TextBox ID="SearchBox" runat="server" CssClass="search-box" placeholder="Search orders..."></asp:TextBox>
            <asp:DropDownList ID="StatusDropDown" runat="server" CssClass="status-dropdown">
                <asp:ListItem Text="All Status" Value=""></asp:ListItem>
                <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                <asp:ListItem Text="Processing" Value="Processing"></asp:ListItem>
                <asp:ListItem Text="Completed" Value="Completed"></asp:ListItem>
                <asp:ListItem Text="Cancelled" Value="Cancelled"></asp:ListItem>
            </asp:DropDownList>
                    </div>
                    
                    <div class="orders-container">
            <asp:ListView ID="OrdersListView" runat="server">
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
                        
                        <div class="order-details">
                                    <div class="order-items">
                                <asp:Repeater ID="OrderItemsRepeater" runat="server" DataSource='<%# GetOrderItems(Eval("order_id")) %>'>
                                            <ItemTemplate>
                                                <div class="order-item">
                                            <span class="item-name"><%# Eval("item_name") %></span>
                                            <span class="item-quantity">x<%# Eval("quantity") %></span>
                                            <span class="item-price">PHP <%# Format(Eval("price"), "0.00") %></span>
                            </div>
                                            </ItemTemplate>
                                        </asp:Repeater>
                        </div>
                        
                                    <div class="order-total">
                                Total: PHP <%# Format(Eval("total_amount"), "0.00") %>
                </div>
                
                            <div class="order-actions">
                                <asp:Button ID="ProcessButton" runat="server" Text="Process" CssClass="action-btn btn-process" 
                                    CommandName="Process" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Pending" %>' />
                                    
                                <asp:Button ID="CompleteButton" runat="server" Text="Complete" CssClass="action-btn btn-complete" 
                                    CommandName="Complete" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Processing" %>' />
                                    
                                <asp:Button ID="CancelButton" runat="server" Text="Cancel" CssClass="action-btn btn-cancel" 
                                    CommandName="Cancel" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Pending" %>' />
                    </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:ListView>
        </div>
        
        <!-- Delivery Information Modal -->
        <asp:Panel ID="DeliveryModal" runat="server" CssClass="modal" Visible="false">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Update Delivery Information</h2>
                    <button type="button" class="close-btn" onclick="closeModal()">&times;</button>
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
                        <label>Delivery Notes</label>
                        <asp:TextBox ID="DeliveryNotesTextBox" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="SaveDeliveryButton" runat="server" Text="Save" CssClass="btn btn-primary" OnClick="SaveDeliveryButton_Click" />
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
                </div>
            </div>
        </asp:Panel>
        </div>

    <script type="text/javascript">
        function closeModal() {
            document.getElementById('<%= DeliveryModal.ClientID %>').style.display = 'none';
        }
    </script>
</asp:Content>

