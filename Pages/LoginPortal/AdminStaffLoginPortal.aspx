<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminStaffLoginPortal.aspx.vb" Inherits="Pages_LoginPortal_AdminStaffLoginPortal" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin & Staff Login</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <style type="text/css">
        .login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background-color: #f5f5f5;
        }
        
        .login-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
        }
        
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .login-header img {
            max-width: 150px;
            margin-bottom: 20px;
        }
        
        .login-header h1 {
            color: #333;
            font-size: 24px;
            margin: 0;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #666;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
        }
        
        .form-control:focus {
            border-color: #619F2B;
            outline: none;
            box-shadow: 0 0 5px rgba(97, 159, 43, 0.2);
        }
        
        .login-btn {
            background-color: #619F2B;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            width: 100%;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        
        .login-btn:hover {
            background-color: #4c7c22;
        }
        
        .alert-message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: none;
        }
        
        .alert-message.show {
            display: block;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        
        .alert-success {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        
        .user-type-selector {
            margin-bottom: 20px;
            text-align: center;
        }
        
        .user-type-selector label {
            margin: 0 10px;
            cursor: pointer;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .remember-me input[type="checkbox"] {
            margin-right: 10px;
        }
        
        @media (max-width: 480px) {
            .login-box {
                padding: 20px;
                margin: 20px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="login-container">
            <div class="login-box">
                <div class="login-header">
                    <img src="../../Assets/Images/logo-removebg-preview.png" alt="Logo" />
                    <h1>Admin & Staff Login</h1>
                </div>
                
                <div class="alert-message" id="alertMessage" runat="server" visible="false">
                    <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                </div>
                
                <div class="user-type-selector">
                    <asp:RadioButton ID="AdminRadio" runat="server" GroupName="UserType" Text="Admin" Checked="true" />
                    <asp:RadioButton ID="StaffRadio" runat="server" GroupName="UserType" Text="Staff" />
                </div>
                
                <div class="form-group">
                    <label for="UsernameTxt">Username</label>
                    <asp:TextBox ID="UsernameTxt" runat="server" CssClass="form-control" placeholder="Enter your username"></asp:TextBox>
                </div>
                
                <div class="form-group">
                    <label for="PasswordTxt">Password</label>
                    <asp:TextBox ID="PasswordTxt" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter your password"></asp:TextBox>
                </div>
                
                <div class="remember-me">
                    <asp:CheckBox ID="RememberMeChk" runat="server" Text="Remember me" />
                </div>
                
                <asp:Button ID="LoginBtn" runat="server" Text="Login" CssClass="login-btn" OnClick="LoginBtn_Click" />
            </div>
        </div>
    </form>
</body>
</html>
