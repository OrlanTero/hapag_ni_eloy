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
            min-height: 500px;
            display: flex;
            flex-direction: column;
        }
        
        .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
            flex-shrink: 0;
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
            min-height: 400px;
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
            min-height: 400px;
        }
        
        .ticket-list {
            width: 30%;
            min-width: 250px;
            border-right: 1px solid #eee;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }
        
        .ticket-search {
            padding: 15px;
            border-bottom: 1px solid #eee;
            display: flex;
            flex-shrink: 0;
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
            flex-shrink: 0;
        }
        
        .ticket-items {
            flex: 1;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #cdcdcd #f1f1f1;
        }
        
        /* Nice styling for the ticket items scrollbar when it appears */
        .ticket-items::-webkit-scrollbar {
            width: 6px;
        }
        
        .ticket-items::-webkit-scrollbar-track {
            background: #f1f1f1;
        }
        
        .ticket-items::-webkit-scrollbar-thumb {
            background: #cdcdcd;
            border-radius: 3px;
        }
        
        .ticket-items::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
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
            min-width: 300px;
            position: relative;
            overflow-y: auto;
        }
        
        .chat-header {
            padding: 15px;
            border-bottom: 1px solid #eee;
            background-color: #f8f9fa;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
            flex-wrap: wrap;
        }
        
        .chat-header-info {
            margin-bottom: 10px;
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
            overflow-y: scroll !important;
            padding: 20px;
            min-height: 200px;
            position: relative;
            scrollbar-width: thin;
            scrollbar-color: #cdcdcd #f1f1f1;
            display: flex;
            flex-direction: column;
        }
        
        .chat-messages-container {
            width: 100%;
            overflow-anchor: none;
            display: flex;
            flex-direction: column;
            min-height: 100%;
        }
        
        /* Anchor for auto-scrolling */
        .scroll-anchor {
            height: 1px;
            margin-top: auto;
        }
        
        /* Enhanced scrollbar styling for better visibility */
        .chat-body::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        
        .chat-body::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 4px;
        }
        
        .chat-body::-webkit-scrollbar-thumb {
            background: #cdcdcd;
            border-radius: 4px;
            border: 2px solid #f1f1f1;
        }
        
        .chat-body::-webkit-scrollbar-thumb:hover {
            background: #a8a8a8;
        }
        
        /* Enhanced for Firefox */
        .chat-body {
            scrollbar-width: thin;
            scrollbar-color: #cdcdcd #f1f1f1;
        }
        
        .scroll-indicator {
            position: absolute;
            bottom: 70px; /* Position above the chat footer */
            left: 50%;
            transform: translateX(-50%);
            background-color: #619F2B;
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-size: 12px;
            cursor: pointer;
            z-index: 20;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
            opacity: 0.9;
            transition: all 0.3s;
            display: none;
        }
        
        .scroll-indicator:hover {
            opacity: 1;
            transform: translateX(-50%) translateY(-3px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .scroll-indicator i {
            margin-right: 5px;
        }
        
        .message {
            display: flex;
            margin-bottom: 15px;
            transition: opacity 0.3s ease-in-out;
        }
        
        .message.new-message {
            animation: fade-in 0.5s ease-in-out;
        }
        
        @keyframes fade-in {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
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
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
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
            line-height: 1.5;
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
        
        /* Better footer positioning and styling */
        .chat-footer {
            padding: 15px;
            border-top: 1px solid #eee;
            display: flex;
            align-items: center;
            flex-shrink: 0;
            background-color: #fff;
            position: sticky;
            bottom: 0;
            z-index: 10;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
        }
        
        /* Enhanced input container with better focus effects */
        .chat-footer .input-container {
            flex: 1;
            display: flex;
            border: 1px solid #ddd;
            border-radius: 24px;
            overflow: hidden;
            padding: 0 15px;
            align-items: center;
            background-color: #fff;
            min-height: 40px;
            transition: all 0.2s ease;
        }
        
        .chat-footer .input-container:focus-within {
            border-color: #619F2B;
            box-shadow: 0 0 0 3px rgba(97, 159, 43, 0.15);
            transform: translateY(-1px);
        }
        
        /* Better textarea styling */
        .chat-footer textarea {
            flex: 1;
            border: none;
            outline: none;
            padding: 10px 0;
            resize: none;
            max-height: 100px;
            min-height: 40px;
            height: 40px;
            font-family: inherit;
            font-size: 15px;
            line-height: 1.5;
            background-color: transparent;
        }
        
        /* Enhanced send button with better hover/active states */
        .chat-footer .send-btn {
            background-color: #619F2B;
            color: white;
            border: none;
            width: 40px;
            height: 40px;
            min-width: 40px;
            min-height: 40px;
            border-radius: 50%;
            margin-left: 10px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            transition: all 0.2s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        .chat-footer .send-btn:hover {
            background-color: #548c25;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }
        
        .chat-footer .send-btn:active {
            transform: translateY(0);
            box-shadow: 0 2px 3px rgba(0, 0, 0, 0.1);
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
        
        @media (max-width: 992px) {
            .dashboard-card {
                height: calc(100vh - 150px);
            }
            
            .chat-controls {
                flex-wrap: wrap;
            }
        }
        
        /* Smaller screens adjustments */
        @media (max-width: 768px) {
            .support-container {
                flex-direction: column;
            }
            
            .ticket-list {
                width: 100%;
                min-width: 100%;
                max-height: 300px;
                border-right: none;
                border-bottom: 1px solid #eee;
            }
            
            .chat-container {
                width: 100%;
                min-width: 100%;
            }
            
            .chat-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .chat-controls {
                width: 100%;
                margin-top: 10px;
                display: flex;
                flex-wrap: wrap;
                gap: 5px;
            }
            
            .chat-controls select, 
            .chat-controls input[type="button"] {
                flex: 1;
                min-width: 100px;
            }
            
            .message .bubble {
                max-width: 85%; /* Allow messages to take more width on small screens */
            }
        }
        
        /* Very small screens */
        @media (max-width: 480px) {
            .dashboard-card {
                height: calc(100vh - 100px);
                min-height: 400px;
            }
            
            .chat-footer {
                padding: 10px;
            }
            
            .chat-footer .input-container {
                padding: 0 10px;
            }
            
            .chat-footer .send-btn {
                width: 44px;
                height: 44px;
                min-width: 44px;
                min-height: 44px;
            }
            
            .message .bubble {
                max-width: 95%; /* Allow messages to take almost full width on very small screens */
            }
            
            .ticket-search input {
                font-size: 14px;
            }
            
            /* Ensure scrollbars visible on mobile */
            .chat-body, .ticket-items {
                -webkit-overflow-scrolling: touch;
                overflow-y: scroll !important;
            }
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
                            <!-- Tickets will b e populated here -->
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
                                <div class="chat-messages-container">
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
                                    <div id="scrollAnchor" class="scroll-anchor"></div>
                                </div>
                                <div id="scrollIndicator" class="scroll-indicator" style="display: none;">
                                    <i class="fas fa-arrow-down"></i> New messages
                                </div>
                            </div>
                            
                            <div class="chat-footer">
                                <div class="input-container">
                                    <asp:TextBox ID="MessageTextBox" runat="server" TextMode="MultiLine" placeholder="Type a message..."></asp:TextBox>
                                </div>
                                <asp:Button ID="SendMessageBtn" runat="server" CssClass="send-btn" Text="Send" OnClick="SendMessageBtn_Click" />
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
            var scrollAnchor = document.getElementById('scrollAnchor');
            
            if (chatBody && scrollAnchor) {
                // scrollAnchor.scrollIntoView({ behavior: 'smooth' });
                hideScrollIndicator(); // Hide indicator when we scroll to bottom
            } else if (chatBody) {
                // chatBody.scrollTop = chatBody.scrollHeight;
                hideScrollIndicator();
            }
        }
        
        // Keep scroll position at bottom when new messages are added
        function scrollToBottomIfNearBottom() {
            var chatBody = document.getElementById('<%=chatBody.ClientID %>');
            if (chatBody) {
                // If the user is already near the bottom, scroll to bottom
                var isNearBottom = chatBody.scrollHeight - chatBody.clientHeight - chatBody.scrollTop < 100;
                if (isNearBottom) {
                    scrollChatToBottom();
                } else {
                    // Show scroll indicator if not near bottom
                    showScrollIndicator();
                }
            }
        }
        
        // Show scroll indicator when new messages arrive but user is scrolled up
        function showScrollIndicator() {
            var indicator = document.getElementById('scrollIndicator');
            if (indicator) {
                indicator.style.display = 'block';
                
                // Add click handler if not already added
                if (!indicator.hasAttribute('data-handler-added')) {
                    indicator.addEventListener('click', function() {
                        scrollChatToBottom();
                    });
                    indicator.setAttribute('data-handler-added', 'true');
                }
            }
        }
        
        // Hide scroll indicator
        function hideScrollIndicator() {
            var indicator = document.getElementById('scrollIndicator');
            if (indicator) {
                indicator.style.display = 'none';
            }
        }
        
        // Handle textarea auto-resize
        function adjustTextareaHeight(textarea) {
            if (textarea) {
                // Reset height to recalculate correctly
                textarea.style.height = 'auto';
                
                // Set new height based on scroll height (content)
                var newHeight = Math.min(textarea.scrollHeight, 100); // Cap at 100px max
                textarea.style.height = Math.max(40, newHeight) + 'px'; // Ensure minimum height
            }
        }
        
        // When page loads
        document.addEventListener('DOMContentLoaded', function() {
            var textarea = document.getElementById('<%=MessageTextBox.ClientID %>');
            var chatBody = document.getElementById('<%=chatBody.ClientID %>');
            var sendButton = document.getElementById('<%=SendMessageBtn.ClientID %>');
            
            if (textarea) {
                // Initial adjustment
                adjustTextareaHeight(textarea);
                
                // Listen for input events
                textarea.addEventListener('input', function() {
                    adjustTextareaHeight(this);
                });
                
                // Listen for keydown events (Enter to send, Shift+Enter for new line)
                textarea.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter' && !e.shiftKey) {
                        e.preventDefault(); // Prevent default Enter behavior (new line)
                        if (sendButton) {
                            sendButton.click(); // Trigger send button
                        }
                    }
                });
                
                // Focus textarea when chat is active
                if (chatBody && chatBody.offsetParent !== null) { // Check if visible
                    setTimeout(function() { textarea.focus(); }, 100);
                }
            }
            
            if (chatBody) {
                // Ensure scrollbars are visible and functional
                chatBody.style.overflowY = 'scroll';
                
                // Scroll chat to bottom initially
                setTimeout(function() {
                    scrollChatToBottom();
                }, 100);
                
                // Handle scroll events to hide indicator when user scrolls to bottom
                chatBody.addEventListener('scroll', function() {
                    var isNearBottom = chatBody.scrollHeight - chatBody.clientHeight - chatBody.scrollTop < 50;
                    if (isNearBottom) {
                        hideScrollIndicator();
                    }
                });
                
                // Fix for mobile devices where scrollbars may be hidden
                chatBody.addEventListener('touchstart', function() {
                    this.classList.add('scrolling-touch');
                });
            }
            
            // Set up auto-resize for window resize events
            window.addEventListener('resize', function() {
                // Readjust textarea on window resize
                if (textarea) {
                    adjustTextareaHeight(textarea);
                }
                // Keep chat scrolled to bottom if appropriate
                scrollToBottomIfNearBottom();
            });
            
            // Observe changes to the chat body to auto-scroll when new messages are added
            if (typeof MutationObserver !== 'undefined' && chatBody) {
                var observer = new MutationObserver(function(mutations) {
                    // Check if content was added
                    var contentAdded = mutations.some(function(mutation) {
                        return mutation.addedNodes.length > 0;
                    });
                    
                    if (contentAdded) {
                        setTimeout(function() {
                            scrollToBottomIfNearBottom();
                        }, 50); // Small delay to ensure DOM is updated
                    }
                });
                
                // Observe both the chat body and its children for changes
                observer.observe(chatBody, { childList: true, subtree: true });
                
                // Add a class when messages are added for potential CSS transitions
                chatBody.addEventListener('DOMNodeInserted', function(event) {
                    if (event.target.classList && event.target.classList.contains('message')) {
                        event.target.classList.add('new-message');
                        setTimeout(function() {
                            event.target.classList.remove('new-message');
                        }, 500);
                    }
                });
            }
        });
    </script>
</asp:Content> 