<%@ Page Language="VB" AutoEventWireup="true" CodeFile="AdminOrders.aspx.vb" Inherits="Pages_Admin_AdminOrders" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Manage Orders</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" />
    <!-- Add jQuery reference -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <!-- Add external stylesheets and scripts -->
    <link rel="stylesheet" href="../../StyleSheets/AdminOrders.css" />
    <script src="../../Scripts/AdminOrders.js"></script>
    <script src="../../Scripts/PaymentVerification.js"></script>
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
                                    CommandName="ViewDetails" CommandArgument='<%# Eval("order_id") %>'
                                    data-order-id='<%# Eval("order_id") %>'>
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
                                        Visible='<%# Eval("transaction_status").ToString() <> "Verified" AndAlso Eval("transaction_status").ToString() <> "Rejected" AndAlso Eval("status").ToString() <> "Completed" %>'>
                                        
                                        <!-- PAYMENT VERIFICATION BUTTON -->
                                        <button type="button" 
                                            class="action-btn btn-verify-direct" 
                                            data-order-id='<%# Eval("order_id") %>' 
                                            data-transaction-id='<%# Eval("transaction_id") %>'>
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
                                CommandName="UpdateStatus" CommandArgument='<%# Eval("order_id") %>' 
                                Visible='<%# Eval("status").ToString() <> "Completed" %>' />
                                
                            <asp:Button ID="DeliveryButton" runat="server" Text="Update Delivery" CssClass="action-btn btn-delivery" 
                                CommandName="SetDelivery" CommandArgument='<%# Eval("order_id") %>' 
                                Visible='<%# Eval("status").ToString() <> "Cancelled" And Eval("status").ToString() <> "Completed" %>' />
                                    
                                <asp:Button ID="CompleteButton" runat="server" Text="Complete" CssClass="action-btn btn-complete" 
                                    CommandName="Complete" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Processing" %>' />
                                    
                                <asp:Button ID="CancelButton" runat="server" Text="Cancel" CssClass="action-btn btn-cancel" 
                                    CommandName="Cancel" CommandArgument='<%# Eval("order_id") %>' 
                                    Visible='<%# Eval("status").ToString() = "Pending" %>' />

                                <asp:Button ID="PrintButton" runat="server" Text="Print Receipt" CssClass="action-btn btn-print" 
                                    CommandName="PrintReceipt" CommandArgument='<%# Eval("order_id") %>' />
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
        
        <asp:Panel ID="PaymentVerificationModal" runat="server" CssClass="modal payment-verification-modal" ClientIDMode="Static" Style="display:none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h2>Verify Payment</h2>
                    <button type="button" class="close-btn" onclick="document.getElementById('PaymentVerificationModal').style.display='none';">&times;</button>
                </div>
                <div class="modal-body">
                    <asp:HiddenField ID="PaymentOrderId" runat="server" ClientIDMode="Static" />
                    <asp:HiddenField ID="PaymentTransactionId" runat="server" ClientIDMode="Static" />
                    
                    <div class="payment-verification-container">
                        <div class="info-section">
                            <h4>Order Information</h4>
                            <div class="info-row">
                                <div class="info-label">Order ID:</div>
                                <div class="info-value" id="OrderIdLiteral">Loading...</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Customer:</div>
                                <div class="info-value" id="CustomerNameLiteral">Loading...</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Total Amount:</div>
                                <div class="info-value" id="OrderAmountLiteral">Loading...</div>
                            </div>
                        </div>
                        
                        <div class="info-section">
                            <h4>Payment Details</h4>
                            <div class="info-row">
                                <div class="info-label">Payment Method:</div>
                                <div class="info-value" id="PaymentMethodLiteral">Loading...</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Reference Number:</div>
                                <div class="info-value" id="ReferenceNumberLiteral">Loading...</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Sender Name:</div>
                                <div class="info-value" id="SenderNameLiteral">Loading...</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Sender Number:</div>
                                <div class="info-value" id="SenderNumberLiteral">Loading...</div>
                        </div>
                            <div class="info-row">
                                <div class="info-label">Transaction Date:</div>
                                <div class="info-value" id="TransactionDateLiteral">Loading...</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">Status:</div>
                                <div class="info-value" id="TransactionStatusLiteral">Loading...</div>
                            </div>
                            </div>
                    
                        <div class="verification-message">
                            <p>Please verify the payment details before approving. Once approved, the order status will be updated and the order will be ready for processing.</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <asp:Button ID="ConfirmPaymentButton" runat="server" Text="Confirm Payment" CssClass="btn btn-success" OnClick="ConfirmPaymentButton_Click" />
                    <asp:Button ID="RejectPaymentButton" runat="server" Text="Reject Payment" CssClass="btn btn-danger" OnClick="RejectPaymentButton_Click" />
                    <asp:Button ID="CancelPaymentVerificationButton" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="ClosePaymentModalButton_Click" />
                </div>
            </div>
        </asp:Panel>
    </div>
</asp:Content>

