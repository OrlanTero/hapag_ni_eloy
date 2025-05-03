<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerProfile.aspx.vb" Inherits="Pages_Customer_CustomerProfile" MasterPageFile="~/Pages/Customer/CustomerTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Content Container -->
    <div class="content-container">
        <!-- Content Header -->
        <div class="content-header">
            <h1><i class="fas fa-user-circle"></i> My Profile</h1>
            <p>View and manage your account information</p>
        </div>

        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>

        <!-- Toast Container -->
        <div id="toastContainer"></div>

        <!-- Profile Section -->
        <div class="profile-section">
            <div class="profile-header">
                <div class="profile-avatar">
                    <asp:Literal ID="UserInitialsLiteral" runat="server"></asp:Literal>
                </div>
                <div class="profile-title">
                    <h2>
                        <asp:Literal ID="UserDisplayNameLiteral" runat="server"></asp:Literal>
                    </h2>
                    <span class="profile-role"><i class="fas fa-user"></i> Customer</span>
                </div>
            </div>

            <!-- Profile Form -->
            <div class="profile-form">
                <div class="form-group">
                    <label><i class="fas fa-user-tag"></i> Display Name</label>
                    <asp:TextBox ID="DisplayNameTextBox" runat="server" CssClass="form-control" placeholder="Enter your name"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="DisplayNameValidator" runat="server" 
                        ControlToValidate="DisplayNameTextBox" 
                        ErrorMessage="Display name is required" 
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-user"></i> Username</label>
                    <asp:TextBox ID="UsernameTextBox" runat="server" CssClass="form-control" placeholder="Enter username"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="UsernameValidator" runat="server" 
                        ControlToValidate="UsernameTextBox" 
                        ErrorMessage="Username is required" 
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-envelope"></i> Email</label>
                    <asp:TextBox ID="EmailTextBox" runat="server" CssClass="form-control" placeholder="Enter email" ></asp:TextBox>
                    <asp:RequiredFieldValidator ID="EmailValidator" runat="server" 
                        ControlToValidate="EmailTextBox" 
                        ErrorMessage="Email is required" 
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="EmailFormatValidator" runat="server" 
                        ControlToValidate="EmailTextBox"
                        ErrorMessage="Invalid email format"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-phone"></i> Contact Number</label>
                    <asp:TextBox ID="PhoneTextBox" runat="server" CssClass="form-control" placeholder="Enter contact number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="PhoneValidator" runat="server" 
                        ControlToValidate="PhoneTextBox" 
                        ErrorMessage="Contact number is required" 
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-map-marker-alt"></i> Address</label>
                    <asp:TextBox ID="AddressTextBox" runat="server" CssClass="form-control" placeholder="Enter address" TextMode="MultiLine" Rows="3"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="AddressValidator" runat="server" 
                        ControlToValidate="AddressTextBox" 
                        ErrorMessage="Address is required" 
                        CssClass="validation-error" Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-lock"></i> Current Password</label>
                    <asp:TextBox ID="CurrentPasswordTextBox" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter current password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-key"></i> New Password</label>
                    <asp:TextBox ID="NewPasswordTextBox" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter new password"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-check-circle"></i> Confirm New Password</label>
                    <asp:TextBox ID="ConfirmPasswordTextBox" runat="server" CssClass="form-control" TextMode="Password" placeholder="Confirm new password"></asp:TextBox>
                    <asp:CompareValidator ID="PasswordCompareValidator" runat="server"
                        ControlToValidate="ConfirmPasswordTextBox"
                        ControlToCompare="NewPasswordTextBox"
                        ErrorMessage="Passwords do not match"
                        CssClass="validation-error" Display="Dynamic">
                    </asp:CompareValidator>
                </div>

                <div class="button-group">
                    <asp:Button ID="UpdateProfileButton" runat="server" Text="Update Profile" CssClass="btn btn-primary" OnClick="UpdateProfileButton_Click" />
                    <asp:Button ID="DeleteAccountButton" runat="server" Text="Delete Account" CssClass="btn btn-danger" OnClick="DeleteAccountButton_Click" OnClientClick="return confirm('Are you sure you want to delete your account? This action cannot be undone.');" />
                </div>
            </div>
        </div>
    </div>

    <style type="text/css">
        .profile-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }

        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .profile-avatar {
            width: 80px;
            height: 80px;
            background-color: #619F2B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            color: white;
            text-transform: uppercase;
            font-weight: 500;
            border: 3px solid rgba(97, 159, 43, 0.3);
        }

        .profile-title h2 {
            margin: 0 0 5px 0;
            color: #2C3E50;
            font-size: 24px;
        }

        .profile-role {
            color: #666;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .profile-form {
            max-width: 600px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #2C3E50;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-group label i {
            color: #619F2B;
            width: 16px;
            text-align: center;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            border-color: #619F2B;
            outline: none;
            box-shadow: 0 0 0 2px rgba(97, 159, 43, 0.1);
        }

        .validation-error {
            color: #dc3545;
            font-size: 12px;
            margin-top: 5px;
            display: block;
        }

        .button-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        .btn-primary {
            background-color: #619F2B;
            color: white;
        }

        .btn-primary:hover {
            background-color: #4F8022;
        }

        .btn-danger {
            background-color: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background-color: #c82333;
        }

        /* Add icons to buttons */
        .btn-primary:before {
            content: "\f044";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            margin-right: 8px;
        }

        .btn-danger:before {
            content: "\f2ed";
            font-family: "Font Awesome 5 Free";
            font-weight: 900;
            margin-right: 8px;
        }

        @media (max-width: 768px) {
            .profile-section {
                padding: 20px;
            }

            .profile-header {
                flex-direction: column;
                text-align: center;
                gap: 15px;
            }

            .button-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }

        /* Content header with icon */
        .content-header h1 {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .content-header h1 i {
            color: #619F2B;
        }

        /* Toast Notification Styles */
        #toastContainer {
            position: fixed;
            bottom: 20px;
            right: 20px;
            z-index: 1000;
        }

        .toast {
            padding: 15px 25px;
            margin-bottom: 10px;
            border-radius: 8px;
            color: white;
            display: flex;
            align-items: center;
            animation: slideIn 0.3s ease-in-out;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .toast i {
            margin-right: 10px;
            font-size: 18px;
        }

        .toast-success {
            background-color: #619F2B;
        }

        .toast-error {
            background-color: #dc3545;
        }

        @keyframes slideIn {
            from {
                transform: translateX(100%);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }

        @keyframes fadeOut {
            from {
                transform: translateX(0);
                opacity: 1;
            }
            to {
                transform: translateX(100%);
                opacity: 0;
            }
        }
    </style>

    <script type="text/javascript">
        function showToast(message, type) {
            const toast = document.createElement('div');
            toast.className = `toast toast-${type}`;
            
            const icon = document.createElement('i');
            icon.className = type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle';
            toast.appendChild(icon);
            
            const text = document.createTextNode(message);
            toast.appendChild(text);
            
            const container = document.getElementById('toastContainer');
            container.appendChild(toast);

            // Animate out and remove after 3 seconds
            setTimeout(() => {
                toast.style.animation = 'fadeOut 0.3s ease-in-out forwards';
                setTimeout(() => {
                    container.removeChild(toast);
                }, 300);
            }, 3000);
        }
    </script>
</asp:Content> 