<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Admin Transaction.aspx.vb" Inherits="Pages_Admin_Admin_Transaction" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
</head>
<body>
    <form id="Form1" runat="server">
        <div class="page-container">
            <!-- Admin Sidebar -->
            <div class="admin-sidebar">
                <div class="logo">
                    <img src="../../Assets/Images/logo-removebg-preview.png" alt="Logo" />
                </div>
                <div class="nav-links">
                    <a href="AdminDashboard.aspx">
                        <img src="../../Assets/Images/icons/dashboard icon black.png" class="black" />
                        <img src="../../Assets/Images/icons/dasboard icon white.png" class="white" />
                        <span>Dashboard</span>
                    </a>

                    <a href="AdminMenu.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Menu</span>
                    </a> 

                    <a href="AdminMenuCategories.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Categories</span>
                    </a>

                    <a href="AdminMenuTypes.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Types</span>
                    </a>

                    <a href="AdminOrders.aspx">
                        <img src="../../Assets/Images/icons/order-black.png" class="black" />
                        <img src="../../Assets/Images/icons/order-white.png" class="white" />
                        <span>Orders</span>
                    </a>

                    <a href="AdminAccounts.aspx">
                        <img src="../../Assets/Images/icons/account-black.png" class="black" />
                        <img src="../../Assets/Images/icons/account-white.png" class="white" />
                        <span>Accounts</span>
                    </a>

                    <div class="dropdown-container">
                        <a href="javascript:void(0);" class="dropdown-toggle">
                            <img src="../../Assets/Images/icons/administrator-black.png" class="black" />
                            <img src="../../Assets/Images/icons/administrator-white.png" class="white" />
                            <span>Administrator</span>
                        </a>
                        <div class="dropdown-menu">
                            <a href="AdminDeals.aspx">Deals</a>
                            <a href="AdminPromotions.aspx">Promotions</a>
                            <a href="AdminDiscounts.aspx">Discounts</a>
                        </div>
                    </div>

                    <a href="Admin Transaction.aspx" class="active">
                        <img src="../../Assets/Images/icons/transaction-black.png" class="black" />
                        <img src="../../Assets/Images/icons/transaction-white.png" class="white" />
                        <span>Transactions</span>
                    </a>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="main-content">
                <!-- Mobile Menu Toggle -->
                <button class="menu-toggle" id="menuToggle">
                    <i class="fa fa-bars"></i> Menu
                </button>
                
                <!-- Content Container -->
                <div class="content-container">
                    <!-- Content Header -->
                    <div class="content-header">
                        <h1>Manage Transactions</h1>
                        <p>Add, edit, or remove transaction records</p>
                    </div>
                    
                    <!-- Alert Message -->
                    <div class="alert-message" id="alertMessage" runat="server" visible="false">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
                    <!-- Form Container -->
                    <div class="form-container">
                        <asp:TextBox ID="UserIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden></asp:TextBox>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <h3>Payment Method:</h3>
                                <asp:DropDownList ID="PaymentMethodDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="GCash" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Cash" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Subtotal:</h3>
                                <asp:TextBox ID="SubtotalTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Total:</h3>
                                <asp:TextBox ID="TotalTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Discounts:</h3>
                                <asp:TextBox ID="DiscountTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Driver:</h3>
                                <asp:TextBox ID="DriverTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <asp:Button ID="AddBtn" runat="server" Text="ADD" CssClass="btn btn-primary" />
                            <asp:Button ID="EditBtn" runat="server" Text="EDIT" CssClass="btn btn-secondary" />
                            <asp:Button ID="RemoveBtn" runat="server" Text="REMOVE" CssClass="btn btn-danger" />
                        </div>
                    </div>
                </div>
                
                <!-- Table Container -->
                <div class="content-container">
                    <div class="content-header">
                        <h1>Transactions</h1>
                        <p>Click on a row to select and edit a transaction</p>
                    </div>
                    <div class="table-responsive">
                        <asp:Table ID="Table1" runat="server" CssClass="table table-striped table-hover">
                        </asp:Table>
                    </div>
                </div>
                
                <!-- Footer -->
                <div class="footer">
                    <p>&copy; <%= DateTime.Now.Year %> Food Ordering System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </form>

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
        
        // Dropdown toggle
        document.addEventListener('DOMContentLoaded', function() {
            var dropdownToggles = document.querySelectorAll('.dropdown-toggle');
            
            dropdownToggles.forEach(function(toggle) {
                toggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    this.parentElement.classList.toggle('active');
                });
            });
            
            // Set active class based on current page
            var currentPage = window.location.pathname.split('/').pop();
            var navLinks = document.querySelectorAll('.nav-links a');
            var dropdownLinks = document.querySelectorAll('.dropdown-menu a');
            
            navLinks.forEach(function(link) {
                var href = link.getAttribute('href');
                if (href === currentPage) {
                    link.classList.add('active');
                }
            });
            
            dropdownLinks.forEach(function(link) {
                var href = link.getAttribute('href');
                if (href === currentPage) {
                    link.classList.add('active');
                    link.parentElement.parentElement.classList.add('active');
                }
            });
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
            var rows = table.querySelectorAll("tr");

            for(const row of rows) {
                row.addEventListener("click", function() {
                    Highlight(rows, row);
                    Display(row);
                });
            }
        }
        
        function Display(row) {
            const userIdTxt = document.getElementById("UserIdTxt");
            const paymentMethodDdl = document.getElementById("PaymentMethodDdl");
            const subtotalTxt = document.getElementById("SubtotalTxt");
            const totalTxt = document.getElementById("TotalTxt");
            const discountTxt = document.getElementById("DiscountTxt");
            const driverTxt = document.getElementById("DriverTxt");
            const cols = row.querySelectorAll("td");

            userIdTxt.value = row.getAttribute("data-user_id");
            paymentMethodDdl.value = cols[0].innerText === "GCash" ? "1" : "2";
            subtotalTxt.value = cols[1].innerText;
            totalTxt.value = cols[2].innerText;
            discountTxt.value = cols[3].innerText;
            driverTxt.value = cols[4].innerText;
        }

        function ListenToButtons() {
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const userIdTxt = document.getElementById("UserIdTxt");

            editBtn.addEventListener("click", function(e) {
                if (userIdTxt.value.length == 0) {
                    showAlert("Please Select a Transaction!", "warning");
                    e.preventDefault();
                }
            });
            
            removeBtn.addEventListener("click", function(e) {
                if (userIdTxt.value.length == 0) {
                    showAlert("Please Select a Transaction!", "warning");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this transaction?")) {
                    e.preventDefault();
                    return false;
                }
            });
        }
        
        function showAlert(message, type) {
            const alertMessage = document.getElementById("alertMessage");
            
            alertMessage.className = "alert-message";
            alertMessage.classList.add("alert-" + type);
            alertMessage.innerHTML = message;
            alertMessage.style.display = "block";
        }

        ListenTable();
        ListenToButtons();
    </script>
</body>
</html>
