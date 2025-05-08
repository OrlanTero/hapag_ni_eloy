<%@ Page Language="VB" AutoEventWireup="true" CodeFile="RegistrationComplete.aspx.vb" Inherits="Pages_RegistrationComplete" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Registration Complete - Hapag Filipino Restaurant</title>
    <link href="../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <link href="../StyleSheets/Customer.css" rel="stylesheet" type="text/css" />
    <link href="../StyleSheets/Containers.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        
        .header {
            padding: 20px;
            background-color: #fff;
            text-align: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        .header img {
            height: 80px;
        }
        
        .main-content {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        
        footer {
            background-color: #333;
            color: #fff;
            text-align: center;
            padding: 20px;
        }
        
        /* Registration Complete Styles */
        .complete-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .complete-icon {
            font-size: 80px;
            color: #4CAF50;
            margin-bottom: 20px;
        }
        
        .complete-title {
            font-size: 28px;
            margin-bottom: 20px;
            color: #333;
        }
        
        .complete-message {
            font-size: 16px;
            margin-bottom: 30px;
            color: #666;
            line-height: 1.6;
        }
        
        .login-btn {
            display: inline-block;
            background-color: #4CAF50;
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            font-size: 16px;
            transition: background-color 0.3s;
        }
        
        .login-btn:hover {
            background-color: #45a049;
        }
        
        .error-message {
            color: #f44336;
            text-align: center;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <img src="../Assets/Images/logo-removebg-preview.png" alt="HAPAG Logo" />
        </div>
        
        <div class="main-content">
            <div class="complete-container">
                <asp:Panel ID="SuccessPanel" runat="server" Visible="true">
                    <div class="complete-icon">✓</div>
                    <h2 class="complete-title">Registration Complete!</h2>
                    <p class="complete-message">
                        Thank you for registering with Hapag Filipino Restaurant. Your account has been created successfully.
                        <br /><br />
                        You can now sign in to your account and start enjoying our services.
                    </p>
                    <a href="../Pages/LoginPortal/CustomerLoginPortal.aspx" class="login-btn">Sign In Now</a>
                </asp:Panel>
                
                <asp:Panel ID="ErrorPanel" runat="server" Visible="false" CssClass="error-message">
                    <p>Sorry, we couldn't complete your registration. Please try again.</p>
                    <a href="../Pages/LoginPortal/RegisterPortal.aspx" class="login-btn">Try Again</a>
                </asp:Panel>
            </div>
        </div>
        
        <footer>
            <p>&copy; <%= DateTime.Now.Year %> HAPAG Filipino Restaurant. All rights reserved.</p>
        </footer>
    </form>
</body>
</html> 