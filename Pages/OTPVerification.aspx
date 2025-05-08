<%@ Page Language="VB" AutoEventWireup="true" CodeFile="OTPVerification.aspx.vb" Inherits="Pages_OTPVerification" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Email Verification - Hapag Filipino Restaurant</title>
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
        
        /* OTP Verification Styles */
        .otp-container {
            max-width: 500px;
            margin: 40px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .otp-title {
            text-align: center;
            margin-bottom: 30px;
            color: #333;
        }
        
        .otp-subtitle {
            text-align: center;
            margin-bottom: 20px;
            color: #666;
            font-size: 16px;
        }
        
        .otp-email {
            text-align: center;
            font-weight: bold;
            margin-bottom: 30px;
            color: #444;
        }
        
        .otp-input-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 30px;
        }
        
        .otp-input {
            width: 50px;
            height: 60px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
            border: 2px solid #ddd;
            border-radius: 8px;
        }
        
        .otp-input:focus {
            border-color: #4CAF50;
            outline: none;
        }
        
        .otp-timer {
            text-align: center;
            margin-bottom: 20px;
            color: #666;
        }
        
        .otp-actions {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .verify-btn {
            background-color: #4CAF50;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        
        .verify-btn:hover {
            background-color: #45a049;
        }
        
        .resend-btn {
            background-color: transparent;
            color: #4CAF50;
            padding: 10px;
            border: 1px solid #4CAF50;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        
        .resend-btn:hover {
            background-color: #f9f9f9;
        }
        
        .resend-btn:disabled {
            color: #999;
            border-color: #ddd;
            cursor: not-allowed;
        }
        
        .error-message {
            color: #f44336;
            text-align: center;
            margin-bottom: 15px;
        }
        
        .success-message {
            color: #4CAF50;
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
            <div class="otp-container">
                <h2 class="otp-title">Email Verification</h2>
                <p class="otp-subtitle">We've sent a verification code to your email address:</p>
                <p class="otp-email">
                    <asp:Literal ID="EmailLiteral" runat="server"></asp:Literal>
                </p>
                
                <asp:Panel ID="ErrorPanel" runat="server" CssClass="error-message" Visible="false">
                    <asp:Literal ID="ErrorMessage" runat="server"></asp:Literal>
                </asp:Panel>
                
                <asp:Panel ID="SuccessPanel" runat="server" CssClass="success-message" Visible="false">
                    <asp:Literal ID="SuccessMessage" runat="server"></asp:Literal>
                </asp:Panel>
                
                <div class="otp-input-container">
                    <asp:TextBox ID="Digit1" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                    <asp:TextBox ID="Digit2" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                    <asp:TextBox ID="Digit3" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                    <asp:TextBox ID="Digit4" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                    <asp:TextBox ID="Digit5" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                    <asp:TextBox ID="Digit6" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                </div>
                
                <div class="otp-timer">
                    Time remaining: <span id="timer">15:00</span>
                </div>
                
                <div class="otp-actions">
                    <asp:Button ID="VerifyButton" runat="server" Text="Verify" CssClass="verify-btn" OnClick="VerifyButton_Click" />
                    <asp:Button ID="ResendButton" runat="server" Text="Resend Code" CssClass="resend-btn" OnClick="ResendButton_Click" />
                </div>
            </div>
        </div>
        
        <footer>
            <p>&copy; <%= DateTime.Now.Year %> HAPAG Filipino Restaurant. All rights reserved.</p>
        </footer>
        
        <asp:HiddenField ID="RemainingSecondsField" runat="server" />
        
        <script type="text/javascript">
            // Auto-focus and auto-tab functionality for OTP inputs
            document.addEventListener('DOMContentLoaded', function() {
                const inputs = document.querySelectorAll('.otp-input');
                
                // Set focus to the first input on page load
                if (inputs.length > 0) {
                    setTimeout(function() {
                        inputs[0].focus();
                    }, 100);
                }
                
                // Handle input events for auto-tabbing
                inputs.forEach(function(input, index) {
                    input.addEventListener('input', function() {
                        if (this.value.length === this.maxLength) {
                            // Move to next input if available
                            if (index < inputs.length - 1) {
                                inputs[index + 1].focus();
                            }
                        }
                    });
                    
                    // Handle backspace key for auto-tabbing backwards
                    input.addEventListener('keydown', function(e) {
                        if (e.key === 'Backspace' && this.value.length === 0) {
                            if (index > 0) {
                                inputs[index - 1].focus();
                            }
                        }
                    });
                });
                
                // Timer functionality
                const timerElement = document.getElementById('timer');
                if (timerElement) {
                    // Get remaining seconds from hidden field
                    let remainingSeconds = parseInt(document.getElementById('<%= RemainingSecondsField.ClientID %>').value) || 0;
                    
                    const updateTimer = function() {
                        if (remainingSeconds <= 0) {
                            timerElement.textContent = "Expired";
                            document.getElementById('<%= ResendButton.ClientID %>').disabled = false;
                            return;
                        }
                        
                        const minutes = Math.floor(remainingSeconds / 60);
                        const seconds = remainingSeconds % 60;
                        timerElement.textContent = minutes.toString().padStart(2, '0') + ':' + seconds.toString().padStart(2, '0');
                        remainingSeconds--;
                        
                        setTimeout(updateTimer, 1000);
                    };
                    
                    // Initialize timer
                    updateTimer();
                    
                    // Initially disable resend button until timer expires
                    document.getElementById('<%= ResendButton.ClientID %>').disabled = remainingSeconds > 0;
                }
            });
        </script>
    </form>
</body>
</html> 