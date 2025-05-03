<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminAccounts.aspx.vb" Inherits="Pages_Admin_AdminAccounts" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Account Management</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <link href="./../../StyleSheets/Admin.css" rel="stylesheet" type="text/css" />
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

                    <a href="AdminAccounts.aspx" class="active">
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
                        <h1>Account Management</h1>
                        <p>Add, edit, or remove user accounts</p>
                    </div>
                    
                    <!-- Alert Message -->
                    <div class="alert-message" id="alertMessage" runat="server" visible="false">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
                    <!-- Form Container -->
                    <div class="form-container">
                        <asp:TextBox ID="UserIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden></asp:TextBox>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Username:</h3>
                                <asp:TextBox ID="UsernameTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Password:</h3>
                                <asp:TextBox ID="PasswordTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Contact:</h3>
                                <asp:TextBox ID="ContactTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>Address:</h3>
                                <asp:TextBox ID="AddressTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group-half">
                                <h3>Display Name:</h3>
                                <asp:TextBox ID="DisplayNameTxt" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group-half">
                                <h3>User Type:</h3>
                                <asp:DropDownList ID="UsertypeDdl" runat="server" CssClass="form-control">
                                    <asp:ListItem Text="Admin" Value="1"></asp:ListItem>
                                    <asp:ListItem Text="Staff" Value="2"></asp:ListItem>
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
                        <h1>User Accounts</h1>
                        <p>Click on a row to select and edit a user account</p>
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
            const uidTxt = document.getElementById("UserIdTxt");
            const uTxt = document.getElementById("UsernameTxt");
            const pTxt = document.getElementById("PasswordTxt");
            const dndTxt = document.getElementById("DisplayNameTxt");
            const cTxt = document.getElementById("ContactTxt");
            const aTxt = document.getElementById("AddressTxt");
            const utTxt = document.getElementById("UsertypeDdl");
            const cols = row.querySelectorAll("td");

            uidTxt.value = row.getAttribute("data-user_id");
            uTxt.value = cols[0].innerText;
            pTxt.value = cols[1].innerText;
            dndTxt.value = cols[2].innerText;
            cTxt.value = cols[3].innerText;
            aTxt.value = cols[4].innerText;
            utTxt.value = cols[5].innerText;
        }

        function ListenToButtons() {
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const uidTxt = document.getElementById("UserIdTxt");

            editBtn.addEventListener("click", function(e) {
                if (uidTxt.value.length == 0) {
                    showAlert("Please Select a User!", "warning");
                    e.preventDefault();
                }
            });
            
            removeBtn.addEventListener("click", function(e) {
                if (uidTxt.value.length == 0) {
                    showAlert("Please Select a User!", "warning");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this user?")) {
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
