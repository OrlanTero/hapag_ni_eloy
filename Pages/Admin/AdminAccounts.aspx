<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminAccounts.aspx.vb" Inherits="Pages_Admin_AdminAccounts" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Account Management</title>
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
            <h1>Account Management</h1>
            <p>Add, edit, or remove user accounts</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <!-- Form Container -->
        <div class="form-container">
            <asp:TextBox ID="UserIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden ClientIDMode="Static"></asp:TextBox>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Username:</h3>
                    <asp:TextBox ID="UsernameTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Password:</h3>
                    <asp:TextBox ID="PasswordTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Contact:</h3>
                    <asp:TextBox ID="ContactTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Address:</h3>
                    <asp:TextBox ID="AddressTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Display Name:</h3>
                    <asp:TextBox ID="DisplayNameTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>User Type:</h3>
                    <asp:DropDownList ID="UsertypeDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="Admin" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Staff" Value="2"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-actions">
                <asp:Button ID="AddBtn" runat="server" Text="ADD" CssClass="btn btn-primary" ClientIDMode="Static" />
                <asp:Button ID="EditBtn" runat="server" Text="EDIT" CssClass="btn btn-secondary" ClientIDMode="Static" />
                <asp:Button ID="RemoveBtn" runat="server" Text="REMOVE" CssClass="btn btn-danger" ClientIDMode="Static" />
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
                row.addEventListener("click", function() {
                    Highlight(rows, row);
                    Display(row);
                });
            }
        }
        
        function Display(row) {
            console.log("Display function called for row:", row);
            
            const uidTxt = document.getElementById("UserIdTxt");
            const uTxt = document.getElementById("UsernameTxt");
            const pTxt = document.getElementById("PasswordTxt");
            const dndTxt = document.getElementById("DisplayNameTxt");
            const cTxt = document.getElementById("ContactTxt");
            const aTxt = document.getElementById("AddressTxt");
            const utTxt = document.getElementById("UsertypeDdl");
            
            if (!uidTxt || !uTxt || !pTxt || !dndTxt || !cTxt || !aTxt || !utTxt) {
                console.error("One or more required elements not found!");
                return;
            }
            
            const cols = row.querySelectorAll("td");
            if (cols.length === 0) {
                console.error("No columns found in the selected row!");
                return;
            }

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
            
            if (!editBtn || !removeBtn || !uidTxt) {
                console.error("One or more button elements not found!");
                return;
            }

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

        // Initialize table and button listeners when the DOM is loaded
        document.addEventListener("DOMContentLoaded", function() {
            console.log("DOM fully loaded, initializing listeners");
            ListenTable();
            ListenToButtons();
        });
    </script>
</asp:Content>
