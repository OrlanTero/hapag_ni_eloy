<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminMenuTypes.aspx.vb" Inherits="Pages_Admin_AdminMenuTypes" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Menu Types</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <link href="./../../StyleSheets/Admin.css" rel="stylesheet" type="text/css" />
    <link href="./../../StyleSheets/MenuManagement.css" rel="stylesheet" type="text/css" />
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

                    <a href="AdminMenuTypes.aspx" class="active">
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
                        <h1>Manage Menu Types</h1>
                        <p>Add, edit, or remove menu types. Click on a row in the table to select and edit a type.</p>
                    </div>
                    
                    <!-- Alert Message -->
                    <div class="alert-message" id="alertMessage" runat="server" visible="false">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
                    <!-- Form Container -->
                    <div class="form-container">
                        <asp:TextBox ID="TypeIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden></asp:TextBox>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <h3>Type Name:</h3>
                                <asp:TextBox ID="TypeNameTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <h3>Description:</h3>
                                <asp:TextBox ID="DescriptionTxt" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <h3>Status:</h3>
                                <asp:DropDownList ID="StatusDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
                                </asp:DropDownList>
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
                        <h1>Menu Types</h1>
                        <p>Click on a row to select and edit a menu type</p>
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
            const typeIdTxt = document.getElementById("TypeIdTxt");
            const typeNameTxt = document.getElementById("TypeNameTxt");
            const descriptionTxt = document.getElementById("DescriptionTxt");
            const statusDdl = document.getElementById("StatusDdl");
            const cols = row.querySelectorAll("td");

            typeIdTxt.value = row.getAttribute("data-type_id");
            typeNameTxt.value = cols[0].innerText;
            descriptionTxt.value = cols[1].innerText;
            statusDdl.value = cols[2].innerText === "Active" ? "1" : "0";
        }

        function ListenToButtons() {
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const typeIdTxt = document.getElementById("TypeIdTxt");

            editBtn.addEventListener("click", function(e) {
                if (typeIdTxt.value.length == 0) {
                    showAlert("Please Select a Type!", "warning");
                    e.preventDefault();
                }
            });
            
            removeBtn.addEventListener("click", function(e) {
                if (typeIdTxt.value.length == 0) {
                    showAlert("Please Select a Type!", "warning");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this type?")) {
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