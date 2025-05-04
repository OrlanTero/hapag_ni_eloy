<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerSupport.aspx.vb" Inherits="Pages_Admin_CustomerSupport" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .content-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .content-header {
            margin-bottom: 30px;
        }
        
        .content-header h1 {
            font-size: 28px;
            color: #2C3E50;
            margin-bottom: 10px;
        }
        
        .content-header p {
            color: #7f8c8d;
            font-size: 16px;
        }
        
        .dashboard-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            overflow: hidden;
            height: calc(100vh - 220px);
            display: flex;
            flex-direction: column;
        }
        
        .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
        }
        
        .card-header h2 {
            margin: 0;
            font-size: 18px;
            color: #2C3E50;
        }
        
        .card-body {
            padding: 0;
            display: flex;
            flex: 1;
            overflow: hidden;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            width: 100%;
        }
        
        .empty-state i {
            color: #619F2B;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .empty-state h3 {
            color: #2C3E50;
            margin-bottom: 15px;
        }
        
        .empty-state p {
            color: #7f8c8d;
            max-width: 600px;
            margin: 0 auto 10px;
        }
        
        /* Support chat styling */
        .support-container {
            display: flex;
            width: 100%;
            height: 100%;
        }
        
        .ticket-list {
            width: 30%;
            border-right: 1px solid #eee;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }
        
        .ticket-search {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
        }
        
        .ticket-search input {
            flex: 1;
            border: 1px solid #ddd;
            padding: 8px 12px;
            border-radius: 4px;
        }
        
        .ticket-filter {
            padding: 10px 15px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fa;
        }
        
        .ticket-items {
            flex: 1;
            overflow-y: auto;
        }
        
        .ticket-item {
            padding: 15px;
            border-bottom: 1px solid #eee;
            cursor: pointer;
            transition: background-color 0.2s;
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
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        
        .ticket-item .meta {
            display: flex;
            justify-content: space-between;
            font-size: 12px;
            color: #95a5a6;
        }
        
        .chat-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 0;
        }
        
        .chat-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fa;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .chat-header-info h2 {
            margin: 0;
            font-size: 18px;
        }
        
        .chat-header-info p {
            margin: 3px 0 0;
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .chat-body {
            flex: 1;
            overflow-y: auto;
            padding: 20px;
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
            border-radius: 24px;
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
            max-height: 100px;
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
        
        .priority {
            display: inline-block;
            padding: 2px 8px;
            border-radius: 3px;
            font-size: 12px;
            font-weight: bold;
            color: white;
        }
        
        .priority.high {
            background-color: #e74c3c;
        }
        
        .priority.medium {
            background-color: #f39c12;
        }
        
        .priority.low {
            background-color: #3498db;
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
        
        .empty-chat {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            color: #95a5a6;
        }
        
        .empty-chat i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #bdc3c7;
        }
        
        .ticket-action {
            margin-top: 10px;
            display: flex;
            justify-content: space-between;
        }
        
        .attachment {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 8px 12px;
            margin-top: 8px;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
        }
        
        .attachment i {
            margin-right: 8px;
            color: #7f8c8d;
        }
        
        .attachment a {
            color: #2980b9;
            text-decoration: none;
        }
        
        .chat-controls {
            display: flex;
            gap: 10px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-container">
        <div class="content-header">
            <h1><i class="fas fa-headset"></i> Customer Support</h1>
            <p>Manage customer inquiries and support requests</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <div class="dashboard-card">
            <div class="card-header">
                <h2>Support Ticket Center</h2>
            </div>
            <div class="card-body">
                <div class="support-container">
                    <div class="ticket-list">
                        <div class="ticket-search">
                            <asp:TextBox ID="SearchBox" runat="server" placeholder="Search tickets..." AutoPostBack="true" OnTextChanged="SearchBox_TextChanged"></asp:TextBox>
                        </div>
                        <div class="ticket-filter">
                            <asp:DropDownList ID="StatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="StatusFilter_SelectedIndexChanged">
                                <asp:ListItem Value="" Text="All Tickets" Selected="True"></asp:ListItem>
                                <asp:ListItem Value="Open" Text="Open"></asp:ListItem>
                                <asp:ListItem Value="In Progress" Text="In Progress"></asp:ListItem>
                                <asp:ListItem Value="Closed" Text="Closed"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="ticket-items" id="ticketItems" runat="server">
                            <!-- Tickets will be populated here -->
                            <asp:Repeater ID="TicketRepeater" runat="server" OnItemCommand="TicketRepeater_ItemCommand">
                                <ItemTemplate>
                                    <div class="ticket-item <%# If(Convert.ToInt32(Eval("ticket_id")) = Convert.ToInt32(Request.QueryString("id")), "active", "") %>">
                                        <asp:LinkButton ID="SelectTicketBtn" runat="server" CommandName="SelectTicket" CommandArgument='<%# Eval("ticket_id") %>' 
                                            Style="display:block; text-decoration:none; color:inherit;">
                                            <h3>
                                                <%# Eval("subject") %>
                                                <%# If(Convert.ToInt32(Eval("unread_count")) > 0, "<span class='badge'>" & Eval("unread_count") & "</span>", "") %>
                                            </h3>
                                            <p><%# Eval("user_name") %></p>
                                            <div class="meta">
                                                <span>
                                                    <span class="status <%# GetStatusClass(Eval("status").ToString()) %>"><%# Eval("status") %></span>
                                                    <span class="priority <%# GetPriorityClass(Eval("priority").ToString()) %>"><%# Eval("priority") %></span>
                                                </span>
                                                <span><%# FormatDate(Eval("last_updated")) %></span>
                                            </div>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                    
                    <div class="chat-container">
                        <asp:Panel ID="EmptyChatPanel" runat="server" CssClass="empty-chat">
                            <i class="fas fa-comments"></i>
                            <h3>No ticket selected</h3>
                            <p>Select a ticket from the list to view the conversation</p>
                        </asp:Panel>
                        
                        <asp:Panel ID="ChatPanel" runat="server" Visible="false">
                            <div class="chat-header">
                                <div class="chat-header-info">
                                    <h2>
                                        <asp:Literal ID="TicketSubjectLiteral" runat="server"></asp:Literal>
                                    </h2>
                                    <p>
                                        Customer: <asp:Literal ID="CustomerNameLiteral" runat="server"></asp:Literal> | 
                                        Status: <asp:Literal ID="TicketStatusLiteral" runat="server"></asp:Literal> | 
                                        Priority: <asp:Literal ID="TicketPriorityLiteral" runat="server"></asp:Literal>
                                    </p>
                                </div>
                                <div class="chat-controls">
                                    <asp:DropDownList ID="StatusDropDown" runat="server">
                                        <asp:ListItem Value="Open" Text="Open"></asp:ListItem>
                                        <asp:ListItem Value="In Progress" Text="In Progress"></asp:ListItem>
                                        <asp:ListItem Value="Closed" Text="Closed"></asp:ListItem>
                                    </asp:DropDownList>
                                    
                                    <asp:DropDownList ID="PriorityDropDown" runat="server">
                                        <asp:ListItem Value="Low" Text="Low"></asp:ListItem>
                                        <asp:ListItem Value="Medium" Text="Medium"></asp:ListItem>
                                        <asp:ListItem Value="High" Text="High"></asp:ListItem>
                                    </asp:DropDownList>
                                    
                                    <asp:Button ID="UpdateTicketBtn" runat="server" Text="Update Ticket" OnClick="UpdateTicketBtn_Click" />
                                </div>
                            </div>
                            
                            <div class="chat-body" id="chatBody" runat="server">
                                <asp:Repeater ID="MessageRepeater" runat="server">
                                    <ItemTemplate>
                                        <div class="message <%# If(Convert.ToBoolean(Eval("is_staff")), "sent", "received") %>">
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
                                    <asp:TextBox ID="MessageTextBox" runat="server" TextMode="MultiLine" placeholder="Type a message..."></asp:TextBox>
                                </div>
                                <asp:Button ID="SendMessageBtn" runat="server" CssClass="send-btn" Text="→" OnClick="SendMessageBtn_Click" />
                            </div>
                        </asp:Panel>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script type="text/javascript">
        // Auto-scroll chat to bottom on load
        function scrollChatToBottom() {
            var chatBody = document.getElementById('<%=chatBody.ClientID %>');
            if (chatBody) {
                chatBody.scrollTop = chatBody.scrollHeight;
            }
        }
        
        // Handle textarea auto-resize
        document.addEventListener('DOMContentLoaded', function() {
            var textarea = document.getElementById('<%=MessageTextBox.ClientID %>');
            if (textarea) {
                textarea.addEventListener('input', function() {
                    this.style.height = 'auto';
                    this.style.height = (this.scrollHeight) + 'px';
                });
            }
            
            // Scroll chat to bottom initially
            scrollChatToBottom();
        });
    </script>
</asp:Content> 