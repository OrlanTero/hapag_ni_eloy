<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerLoginPortal.aspx.vb" Inherits="CustomerLoginPortal" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Customer Login - Hapag Filipino Restaurant</title>
     <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
    <style>
        /* Custom styles for login page */
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
        
        .register-main-container {
            position: relative;
            display: flex;
            min-height: 100vh;
            margin-top: 0;
        }
        
        .register-main-auth-container.login {
            width: 550px !important;
            max-width: 90% !important;
            height: 650px !important;
            padding-bottom: -10px !important;
            margin: 0 !important;
            display: flex !important;
            flex-direction: column !important;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15) !important;
            position: absolute !important;
            top: 150px !important;
            left: 250px !important;
        }
        
        .left-head h1 {
            padding: 15px 0 10px !important;
            text-align: center !important;
        }
        
        .left-form-group label {
            font-weight: 500;
            margin-bottom: 8px;
            display: block;
            color: #555;
        }
        
        .left-form-group input[type="text"],
        .left-form-group input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            box-sizing: border-box;
            height: 40px !important;
        }
        
        .left-form-group input[type="text"]:focus,
        .left-form-group input[type="password"]:focus {
            border-color: #FCA418;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            width: 100%;
            font-size: 16px;
            outline: none;
            box-shadow: 0 0 0 3px rgba(252, 164, 24, 0.1);
            height: 40px !important;
        }
        
        .left-form-group input[type="button"],
        .left-form-group input[type="submit"] {
            height: 40px !important;
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
            margin-top: 20px;
        }
        
        .left-form-group input[type="button"]:hover,
        .left-form-group input[type="submit"]:hover {
            height: 40px !important;
            background-color: #e59316;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(252, 164, 24, 0.2);
            padding: 12px;
        }
        
        .left-form-group p {
            text-align: center;
            margin-top: 25px;
            color: #666;
            font-size: 15px;
            text-align: center;
        }
        
        .left-form-group a {
            color: #FCA418;
            text-decoration: none;
            font-weight: 600;
        }
        
        .left-form-group a:hover {
            text-decoration: underline;
        }
        
        .forgot-password {
            text-align: center;
            margin-top: 5px;
        }
        
        .forgot-password a {
            color: #777;
            font-size: 0.9rem;
            text-decoration: none;
            transition: all 0.2s;
        }
        
        .forgot-password a:hover {
            color: #FCA418;
        }
        
        /* Password Recovery Panel */
        .password-recovery {
            display: none;
            background: white;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 5px 25px rgba(0,0,0,0.15);
            width: 420px;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 10;
        }
        
        .password-recovery.active {
            display: block;
        }
        
        .password-recovery h2 {
            font-size: 1.8rem;
            color: #333;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .password-recovery p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.5;
        }
        
        .password-recovery .form-group {
            margin-bottom: 20px;
        }
        
        .password-recovery .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        
        .password-recovery .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s;
            box-sizing: border-box;
        }
        
        .password-recovery .form-group input:focus {
            border-color: #FCA418;
            outline: none;
            box-shadow: 0 0 0 3px rgba(252, 164, 24, 0.1);
        }
        
        .recovery-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 25px;
        }
        
        .recovery-buttons input[type="button"],
        .recovery-buttons input[type="submit"] {
            padding: 12px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
            transition: all 0.3s;
            background-color: #FCA418;
            color: white;
            flex-grow: 1;
            margin-right: 10px;
            
        }
        
        .recovery-buttons input[type="button"]:hover,
        .recovery-buttons input[type="submit"]:hover {
            background-color: #e59316;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(252, 164, 24, 0.2);
        }
        
        .recovery-buttons .cancel-btn {
            background-color: #f0f0f0;
            color: #666;
            width: 100px;
        }
        
        .recovery-buttons .cancel-btn:hover {
            background-color: #e0e0e0;
        }
        
        .overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 5;
        }
        
        .overlay.active {
            display: block;
        }
        
        .success-message {
            display: none;
            text-align: center;
            margin-top: 20px;
            padding: 15px;
            background-color: rgba(46, 204, 113, 0.1);
            border-left: 4px solid #2ecc71;
            border-radius: 4px;
            color: #27ae60;
        }
        
        .success-message.active {
            display: block;
        }
        
        @media (max-width: 992px) {
            .right-side-background {
                width: 40%;
            }
            
            .register-main-auth-container.login {
                left: 5%;
            }
        }
        
        @media (max-width: 768px) {
            .right-side-background {
                display: none;
            }
            
            .register-main-auth-container.login {
                left: 50%;
                transform: translateX(-50%);
            }
        }
    </style>
