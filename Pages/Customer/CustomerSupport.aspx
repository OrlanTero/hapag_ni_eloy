<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerSupport.aspx.vb" Inherits="Pages_Customer_CustomerSupport" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style type="text/css">
        .support-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .section-title {
            margin-bottom: 20px;
            color: #2C3E50;
        }
        
        .section-title h1 {
            font-size: 28px;
            margin-bottom: 5px;
        }
        
        .section-title p {
            color: #7f8c8d;
            font-size: 16px;
        }
        
        .support-tickets {
            display: flex;
            margin-bottom: 30px;
        }
        
        .support-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            flex: 1;
            margin-right: 20px;
            overflow: hidden;
        }
        
        .support-card:last-child {
            margin-right: 0;
        }
        
        .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .card-header h2 {
            margin: 0;
            font-size: 18px;
            color: #2C3E50;
        }
        
        .card-header .btn-new {
            background-color: #619F2B;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .card-header .btn-new:hover {
            background-color: #548c25;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .ticket-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .ticket-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .ticket-item:last-child {
            border-bottom: none;
        }
        
        .ticket-item:hover {
            background-color: #f8f9fa;
        }
        
        .ticket-item.active {
            background-color: #EBF7E3;
            border-left: 3px solid #619F2B;
        }
        
        .ticket-item h3 {
            margin: 0 0 5px;
            color: #2C3E50;
            font-size: 16px;
            display: flex;
            justify-content: space-between;
        }
        
        .ticket-item p {
            margin: 0 0 5px;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .ticket-item .meta {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #95a5a6;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px 20px;
        }
        
        .empty-state i {
            color: #619F2B;
            margin-bottom: 20px;
            opacity: 0.7;
            font-size: 36px;
        }
        
        .empty-state h3 {
            color: #2C3E50;
            margin-bottom: 15px;
        }
        
        .empty-state p {
            color: #7f8c8d;
            max-width: 400px;
            margin: 0 auto 15px;
        }
        
        .ticket-details {
            height: 400px;
            display: flex;
            flex-direction: column;
        }
        
        .new-ticket-form {
            margin-top: 20px;
        }
        
        .form-group {
            margin-bottom: 15px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #2C3E50;
            font-weight: 600;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #619F2B;
            outline: none;
        }
        
        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        
        .btn {
            padding: 10px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            border: none;
        }
        
        .btn-primary {
            background-color: #619F2B;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #548c25;
        }
        
        .btn-secondary {
            background-color: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #7f8c8d;
        }
        
        .chat-container {
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        
        .chat-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fa;
        }
        
        .chat-header h3 {
            margin: 0;
            font-size: 16px;
            color: #2C3E50;
        }
        
        .chat-header p {
            margin: 5px 0 0;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .chat-body {
            flex: 1;
            overflow-y: auto;
            padding: 15px;
        }
        
        .message {
            display: flex;
            margin-bottom: 15px;
        }
        
        .message.sent {
            justify-content: flex-end;
        }
        
        .message.received {
            justify-content: flex-start;
        }
        
        .message .bubble {
            max-width: 70%;
            padding: 12px 15px;
            border-radius: 18px;
            position: relative;
        }
        
        .message.sent .bubble {
            background-color: #DCF8C6;
            border-bottom-right-radius: 5px;
        }
        
        .message.received .bubble {
            background-color: #f1f0f0;
            border-bottom-left-radius: 5px;
        }
        
        .message .bubble p {
            margin: 0;
            word-break: break-word;
        }
        
        .message .bubble .meta {
            font-size: 12px;
            color: #95a5a6;
            margin-top: 5px;
            text-align: right;
        }
        
        .message .bubble .sender {
            font-weight: bold;
            color: #2C3E50;
            margin-bottom: 5px;
        }
        
        .chat-footer {
            padding: 15px;
            border-top: 1px solid #eee;
            display: flex;
            align-items: center;
        }
        
        .chat-footer .input-container {
            flex: 1;
            display: flex;
            border: 1px solid #ddd;
            border-radius: 20px;
            overflow: hidden;
            padding: 0 15px;
            align-items: center;
        }
        
        .chat-footer textarea {
            flex: 1;
            border: none;
            outline: none;
            padding: 10px 0;
            resize: none;
            height: 40px;
            min-height: 40px;
        }
        
        .chat-footer .send-btn {
            background-color: #619F2B;
            color: white;
            border: none;
            width: 36px;
            height: 36px;
            border-radius: 50%;
            margin-left: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .chat-footer .send-btn:hover {
            background-color: #548c25;
        }
        
        .badge {
            background-color: #e74c3c;
            color: white;
            border-radius: 50%;
            padding: 2px 6px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .status.open {
            background-color: #3498db;
            color: white;
        }
        
        .status.in-progress {
            background-color: #f39c12;
            color: white;
        }
        
        .status.closed {
            background-color: #7f8c8d;
            color: white;
        }
        
        .faq-section {
            margin-top: 30px;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .faq-section h2 {
            margin-top: 0;
            color: #2C3E50;
        }
        
        .faq-item {
            margin-bottom: 20px;
        }
        
        .faq-question {
            font-weight: 600;
            color: #2C3E50;
            margin-bottom: 8px;
        }
        
        .faq-answer {
            color: #7f8c8d;
        }
        
        /* Responsive adjustments */
        @media (max-width: 768px) {
            .support-tickets {
                flex-direction: column;
            }
            
            .support-card {
                margin-right: 0;
                margin-bottom: 20px;
            }
            
            .support-card:last-child {
                margin-bottom: 0;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="support-container">
        <!-- Title and description -->
        <div class="section-title">
            <h1>Customer Support</h1>
            <p>Get help with your orders, reservations, or any other questions</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <!-- Support Tickets Section -->
        <div class="support-tickets">
            <!-- Left panel for ticket list -->
            <div class="support-card">
                <div class="card-header">
                    <h2>My Support Tickets</h2>
                    <asp:Button ID="NewTicketBtn" runat="server" Text="New Ticket" CssClass="btn-new" OnClick="NewTicketBtn_Click" />
                </div>
                <div class="card-body">
                    <asp:Panel ID="TicketListPanel" runat="server">
                        <asp:Repeater ID="TicketRepeater" runat="server" OnItemCommand="TicketRepeater_ItemCommand">
                            <HeaderTemplate>
                                <ul class="ticket-list">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li class="ticket-item <%# If(Convert.ToInt32(Eval("ticket_id")) = Convert.ToInt32(Request.QueryString("id")), "active", "") %>">
                                    <asp:LinkButton ID="SelectTicketBtn" runat="server" CommandName="SelectTicket" CommandArgument='<%# Eval("ticket_id") %>' 
                                        Style="display:block; text-decoration:none; color:inherit;">
                                        <h3>
                                            <%# Eval("subject") %>
                                            <%# If(Convert.ToInt32(Eval("unread_count")) > 0, "<span class='badge'>" & Eval("unread_count") & "</span>", "") %>
                                        </h3>
                                        <div class="meta">
                                            <span class="status <%# GetStatusClass(Eval("status").ToString()) %>"><%# Eval("status") %></span>
                                            <span><%# FormatDate(Eval("last_updated")) %></span>
                                        </div>
                                    </asp:LinkButton>
                                </li>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            </FooterTemplate>
                        </asp:Repeater>
                        
                        <asp:Panel ID="NoTicketsPanel" runat="server" CssClass="empty-state" Visible="false">
                            <i class="fas fa-ticket-alt"></i>
                            <h3>No Support Tickets</h3>
                            <p>You haven't created any support tickets yet.</p>
                            <asp:Button ID="CreateFirstTicketBtn" runat="server" Text="Create Your First Ticket" CssClass="btn btn-primary" OnClick="NewTicketBtn_Click" />
                        </asp:Panel>
                    </asp:Panel>
                    
                    <asp:Panel ID="NewTicketPanel" runat="server" Visible="false">
                        <h3>Create New Support Ticket</h3>
                        <div class="new-ticket-form">
                            <div class="form-group">
                                <label for="<%= SubjectTxt.ClientID %>">Subject</label>
                                <asp:TextBox ID="SubjectTxt" runat="server" CssClass="form-control" placeholder="Brief description of your issue"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="SubjectRequired" runat="server" ErrorMessage="Subject is required" ControlToValidate="SubjectTxt" ForeColor="Red" Display="Dynamic" ValidationGroup="NewTicket"></asp:RequiredFieldValidator>
                            </div>
                            
                            <div class="form-group">
                                <label for="<%= PriorityDdl.ClientID %>">Priority</label>
                                <asp:DropDownList ID="PriorityDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="Low" Text="Low - General question"></asp:ListItem>
                                    <asp:ListItem Value="Medium" Text="Medium - Order issue" Selected="True"></asp:ListItem>
                                    <asp:ListItem Value="High" Text="High - Urgent problem"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            
                            <div class="form-group">
                                <label for="<%= MessageTxt.ClientID %>">Message</label>
                                <asp:TextBox ID="MessageTxt" runat="server" CssClass="form-control" TextMode="MultiLine" placeholder="Describe your issue in detail. Include order numbers if applicable."></asp:TextBox>
                                <asp:RequiredFieldValidator ID="MessageRequired" runat="server" ErrorMessage="Message is required" ControlToValidate="MessageTxt" ForeColor="Red" Display="Dynamic" ValidationGroup="NewTicket"></asp:RequiredFieldValidator>
                            </div>
                            
                            <div class="form-actions">
                                <asp:Button ID="CancelBtn" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="CancelBtn_Click" CausesValidation="false" />
                                <asp:Button ID="SubmitTicketBtn" runat="server" Text="Submit Ticket" CssClass="btn btn-primary" OnClick="SubmitTicketBtn_Click" ValidationGroup="NewTicket" />
                            </div>
                        </div>
                    </asp:Panel>
                </div>
            </div>
            
            <!-- Right panel for ticket details and chat -->
            <div class="support-card">
                <asp:Panel ID="EmptyDetailsPanel" runat="server" CssClass="empty-state">
                    <i class="fas fa-comments"></i>
                    <h3>Support Chat</h3>
                    <p>Select a ticket to view your conversation with our support team, or create a new ticket to get help.</p>
                </asp:Panel>
                
                <asp:Panel ID="TicketDetailsPanel" runat="server" CssClass="ticket-details" Visible="false">
                    <div class="chat-header">
                        <h3><asp:Literal ID="TicketSubjectLiteral" runat="server"></asp:Literal></h3>
                        <p>
                            Status: <asp:Literal ID="TicketStatusLiteral" runat="server"></asp:Literal> | 
                            Created: <asp:Literal ID="TicketDateLiteral" runat="server"></asp:Literal>
                            <asp:Literal ID="TicketAssignedLiteral" runat="server"></asp:Literal>
                        </p>
                    </div>
                    
                    <div class="chat-body" id="chatBody" runat="server">
                        <asp:Repeater ID="MessageRepeater" runat="server">
                            <ItemTemplate>
                                <div class="message <%# If(Convert.ToBoolean(Eval("is_staff")), "received", "sent") %>">
                                    <div class="bubble">
                                        <div class="sender"><%# Eval("sender_name") %></div>
                                        <p><%# Eval("message_text") %></p>
                                        
                                        <%# If(Eval("attachment_url") IsNot Nothing AndAlso Not String.IsNullOrEmpty(Eval("attachment_url").ToString()), 
                                            "<div class='attachment'><i class='fas fa-paperclip'></i><a href='" & Eval("attachment_url") & "' target='_blank'>View Attachment</a></div>", 
                                            "") %>
                                        
                                        <div class="meta">
                                            <%# FormatMessageDate(Eval("created_at")) %>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                    
                    <div class="chat-footer">
                        <div class="input-container">
                            <asp:TextBox ID="ReplyMessageTxt" runat="server" TextMode="MultiLine" placeholder="Type a message..." onkeydown="resizeTextarea(this)"></asp:TextBox>
                        </div>
                        <asp:Button ID="SendBtn" runat="server" Text="→" CssClass="send-btn" OnClick="SendBtn_Click" />
                    </div>
                </asp:Panel>
            </div>
        </div>
        
        <!-- FAQ Section -->
        <div class="faq-section">
            <h2>Frequently Asked Questions</h2>
            
            <div class="faq-item">
                <div class="faq-question">How do I track my order?</div>
                <div class="faq-answer">
                    You can track your order by going to the Orders page in your account dashboard. 
                    Click on the specific order to see its status, estimated delivery time, and tracking information.
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">What payment methods do you accept?</div>
                <div class="faq-answer">
                    We accept various payment methods including credit/debit cards, GCash, and cash on delivery (COD).
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">Can I cancel my order?</div>
                <div class="faq-answer">
                    Yes, you can cancel your order if it hasn't been processed yet. Go to your Orders page, 
                    select the order you wish to cancel, and click the "Cancel Order" button. If your order 
                    is already being prepared, please contact our support team for assistance.
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">How do I apply a promo code?</div>
                <div class="faq-answer">
                    You can apply a promo code during checkout. In the payment section, look for the 
                    "Have a promo code?" field, enter your code, and click "Apply" to see the discount applied to your total.
                </div>
            </div>
            
            <div class="faq-item">
                <div class="faq-question">What is the delivery area?</div>
                <div class="faq-answer">
                    We currently deliver to selected areas in the city. During checkout, you'll be able to 
                    see if your address is within our delivery range. If you're outside our current delivery area, 
                    you can still place an order for pickup.
                </div>
            </div>
        </div>
    </div>
    
    <script type="text/javascript">
        function resizeTextarea(textarea) {
            textarea.style.height = "auto";
            textarea.style.height = (textarea.scrollHeight) + "px";
        }
        
        // Auto-scroll chat to bottom
        function scrollChatToBottom() {
            var chatBody = document.getElementById('<%=chatBody.ClientID %>');
            if (chatBody) {
                chatBody.scrollTop = chatBody.scrollHeight;
            }
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            scrollChatToBottom();
            
            // Auto-resize textareas
            var textareas = document.querySelectorAll('textarea');
            textareas.forEach(function(textarea) {
                textarea.addEventListener('input', function() {
                    resizeTextarea(this);
                });
            });
        });
    </script>
</asp:Content> 