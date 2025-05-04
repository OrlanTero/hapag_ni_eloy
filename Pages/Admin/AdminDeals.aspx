<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDeals.aspx.vb" Inherits="Pages_Admin_AdminDeals" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Manage Deals</title>
    <script src="../../Scripts/jquery-3.6.0.min.js" type="text/javascript"></script>
    <link href="../../Scripts/jquery-ui.css" rel="stylesheet" type="text/css" />
    <script src="../../Scripts/jquery-ui.min.js" type="text/javascript"></script>
    <style type="text/css">
        .image-panel {
            width: 200px;
            height: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
            margin-top: 10px;
            background-color: #f8f8f8;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .image-panel img {
            max-width: 100%;
            max-height: 100%;
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
            <h1>Manage Deals</h1>
            <p>Add, edit, or remove special deals for customers</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <!-- Form Container -->
        <div class="form-container">
            <asp:TextBox ID="DealIdTxt" runat="server" Width="282px" RequiredFieldValidator1="true" hidden ClientIDMode="Static"></asp:TextBox>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Name:</h3>
                    <asp:TextBox ID="NameTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Value:</h3>
                    <asp:TextBox ID="ValueTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Value Type:</h3>
                    <asp:DropDownList ID="ValueTypeDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="Percentage" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Fixed Amount" Value="2"></asp:ListItem>
                        <asp:ListItem Text="Buy One Get One" Value="3"></asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group-half">
                    <h3>Start Date:</h3>
                    <asp:TextBox ID="StartDateTxt" runat="server" CssClass="form-control date-picker1" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Valid Until:</h3>
                    <asp:TextBox ID="ValidUntilTxt" runat="server" CssClass="form-control date-picker2" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Image:</h3>
                    <div class="image-upload-container">
                        <div class="image-preview">
                            <asp:Panel ID="ImagePanel" runat="server" CssClass="image-panel" ClientIDMode="Static">
                            </asp:Panel>
                        </div>
                        <div class="file-upload">
                            <asp:FileUpload ID="ImageUpload" runat="server" CssClass="form-control" ClientIDMode="Static" />
                            <asp:Button ID="UploadBtn" runat="server" Text="Upload" CssClass="btn btn-info" ClientIDMode="Static" />
                        </div>
                    </div>
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
                <asp:Button ID="RemoveBtn" runat="server" Text="REMOVE" CssClass="btn btn-danger" ClientIDMode="Static" />
                <asp:Button ID="ClearBtn" runat="server" Text="CLEAR" CssClass="btn btn-info" ClientIDMode="Static" />
            </div>
        </div>
    </div>
    
    <!-- Table Container -->
    <div class="content-container">
        <div class="content-header">
            <h1>Available Deals</h1>
            <p>Click on a row to select and edit a deal</p>
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
            
            const didTxt = document.getElementById("DealIdTxt");
            const nTxt = document.getElementById("NameTxt");
            const vTxt = document.getElementById("ValueTxt");
            const vtTxt = document.getElementById("ValueTypeDdl");
            const sdTxt = document.getElementById("StartDateTxt");
            const vuTxt = document.getElementById("ValidUntilTxt");
            const dTxt = document.getElementById("DescriptionTxt");
            
            if (!didTxt || !nTxt || !vTxt || !vtTxt || !sdTxt || !vuTxt || !dTxt) {
                console.error("One or more required elements not found!");
                return;
            }
            
            const cols = row.querySelectorAll("td");
            if (cols.length === 0) {
                console.error("No columns found in the selected row!");
                return;
            }

            didTxt.value = row.getAttribute("data-deals_id");
            nTxt.value = cols[0].innerText;
            vTxt.value = cols[1].innerText;
            vtTxt.value = cols[2].innerText;
            sdTxt.value = cols[3].innerText;
            vuTxt.value = cols[4].innerText;
            dTxt.value = cols[6].innerText;
        }

        function ListenToButtons() {
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const dealIdTxt = document.getElementById("DealIdTxt");
            
            if (!editBtn || !removeBtn || !dealIdTxt) {
                console.error("One or more button elements not found!");
                return;
            }

            editBtn.addEventListener("click", function(e) {
                if (dealIdTxt.value.length == 0) {
                    alert("Please Select a Deal!");
                    e.preventDefault();
                }
            });
            
            removeBtn.addEventListener("click", function(e) {
                if (dealIdTxt.value.length == 0) {
                    alert("Please Select a Deal!");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this deal?")) {
                    e.preventDefault();
                    return false;
                }
            });
        }

        // Initialize datepickers and table listeners when DOM is loaded
        document.addEventListener("DOMContentLoaded", function() {
            console.log("DOM fully loaded, initializing listeners");
            
            // Initialize date pickers
            $(".date-picker1, .date-picker2").datepicker({
                dateFormat: 'mm/dd/yy'
            });
            
            ListenTable();
            ListenToButtons();
        });
    </script>
</asp:Content>