</head>
<body>
       <form id="Form1" runat="server">
        <div class="root-container">
       <div class="register-main-container">
            <div class="right-side-background" 
                    style="background-image:url('./../../Assets/Images/backgrounds/login_background.png')"></div>

            <div class="register-main-auth-container login">
                <div class="left-head">
                    <h1>
                            Login
                    </h1>
                </div>
                
                <div class="left-body">
                    
                    <div class="left-form-group">
                        <label for="username">Username</label>
                        <asp:TextBox ID="usernameTxt" runat="server"></asp:TextBox>
                    </div>
                    <div class="left-form-group">
                        <label for="username">&nbsp;Password</label>
                        &nbsp;&nbsp;<asp:TextBox ID="passwordTxt" type="password" runat="server"></asp:TextBox>
                            
                    <br><br><br>
                      <div class="left-form-group">
                            <asp:Button ID="Button1" Text="Login" runat="server" />
                        </div>
                        <div class="forgot-password">
                            <a href="javascript:void(0);" onclick="showPasswordRecovery()">Forgot password?</a>
                        </div>
                    </div>

                    <div class="left-form-group">
                        <p>
                        Don't have an account? <a href="./../LoginPortal/RegisterPortal.aspx">Register</a>
                        </p>
                    </div>
                </div>
            </div>
       </div>
    </div>
        
        <!-- Password Recovery Overlay -->
        <div id="recoveryOverlay" class="overlay">
            <div id="passwordRecoveryPanel" class="password-recovery">
                <h2>Password Recovery</h2>
                <p>Enter the email address associated with your account. We'll send you a verification link to reset your password.</p>
                
                <div class="form-group">
                    <label for="recoveryEmail">Email Address</label>
                    <asp:TextBox ID="recoveryEmail" runat="server" type="email" placeholder="Enter your email"></asp:TextBox>
                </div>
                
                <div id="successMessage" class="success-message">
                    Password recovery link has been sent to your email. Please check your inbox.
                </div>
                
                <div class="recovery-buttons">
                    <asp:Button ID="btnSendLink" runat="server" Text="Send Recovery Link" CssClass="submit-btn" OnClientClick="return simulatePasswordRecovery();" />
                    <button type="button" class="cancel-btn" onclick="hidePasswordRecovery()">Cancel</button>
            </div>
       </div>
    </div>
    </form>

  <script type="text/javascript">
        function showPasswordRecovery() {
            document.getElementById('recoveryOverlay').classList.add('active');
            document.getElementById('passwordRecoveryPanel').classList.add('active');
        }
        
        function hidePasswordRecovery() {
            document.getElementById('recoveryOverlay').classList.remove('active');
            document.getElementById('passwordRecoveryPanel').classList.remove('active');
            document.getElementById('successMessage').classList.remove('active');
            document.getElementById('recoveryEmail').value = '';
        }
        
        function simulatePasswordRecovery() {
            // Get the email address
            var email = document.getElementById('recoveryEmail').value;
            
            // Simple validation
            if (!email || email.indexOf('@') === -1) {
                alert('Please enter a valid email address.');
                return false;
            }
            
            // Show success message (in a real app, this would happen after server validation)
            document.getElementById('successMessage').classList.add('active');
            
            // Prevent the form from submitting
            return false;
        }
    </script>
</body>
</html>
