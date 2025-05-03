<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ResetPassword.aspx.vb" Inherits="Pages_LoginPortal_ResetPassword" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Reset Password - Hapag Filipino Restaurant</title>
    <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
    <style>
        /* Custom styles for reset password page */
        .right-side-background {
            position: fixed; 
            top: 0;
            right: 0;
            width: 50%;
            height: 100vh;
            background-repeat: no-repeat;
            background-position: center;
            background-size: cover;
            z-index: 1;
        }
        
        .reset-main-container {
            position: relative;
            display: flex;
            min-height: 100vh;
            margin-top: 0;
        }
        
        .reset-main-auth-container {
            position: relative;
            left: 15%;
            margin-top: 50px;
            background: #fff;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.15);
            width: 450px;
            z-index: 2;
        }
        
        .reset-head h1 {
            font-size: 2.2rem;
            color: #333;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .reset-head p {
            color: #666;
            margin-bottom: 25px;
            text-align: center;
            line-height: 1.5;
        }
        
        .reset-form-group {
            margin-bottom: 20px;
        }
        
        .reset-form-group label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
            color: #555;
        }
        
        .reset-form-group input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        
        .reset-form-group input[type="password"]:focus {
            border-color: #FCA418;
            outline: none;
            box-shadow: 0 0 0 3px rgba(252, 164, 24, 0.1);
        }
        
        .password-requirements {
            background-color: #f9f9f9;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            font-size: 0.9rem;
        }
        
        .password-requirements h3 {
            font-size: 1rem;
            margin-bottom: 10px;
            color: #555;
        }
        
        .password-requirements ul {
            list-style: none;
            padding-left: 0;
            margin: 0;
        }
        
        .password-requirements ul li {
            margin-bottom: 5px;
            color: #777;
            display: flex;
            align-items: center;
        }
        
        .password-requirements ul li::before {
            content: "•";
            display: inline-block;
            margin-right: 8px;
            color: #FCA418;
        }
        
        .reset-form-group button,
        .reset-form-group input[type="button"],
        .reset-form-group input[type="submit"] {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background-color: #FCA418;
            color: white;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
        }
        
        .reset-form-group button:hover,
        .reset-form-group input[type="button"]:hover,
        .reset-form-group input[type="submit"]:hover {
            background-color: #e59316;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(252, 164, 24, 0.2);
        }
        
        .success-message {
            display: none;
            padding: 20px;
            margin-top: 20px;
            background-color: rgba(46, 204, 113, 0.1);
            border-left: 4px solid #2ecc71;
            border-radius: 4px;
        }
        
        .success-message h3 {
            color: #27ae60;
            margin-bottom: 10px;
        }
        
        .success-message p {
            color: #555;
            margin-bottom: 15px;
        }
        
        .success-message a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #FCA418;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .success-message a:hover {
            background-color: #e59316;
            transform: translateY(-2px);
        }
        
        .error-message {
            display: none;
            padding: 15px;
            margin-bottom: 20px;
            background-color: rgba(231, 76, 60, 0.1);
            border-left: 4px solid #e74c3c;
            border-radius: 4px;
            color: #c0392b;
        }
        
        @media (max-width: 992px) {
            .right-side-background {
                width: 40%;
            }
            
            .reset-main-auth-container {
                left: 5%;
            }
        }
        
        @media (max-width: 768px) {
            .right-side-background {
                display: none;
            }
            
            .reset-main-auth-container {
                left: 50%;
                transform: translateX(-50%);
                width: 90%;
                max-width: 450px;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="root-container">
            <div class="reset-main-container">
                <div class="right-side-background" 
                    style="background-image:url('./../../Assets/Images/backgrounds/signup_background.png')"></div>

                <div class="reset-main-auth-container">
                    <div class="reset-head">
                        <h1>Reset Your Password</h1>
                        <p>Create a new password for your account.</p>
                    </div>
                    
                    <div id="errorMessage" class="error-message" runat="server" visible="false">
                        Invalid or expired reset token. Please request a new password reset link.
                    </div>
                    
                    <div id="resetForm" runat="server">
                        <div class="password-requirements">
                            <h3>Password Requirements:</h3>
                            <ul>
                                <li>At least 8 characters long</li>
                                <li>Contains at least one uppercase letter</li>
                                <li>Contains at least one lowercase letter</li>
                                <li>Contains at least one number</li>
                                <li>Contains at least one special character</li>
                            </ul>
                        </div>
                        
                        <div class="reset-form-group">
                            <label for="newPassword">New Password</label>
                            <asp:TextBox ID="newPassword" runat="server" TextMode="Password"></asp:TextBox>
                        </div>
                        
                        <div class="reset-form-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <asp:TextBox ID="confirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                        </div>
                        
                        <asp:HiddenField ID="tokenValue" runat="server" />
                        
                        <div class="reset-form-group">
                            <asp:Button ID="resetPasswordBtn" runat="server" Text="Reset Password" />
                        </div>
                    </div>
                    
                    <div id="successMessage" class="success-message" runat="server" visible="false">
                        <h3>Password Reset Successful!</h3>
                        <p>Your password has been updated successfully. You can now log in with your new password.</p>
                        <a href="CustomerLoginPortal.aspx">Go to Login</a>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html> 