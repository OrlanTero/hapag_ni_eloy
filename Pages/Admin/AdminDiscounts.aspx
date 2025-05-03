<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDiscounts.aspx.vb" Inherits="Pages_Admin_AdminDiscounts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Discounts</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <link href="./../../StyleSheets/Admin.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-3.6.0.min.js" type="text/javascript"></script>
    <link href="../../Scripts/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-ui.min.js" type="text/javascript"></script>
    <style type="text/css">
        /* General Styles */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        
        /* Status Styles */
        .status-active {
            background-color: #d4edda;
            color: #155724;
            padding: 3px 8px;
            border-radius: 4px;
            font-weight: bold;
        }
        
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
            padding: 3px 8px;
            border-radius: 4px;
            font-weight: bold;
        }
        
        /* Alert Message */
        .alert-message {
            padding: 10px 15px;
            margin: 10px 0;
            border-radius: 4px;
            display: none;
        }
        
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-warning {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeeba;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        /* No Records Panel */
        .no-records {
            padding: 20px;
            text-align: center;
            background-color: #f8f9fa;
            border-radius: 4px;
            margin-top: 20px;
        }
        
        .no-records p {
            color: #6c757d;
            font-size: 18px;
        }
        
        
        /* Alert styles */
        .alert-message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-weight: bold;
        }
        
        .alert-success {
            background-color: #dff0d8;
            border: 1px solid #d6e9c6;
            color: #3c763d;
        }
        
        .alert-warning {
            background-color: #fcf8e3;
            border: 1px solid #faebcc;
            color: #8a6d3b;
        }
        
        .alert-error {
            background-color: #f2dede;
            border: 1px solid #ebccd1;
            color: #a94442;
        }
        
        /* Dropdown styles */
        .dropdown-container {
            position: relative;
        }
        
        .dropdown-menu {
            display: none;
            position: absolute;
            left: 100%;
            top: 0;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
            border-radius: 4px;
        }
        
        .dropdown-container:hover .dropdown-menu {
            display: block;
        }
        
        .dropdown-menu a {
            color: #333;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            transition: background-color 0.3s;
        }
        
        .dropdown-menu a:hover {
            background-color: #f1f1f1;
            color: #000;
        }
        
        /* Mobile dropdown */
        @media screen and (max-width: 768px) {
            .dropdown-menu {
                position: static;
                box-shadow: none;
                width: 100%;
                padding-left: 30px;
            }
            
            .dropdown-container:hover .dropdown-menu {
                display: none;
            }
            
            .dropdown-container.active .dropdown-menu {
                display: block;
            }
            
            .dropdown-toggle {
                cursor: pointer;
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
                            <a href="AdminDiscounts.aspx" class="active">Discounts</a>
                        </div>
                    </div>

                    <a href="Admin Transaction.aspx">
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
                        <h1>Manage Discounts</h1>
                        <p>Add, edit, or remove discount offers</p>
                    </div>
                    
                    <!-- Alert Message -->
                    <div class="alert-message" id="alertMessage" style="display: none;">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
                    <!-- Form Container -->
                    <div class="form-container">
                        <input type="hidden" id="DiscountIdTxt" runat="server" />
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Discount Name:</h3>
                                <asp:TextBox ID="NameTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Discount Type:</h3>
                                <asp:DropDownList ID="DiscountTypeDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Percentage" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Fixed Amount" Value="2"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Discount Value:</h3>
                                <asp:TextBox ID="ValueTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Applicable To:</h3>
                                <asp:DropDownList ID="ApplicableToDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="All Products" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Specific Category" Value="2"></asp:ListItem>
                                    <asp:ListItem Text="Specific Product" Value="3"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Start Date:</h3>
                                <asp:TextBox ID="StartDateTxt" runat="server" CssClass="form-control date-picker1"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>End Date:</h3>
                                <asp:TextBox ID="EndDateTxt" runat="server" CssClass="form-control date-picker2"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Minimum Order Amount:</h3>
                                <asp:TextBox ID="MinOrderAmountTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Status:</h3>
                                <asp:DropDownList ID="StatusDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <h3>Description:</h3>
                                <asp:TextBox ID="DescriptionTxt" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-actions">
                            <asp:Button ID="AddBtn" runat="server" Text="ADD" CssClass="btn btn-primary" UseSubmitBehavior="true" OnClientClick="console.log('AddBtn client click'); return true;" />
                            <asp:Button ID="EditBtn" runat="server" Text="EDIT" CssClass="btn btn-secondary" />
                            <asp:Button ID="RemoveBtn" runat="server" Text="REMOVE" CssClass="btn btn-danger" />
                            <asp:Button ID="ClearBtn" runat="server" Text="CLEAR" CssClass="btn btn-info" />
                        </div>
                    </div>
                </div>
                
                <!-- Table Container -->
                <div class="content-container">
                    <div class="content-header">
                        <h1>Available Discounts</h1>
                        <p>Click on a row to select and edit a discount</p>
                    </div>
                    <asp:HiddenField ID="DiscountIdHidden" runat="server" Value="" />
                    <div class="table-responsive" id="TableContainer" runat="server">
                        <asp:Table ID="Table1" runat="server" CssClass="table table-striped table-hover">
                        </asp:Table>
                    </div>
                    <asp:Panel ID="NoRecords" runat="server" CssClass="no-records" Visible="false">
                        <p>No discounts found. Add a discount to see it here.</p>
                    </asp:Panel>
                </div>
                
                <!-- Footer -->
                <div class="footer">
                    <p>&copy; <%= DateTime.Now.Year %> Food Ordering System. All rights reserved.</p>
                </div>
            </div>
    </div>
    </form>

    <script type="text/javascript">
        // Initialize all event handlers when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            console.log("DOM loaded - initializing events");
            
        // Mobile menu toggle
            var menuToggle = document.getElementById('menuToggle');
            if (menuToggle) {
                menuToggle.addEventListener('click', function() {
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
            }
            
            // Initialize date pickers
            if (typeof $ !== 'undefined' && $.datepicker) {
            $(".date-picker1, .date-picker2").datepicker({
                dateFormat: 'mm/dd/yy'
            });
            }
            
            // Initialize event listeners for the table
            setTimeout(function() {
                console.log("Initializing table listeners");
                ListenTable();
                ListenToButtons();
            }, 500);
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
            console.log("ListenTable called");
            try {
                var table = document.getElementById("<%= Table1.ClientID %>");
                console.log("Table1 ClientID: <%= Table1.ClientID %>");
                
                if (!table) {
                    console.error("Table1 element not found");
                    // Try by tag name
                    var tables = document.getElementsByTagName("table");
                    console.log("Found " + tables.length + " tables on the page");
                    for (var i = 0; i < tables.length; i++) {
                        console.log("Table " + i + " id: " + tables[i].id);
                    }
                    return;
                }
                
            var rows = table.querySelectorAll("tr");
                console.log("Found " + rows.length + " rows in the table");
                
                if (rows.length <= 1) {
                    console.log("No data rows found (only header row)");
                    return;
                }
                
                for(var i = 0; i < rows.length; i++) {
                    var row = rows[i];
                    if (i === 0) {
                        // Skip header row
                        continue;
                    }
                    
                row.addEventListener("click", function() {
                        Highlight(rows, this);
                        Display(this);
                });
                }
            } catch (e) {
                console.error("Error in ListenTable: " + e.message);
            }
        }
        
        function Display(row) {
            console.log("Display function called for row");
            try {
                var didTxt = document.getElementById("<%= DiscountIdHidden.ClientID %>");
                var nTxt = document.getElementById("<%= NameTxt.ClientID %>");
                var dtTxt = document.getElementById("<%= DiscountTypeDdl.ClientID %>");
                var vTxt = document.getElementById("<%= ValueTxt.ClientID %>");
                var atTxt = document.getElementById("<%= ApplicableToDdl.ClientID %>");
                var sdTxt = document.getElementById("<%= StartDateTxt.ClientID %>");
                var edTxt = document.getElementById("<%= EndDateTxt.ClientID %>");
                var moaTxt = document.getElementById("<%= MinOrderAmountTxt.ClientID %>");
                var sTxt = document.getElementById("<%= StatusDdl.ClientID %>");
                var descTxt = document.getElementById("<%= DescriptionTxt.ClientID %>");
                
                if (!didTxt || !nTxt || !dtTxt || !vTxt || !atTxt || !sdTxt || !edTxt || !moaTxt || !sTxt || !descTxt) {
                    console.error("One or more form elements not found");
                    return;
                }
                
                var cols = row.querySelectorAll("td");
                if (cols.length < 8) {
                    console.error("Row doesn't have enough columns: " + cols.length);
                    return;
                }
                
                console.log("Setting discount ID: " + row.getAttribute("data-discount_id"));
            didTxt.value = row.getAttribute("data-discount_id");
            nTxt.value = cols[0].innerText;
                
                // Set discount type dropdown
                var discountType = cols[1].innerText;
                dtTxt.value = discountType === "Percentage" ? "1" : "2";
                
                // Set value (remove formatting)
                var value = cols[2].innerText;
                if (value.startsWith("PHP ")) {
                    value = value.substring(4);
                } else if (value.endsWith("%")) {
                    value = value.substring(0, value.length - 1);
                }
                vTxt.value = value;
            
            // Set applicable to dropdown
                var applicableTo = cols[3].innerText;
            if (applicableTo === "All Products") {
                atTxt.value = "1";
            } else if (applicableTo === "Specific Category") {
                atTxt.value = "2";
            } else {
                atTxt.value = "3";
            }
            
            sdTxt.value = cols[4].innerText;
            edTxt.value = cols[5].innerText;
                
                // Set min order amount (remove formatting)
                var minOrder = cols[6].innerText;
                if (minOrder === "None") {
                    moaTxt.value = "";
                } else if (minOrder.startsWith("PHP ")) {
                    moaTxt.value = minOrder.substring(4);
                } else {
                    moaTxt.value = minOrder;
                }
                
                // Get status text (removing the span tags)
                var statusCell = cols[7];
                var statusText = "";
                if (statusCell.querySelector("span")) {
                    statusText = statusCell.querySelector("span").innerText;
                } else {
                    statusText = statusCell.innerText;
                }
                
                // Set status dropdown
                sTxt.value = statusText.trim() === "Active" ? "1" : "0";
                
                // Set description
                descTxt.value = row.getAttribute("data-description") || "";
                
                console.log("Form populated successfully");
            } catch (e) {
                console.error("Error in Display function: " + e.message);
            }
        }

        function ListenToButtons() {
            const addBtn = document.getElementById("AddBtn");
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const discountIdTxt = document.getElementById("<%= DiscountIdHidden.ClientID %>");
            const nameTxt = document.getElementById("NameTxt");
            const valueTxt = document.getElementById("ValueTxt");
            const startDateTxt = document.getElementById("StartDateTxt");
            const endDateTxt = document.getElementById("EndDateTxt");

            // Add button validation
            addBtn.addEventListener("click", function(e) {
                if (nameTxt.value.trim() === "" || valueTxt.value.trim() === "") {
                    showAlert("Name and Value are required fields!", "warning");
                    e.preventDefault();
                    return false;
                }
                
                if (startDateTxt.value.trim() === "" || endDateTxt.value.trim() === "") {
                    showAlert("Start Date and End Date are required!", "warning");
                    e.preventDefault();
                    return false;
                }
            });

            editBtn.addEventListener("click", function(e) {
                if (discountIdTxt.value.length == 0) {
                    showAlert("Please Select a Discount!", "warning");
                    e.preventDefault();
                }
            });
            
            removeBtn.addEventListener("click", function(e) {
                if (discountIdTxt.value.length == 0) {
                    showAlert("Please Select a Discount!", "warning");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this discount?")) {
                    e.preventDefault();
                    return false;
                }
            });
        }
        
        function showAlert(message, type) {
            console.log("showAlert called: " + message + ", type: " + type);
            try {
                var alertMessage = document.getElementById("alertMessage");
                if (!alertMessage) {
                    console.error("Alert message element not found");
                    return;
                }
                
                // Clear previous classes and add new ones
            alertMessage.className = "alert-message";
            alertMessage.classList.add("alert-" + type);
                
                // Set message and show
            alertMessage.innerHTML = message;
            alertMessage.style.display = "block";
                
                // Auto-hide after 5 seconds
                setTimeout(function() {
                    alertMessage.style.display = "none";
                }, 5000);
            } catch (e) {
                console.error("Error in showAlert: " + e.message);
            }
        }
    </script>
</body>
</html>
