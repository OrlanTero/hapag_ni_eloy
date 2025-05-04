<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminMenuTypes.aspx.vb" Inherits="Pages_Admin_AdminMenuTypes" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Menu Types</title>
    <link href="./../../StyleSheets/MenuManagement.css" rel="stylesheet" type="text/css" />
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
            <h1>Manage Menu Types</h1>
            <p>Add, edit, or remove menu types. Click on a row in the table to select and edit a type.</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <!-- Form Container -->
        <div class="form-container">
            <asp:TextBox ID="TypeIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden ClientIDMode="Static"></asp:TextBox>
            
            <div class="form-row">
                <div class="form-group">
                    <h3>Type Name:</h3>
                    <asp:TextBox ID="TypeNameTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <h3>Description:</h3>
                    <asp:TextBox ID="DescriptionTxt" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group">
                    <h3>Status:</h3>
                    <asp:DropDownList ID="StatusDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="Active" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Inactive" Value="0"></asp:ListItem>
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
            <h1>Menu Types</h1>
            <p>Click on a row to select and edit a menu type</p>
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
            
            const typeIdTxt = document.getElementById("TypeIdTxt");
            const typeNameTxt = document.getElementById("TypeNameTxt");
            const descriptionTxt = document.getElementById("DescriptionTxt");
            const statusDdl = document.getElementById("StatusDdl");
            
            if (!typeIdTxt || !typeNameTxt || !descriptionTxt || !statusDdl) {
                console.error("One or more required elements not found!");
                return;
            }
            
            const cols = row.querySelectorAll("td");
            if (cols.length === 0) {
                console.error("No columns found in the selected row!");
                return;
            }

            typeIdTxt.value = row.getAttribute("data-type_id");
            typeNameTxt.value = cols[0].innerText;
            descriptionTxt.value = cols[1].innerText;
            statusDdl.value = cols[2].innerText === "Active" ? "1" : "0";
        }

        function ListenToButtons() {
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const typeIdTxt = document.getElementById("TypeIdTxt");
            
            if (!editBtn || !removeBtn || !typeIdTxt) {
                console.error("One or more button elements not found!");
                return;
            }

            editBtn.addEventListener("click", function(e) {
                if (typeIdTxt.value.length == 0) {
                    alert("Please Select a Type!");
                    e.preventDefault();
                }
            });
            
            removeBtn.addEventListener("click", function(e) {
                if (typeIdTxt.value.length == 0) {
                    alert("Please Select a Type!");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this type?")) {
                    e.preventDefault();
                    return false;
                }
            });
        }

        // Initialize table and button listeners when the DOM is loaded
        document.addEventListener("DOMContentLoaded", function() {
            console.log("DOM fully loaded, initializing listeners");
            ListenTable();
            ListenToButtons();
        });
    </script>
</asp:Content> 