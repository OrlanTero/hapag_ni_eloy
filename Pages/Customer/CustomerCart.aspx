<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerCart.aspx.vb" Inherits="Pages_Customer_CustomerCart" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" %>
<%@ MasterType VirtualPath="~/Pages/Customer/CustomerTemplate.master" %>
<%@ Register Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-container">
        <!-- Hidden Fields for JavaScript -->
        <asp:HiddenField ID="DeliveryFeeHidden" runat="server" Value="0" />
        <asp:HiddenField ID="DeliveryTypeHidden" runat="server" Value="standard" />
        <asp:HiddenField ID="ScheduledTimeHidden" runat="server" Value="" />
        <asp:HiddenField ID="DiscountIdHidden" runat="server" Value="0" />
        <asp:HiddenField ID="DiscountValueHidden" runat="server" Value="0" />
        <asp:HiddenField ID="DeliveryAddressHidden" runat="server" Value="" />

        <!-- Content Header -->
        <div class="content-header">
            <h1><i class="fas fa-shopping-cart"></i> My Cart</h1>
            <p>Review and manage your selected items</p>
        </div>

        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>

        <!-- Empty Cart Panel -->
        <asp:Panel ID="EmptyCartPanel" runat="server" CssClass="cart-container" Visible="false">
            <div class="empty-cart">
                <i class="fas fa-shopping-cart"></i>
                <h2>Your cart is empty</h2>
                <p>Browse our menu and add some delicious items!</p>
                <a href="CustomerMenu.aspx" class="browse-menu-btn">Browse Menu</a>
            </div>
        </asp:Panel>

        <!-- Cart Items Panel -->
        <asp:Panel ID="CartItemsPanel" runat="server" CssClass="cart-container">
            <asp:Repeater ID="CartRepeater" runat="server">
                <HeaderTemplate>
                    <div class="cart-header">
                        <div class="cart-item-details">Item Details</div>
                        <div class="cart-item-price">Price</div>
                        <div class="cart-item-quantity">Quantity</div>
                        <div class="cart-item-total">Total</div>
                        <div class="cart-item-actions">Actions</div>
                    </div>
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="cart-item">
                        <div class="cart-item-details">
                            <img src='<%# GetImageUrl(Eval("image").ToString()) %>' 
                                 alt='<%# Eval("name") %>' class="cart-item-image" 
                                 onerror="handleImageError(this)" />
                            <div class="cart-item-info">
                                <h3><%# Eval("name") %></h3>
                                <p class="item-description"><%# Eval("description") %></p>
                                <div class="item-meta">
                                    <span class="category-tag"><%# Eval("category") %></span>
                                    <span class="type-tag"><%# Eval("type") %></span>
                                </div>
                            </div>
                        </div>
                        <div class="cart-item-price">PHP <%# Format(CDec(Eval("price")), "0.00") %></div>
                        <div class="cart-item-quantity">
                            <div class="quantity-control">
                                <button type="button" class="quantity-btn minus" onclick="updateCartQuantity(this, '<%# Eval("cart_id") %>', -1)">-</button>
                                <input type="number" class="quantity-input" value='<%# Eval("quantity") %>' min="1" max="99" 
                                       onchange="updateCartQuantity(this, '<%# Eval("cart_id") %>', 0)" />
                                <button type="button" class="quantity-btn plus" onclick="updateCartQuantity(this, '<%# Eval("cart_id") %>', 1)">+</button>
                            </div>
                        </div>
                        <div class="cart-item-total">PHP <%# Format(CDec(Eval("price")) * CDec(Eval("quantity")), "0.00") %></div>
                        <div class="cart-item-actions">
                            <button type="button" class="remove-btn" onclick="removeCartItem('<%# Eval("cart_id") %>')">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- Cart Summary Section -->
            <asp:UpdatePanel ID="SummaryUpdatePanel" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <div class="cart-footer">
                        <div class="cart-summary">
                            <h3>Order Summary</h3>
                            <div class="summary-row">
                                <span>Subtotal:</span>
                                <span class="summary-amount">PHP <asp:Literal ID="CartSummarySubtotalLiteral" runat="server"></asp:Literal></span>
                            </div>
                            <div class="summary-row">
                                <span>Total Items:</span>
                                <span class="summary-amount"><asp:Literal ID="CartSummaryItemsLiteral" runat="server"></asp:Literal></span>
                            </div>
                            <asp:Panel ID="DiscountRow" runat="server" Visible="false" CssClass="summary-row discount-row">
                                <span>Discount:</span>
                                <span class="summary-amount discount-amount">-PHP <asp:Literal ID="DiscountAmountLiteral" runat="server"></asp:Literal></span>
                            </asp:Panel>
                            <asp:Panel ID="PromotionRow" runat="server" Visible="false" CssClass="summary-row promotion-row">
                                <span>Promotion:</span>
                                <span class="summary-amount promotion-amount">-PHP <asp:Literal ID="PromotionAmountLiteral" runat="server"></asp:Literal></span>
                            </asp:Panel>
                            <asp:Panel ID="DealRow" runat="server" Visible="false" CssClass="summary-row deal-row">
                                <span>Deal:</span>
                                <span class="summary-amount deal-amount">-PHP <asp:Literal ID="DealAmountLiteral" runat="server"></asp:Literal></span>
                            </asp:Panel>
                            <asp:Panel ID="TotalSavingsRow" runat="server" Visible="false" CssClass="summary-row total-savings-row">
                                <span><strong>Total Savings:</strong></span>
                                <span class="summary-amount total-savings-amount">-PHP <asp:Literal ID="TotalSavingsLiteral" runat="server"></asp:Literal></span>
                            </asp:Panel>
                            <div id="DeliveryRow" class="summary-row delivery-row">
                                <span>Delivery Fee:</span>
                                <span class="summary-amount" id="DeliveryFeeLiteral">PHP 0.00</span>
                            </div>
                            <div class="summary-row total">
                                <span>Grand Total:</span>
                                <span class="summary-amount grand-total">PHP <asp:Literal ID="CartSummaryTotalLiteral" runat="server"></asp:Literal></span>
                            </div>
                            <div class="recalculate-section">
                                <asp:Button ID="RecalculateButton" runat="server" Text="Recalculate Total" 
                                    CssClass="btn btn-sm btn-outline-secondary" OnClick="RecalculateButton_Click" />
                            </div>
                        </div>
                    </div>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="DeliveryFeeHidden" EventName="ValueChanged" />
                </Triggers>
            </asp:UpdatePanel>

            <!-- Discount and Delivery Options Section -->
            <div class="options-container">
                <!-- Promotions Section -->
                <div class="options-section promotions-section">
                    <h3>Active Promotions</h3>
                    <asp:DropDownList ID="PromotionDropDown" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="PromotionDropDown_SelectedIndexChanged">
                        <asp:ListItem Text="-- Select a Promotion --" Value="0" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                    <div class="promotion-info" id="PromotionInfo" runat="server" visible="false">
                        <p><strong>Promotion:</strong> <asp:Literal ID="PromotionNameLiteral" runat="server"></asp:Literal></p>
                        <p><asp:Literal ID="PromotionDescriptionLiteral" runat="server"></asp:Literal></p>
                        <p><strong>Value:</strong> <asp:Literal ID="PromotionValueLiteral" runat="server"></asp:Literal></p>
                    </div>
                    <asp:HiddenField ID="PromotionIdHidden" runat="server" Value="0" />
                    <asp:HiddenField ID="PromotionValueHidden" runat="server" Value="0" />
                </div>

                <!-- Deals Section -->
                <div class="options-section deals-section">
                    <h3>Special Deals</h3>
                    <asp:DropDownList ID="DealDropDown" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DealDropDown_SelectedIndexChanged">
                        <asp:ListItem Text="-- Select a Deal --" Value="0" Selected="True"></asp:ListItem>
                    </asp:DropDownList>
                    <div class="deal-info" id="DealInfo" runat="server" visible="false">
                        <p><strong>Deal:</strong> <asp:Literal ID="DealNameLiteral" runat="server"></asp:Literal></p>
                        <p><asp:Literal ID="DealDescriptionLiteral" runat="server"></asp:Literal></p>
                        <p><strong>Value:</strong> <asp:Literal ID="DealValueLiteral" runat="server"></asp:Literal></p>
                    </div>
                    <asp:HiddenField ID="DealIdHidden" runat="server" Value="0" />
                    <asp:HiddenField ID="DealValueHidden" runat="server" Value="0" />
                </div>

                <!-- Discount Section -->
                <div class="options-section discount-section">
                    <h3>Apply Discount</h3>
                    <div class="discount-selector">
                        <asp:DropDownList ID="DiscountDropDown" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="DiscountDropDown_SelectedIndexChanged">
                            <asp:ListItem Text="-- Select a Discount --" Value="0" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                        <div class="discount-info" id="DiscountInfo" runat="server" visible="false">
                            <p><strong>Discount:</strong> <asp:Literal ID="DiscountNameLiteral" runat="server"></asp:Literal></p>
                            <p><asp:Literal ID="DiscountDescriptionLiteral" runat="server"></asp:Literal></p>
                            <p><strong>Value:</strong> <asp:Literal ID="DiscountValueLiteral" runat="server"></asp:Literal></p>
                        </div>
                    </div>
                </div>
                
                <!-- Checkout Button -->
                <div class="checkout-section">
                    <asp:Button ID="CheckoutButton" runat="server" Text="Proceed to Checkout" CssClass="btn btn-primary" OnClick="CheckoutButton_Click" />
                </div>

                <!-- Delivery Options Section (Initially Hidden) -->
                <asp:Panel ID="DeliveryOptionsPanel" runat="server" Visible="false" CssClass="options-section delivery-section">
                    <h3>Delivery Details</h3>
                    
                    <!-- Address Selection -->
                    <div class="address-selection">
                        <h4>Select Delivery Address</h4>
                        <asp:RadioButtonList ID="AddressRadioList" runat="server" CssClass="address-radio-list" 
                            AutoPostBack="false" RepeatLayout="Flow" OnSelectedIndexChanged="AddressRadioList_SelectedIndexChanged">
                        </asp:RadioButtonList>
                        
                        <asp:Panel ID="NoAddressPanel" runat="server" Visible="false" CssClass="no-address">
                            <p>No saved addresses found. Please add a new delivery address below.</p>
                        </asp:Panel>
                        
                        <div class="address-actions">
                            <asp:LinkButton ID="ShowNewAddressButton" runat="server" CssClass="btn btn-secondary" OnClick="ShowNewAddressButton_Click">Add New Address</asp:LinkButton>
                        </div>
                    </div>
                    
                    <!-- New Address Form (Initially Hidden) -->
                    <asp:Panel ID="NewAddressPanel" runat="server" Visible="false" style="display: none;" CssClass="new-address-form">
                        <h4>Add New Address</h4>
                        <div class="form-group">
                            <label for="AddressNameTextBox">Address Name (e.g. Home, Office)</label>
                            <asp:TextBox ID="AddressNameTextBox" runat="server" CssClass="form-control" placeholder="Home, Office, etc."></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label for="RecipientNameTextBox">Recipient Name</label>
                            <asp:TextBox ID="RecipientNameTextBox" runat="server" CssClass="form-control" placeholder="Full Name"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RecipientNameValidator" runat="server" 
                                ControlToValidate="RecipientNameTextBox" 
                                ErrorMessage="Recipient name is required" 
                                Display="Dynamic" CssClass="text-danger"
                                ValidationGroup="AddressGroup"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="ContactNumberTextBox">Contact Number</label>
                            <asp:TextBox ID="ContactNumberTextBox" runat="server" CssClass="form-control" placeholder="Phone Number"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="ContactNumberValidator" runat="server" 
                                ControlToValidate="ContactNumberTextBox" 
                                ErrorMessage="Contact number is required" 
                                Display="Dynamic" CssClass="text-danger"
                                ValidationGroup="AddressGroup"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="AddressLineTextBox">Address Line</label>
                            <asp:TextBox ID="AddressLineTextBox" runat="server" CssClass="form-control" placeholder="Street, Building, etc."></asp:TextBox>
                            <asp:RequiredFieldValidator ID="AddressLineValidator" runat="server" 
                                ControlToValidate="AddressLineTextBox" 
                                ErrorMessage="Address is required" 
                                Display="Dynamic" CssClass="text-danger"
                                ValidationGroup="AddressGroup"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="CityTextBox">City</label>
                            <asp:TextBox ID="CityTextBox" runat="server" CssClass="form-control" placeholder="City"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="CityValidator" runat="server" 
                                ControlToValidate="CityTextBox" 
                                ErrorMessage="City is required" 
                                Display="Dynamic" CssClass="text-danger"
                                ValidationGroup="AddressGroup"></asp:RequiredFieldValidator>
                        </div>
                        <div class="form-group">
                            <label for="PostalCodeTextBox">Postal Code</label>
                            <asp:TextBox ID="PostalCodeTextBox" runat="server" CssClass="form-control" placeholder="Postal Code"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <asp:CheckBox ID="DefaultAddressCheckBox" runat="server" Text="Set as default address" CssClass="default-address-checkbox" />
                        </div>
                        <div class="address-form-actions">
                            <asp:Button ID="SaveAddressButton" runat="server" Text="Save Address" CssClass="btn btn-primary" OnClick="SaveAddressButton_Click" ValidationGroup="AddressGroup" />
                            <asp:Button ID="CancelAddressButton" runat="server" Text="Cancel" CssClass="btn btn-outline-secondary" OnClick="CancelAddressButton_Click" CausesValidation="false" />
                        </div>
                    </asp:Panel>

                    <!-- Delivery Type Selection -->
                    <div class="delivery-options">
                        <div class="delivery-option">
                            <input type="radio" id="standardDelivery" name="deliveryOption" value="standard" checked="checked" onchange="updateDeliveryFee(0)" />
                            <label for="standardDelivery">
                                <span class="delivery-name">Standard Delivery</span>
                                <span class="delivery-info">Regular delivery within 45-60 minutes</span>
                                <span class="delivery-fee">Free</span>
                            </label>
                        </div>
                        <div class="delivery-option">
                            <input type="radio" id="priorityDelivery" name="deliveryOption" value="priority" onchange="updateDeliveryFee(50)" />
                            <label for="priorityDelivery">
                                <span class="delivery-name">Priority Delivery</span>
                                <span class="delivery-info">Express delivery within 20-30 minutes</span>
                                <span class="delivery-fee">PHP 50.00</span>
                            </label>
                        </div>
                        <div class="delivery-option">
                            <input type="radio" id="scheduledDelivery" name="deliveryOption" value="scheduled" onchange="updateDeliveryFee(0)" />
                            <label for="scheduledDelivery">
                                <span class="delivery-name">Scheduled Delivery</span>
                                <span class="delivery-info">Choose your preferred delivery time</span>
                                <span class="delivery-fee">Free</span>
                            </label>
                        </div>
                        <div id="scheduledTimeContainer" style="display: none;" class="scheduled-time-container">
                            <label for="scheduledTime">Select Delivery Time:</label>
                            <input type="datetime-local" id="scheduledTime" class="form-control" />
                            <p class="note">*Schedule your delivery at least 1 hour in advance</p>
                        </div>
                    </div>

                    <!-- Payment Section -->
                    <div class="payment-section">
                        <h4>Payment Method</h4>
                        <div class="payment-options">
                            <div class="payment-option">
                                <input type="radio" id="cashPayment" name="paymentMethod" value="cash" checked="checked" />
                                <label for="cashPayment">
                                    <span class="payment-name">Cash on Delivery</span>
                                </label>
                            </div>
                            <div class="payment-option">
                                <input type="radio" id="gcashPayment" name="paymentMethod" value="gcash" />
                                <label for="gcashPayment">
                                    <span class="payment-name">GCash</span>
                                </label>
                            </div>
                        </div>

                        <!-- GCash Details (Initially Hidden) -->
                        <div id="gcashDetails" style="display: none;" class="gcash-details">
                            <div class="text-center mb-3">
                                <img src="../../Assets/Images/gcash.jpg" alt="GCash" class="img-fluid" style="max-width: 300px;" />
                            </div>
                            <div class="form-group">
                                <label for="referenceNumberInput">Reference Number:</label>
                                <asp:TextBox ID="ReferenceNumberTextBox" runat="server" CssClass="form-control" placeholder="Enter GCash reference number"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="senderNameInput">Sender Name:</label>
                                <asp:TextBox ID="SenderNameTextBox" runat="server" CssClass="form-control" placeholder="Enter sender's name"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label for="senderNumberInput">Sender Number:</label>
                                <asp:TextBox ID="SenderNumberTextBox" runat="server" CssClass="form-control" placeholder="Enter sender's number"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Place Order Button -->
                        <div class="place-order-section">
                            <asp:Button ID="PlaceOrderButton" runat="server" Text="Place Order" CssClass="btn btn-success" OnClick="PlaceOrderButton_Click" />
                        </div>
                    </div>
                </asp:Panel>
            </div>

            <div class="cart-actions">
                <asp:Button ID="ClearCartButton" runat="server" Text="Clear Cart" CssClass="clear-cart-btn" OnClick="ClearCartButton_Click" OnClientClick="return confirm('Are you sure you want to clear your cart?');" />
            </div>
        </asp:Panel>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay">
        <div class="loading-spinner"></div>
    </div>

    <!-- Payment Dialog -->
    <div id="paymentDialog" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Select Payment Method</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="payment-options">
                    <div class="payment-option">
                        <input type="radio" id="gcashOption" name="paymentMethod" value="gcash" onchange="toggleGcashFields()" />
                        <label for="gcashOption">
                            <img src="../../Assets/Images/gcash-logo.png" alt="GCash" class="payment-logo" onerror="handleImageError(this)" />
                            GCash
                        </label>
                    </div>
                    <div class="payment-option">
                        <input type="radio" id="cashOption" name="paymentMethod" value="cash" onchange="toggleGcashFields()" />
                        <label for="cashOption">
                            <img src="../../Assets/Images/cash-logo.png" alt="Cash" class="payment-logo" onerror="handleImageError(this)" />
                            Cash
                        </label>
                    </div>
                </div>

                <div id="gcashFields" style="display: none;">
                    <div class="text-center mb-3">
                        <img src="../../Assets/Images/gcash.jpg" alt="GCash" class="img-fluid" style="max-width: 300px;" />
                    </div>
                    <div class="form-group">
                        <label for="referenceNumberModal">Reference Number:</label>
                        <input type="text" id="referenceNumberModal" class="form-control" placeholder="Enter GCash reference number" />
                    </div>
                    <div class="form-group">
                        <label for="senderNameModal">Sender Name:</label>
                        <input type="text" id="senderNameModal" class="form-control" placeholder="Enter sender's name" />
                    </div>
                    <div class="form-group">
                        <label for="senderNumberModal">Sender Number:</label>
                        <input type="text" id="senderNumberModal" class="form-control" placeholder="Enter sender's number" />
                    </div>
                </div>

                <div class="order-summary">
                    <h3>Order Summary</h3>
                    <div class="summary-line">
                        <span>Subtotal:</span>
                        <span class="amount">PHP <asp:Literal ID="SubtotalLiteral" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-line" id="PaymentDiscountRow" runat="server" visible="false">
                        <span>Discount:</span>
                        <span class="amount discount-amount">-PHP <asp:Literal ID="PaymentDiscountLiteral" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-line">
                        <span>Delivery Fee:</span>
                        <span class="amount" id="PaymentDeliveryFeeLiteral">PHP 0.00</span>
                    </div>
                    <div class="summary-line">
                        <span>Total Items:</span>
                        <span class="amount"><asp:Literal ID="TotalItemsLiteral" runat="server"></asp:Literal></span>
                    </div>
                    <div class="summary-line delivery-info">
                        <span>Delivery Option:</span>
                        <span class="delivery-type" id="PaymentDeliveryTypeLiteral">Standard Delivery</span>
                    </div>
                    <div class="summary-line scheduled-time" id="PaymentScheduledTimeRow" style="display: none;">
                        <span>Scheduled For:</span>
                        <span class="scheduled-time" id="PaymentScheduledTimeLiteral"></span>
                    </div>
                    <div class="summary-line total">
                        <span>Total Amount:</span>
                        <span class="amount">PHP <asp:Literal ID="TotalAmountLiteral" runat="server"></asp:Literal></span>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn-secondary" onclick="closePaymentDialog()">Cancel</button>
                <button type="button" class="btn-primary" onclick="processPayment()">Confirm Payment</button>
            </div>
        </div>
    </div>

    <style type="text/css">
        .content-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
            width: 100%;
            box-sizing: border-box;
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

        .cart-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }

        .cart-header {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr 0.5fr;
            padding: 15px 20px;
            background: #f8f9fa;
            border-bottom: 1px solid #eee;
            font-weight: 600;
            color: #2C3E50;
        }

        .cart-item {
            display: grid;
            grid-template-columns: 3fr 1fr 1fr 1fr 0.5fr;
            padding: 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }

        .cart-item-details {
            display: flex;
            gap: 20px;
        }

        .cart-item-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 8px;
        }

        .cart-item-info h3 {
            margin: 0 0 8px 0;
            color: #2C3E50;
            font-size: 18px;
        }

        .item-description {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
        }

        .item-meta {
            display: flex;
            gap: 8px;
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
            gap: 8px;
            width: fit-content;
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

        .remove-btn {
            width: 32px;
            height: 32px;
            border: none;
            background-color: #dc3545;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }

        .remove-btn:hover {
            background-color: #c82333;
        }

        .cart-footer {
            padding: 20px;
            background: #f8f9fa;
        }

        .cart-summary {
            margin-bottom: 20px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            font-size: 16px;
            color: #2C3E50;
        }

        .summary-amount {
            font-weight: 600;
            color: #619F2B;
        }

        .cart-actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
        }

        .clear-cart-btn, .checkout-btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .clear-cart-btn {
            background-color: #6c757d;
            color: white;
        }

        .clear-cart-btn:hover {
            background-color: #5a6268;
        }

        .checkout-btn {
            background-color: #619F2B;
            color: white;
        }

        .checkout-btn:hover {
            background-color: #4F8022;
        }

        .empty-cart {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-cart i {
            font-size: 64px;
            color: #ddd;
            margin-bottom: 20px;
        }

        .empty-cart h2 {
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
            .cart-header {
                display: none;
            }

            .cart-item {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .cart-item-details {
                flex-direction: column;
            }

            .cart-item-image {
                width: 100%;
                height: 200px;
            }

            .cart-item-price,
            .cart-item-quantity,
            .cart-item-total {
                padding: 10px 0;
                border-top: 1px solid #eee;
            }

            .cart-item-actions {
                display: flex;
                justify-content: flex-end;
            }

            .cart-actions {
                flex-direction: column;
            }

            .clear-cart-btn,
            .checkout-btn {
                width: 100%;
            }
        }

        /* Payment Dialog Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1000;
        }

        .modal-content {
            position: relative;
            background-color: #fff;
            margin: 50px auto;
            padding: 0;
            width: 90%;
            max-width: 600px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .modal-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .modal-header h2 {
            margin: 0;
            color: #2C3E50;
            font-size: 24px;
        }

        .close {
            font-size: 28px;
            font-weight: bold;
            color: #666;
            cursor: pointer;
        }

        .close:hover {
            color: #000;
        }

        .modal-body {
            padding: 20px;
        }

        .payment-options {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }

        .payment-option {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            border: 2px solid #eee;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-option:hover {
            border-color: #619F2B;
        }

        .payment-option input[type="radio"] {
            margin: 0;
        }

        .payment-option label {
            display: flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            font-size: 16px;
            color: #2C3E50;
        }

        .payment-logo {
            width: 40px;
            height: 40px;
            object-fit: contain;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #2C3E50;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
        }

        .form-control:focus {
            border-color: #619F2B;
            outline: none;
        }

        .order-summary {
            margin-top: 20px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }

        .order-summary h3 {
            margin: 0 0 15px 0;
            color: #2C3E50;
            font-size: 18px;
        }

        .summary-line {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            color: #666;
        }

        .summary-line.total {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
            font-weight: 600;
            color: #2C3E50;
        }

        .modal-footer {
            padding: 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: flex-end;
            gap: 10px;
        }

        .btn-primary, .btn-secondary {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-primary {
            background-color: #619F2B;
            color: white;
        }

        .btn-primary:hover {
            background-color: #4F8022;
        }

        .btn-secondary {
            background-color: #e9ecef;
            color: #2C3E50;
        }

        .btn-secondary:hover {
            background-color: #dde2e6;
        }

        @media (max-width: 768px) {
            .modal-content {
                margin: 20px;
                width: auto;
            }

            .payment-options {
                flex-direction: column;
            }

            .payment-option {
                width: 100%;
            }
        }

        /* Discount and Delivery Options Styles */
        .options-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
            margin-bottom: 20px;
        }

        .options-section {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            flex: 1;
            min-width: 300px;
        }

        .options-section h3 {
            color: #2C3E50;
            margin-top: 0;
            margin-bottom: 15px;
            font-size: 18px;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        /* Discount Styles */
        .discount-selector {
            margin-bottom: 15px;
        }

        .discount-info {
            background-color: #f8f9fa;
            border-radius: 6px;
            padding: 12px;
            margin-top: 10px;
        }

        .discount-info p {
            margin: 5px 0;
            font-size: 14px;
        }

        .remove-discount-btn {
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 4px;
            margin-top: 8px;
            cursor: pointer;
            font-size: 13px;
        }

        .remove-discount-btn:hover {
            background-color: #c0392b;
        }

        /* Delivery Options Styles */
        .delivery-options {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .delivery-option {
            display: flex;
            align-items: flex-start;
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .delivery-option:hover {
            border-color: #3498db;
            background-color: #f0f7fb;
        }

        .delivery-option input[type="radio"] {
            margin-top: 3px;
            margin-right: 10px;
        }

        .delivery-option label {
            display: flex;
            flex-direction: column;
            width: 100%;
            cursor: pointer;
        }

        .delivery-name {
            font-weight: bold;
            color: #2C3E50;
            margin-bottom: 4px;
        }

        .delivery-info {
            font-size: 13px;
            color: #7f8c8d;
            margin-bottom: 4px;
        }

        .delivery-fee {
            font-weight: bold;
            color: #e74c3c;
        }

        .scheduled-time-container {
            margin-top: 10px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 6px;
        }

        .scheduled-time-container input {
            margin: 10px 0;
        }

        .scheduled-time-container .note {
            font-size: 12px;
            color: #7f8c8d;
            font-style: italic;
        }

        /* Order Totals Styles */
        .order-totals {
            min-width: 300px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 15px;
        }

        .grand-total {
            font-weight: bold;
            font-size: 18px;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }

        .discount-amount, .promotion-amount, .deal-amount {
            color: #27ae60 !important;
            font-weight: bold;
        }

        .summary-row.discount-row, .summary-row.promotion-row, .summary-row.deal-row {
            background-color: #f0fff4;
            padding: 8px 10px;
            border-radius: 6px;
            margin-bottom: 5px;
        }

        .summary-row.total {
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
            font-size: 18px;
        }

        .grand-total {
            color: #e74c3c !important;
            font-weight: bold;
            font-size: 18px;
        }

        .cart-summary h3 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #2C3E50;
            border-bottom: 1px solid #eee;
            padding-bottom: 10px;
        }

        .delivery-row {
            background-color: #f0f7fb;
            padding: 8px 10px;
            border-radius: 6px;
            margin-bottom: 5px;
            margin-top: 10px;
        }

        /* Responsive Styling */
        @media screen and (max-width: 768px) {
            .options-container {
                flex-direction: column;
            }
            
            .options-section {
                width: 100%;
            }
        }

        /* Address Selection Styles */
        .address-radio-list {
            margin-bottom: 20px;
        }
        
        .address-radio-list label {
            display: block;
            padding: 15px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .address-radio-list input[type="radio"] {
            margin-right: 10px;
        }
        
        .address-radio-list label:hover {
            border-color: #4CAF50;
            background-color: #f9f9f9;
        }
        
        .address-radio-list input[type="radio"]:checked + label {
            border-color: #4CAF50;
            background-color: #f0f9f0;
        }
        
        .address-actions {
            margin-top: 15px;
            margin-bottom: 20px;
        }
        
        /* New Address Form Styles */
        .new-address-form {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
        }
        
        .new-address-form h4 {
            margin-top: 0;
            margin-bottom: 15px;
            color: #4CAF50;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        
        .default-address-checkbox {
            margin-top: 10px;
        }
        
        .address-form-actions {
            margin-top: 20px;
            display: flex;
            gap: 10px;
        }
        
        .text-danger {
            color: #ff0000;
            font-size: 12px;
            margin-top: 5px;
        }

        .total-savings-row {
            background-color: #f0fff4;
            padding: 10px;
            border-radius: 6px;
            margin: 10px 0;
            border: 1px dashed #27ae60;
        }

        .total-savings-amount {
            color: #27ae60 !important;
            font-weight: bold;
            font-size: 16px;
        }
        
        .discount-amount, .promotion-amount, .deal-amount {
            color: #27ae60 !important;
            font-weight: bold;
        }

        .recalculate-section {
            text-align: right;
            margin-top: 10px;
        }

        .recalculate-section .btn {
            font-size: 14px;
            padding: 5px 10px;
        }
    </style>

    <script type="text/javascript">
        function updateCartQuantity(element, cartId, change) {
            try {
                var input = element.tagName.toLowerCase() === 'input' ? element : element.parentElement.querySelector('.quantity-input');
                var currentValue = parseInt(input.value) || 1;
                var newValue = change === 0 ? currentValue : currentValue + change;
                
                // Ensure value is between 1 and 99
                newValue = Math.max(1, Math.min(99, newValue));
                
                // Show loading overlay
                document.querySelector('.loading-overlay').style.display = 'flex';

                // Call server-side method to update quantity
                PageMethods.UpdateCartQuantity(cartId, newValue, function(result) {
                    if (result.startsWith('Success')) {
                        // Refresh the page to show updated cart
                        location.reload();
                    } else {
                        // Show error message
                        showAlert(result, false);
                        // Reset the input value
                        input.value = currentValue;
                        // Hide loading overlay
                        document.querySelector('.loading-overlay').style.display = 'none';
                    }
                }, function(error) {
                    showAlert('Error updating quantity: ' + error.get_message(), false);
                    input.value = currentValue;
                    document.querySelector('.loading-overlay').style.display = 'none';
                });
            } catch (error) {
                console.error('Error updating quantity:', error);
                document.querySelector('.loading-overlay').style.display = 'none';
            }
        }

        function removeCartItem(cartId) {
            if (confirm('Are you sure you want to remove this item from your cart?')) {
                // Show loading overlay
                document.querySelector('.loading-overlay').style.display = 'flex';

                // Call server-side method to remove item
                PageMethods.RemoveCartItem(cartId, function(result) {
                    if (result.startsWith('Success')) {
                        // Refresh the page to show updated cart
                        location.reload();
                    } else {
                        // Show error message
                        showAlert(result, false);
                        // Hide loading overlay
                        document.querySelector('.loading-overlay').style.display = 'none';
                    }
                }, function(error) {
                    showAlert('Error removing item: ' + error.get_message(), false);
                    document.querySelector('.loading-overlay').style.display = 'none';
                });
            }
        }

        function showAlert(message, isSuccess) {
            var alertDiv = document.getElementById('<%= alertMessage.ClientID %>');
            var alertLiteral = document.getElementById('<%= AlertLiteral.ClientID %>');

            if (alertDiv && alertLiteral) {
                alertDiv.style.display = 'block';
                alertDiv.className = 'alert-message ' + (isSuccess ? 'alert-success' : 'alert-danger');
                alertLiteral.textContent = message;

                setTimeout(function() {
                    alertDiv.style.display = 'none';
                }, 3000);
            } else {
                alert(message);
            }
        }

        // Payment Dialog Functions
        function showPaymentDialog() {
            document.getElementById('paymentDialog').style.display = 'block';
            // Reset form
            document.getElementById('gcashOption').checked = false;
            document.getElementById('cashOption').checked = false;
            document.getElementById('gcashFields').style.display = 'none';
            if (document.getElementById('referenceNumber')) {
                document.getElementById('referenceNumber').value = '';
                document.getElementById('senderName').value = '';
                document.getElementById('senderNumber').value = '';
            }
        }

        function closePaymentDialog() {
            document.getElementById('paymentDialog').style.display = 'none';
        }

        function toggleGcashFields() {
            var gcashFields = document.getElementById('gcashFields');
            var isGcash = document.getElementById('gcashOption').checked;
            gcashFields.style.display = isGcash ? 'block' : 'none';
            
            // Clear the fields if not using GCash
            if (!isGcash) {
                var referenceNumberInput = document.getElementById('<%= ReferenceNumberTextBox.ClientID %>');
                var senderNameInput = document.getElementById('<%= SenderNameTextBox.ClientID %>');
                var senderNumberInput = document.getElementById('<%= SenderNumberTextBox.ClientID %>');
                
                if (referenceNumberInput) referenceNumberInput.value = '';
                if (senderNameInput) senderNameInput.value = '';
                if (senderNumberInput) senderNumberInput.value = '';
            }
        }

        function updateDeliveryFee(fee) {
            // Update hidden field
            const deliveryFeeHidden = document.getElementById('<%= DeliveryFeeHidden.ClientID %>');
            deliveryFeeHidden.value = fee;
            
            // Update the fee display
            const deliveryFeeLiteral = document.getElementById('DeliveryFeeLiteral');
            deliveryFeeLiteral.textContent = 'PHP ' + fee.toFixed(2);
            
            // Update the grand total by adding to current subtotal
            const subtotalText = document.querySelector('.summary-amount').textContent.replace('PHP ', '');
            const subtotal = parseFloat(subtotalText) || 0;
            
            // Get discount amount if visible
            let discountAmount = 0;
            const discountRow = document.getElementById('<%= DiscountRow.ClientID %>');
            if (discountRow && window.getComputedStyle(discountRow).display !== 'none') {
                const discountText = document.querySelector('.discount-amount').textContent.replace('-PHP ', '');
                discountAmount = parseFloat(discountText) || 0;
            }
            
            // Get promotion amount if visible
            let promotionAmount = 0;
            const promotionRow = document.getElementById('<%= PromotionRow.ClientID %>');
            if (promotionRow && window.getComputedStyle(promotionRow).display !== 'none') {
                const promotionText = document.querySelector('.promotion-amount').textContent.replace('-PHP ', '');
                promotionAmount = parseFloat(promotionText) || 0;
            }
            
            // Get deal amount if visible
            let dealAmount = 0;
            const dealRow = document.getElementById('<%= DealRow.ClientID %>');
            if (dealRow && window.getComputedStyle(dealRow).display !== 'none') {
                const dealText = document.querySelector('.deal-amount').textContent.replace('-PHP ', '');
                dealAmount = parseFloat(dealText) || 0;
            }
            
            // Calculate grand total
            const grandTotal = subtotal - discountAmount - promotionAmount - dealAmount + fee;
            
            // Update grand total display
            const grandTotalDisplay = document.querySelector('.grand-total');
            if (grandTotalDisplay) {
                grandTotalDisplay.textContent = 'PHP ' + grandTotal.toFixed(2);
            }
        }
        
        // Override processPayment to include delivery and discount info
        function processPayment() {
            // Get selected payment method
            var paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
            if (!paymentMethod) {
                showAlert("Please select a payment method", "warning");
                return;
            }
            
            // Show loading spinner
            document.querySelector('.loading-overlay').style.display = 'flex';
            
            // Prepare payment data
            var paymentData = {
                method: paymentMethod.value,
                deliveryType: document.getElementById('<%= DeliveryTypeHidden.ClientID %>').value,
                deliveryFee: parseFloat(document.getElementById('<%= DeliveryFeeHidden.ClientID %>').value) || 0,
                discountId: parseInt(document.getElementById('<%= DiscountIdHidden.ClientID %>').value) || 0,
                scheduledTime: document.getElementById('<%= ScheduledTimeHidden.ClientID %>').value || null
            };
            
            // Add GCash details if selected
            if (paymentMethod.value === 'gcash') {
                // Try to get values from the main form controls first (server controls)
                var referenceNumberInput = document.getElementById('<%= ReferenceNumberTextBox.ClientID %>');
                var senderNameInput = document.getElementById('<%= SenderNameTextBox.ClientID %>');
                var senderNumberInput = document.getElementById('<%= SenderNumberTextBox.ClientID %>');
                
                var referenceNumber = referenceNumberInput ? referenceNumberInput.value : '';
                var senderName = senderNameInput ? senderNameInput.value : '';
                var senderNumber = senderNumberInput ? senderNumberInput.value : '';
                
                // If the main form fields are empty, try to get values from the modal
                if (!referenceNumber && !senderName && !senderNumber) {
                    referenceNumber = document.getElementById('referenceNumberModal').value;
                    senderName = document.getElementById('senderNameModal').value;
                    senderNumber = document.getElementById('senderNumberModal').value;
                    
                    // If using modal values, copy them to the server controls for form submission
                    if (referenceNumberInput) referenceNumberInput.value = referenceNumber;
                    if (senderNameInput) senderNameInput.value = senderName;
                    if (senderNumberInput) senderNumberInput.value = senderNumber;
                }
                
                if (!referenceNumber || !senderName || !senderNumber) {
                    document.querySelector('.loading-overlay').style.display = 'none';
                    showAlert("Please enter all GCash details", "warning");
                    return;
                }
                
                paymentData.referenceNumber = referenceNumber;
                paymentData.senderName = senderName;
                paymentData.senderNumber = senderNumber;
            }
            
            // Convert payment data to JSON
            var paymentDataJson = JSON.stringify(paymentData);
            
            // Call the server-side method using PageMethods
            PageMethods.ProcessPayment(paymentDataJson, processPaymentCallback, function(error) {
                document.querySelector('.loading-overlay').style.display = 'none';
                showAlert("Error processing payment: " + error.get_message(), "error");
            });
        }
        
        function processPaymentCallback(response) {
            // Hide loading spinner
            document.querySelector('.loading-overlay').style.display = 'none';
            
            if (response.startsWith("Success")) {
                showAlert(response, "success");
                closePaymentDialog();
                
                // Redirect to orders page after 3 seconds
                setTimeout(function() {
                    window.location.href = "CustomerOrders.aspx";
                }, 3000);
            } else {
                showAlert(response, "error");
            }
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById('paymentDialog');
            if (event.target == modal) {
                closePaymentDialog();
            }
        }

        // Delivery options functionality
        document.addEventListener('DOMContentLoaded', function() {
            // Scheduled delivery time handling
            const scheduledDelivery = document.getElementById('scheduledDelivery');
            const standardDelivery = document.getElementById('standardDelivery');
            const priorityDelivery = document.getElementById('priorityDelivery');
            const scheduledTimeContainer = document.getElementById('scheduledTimeContainer');
            const scheduledTime = document.getElementById('scheduledTime');
            const scheduledTimeHidden = document.getElementById('<%= ScheduledTimeHidden.ClientID %>');
            const deliveryTypeHidden = document.getElementById('<%= DeliveryTypeHidden.ClientID %>');
            const paymentScheduledTimeRow = document.getElementById('PaymentScheduledTimeRow');
            const paymentScheduledTimeLiteral = document.getElementById('PaymentScheduledTimeLiteral');
            const paymentDeliveryTypeLiteral = document.getElementById('PaymentDeliveryTypeLiteral');
            
            if (scheduledDelivery) {
                scheduledDelivery.addEventListener('change', function() {
                    scheduledTimeContainer.style.display = 'block';
                    deliveryTypeHidden.value = 'scheduled';
                    paymentDeliveryTypeLiteral.textContent = 'Scheduled Delivery';
                    
                    // Set minimum datetime to 1 hour from now
                    const now = new Date();
                    now.setHours(now.getHours() + 1);
                    const minDateTime = now.toISOString().slice(0, 16);
                    scheduledTime.setAttribute('min', minDateTime);
                    
                    if (scheduledTime.value) {
                        paymentScheduledTimeRow.style.display = 'flex';
                        paymentScheduledTimeLiteral.textContent = formatScheduledTime(scheduledTime.value);
                    }
                });
            }
            
            if (standardDelivery) {
                standardDelivery.addEventListener('change', function() {
                    scheduledTimeContainer.style.display = 'none';
                    deliveryTypeHidden.value = 'standard';
                    paymentDeliveryTypeLiteral.textContent = 'Standard Delivery';
                    paymentScheduledTimeRow.style.display = 'none';
                });
            }
            
            if (priorityDelivery) {
                priorityDelivery.addEventListener('change', function() {
                    scheduledTimeContainer.style.display = 'none';
                    deliveryTypeHidden.value = 'priority';
                    paymentDeliveryTypeLiteral.textContent = 'Priority Delivery';
                    paymentScheduledTimeRow.style.display = 'none';
                });
            }
            
            if (scheduledTime) {
                scheduledTime.addEventListener('change', function() {
                    scheduledTimeHidden.value = this.value;
                    if (this.value) {
                        paymentScheduledTimeRow.style.display = 'flex';
                        paymentScheduledTimeLiteral.textContent = formatScheduledTime(this.value);
                    } else {
                        paymentScheduledTimeRow.style.display = 'none';
                    }
                });
            }
        });
        
        function formatScheduledTime(dateTimeString) {
            const dateTime = new Date(dateTimeString);
            return dateTime.toLocaleString('en-US', { 
                weekday: 'short',
                month: 'short', 
                day: 'numeric', 
                year: 'numeric',
                hour: 'numeric', 
                minute: '2-digit',
                hour12: true
            });
        }

        function updateSelectedAddress(address) {
            document.getElementById('DeliveryAddressHidden').value = address;
        }

        function showNewAddressForm() {
            var newAddressPanel = document.getElementById('<%= NewAddressPanel.ClientID %>');
            if (newAddressPanel) {
                newAddressPanel.style.display = 'block';
            }
        }

        function hideNewAddressForm() {
            var newAddressPanel = document.getElementById('<%= NewAddressPanel.ClientID %>');
            if (newAddressPanel) {
                newAddressPanel.style.display = 'none';
            }
        }

        function toggleScheduledTime() {
            var scheduledDelivery = document.getElementById('scheduledDelivery');
            var container = document.getElementById('scheduledTimeContainer');
            container.style.display = scheduledDelivery.checked ? 'block' : 'none';
        }

        function toggleGCashDetails() {
            var gcashPayment = document.getElementById('gcashPayment');
            var details = document.getElementById('gcashDetails');
            details.style.display = gcashPayment.checked ? 'block' : 'none';
            
            // Clear the fields if not using GCash
            if (!gcashPayment.checked) {
                var referenceNumberInput = document.getElementById('<%= ReferenceNumberTextBox.ClientID %>');
                var senderNameInput = document.getElementById('<%= SenderNameTextBox.ClientID %>');
                var senderNumberInput = document.getElementById('<%= SenderNumberTextBox.ClientID %>');
                
                if (referenceNumberInput) referenceNumberInput.value = '';
                if (senderNameInput) senderNameInput.value = '';
                if (senderNumberInput) senderNumberInput.value = '';
            }
        }

        // Add event listeners when the page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Listen for delivery option changes
            document.querySelectorAll('input[name="deliveryOption"]').forEach(function(radio) {
                radio.addEventListener('change', function() {
                    if (this.value === 'scheduled') {
                        toggleScheduledTime();
                    }
                });
            });

            // Listen for payment method changes
            document.querySelectorAll('input[name="paymentMethod"]').forEach(function(radio) {
                radio.addEventListener('change', function() {
                    if (this.value === 'gcash') {
                        toggleGCashDetails();
                    }
                });
            });
        });

        // Add a function to handle image loading errors
        function handleImageError(img) {
            // If the image fails to load, use a default image or hide it
            img.onerror = null; // Prevent infinite loop
            img.src = '<%=ResolveUrl("~/Assets/Images/default-food.jpg") %>'; // Use an existing default image
        }
    </script>
</asp:Content>
