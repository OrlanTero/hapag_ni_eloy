<%@ Page Language="VB" AutoEventWireup="true" CodeFile="ForgotPasswordOTP.aspx.vb" Inherits="Pages_LoginPortal_ForgotPasswordOTP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Verify Email - Hapag Filipino Restaurant</title>
    <link href="./../../StyleSheets/StyleSheet.css" rel="stylesheet" type="text/css" />
    <style>
        /* Custom styles for OTP verification page */
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
        
        .otp-main-container {
            position: relative;
            display: flex;
            min-height: 100vh;
            margin-top: 0;
        }
        
        .otp-main-auth-container {
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
        
        .otp-head h1 {
            font-size: 2.2rem;
            color: #333;
            margin-bottom: 15px;
            text-align: center;
        }
        
        .otp-head p {
            color: #666;
            margin-bottom: 25px;
            text-align: center;
            line-height: 1.5;
        }
        
        .otp-form-group {
            margin-bottom: 20px;
        }
        
        .otp-input-container {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin: 30px 0;
        }
        
        .otp-input {
            width: 45px;
            height: 45px;
            font-size: 24px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 8px;
            margin: 0 5px;
        }
        
        .otp-input:focus {
            border-color: #FCA418;
            outline: none;
            box-shadow: 0 0 0 3px rgba(252, 164, 24, 0.1);
        }
        
        .timer-container {
            text-align: center;
            margin-bottom: 20px;
            font-size: 16px;
            color: #555;
        }
        
        .otp-form-group button,
        .otp-form-group input[type="button"],
        .otp-form-group input[type="submit"] {
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
        
        .otp-form-group button:hover,
        .otp-form-group input[type="button"]:hover,
        .otp-form-group input[type="submit"]:hover {
            background-color: #e59316;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(252, 164, 24, 0.2);
        }
        
        .resend-link {
            text-align: center;
            margin-top: 20px;
        }
        
        .resend-link a {
            color: #FCA418;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.2s;
        }
        
        .resend-link a:hover {
            text-decoration: underline;
        }
        
        .error-message {
            padding: 15px;
            margin-bottom: 20px;
            background-color: rgba(231, 76, 60, 0.1);
            border-left: 4px solid #e74c3c;
            border-radius: 4px;
            color: #c0392b;
            display: none;
        }
        
        .error-message.visible {
            display: block;
        }
        
        .remaining-attempts {
            text-align: center;
            margin-top: 10px;
            font-size: 14px;
            color: #777;
        }
        
        @media (max-width: 992px) {
            .right-side-background {
                width: 40%;
            }
            
            .otp-main-auth-container {
                left: 5%;
            }
        }
        
        @media (max-width: 768px) {
            .right-side-background {
                display: none;
            }
            
            .otp-main-auth-container {
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
            <div class="otp-main-container">
                <div class="right-side-background" 
                    style="background-image:url('./../../Assets/Images/backgrounds/signup_background.png')"></div>

                <div class="otp-main-auth-container">
                    <div class="otp-head">
                        <h1>Verify Your Email</h1>
                        <p>
                            We've sent a verification code to<br />
                            <strong><asp:Label ID="EmailLabel" runat="server" Text="your email"></asp:Label></strong><br />
                            Enter the code below to continue resetting your password.
                        </p>
                    </div>
                    
                    <div id="errorMessage" class="error-message" runat="server">
                        Invalid verification code. Please try again.
                    </div>
                    
                    <div class="otp-input-container">
                        <asp:TextBox ID="OtpDigit1" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                        <asp:TextBox ID="OtpDigit2" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                        <asp:TextBox ID="OtpDigit3" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                        <asp:TextBox ID="OtpDigit4" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                        <asp:TextBox ID="OtpDigit5" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                        <asp:TextBox ID="OtpDigit6" runat="server" CssClass="otp-input" MaxLength="1" autocomplete="off"></asp:TextBox>
                    </div>
                    
                    <div class="timer-container">
                        Code expires in: <span id="timer">15:00</span>
                        <asp:HiddenField ID="RemainingTimeHidden" runat="server" Value="900" />
                    </div>
                    
                    <div class="remaining-attempts">
                        Remaining attempts: <asp:Label ID="AttemptsLabel" runat="server" Text="3"></asp:Label>
                    </div>
                    
                    <div class="otp-form-group">
                        <asp:Button ID="VerifyButton" runat="server" Text="Verify & Continue" />
                    </div>
                    
                    <div class="resend-link">
                        <asp:LinkButton ID="ResendButton" runat="server" Text="Resend Code"></asp:LinkButton>
                    </div>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        // OTP input auto-tab functionality
        document.addEventListener('DOMContentLoaded', function() {
            const inputs = document.querySelectorAll('.otp-input');
            
            inputs.forEach((input, index) => {
                // When user enters a digit, move to next input
                input.addEventListener('keyup', function(e) {
                    // Move to next input on valid input
                    if (e.key >= '0' && e.key <= '9' && index < inputs.length - 1) {
                        inputs[index + 1].focus();
                    }
                    
                    // Allow backspace to go to previous input
                    if (e.key === 'Backspace' && index > 0) {
                        if (input.value === '') {
                            inputs[index - 1].focus();
                        }
                    }
                });
                
                // Prevent non-numeric input
                input.addEventListener('keypress', function(e) {
                    if (e.key < '0' || e.key > '9') {
                        e.preventDefault();
                    }
                });
                
                // Handle paste events
                input.addEventListener('paste', function(e) {
                    e.preventDefault();
                    const pasteData = e.clipboardData.getData('text');
                    const digits = pasteData.replace(/\D/g, '').substring(0, inputs.length);
                    
                    if (digits.length > 0) {
                        // Distribute digits to inputs
                        for (let i = 0; i < Math.min(digits.length, inputs.length); i++) {
                            inputs[i].value = digits[i];
                        }
                        
                        // Focus the next empty input or the last one
                        const nextIndex = Math.min(digits.length, inputs.length - 1);
                        inputs[nextIndex].focus();
                    }
                });
            });
            
            // Timer functionality
            const timerElement = document.getElementById('timer');
            const remainingTimeField = document.getElementById('<%= RemainingTimeHidden.ClientID %>');
            let remainingSeconds = parseInt(remainingTimeField.value);
            
            function updateTimer() {
                const minutes = Math.floor(remainingSeconds / 60);
                const seconds = remainingSeconds % 60;
                timerElement.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
                
                if (remainingSeconds <= 0) {
                    clearInterval(timerInterval);
                    timerElement.textContent = '00:00';
                    // Disable verification button when time expires
                    document.getElementById('<%= VerifyButton.ClientID %>').disabled = true;
                } else {
                    remainingSeconds--;
                }
            }
            
            // Update timer immediately and then every second
            updateTimer();
            const timerInterval = setInterval(updateTimer, 1000);
        });
    </script>
</body>
</html> 