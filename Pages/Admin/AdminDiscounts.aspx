<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDiscounts.aspx.vb" Inherits="Pages_Admin_AdminDiscounts" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Manage Discounts</title>
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
            <h1>Manage Discounts</h1>
            <p>Add, edit, or remove discount offers</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" style="display: none;">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <!-- Form Container -->
        <div class="form-container">
            <asp:TextBox ID="DiscountIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden ClientIDMode="Static"></asp:TextBox>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Discount Name:</h3>
                    <asp:TextBox ID="NameTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Discount Type:</h3>
                    <asp:DropDownList ID="DiscountTypeDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="Percentage" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Fixed Amount" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Discount Value:</h3>
                    <asp:TextBox ID="ValueTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Applicable To:</h3>
                    <asp:DropDownList ID="ApplicableToDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="All Products" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Specific Category" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Specific Product" Value="3"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Start Date:</h3>
                    <asp:TextBox ID="StartDateTxt" runat="server" CssClass="form-control date-picker1" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>End Date:</h3>
                    <asp:TextBox ID="EndDateTxt" runat="server" CssClass="form-control date-picker2" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Minimum Order Amount:</h3>
                    <asp:TextBox ID="MinOrderAmountTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Status:</h3>
                    <asp:DropDownList ID="StatusDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <h3>Description:</h3>
                    <asp:TextBox ID="DescriptionTxt" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-actions">
                <asp:Button ID="AddBtn" runat="server" Text="ADD" CssClass="btn btn-primary" ClientIDMode="Static" />
                <asp:Button ID="EditBtn" runat="server" Text="EDIT" CssClass="btn btn-secondary" ClientIDMode="Static" />
                <asp:Button ID="DeleteBtn" runat="server" Text="DELETE" CssClass="btn btn-danger" ClientIDMode="Static" />
                <asp:Button ID="ClearBtn" runat="server" Text="CLEAR" CssClass="btn btn-info" ClientIDMode="Static" />
            </div>
        </div>
    </div>
    
    <!-- Table Container -->
    <div class="content-container">
        <div class="content-header">
            <h1>Available Discounts</h1>
            <p>Click on a row to select and edit a discount</p>
        </div>
        <div class="table-responsive" id="TableContainer" runat="server">
            <asp:Table ID="Table1" runat="server" CssClass="table table-striped table-hover" ClientIDMode="Static">
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

    <script type="text/javascript">
        // Define showAlert function in the global scope
        function showAlert(message, type) {
            try {
                // Try to use the master page's showAlert function
                if (typeof window.masterShowAlert === 'function') {
                    window.masterShowAlert(message, type);
                    return;
                }
                
                // Fallback to local implementation
                var alertMessage = document.getElementById("alertMessage");
                
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
            // First make sure menuToggle event listener is set
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
            
            // Initialize date pickers
            if (typeof $ !== 'undefined' && $.datepicker) {
                $(".date-picker1, .date-picker2").datepicker({
                    dateFormat: 'mm/dd/yy'
                });
            }
            
            // Initialize table listeners
            setTimeout(function() {
                try {
                    ListenTable();
                    ListenToButtons();
                } catch (e) {
                    console.error("Error initializing: " + e.message);
                }
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
            var table = document.getElementById("Table1");
            if (!table) {
                console.error("Table1 element not found");
                return;
            }
            
            var rows = table.querySelectorAll("tr");
            if (rows.length <= 1) {
                console.log("No data rows found (only header row)");
                return;
            }

            for(var i = 0; i < rows.length; i++) {
                if (i === 0) {
                    // Skip header row
                    continue;
                }
                rows[i].addEventListener("click", function() {
                    Highlight(rows, this);
                    Display(this);
                });
            }
        }
        
        function Display(row) {
            var didTxt = document.getElementById("DiscountIdTxt");
            var nTxt = document.getElementById("NameTxt");
            var dtTxt = document.getElementById("DiscountTypeDdl");
            var vTxt = document.getElementById("ValueTxt");
            var atTxt = document.getElementById("ApplicableToDdl");
            var sdTxt = document.getElementById("StartDateTxt");
            var edTxt = document.getElementById("EndDateTxt");
            var moaTxt = document.getElementById("MinOrderAmountTxt");
            var sTxt = document.getElementById("StatusDdl");
            var descTxt = document.getElementById("DescriptionTxt");
            
            if (!didTxt || !nTxt || !dtTxt || !vTxt || !atTxt || !sdTxt || !edTxt || !moaTxt || !sTxt || !descTxt) {
                console.error("One or more form elements not found");
                return;
            }
            
            var cols = row.querySelectorAll("td");
            if (cols.length === 0) {
                console.error("No columns found in the selected row");
                return;
            }
            
            didTxt.value = row.getAttribute("data-discount_id");
            nTxt.value = cols[0].innerText;
            
            // Set discount type dropdown
            var discountType = cols[1].innerText;
            dtTxt.value = discountType === "Percentage" ? "1" : "2";
            
            // Set value (remove formatting)
            var value = cols[2].innerText;
            if (value.startsWith("₱")) {
                value = value.substring(1);
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
            } else if (minOrder.startsWith("₱")) {
                moaTxt.value = minOrder.substring(1);
            } else {
                moaTxt.value = minOrder;
            }
            
            // Get status text and handle possible span tag
            var statusCell = cols[7];
            var statusText = "";
            if (statusCell.querySelector("span")) {
                statusText = statusCell.querySelector("span").innerText.trim();
            } else {
                statusText = statusCell.innerText.trim();
            }
            sTxt.value = statusText === "Active" ? "1" : "0";
            
            // Set description
            descTxt.value = row.getAttribute("data-description") || "";
        }

        function ListenToButtons() {
            var addBtn = document.getElementById("AddBtn");
            var editBtn = document.getElementById("EditBtn");
            var deleteBtn = document.getElementById("DeleteBtn");
            var discountIdTxt = document.getElementById("DiscountIdTxt");
            var nameTxt = document.getElementById("NameTxt");
            var valueTxt = document.getElementById("ValueTxt");
            var startDateTxt = document.getElementById("StartDateTxt");
            var endDateTxt = document.getElementById("EndDateTxt");
            
            if (!addBtn || !editBtn || !deleteBtn || !discountIdTxt || !nameTxt || !valueTxt || !startDateTxt || !endDateTxt) {
                console.error("One or more button or form elements not found");
                return;
            }

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
            
            deleteBtn.addEventListener("click", function(e) {
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
    </script>
</asp:Content>
