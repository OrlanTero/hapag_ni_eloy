<%@ Page Language="VB" AutoEventWireup="false" CodeFile="CustomerSupport.aspx.vb" Inherits="Pages_Admin_CustomerSupport" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-container">
        <div class="content-header">
            <h1><i class="fas fa-headset"></i> Customer Support</h1>
            <p>Manage customer inquiries and support requests</p>
        </div>
        
        <!-- Alert Message -->
        <div class="alert-message" id="alertMessage" runat="server" visible="false">
            <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
        </div>
        
        <div class="dashboard-card">
            <div class="card-header">
                <h2>Customer Support Center</h2>
            </div>
            <div class="card-body">
                <div class="empty-state">
                    <i class="fas fa-headset fa-4x"></i>
                    <h3>Customer Support Dashboard</h3>
                    <p>This area will be used to manage customer inquiries and support requests.</p>
                    <p>Check back later for updates to this functionality.</p>
                </div>
            </div>
        </div>
    </div>
    
    <style type="text/css">
        .content-container {
            padding: 20px;
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .content-header {
            margin-bottom: 30px;
        }
        
        .content-header h1 {
            font-size: 28px;
            color: #2C3E50;
            margin-bottom: 10px;
        }
        
        .content-header p {
            color: #7f8c8d;
            font-size: 16px;
        }
        
        .dashboard-card {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            overflow: hidden;
        }
        
        .card-header {
            background-color: #f8f9fa;
            padding: 15px 20px;
            border-bottom: 1px solid #eee;
        }
        
        .card-header h2 {
            margin: 0;
            font-size: 18px;
            color: #2C3E50;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state i {
            color: #619F2B;
            margin-bottom: 20px;
            opacity: 0.7;
        }
        
        .empty-state h3 {
            color: #2C3E50;
            margin-bottom: 15px;
        }
        
        .empty-state p {
            color: #7f8c8d;
            max-width: 600px;
            margin: 0 auto 10px;
        }
    </style>
</asp:Content> 