<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Admin Transaction.aspx.vb" Inherits="Pages_Admin_Admin_Transaction" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Manage Transactions</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <link href="./../../StyleSheets/Admin.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        /* Existing styles */
        .page-container {
            display: flex;
            min-height: 100vh;
        }
        
        /* Transaction Table Styles */
        .table-responsive {
            margin-top: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        
        .table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .table th {
            background-color: #f8f9fa;
            padding: 12px;
            font-weight: 600;
            text-align: left;
            border-bottom: 2px solid #dee2e6;
            color: #495057;
        }
        
        .table td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
            vertical-align: middle;
        }
        
        .table tr:hover {
            background-color: #f8f9fa;
        }
        
        .table tr.active {
            background-color: #e9ecef;
        }
        
        /* Payment Status Styles */
        .status-paid {
            color: #28a745;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
            background-color: #d4edda;
        }
        
        .status-pending {
            color: #ffc107;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
            background-color: #fff3cd;
        }
        
        .status-canceled {
            color: #dc3545;
            font-weight: 600;
            padding: 4px 8px;
            border-radius: 4px;
            background-color: #f8d7da;
        }
        
        /* Transaction Details Styles */
        .transaction-details {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .detail-row {
            display: flex;
            margin-bottom: 12px;
            border-bottom: 1px solid #eee;
            padding-bottom: 8px;
        }
        
        .detail-label {
            flex: 1;
            font-weight: 600;
            color: #495057;
        }
        
        .detail-value {
            flex: 2;
            color: #212529;
        }
        
        /* Form Styles */
        .form-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 15px;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-group-half {
            flex: 1;
        }
        
        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .form-control:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        
        /* Button Styles */
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background-color: #007bff;
            color: white;
        }
        
        .btn-primary:hover {
            background-color: #0056b3;
        }
        
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background-color: #545b62;
        }
        
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
        }
        
        /* Alert Styles */
        .alert-message {
            padding: 12px 20px;
            border-radius: 4px;
            margin-bottom: 20px;
            display: none;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
        
        /* Responsive Styles */
        @media (max-width: 768px) {
            .form-row {
                flex-direction: column;
            }
            
            .table-responsive {
                overflow-x: auto;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                <!-- Mobile Menu Toggle -->
                <button class="menu-toggle" id="menuToggle">
                    <i class="fa fa-bars"></i> Menu
                </button>
                
                <!-- Content Container -->
                <div class="content-container">
                    <!-- Content Header -->
                    <div class="content-header">
                        <h1>Manage Transactions</h1>
            <p>View transaction details and update payment status</p>
                    </div>
                    
                    <!-- Alert Message -->
                    <div class="alert-message" id="alertMessage" runat="server" visible="false">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
        <!-- Transaction Details -->
        <div class="transaction-details" id="transactionDetails" runat="server" visible="false">
            <h2>Transaction Details</h2>
            
            <asp:HiddenField ID="TransactionIdHidden" runat="server" ClientIDMode="Static" />
            
            <div class="detail-row">
                <div class="detail-label">Transaction ID:</div>
                <div class="detail-value"><asp:Literal ID="TransactionIdLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <div class="detail-row">
                <div class="detail-label">Reference Number:</div>
                <div class="detail-value"><asp:Literal ID="ReferenceNumberLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <div class="detail-row">
                <div class="detail-label">Transaction Date:</div>
                <div class="detail-value"><asp:Literal ID="TransactionDateLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <div class="detail-row">
                <div class="detail-label">Payment Method:</div>
                <div class="detail-value"><asp:Literal ID="PaymentMethodLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <div class="detail-row">
                <div class="detail-label">Subtotal:</div>
                <div class="detail-value"><asp:Literal ID="SubtotalLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <div class="detail-row">
                <div class="detail-label">Discount:</div>
                <div class="detail-value"><asp:Literal ID="DiscountLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <div class="detail-row">
                <div class="detail-label">Delivery Fee:</div>
                <div class="detail-value"><asp:Literal ID="DeliveryFeeLiteral" runat="server"></asp:Literal></div>
                            </div>
            
            <div class="detail-row">
                <div class="detail-label">Total Amount:</div>
                <div class="detail-value"><asp:Literal ID="TotalAmountLiteral" runat="server"></asp:Literal></div>
                        </div>
                        
            <div class="detail-row">
                <div class="detail-label">Customer:</div>
                <div class="detail-value"><asp:Literal ID="CustomerLiteral" runat="server"></asp:Literal></div>
                            </div>
            
            <div class="detail-row">
                <div class="detail-label">Sender Name:</div>
                <div class="detail-value"><asp:Literal ID="SenderNameLiteral" runat="server"></asp:Literal></div>
                            </div>
            
            <div class="detail-row">
                <div class="detail-label">Sender Number:</div>
                <div class="detail-value"><asp:Literal ID="SenderNumberLiteral" runat="server"></asp:Literal></div>
                        </div>
                        
            <div class="detail-row">
                <div class="detail-label">Driver Name:</div>
                <div class="detail-value"><asp:Literal ID="DriverNameLiteral" runat="server"></asp:Literal></div>
                            </div>
            
            <div class="detail-row">
                <div class="detail-label">Tracking URL:</div>
                <div class="detail-value"><asp:Literal ID="TrackingUrlLiteral" runat="server"></asp:Literal></div>
                            </div>
            
            <div class="detail-row">
                <div class="detail-label">Est. Delivery Time:</div>
                <div class="detail-value"><asp:Literal ID="EstDeliveryLiteral" runat="server"></asp:Literal></div>
                        </div>
                        
            <div class="detail-row">
                <div class="detail-label">Current Status:</div>
                <div class="detail-value"><asp:Literal ID="StatusLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <!-- Update Payment Status Form -->
            <div class="form-container">
                <h3>Update Payment Status</h3>
                <div class="form-row">
                    <div class="form-group">
                        <asp:DropDownList ID="StatusDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                            <asp:ListItem Text="Pending" Value="Pending"></asp:ListItem>
                            <asp:ListItem Text="Paid" Value="Paid"></asp:ListItem>
                            <asp:ListItem Text="Canceled" Value="Canceled"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
                <div class="form-row">
                    <asp:Button ID="UpdateStatusBtn" runat="server" Text="Update Status" CssClass="btn btn-primary" ClientIDMode="Static" />
                </div>
                        </div>
                    </div>
                </div>
                
                <!-- Table Container -->
                <div class="content-container">
                    <div class="content-header">
            <h1>All Transactions</h1>
            <p>Click on a row to view transaction details</p>
                    </div>
                    <div class="table-responsive">
            <asp:Table ID="Table1" runat="server" CssClass="table table-striped table-hover" ClientIDMode="Static">
                        </asp:Table>
                    </div>
                </div>
                
                <!-- Footer -->
                <div class="footer">
                    <p>&copy; <%= DateTime.Now.Year %> Food Ordering System. All rights reserved.</p>
                </div>

    <script type="text/javascript">
        // Mobile menu toggle
        document.getElementById('menuToggle').addEventListener('click', function() {
            var sidebar = document.querySelector('.admin-sidebar');
            var mainContent = document.querySelector('.main-content');
            
            if (sidebar.style.width === '250px' || sidebar.style.width === '') {
                sidebar.style.width = '0';
                mainContent.style.marginLeft = '0';
            } else {
                sidebar.style.width = '250px';
                mainContent.style.marginLeft = '250px';
            }
        });
        
        // Initialize event listeners
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize table listeners
            ListenTable();
        });
    
        function UnHighlight(rows) {
            for (var row of rows) {
                row.classList.remove("active");
            }
        }

        function Highlight(rows, row) {
            UnHighlight(rows);
            row.classList.add("active");
        }

        function ListenTable() {
            var table = document.getElementById("Table1");
            if (!table) {
                console.error("Table with ID 'Table1' not found!");
                return;
            }
            
            var rows = table.querySelectorAll("tr");
            console.log("Found " + rows.length + " rows in the table");

            for(const row of rows) {
                if(row.cells.length > 1) { // Skip header row
                row.addEventListener("click", function() {
                    Highlight(rows, row);
                        ViewTransactionDetails(row);
                    });
                }
            }
        }
        
        function ViewTransactionDetails(row) {
            try {
                // This function will trigger a postback to load transaction details
                var transactionId = row.getAttribute("data-transaction_id");
                if (!transactionId) {
                    console.error("No transaction ID found on the row");
                    return;
                }
                
                var hiddenField = document.getElementById("TransactionIdHidden");
                if (!hiddenField) {
                    console.error("Element 'TransactionIdHidden' not found. Creating a temporary one.");
                    // Create a temporary hidden input if it doesn't exist
                    hiddenField = document.createElement("input");
                    hiddenField.id = "TransactionIdHidden";
                    hiddenField.name = "TransactionIdHidden";
                    hiddenField.type = "hidden";
                    document.forms[0].appendChild(hiddenField);
                }
                hiddenField.value = transactionId;
                
                // Update status dropdown to match current status
                var statusText = "";
                for(var i = 0; i < row.cells.length; i++) {
                    if(row.cells[i].classList.contains("status-paid") || 
                       row.cells[i].classList.contains("status-pending") ||
                       row.cells[i].classList.contains("status-canceled")) {
                        statusText = row.cells[i].innerText.trim();
                        break;
                    }
                }
                
                var statusDdl = document.getElementById("StatusDdl");
                if(statusDdl) {
                    for(var i = 0; i < statusDdl.options.length; i++) {
                        if(statusDdl.options[i].text === statusText) {
                            statusDdl.selectedIndex = i;
                            break;
                        }
                    }
                }
                
                // Trigger server-side code to show transaction details
                if (typeof __doPostBack === 'function') {
                    __doPostBack('ViewTransactionDetails', transactionId);
                } else {
                    console.error("__doPostBack function not found. Submitting form manually.");
                    // Create a form and submit it manually as a fallback
                    var form = document.forms[0];
                    var eventTargetInput = document.createElement("input");
                    eventTargetInput.type = "hidden";
                    eventTargetInput.name = "__EVENTTARGET";
                    eventTargetInput.value = "ViewTransactionDetails";
                    form.appendChild(eventTargetInput);
                    
                    var eventArgumentInput = document.createElement("input");
                    eventArgumentInput.type = "hidden";
                    eventArgumentInput.name = "__EVENTARGUMENT";
                    eventArgumentInput.value = transactionId;
                    form.appendChild(eventArgumentInput);
                    
                    form.submit();
                }
            } catch (ex) {
                console.error("Error in ViewTransactionDetails:", ex);
                alert("An error occurred while viewing transaction details. Please try again.");
            }
        }
        
        function showAlert(message, type) {
            try {
                // Try to use the master page's showAlert function
                if (typeof window.masterShowAlert === 'function') {
                    window.masterShowAlert(message, type);
                    return;
                }
                
                // Fallback to local implementation
            const alertMessage = document.getElementById("alertMessage");
                
                if (!alertMessage) {
                    console.error("Alert message element not found");
                    return;
                }
            
            alertMessage.className = "alert-message";
            alertMessage.classList.add("alert-" + type);
            alertMessage.innerHTML = message;
            alertMessage.style.display = "block";
                
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    alertMessage.style.display = "none";
                }, 5000);
            } catch (e) {
                console.error("Error showing alert:", e);
            }
        }
    </script>
</asp:Content>
