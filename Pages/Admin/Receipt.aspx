<%@ Page Language="VB" AutoEventWireup="true" CodeFile="Receipt.aspx.vb" Inherits="Pages_Admin_Receipt" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Order Receipt - Hapag Restaurant</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <style type="text/css">
        @media print {
            body {
                margin: 0;
                padding: 0;
                color: #000;
                background-color: #fff;
                font-family: Arial, sans-serif;
                font-size: 12pt;
            }
            
            .no-print { display: none !important; }
            
            .receipt-container {
                width: 100%;
                max-width: 80mm; /* Standard receipt width */
                margin: 0 auto;
                padding: 0;
            }
        }
        
        @media screen {
            body {
                margin: 0;
                padding: 20px;
                color: #000;
                background-color: #f8f8f8;
                font-family: Arial, sans-serif;
                font-size: 12pt;
            }
            
            .receipt-container {
                width: 100%;
                max-width: 80mm; /* Standard receipt width */
                margin: 0 auto;
                padding: 10px;
                background-color: #fff;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            
            .print-button {
                display: block;
                margin: 20px auto;
                padding: 10px 20px;
                background-color: #4CAF50;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }
            
            .print-button:hover {
                background-color: #45a049;
            }
        }
        
        /* Common styles for both screen and print */
        .header {
            text-align: center;
            margin-bottom: 10px;
        }
        
        .logo {
            font-weight: bold;
            font-size: 20px;
            margin-bottom: 5px;
        }
        
        .address,
        .contact {
            font-size: 12px;
            margin-bottom: 5px;
        }
        
        .divider {
            border-bottom: 1px dashed #000;
            margin: 10px 0;
        }
        
        .order-info {
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .items {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }
        
        .items th, .items td {
            padding: 3px;
            text-align: left;
            vertical-align: top;
        }
        
        .items .qty {
            text-align: center;
            width: 40px;
        }
        
        .items .price,
        .items .amount {
            text-align: right;
            width: 60px;
        }
        
        .total {
            text-align: right;
            font-weight: bold;
            margin: 10px 0;
            font-size: 16px;
        }
        
        .footer {
            text-align: center;
            font-size: 12px;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <button class="print-button no-print" onclick="window.print()">Print Receipt</button>
    
    <form id="form1" runat="server">
        <div class="receipt-container">
            <div class="header">
                <div class="logo">Hapag Restaurant</div>
                <div class="address">123 Hapag Food Corporation, Manila, Philippines</div>
                <div class="contact">Tel: (123) 456-7890</div>
            </div>
            
            <div class="divider"></div>
            
            <div class="order-info">
                <div><strong>Order #:</strong> <asp:Literal ID="OrderIdLiteral" runat="server"></asp:Literal></div>
                <div><strong>Customer:</strong> <asp:Literal ID="CustomerNameLiteral" runat="server"></asp:Literal></div>
                <div><strong>Date:</strong> <asp:Literal ID="OrderDateLiteral" runat="server"></asp:Literal></div>
            </div>
            
            <div class="divider"></div>
            
            <table class="items">
                <thead>
                    <tr>
                        <th>Item</th>
                        <th class="qty">Qty</th>
                        <th class="price">Price</th>
                        <th class="amount">Amount</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="ItemsRepeater" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("name") %></td>
                                <td class="qty"><%# Eval("quantity") %></td>
                                <td class="price"><%# String.Format("{0:0.00}", Eval("price")) %></td>
                                <td class="amount"><%# String.Format("{0:0.00}", CDec(Eval("price")) * CInt(Eval("quantity"))) %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>
            
            <div class="divider"></div>
            
            <div class="total">Total: PHP <asp:Literal ID="TotalAmountLiteral" runat="server"></asp:Literal></div>
            
            <div class="divider"></div>
            
            <div class="footer">
                <p>Thank you for dining with us!</p>
            </div>
        </div>
    </form>
    
    <script type="text/javascript">
        // Auto-print when the page loads in a popup window
        if (window.opener) {
            window.onload = function() {
                setTimeout(function() {
                    window.print();
                }, 500);
            };
        }
    </script>
</body>
</html> 