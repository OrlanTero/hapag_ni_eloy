<%@ Page Language="VB" AutoEventWireup="true" CodeFile="RegisterPortal.aspx.vb" Inherits="Pages_Customer_RegisterPortal" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up - Hapag Filipino Restaurant</title>
    <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
    <style>
        /* Additional styles for registration page */
        .form-group label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
            color: #555;
        }
        
        .form-group input[type="text"],
        .form-group input[type="password"],
        .form-group input[type="email"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        
        .form-group input[type="text"]:focus,
        .form-group input[type="password"]:focus,
        .form-group input[type="email"]:focus {
            border-color: #FCA418;
            outline: none;
            box-shadow: 0 0 0 3px rgba(252, 164, 24, 0.1);
        }
        
        .form-group input[type="button"],
        .form-group input[type="submit"] {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background-color: #e74c3c;
            color: white;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .form-group input[type="button"]:hover,
        .form-group input[type="submit"]:hover {
            background-color: #e74c3c;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(252, 164, 24, 0.2);
        }
        
        .field-note {
            font-size: 0.85rem;
            color: #777;
            margin-top: 5px;
            font-style: italic;
        }
        
        .required-field::after {
            content: "*";
            color: #e74c3c;
            margin-left: 4px;
        }
        
        /* Override any other button styles from StyleSheet.css */
        .form-group .ui-button,
        .form-group input[type="button"],
        .form-group input[type="submit"] {
            background-color: #e74c3c !important;
        }
        
        .form-group .ui-button:hover,
        .form-group input[type="button"]:hover,
        .form-group input[type="submit"]:hover {
            background-color: #e74c3c !important;
        }
        
        /* Fix container width and textbox sizes */
        .main-auth-container.signup {
            width: 620px !important;
            max-width: 90% !important;
            height: 820px !important;
            padding-bottom: -10px !important;
            margin: 0 !important;
            display: flex !important;
            flex-direction: column !important;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15) !important;
            position: absolute !important;
            top: -30px !important;
            right: 100px !important;
        }
        
        .main-auth-container .head {
            padding: 15px 0 10px !important;
            text-align: center !important;
        }
        
        .main-auth-container .body {
            padding: 10px 40px 20px !important;
            width: 100% !important;
            box-sizing: border-box !important;
            flex: 1 !important;
        }
        
        .form-group {
            width: 100% !important;
            margin-bottom: 10px !important;
        }
        
        .form-group input {
            height: 40px !important;
        }
        
        .form-group:last-child {
            margin-top: -10px !important;
            text-align: center !important;
        }
        
        .validation-error {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }
        
        .error-summary {
            color: #e74c3c;
            background-color: rgba(231, 76, 60, 0.1);
            border: 1px solid #e74c3c;
            border-radius: 5px;
            padding: 10px;
            margin-bottom: 15px;
            display: none;
        }
    </style>
</head>
<body>
     <form id="Form1" runat="server">
        <div class="root-container">
            <div class="top-navbar">
                <div class="right">
                    <img src="./../../Assets/Images/logo.png" alt="Hapag Logo" />
                </div>
            </div>

            <div class="main-container">
                <div class="left-side-background" style="background-image:url('./../../Assets/Images/backgrounds/signup_background.png')"></div>

                <div class="main-auth-container signup">
                    <div class="head">
                        <h1>
                            SIGN UP
                        </h1>
                    </div>
                    <div class="body">
                        <asp:Panel ID="ErrorSummary" runat="server" CssClass="error-summary" Visible="false">
                            <asp:Literal ID="ErrorMessage" runat="server"></asp:Literal>
                        </asp:Panel>
                        
                        <div class="form-group">
                            <label for="displayName" class="required-field">Display Name</label>
                            <asp:TextBox ID="displayNameTxt" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvDisplayName" runat="server" 
                                ControlToValidate="displayNameTxt" Display="Dynamic" 
                                ErrorMessage="Display Name is required" CssClass="validation-error" />
                        </div>
                        <div class="form-group">
                            <label for="username" class="required-field">Username</label>
                            <asp:TextBox ID="usernameTxt" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                                ControlToValidate="usernameTxt" Display="Dynamic" 
                                ErrorMessage="Username is required" CssClass="validation-error" />
                        </div>
                        <div class="form-group">
                            <label for="email" class="required-field">Email Address</label>
                            <asp:TextBox ID="emailTxt" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" 
                                ControlToValidate="emailTxt" Display="Dynamic" 
                                ErrorMessage="Email Address is required" CssClass="validation-error" />
                            <asp:RegularExpressionValidator ID="revEmail" runat="server" 
                                ControlToValidate="emailTxt" Display="Dynamic" 
                                ErrorMessage="Please enter a valid email address" 
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" CssClass="validation-error" />
                        </div>
                        <div class="form-group">
                            <label for="password" class="required-field">Password</label>
                            <asp:TextBox ID="passwordTxt" runat="server" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                                ControlToValidate="passwordTxt" Display="Dynamic" 
                                ErrorMessage="Password is required" CssClass="validation-error" />
                            <div class="field-note">Password must be at least 6 characters long.</div>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword" class="required-field">Confirm Password</label>
                            <asp:TextBox ID="confirmPasswordTxt" runat="server" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvConfirmPassword" runat="server" 
                                ControlToValidate="confirmPasswordTxt" Display="Dynamic" 
                                ErrorMessage="Please confirm your password" CssClass="validation-error" />
                            <asp:CompareValidator ID="cvPasswords" runat="server" 
                                ControlToValidate="confirmPasswordTxt" ControlToCompare="passwordTxt" Display="Dynamic" 
                                ErrorMessage="Passwords do not match" CssClass="validation-error" />
                        </div>

                        <div class="form-group">
                            <asp:Button ID="Button1" Text="Create Account" runat="server" OnClick="Button1_Click" />
                        </div>

                        <div class="form-group">
                            <p>
                                Already have an account? <a href="./../LoginPortal/CustomerLoginPortal.aspx">Log In</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
