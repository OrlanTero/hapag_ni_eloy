<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminMenu.aspx.vb" Inherits="Pages_Admin_AdminMenu" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Menu Management</title>
    <link href="./../../StyleSheets/MenuManagement.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .image-preview {
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
        
        .image-preview img {
            max-width: 100%;
            max-height: 100%;
        }
        
        .file-upload {
            margin-top: 10px;
        }
        
        .description-box {
            width: 100%;
            height: 80px;
        }
        
        .menu-grid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .menu-grid th, .menu-grid td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        
        .menu-grid th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        
        .menu-grid tr:hover {
            background-color: #f5f5f5;
        }
        
        .menu-grid .active {
            background-color: #e0f7fa;
        }
        
        .image-upload-container {
            margin-top: 10px;
        }
        
        .image-preview {
            width: 200px;
            height: 200px;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 5px;
            margin-bottom: 10px;
            background-color: #f8f8f8;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        
        .preview-image {
            max-width: 100%;
            max-height: 100%;
            object-fit: contain;
        }
        
        .file-upload {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .file-upload .form-control {
            flex: 1;
        }
        
        .file-upload .btn {
            white-space: nowrap;
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
            <h1>Menu Management</h1>
            <p>Add, edit, and manage menu items</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <!-- Form Container -->
        <div class="form-container">
            <div class="form-row">
                <div class="form-group-half">
                <h3>ID:</h3>
                <asp:TextBox ID="ItemIdTxt" runat="server" CssClass="form-control" Width="282px" RequiredFieldValidator1="true" hidden ClientIDMode="Static"></asp:TextBox>

                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                <h3>Name:</h3>
                    <asp:TextBox ID="NameTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
                <div class="form-group-half">
                    <h3>Price:</h3>
                    <asp:TextBox ID="PriceTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Category:</h3>
                    <asp:DropDownList ID="CategoryDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
                <div class="form-group-half">
                    <h3>Type:</h3>
                    <asp:DropDownList ID="TypeDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                    </asp:DropDownList>
                </div>
            </div>
            
            <div class="form-row">
                <div class="form-group-half">
                    <h3>Availability:</h3>
                    <asp:DropDownList ID="AvailabilityDdl" runat="server" CssClass="form-control" ClientIDMode="Static">
                        <asp:ListItem Text="Available" Value="1"></asp:ListItem>
                        <asp:ListItem Text="Not Available" Value="0"></asp:ListItem>
                    </asp:DropDownList>
         </div>
                <div class="form-group-half">
                    <h3>Number of Servings:</h3>
                    <asp:TextBox ID="ServingsTxt" runat="server" CssClass="form-control" ClientIDMode="Static"></asp:TextBox>
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
                    <h3>Image:</h3>
                    <div class="image-upload-container">
                        <div class="image-preview" id="imagePreview">
                            <asp:Image ID="ItemImage" runat="server" AlternateText="No Image" CssClass="preview-image" ClientIDMode="Static" />
                        </div>
                        <div class="file-upload">
                            <asp:FileUpload ID="ImageUpload" runat="server" CssClass="form-control" accept="image/*" ClientIDMode="Static" />
                            <asp:Button ID="UploadBtn" runat="server" Text="Upload" OnClick="UploadBtn_Click" CssClass="btn btn-info" />
                            <asp:HiddenField ID="ImagePathHidden" runat="server" ClientIDMode="Static" />
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="form-actions">
                <asp:Button ID="AddBtn" runat="server" Text="ADD" CssClass="btn btn-primary" ClientIDMode="Static" />
                <asp:Button ID="EditBtn" runat="server" Text="EDIT" CssClass="btn btn-secondary" ClientIDMode="Static" />
                <asp:Button ID="RemoveBtn" runat="server" Text="REMOVE" CssClass="btn btn-danger" ClientIDMode="Static" />
                <asp:Button ID="ClearBtn" runat="server" Text="CLEAR" CssClass="btn btn-info" OnClick="ClearBtn_Click" ClientIDMode="Static" />
            </div>
        </div>
    </div>
    
    <!-- Table Container -->
    <div class="content-container">
        <div class="content-header">
            <h1>Menu Items</h1>
            <p>Click on a row to select and edit a menu item</p>
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
            
            const iidTxt = document.getElementById("ItemIdTxt");
            const nTxt = document.getElementById("NameTxt");
            const pTxt = document.getElementById("PriceTxt");
            const cyDdl = document.getElementById("CategoryDdl");
            const tyDdl = document.getElementById("TypeDdl");
            const ayDdl = document.getElementById("AvailabilityDdl");
            const sTxt = document.getElementById("ServingsTxt");
            const dTxt = document.getElementById("DescriptionTxt");
            const imgPreview = document.getElementById("imagePreview");
            const imgPath = document.getElementById("ImagePathHidden");
            
            if (!iidTxt || !nTxt || !pTxt || !cyDdl || !tyDdl || !ayDdl || !sTxt || !dTxt || !imgPath) {
                console.error("One or more required elements not found!");
                return;
            }
            
            const cols = row.querySelectorAll("td");
            if (cols.length === 0) {
                console.error("No columns found in the selected row!");
                return;
            }

            iidTxt.value = row.getAttribute("data-item_id");
            nTxt.value = cols[0].innerText;
            pTxt.value = cols[1].innerText;
            
            // Set category dropdown
            const categoryId = row.getAttribute("data-category_id");
            if (categoryId) {
                for (let i = 0; i < cyDdl.options.length; i++) {
                    if (cyDdl.options[i].value === categoryId) {
                        cyDdl.selectedIndex = i;
                        break;
                    }
                }
            }
            
            // Set type dropdown
            const typeId = row.getAttribute("data-type_id");
            if (typeId) {
                for (let i = 0; i < tyDdl.options.length; i++) {
                    if (tyDdl.options[i].value === typeId) {
                        tyDdl.selectedIndex = i;
                        break;
                    }
                }
            }
            
            // Set availability
            ayDdl.value = cols[4].innerText === "Available" ? "1" : "0";
            
            sTxt.value = cols[5].innerText;
            dTxt.value = row.getAttribute("data-description");
            
            // Set image
            const imagePath = row.getAttribute("data-image");
            imgPath.value = imagePath;
            
            // Update image preview
            const itemImage = document.getElementById("ItemImage");
            if (itemImage) {
                if (imagePath && imagePath.length > 0) {
                    itemImage.src = imagePath;
                    itemImage.style.display = "block";
                } else {
                    itemImage.style.display = "none";
                }
            }
        }

         function ListenToButtons() {
            const editBtn = document.getElementById("EditBtn");
            const removeBtn = document.getElementById("RemoveBtn");
            const itemIdTxt = document.getElementById("ItemIdTxt");
            
            if (!editBtn || !removeBtn || !itemIdTxt) {
                console.error("One or more button elements not found!");
                return;
            }

            editBtn.addEventListener("click", function(e) {
                if (itemIdTxt.value.length == 0) {
                    alert("Please Select a Menu Item!");
                    e.preventDefault();
                }
           });
        
            removeBtn.addEventListener("click", function(e) {
                if (itemIdTxt.value.length == 0) {
                    alert("Please Select a Menu Item!");
                    e.preventDefault();
                    return false;
                }
                
                if(!confirm("Do you really want to delete this menu item?")) {
                    e.preventDefault();
                    return false;
                }
            });
        }

        // Preview uploaded image
        const fileInput = document.getElementById("ImageUpload");
        const imagePreview = document.getElementById("imagePreview");
        const itemImage = document.getElementById("ItemImage");
        
        if (fileInput && imagePreview && itemImage) {
            fileInput.addEventListener("change", function() {
                const file = this.files[0];
                if (file) {
                    // Validate if it's an image
                    if (!file.type.startsWith('image/')) {
                        alert('Please select an image file');
                        this.value = '';
                        return;
                    }

                    const reader = new FileReader();
                    reader.addEventListener("load", function() {
                        if (itemImage) {
                            itemImage.src = reader.result;
                            itemImage.style.display = "block";
                        }
                    });
                    reader.readAsDataURL(file);
                } else {
                    if (itemImage) {
                        itemImage.src = "";
                        itemImage.style.display = "none";
                    }
                }
            });
        }

        // Initialize table and button listeners
        document.addEventListener("DOMContentLoaded", function() {
            console.log("DOM fully loaded, initializing listeners");
            ListenTable();
            ListenToButtons();
        });
    </script>
</asp:Content>
