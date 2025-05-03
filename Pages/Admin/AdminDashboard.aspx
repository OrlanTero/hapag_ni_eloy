<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDashboard.aspx.vb" Inherits="Pages_Admin_AdminDashboard" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="./../../StyleSheets/Layout.css" rel="stylesheet" type="text/css" />
    <link href="./../../StyleSheets/Admin.css" rel="stylesheet" type="text/css" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style type="text/css">
        .dashboard-container {
            padding: 20px 0;
        }
        
        .stats-cards {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            flex: 1;
            min-width: 200px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            display: flex;
            flex-direction: column;
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-card.primary {
            border-top: 4px solid #619F2B;
        }
        
        .stat-card.warning {
            border-top: 4px solid #FFC233;
        }
        
        .stat-card.danger {
            border-top: 4px solid #D12929;
        }
        
        .stat-card.info {
            border-top: 4px solid #2196F3;
        }
        
        .stat-card-title {
            font-size: 14px;
            color: #666;
            margin-bottom: 10px;
        }
        
        .stat-card-value {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .stat-card-change {
            font-size: 12px;
            display: flex;
            align-items: center;
        }
        
        .stat-card-change.positive {
            color: #619F2B;
        }
        
        .stat-card-change.negative {
            color: #D12929;
        }
        
        .stat-card-icon {
            margin-left: auto;
            font-size: 40px;
            opacity: 0.2;
            align-self: flex-start;
        }
        
        .chart-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .chart-card {
            flex: 1;
            min-width: 300px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            height: 400px;
            position: relative;
        }
        
        .chart-card h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 18px;
            color: #333;
        }
        
        .chart-card canvas {
            width: 100% !important;
            height: calc(100% - 50px) !important;
            position: absolute;
            left: 0;
            bottom: 0;
            padding: 20px;
        }
        
        .recent-activity {
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .recent-activity h3 {
            margin-top: 0;
            margin-bottom: 20px;
            font-size: 18px;
            color: #333;
        }
        
        .activity-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        
        .activity-item {
            padding: 15px 0;
            border-bottom: 1px solid #eee;
            display: flex;
            align-items: center;
        }
        
        .activity-item:last-child {
            border-bottom: none;
        }
        
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #f5f5f5;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 15px;
        }
        
        .activity-icon.order {
            background-color: #E3F2FD;
            color: #2196F3;
        }
        
        .activity-icon.user {
            background-color: #E8F5E9;
            color: #4CAF50;
        }
        
        .activity-icon.menu {
            background-color: #FFF8E1;
            color: #FFC107;
        }
        
        .activity-content {
            flex: 1;
        }
        
        .activity-title {
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .activity-time {
            font-size: 12px;
            color: #999;
        }
        
        .quick-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 30px;
        }
        
        .quick-action-btn {
            flex: 1;
            min-width: 150px;
            padding: 15px;
            border-radius: 8px;
            background-color: #fff;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .quick-action-btn.primary {
            background-color: #619F2B;
            color: white;
        }
        
        .quick-action-btn.secondary {
            background-color: #FFC233;
            color: white;
        }
        
        .quick-action-btn.danger {
            background-color: #D12929;
            color: white;
        }
        
        .quick-action-btn.info {
            background-color: #2196F3;
            color: white;
        }
        
        .quick-action-icon {
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .quick-action-text {
            font-size: 14px;
            font-weight: bold;
        }
        
        @media (max-width: 768px) {
            .stats-cards {
                flex-direction: column;
            }
            
            .stat-card {
                width: 100%;
            }
            
            .chart-container {
                flex-direction: column;
            }
            
            .chart-card {
                width: 100%;
                height: 350px;
            }
            
            .quick-actions {
                flex-direction: column;
            }
            
            .quick-action-btn {
                width: 100%;
            }
        }
        
        .user-profile {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 20px;
            background-color: rgba(0, 0, 0, 0.2);
            position: relative;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            gap: 12px;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            background-color: #619F2B;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            color: white;
            text-transform: uppercase;
            font-weight: 500;
            flex-shrink: 0;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }
        
        .user-details {
            flex: 1;
            min-width: 0; /* For text truncation to work */
        }
        
        .user-name {
            color: #FFFFFF;
            font-weight: 500;
            font-size: 15px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            margin-bottom: 2px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }
        
        .user-role {
            color: rgba(255, 255, 255, 0.8);
            font-size: 12px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.2);
        }
        
        .logout-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            background-color: rgba(209, 41, 41, 0.1);
            border: 1px solid rgba(209, 41, 41, 0.2);
            border-radius: 6px;
            color: #FFFFFF;
            font-size: 13px;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 10px;
        }
        
        .logout-btn:hover {
            background-color: rgba(209, 41, 41, 0.2);
            border-color: rgba(209, 41, 41, 0.3);
        }
        
        .logout-btn i {
            margin-right: 8px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <form id="Form1" runat="server">
        <div class="page-container">
            <!-- Admin Sidebar -->
            <div class="admin-sidebar">
                <!-- User Profile Section - Moved to top -->
                <div class="user-profile">
                    <div class="user-info">
                        <div class="user-avatar">
                            <asp:Literal ID="UserInitialsLiteral" runat="server"></asp:Literal>
                        </div>
                        <div class="user-details">
                            <div class="user-name">
                                <asp:Literal ID="UserDisplayNameLiteral" runat="server"></asp:Literal>
                            </div>
                            <div class="user-role">Administrator</div>
                        </div>
                    </div>
                    <asp:LinkButton ID="LogoutButton" runat="server" CssClass="logout-btn" OnClick="LogoutButton_Click">
                        <i class="fas fa-sign-out-alt"></i> Logout
                    </asp:LinkButton>
                </div>

                <div class="logo">
                    <img src="../../Assets/Images/logo-removebg-preview.png" alt="Logo" />
                </div>

                <div class="nav-links">
                    <a href="AdminDashboard.aspx" class="active">
                        <img src="../../Assets/Images/icons/dashboard icon black.png" class="black" />
                        <img src="../../Assets/Images/icons/dasboard icon white.png" class="white" />
                        <span>Dashboard</span>
                    </a>

                    <a href="AdminMenu.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Menu</span>
                    </a> 

                    <a href="AdminMenuCategories.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Categories</span>
                    </a>

                    <a href="AdminMenuTypes.aspx">
                        <img src="../../Assets/Images/icons/menu-black.png" class="black" />
                        <img src="../../Assets/Images/icons/menu-white.png" class="white" />
                        <span>Types</span>
                    </a>

                    <a href="AdminOrders.aspx">
                        <img src="../../Assets/Images/icons/order-black.png" class="black" />
                        <img src="../../Assets/Images/icons/order-white.png" class="white" />
                        <span>Orders</span>
                    </a>

                    <a href="AdminAccounts.aspx">
                        <img src="../../Assets/Images/icons/account-black.png" class="black" />
                        <img src="../../Assets/Images/icons/account-white.png" class="white" />
                        <span>Accounts</span>
                    </a>

                    <div class="dropdown-container">
                        <a href="javascript:void(0);" class="dropdown-toggle">
                            <img src="../../Assets/Images/icons/administrator-black.png" class="black" />
                            <img src="../../Assets/Images/icons/administrator-white.png" class="white" />
                            <span>Administrator</span>
                        </a>
                        <div class="dropdown-menu">
                            <a href="AdminDeals.aspx">Deals</a>
                            <a href="AdminPromotions.aspx">Promotions</a>
                            <a href="AdminDiscounts.aspx">Discounts</a>
                        </div>
                    </div>

                    <a href="Admin Transaction.aspx">
                        <img src="../../Assets/Images/icons/transaction-black.png" class="black" />
                        <img src="../../Assets/Images/icons/transaction-white.png" class="white" />
                        <span>Transactions</span>
                    </a>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="main-content">
                <!-- Mobile Menu Toggle -->
                <button class="menu-toggle" id="menuToggle">
                    <i class="fa fa-bars"></i> Menu
                </button>
                
                <!-- Content Container -->
                <div class="content-container">
                    <!-- Content Header -->
                    <div class="content-header">
                        <h1>Dashboard</h1>
                        <p>Welcome to the Food Ordering System Admin Dashboard</p>
                    </div>
                    
                    <!-- Alert Message -->
                    <div class="alert-message" id="alertMessage" runat="server" visible="false">
                        <asp:Literal ID="AlertLiteral" runat="server"></asp:Literal>
                    </div>
                    
                    <!-- Dashboard Content -->
                    <div class="dashboard-container">
                        <!-- Stats Cards -->
                        <div class="stats-cards">
                            <div class="stat-card primary">
                                <div class="stat-card-title">Total Orders</div>
                                <div class="stat-card-value">
                                    <asp:Literal ID="TotalOrdersLiteral" runat="server">124</asp:Literal>
                                </div>
                                <div class="stat-card-change positive">
                                    <span>↑ 12.5%</span> from last month
                                </div>
                                <div class="stat-card-icon">📊</div>
                            </div>
                            
                            <div class="stat-card info">
                                <div class="stat-card-title">Total Revenue</div>
                                <div class="stat-card-value">PHP
                                    <asp:Literal ID="TotalRevenueLiteral" runat="server">25,430</asp:Literal>
                                </div>
                                <div class="stat-card-change positive">
                                    <span>↑ 8.3%</span> from last month
                                </div>
                                <div class="stat-card-icon">💰</div>
                            </div>
                            
                            <div class="stat-card warning">
                                <div class="stat-card-title">Active Users</div>
                                <div class="stat-card-value">
                                    <asp:Literal ID="ActiveUsersLiteral" runat="server">45</asp:Literal>
                                </div>
                                <div class="stat-card-change positive">
                                    <span>↑ 5.2%</span> from last month
                                </div>
                                <div class="stat-card-icon">👥</div>
                            </div>
                            
                            <div class="stat-card danger">
                                <div class="stat-card-title">Menu Items</div>
                                <div class="stat-card-value">
                                    <asp:Literal ID="MenuItemsLiteral" runat="server">78</asp:Literal>
                                </div>
                                <div class="stat-card-change positive">
                                    <span>↑ 3.7%</span> from last month
                                </div>
                                <div class="stat-card-icon">🍔</div>
                            </div>
                        </div>
                        
                        <!-- Quick Actions -->
                        <div class="quick-actions">
                            <a href="AdminMenu.aspx" class="quick-action-btn primary">
                                <div class="quick-action-icon">🍽️</div>
                                <div class="quick-action-text">Add Menu Item</div>
                            </a>
                            
                            <a href="AdminOrders.aspx" class="quick-action-btn secondary">
                                <div class="quick-action-icon">📋</div>
                                <div class="quick-action-text">View Orders</div>
                            </a>
                            
                            <a href="AdminDeals.aspx" class="quick-action-btn info">
                                <div class="quick-action-icon">🏷️</div>
                                <div class="quick-action-text">Manage Deals</div>
                            </a>
                            
                            <a href="AdminAccounts.aspx" class="quick-action-btn danger">
                                <div class="quick-action-icon">👤</div>
                                <div class="quick-action-text">User Accounts</div>
                            </a>
                        </div>
                        
                        <!-- Charts -->
                        <div class="chart-container">
                            <div class="chart-card">
                                <h3>Sales Overview</h3>
                                <canvas id="salesChart"></canvas>
                            </div>
                            
                            <div class="chart-card">
                                <h3>Popular Categories</h3>
                                <canvas id="categoriesChart"></canvas>
                            </div>
                        </div>
                        
                        <!-- Recent Activity -->
                        <div class="recent-activity">
                            <h3>Recent Activity</h3>
                            <ul class="activity-list">
                                <li class="activity-item">
                                    <div class="activity-icon order">📦</div>
                                    <div class="activity-content">
                                        <div class="activity-title">New order #1234 received</div>
                                        <div class="activity-time">10 minutes ago</div>
                                    </div>
                                </li>
                                
                                <li class="activity-item">
                                    <div class="activity-icon user">👤</div>
                                    <div class="activity-content">
                                        <div class="activity-title">New user John Doe registered</div>
                                        <div class="activity-time">1 hour ago</div>
                                    </div>
                                </li>
                                
                                <li class="activity-item">
                                    <div class="activity-icon menu">🍔</div>
                                    <div class="activity-content">
                                        <div class="activity-title">Menu item "Chicken Adobo" updated</div>
                                        <div class="activity-time">3 hours ago</div>
                                    </div>
                                </li>
                                
                                <li class="activity-item">
                                    <div class="activity-icon order">📦</div>
                                    <div class="activity-content">
                                        <div class="activity-title">Order #1230 completed</div>
                                        <div class="activity-time">5 hours ago</div>
                                    </div>
                                </li>
                                
                                <li class="activity-item">
                                    <div class="activity-icon menu">🍔</div>
                                    <div class="activity-content">
                                        <div class="activity-title">New menu item "Sinigang" added</div>
                                        <div class="activity-time">Yesterday</div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <!-- Footer -->
                <div class="footer">
                    <p>&copy; <%= DateTime.Now.Year %> Food Ordering System. All rights reserved.</p>
                </div>
            </div>
        </div>
    </form>

    <script type="text/javascript">
        // Mobile menu toggle
        document.getElementById('menuToggle').addEventListener('click', function() {
            var sidebar = document.querySelector('.admin-sidebar');
            var mainContent = document.querySelector('.main-content');
            
            if (sidebar.style.width === '250px' || sidebar.style.width === '') {
                sidebar.style.width = '0';
                mainContent.style.marginLeft = '0';
            } else {
                sidebar.style.width = '250px';
                mainContent.style.marginLeft = '250px';
            }
        });
        
        // Dropdown toggle
        document.addEventListener('DOMContentLoaded', function() {
            var dropdownToggles = document.querySelectorAll('.dropdown-toggle');
            
            dropdownToggles.forEach(function(toggle) {
                toggle.addEventListener('click', function(e) {
                    e.preventDefault();
                    this.parentElement.classList.toggle('active');
                });
            });
            
            // Set active class based on current page
            var currentPage = window.location.pathname.split('/').pop();
            var navLinks = document.querySelectorAll('.nav-links a');
            var dropdownLinks = document.querySelectorAll('.dropdown-menu a');
            
            navLinks.forEach(function(link) {
                var href = link.getAttribute('href');
                if (href === currentPage) {
                    link.classList.add('active');
                }
            });
            
            dropdownLinks.forEach(function(link) {
                var href = link.getAttribute('href');
                if (href === currentPage) {
                    link.classList.add('active');
                    link.parentElement.parentElement.classList.add('active');
                }
            });
            
            // Initialize Charts
            // Sales Chart
            var salesCtx = document.getElementById('salesChart').getContext('2d');
            var salesChart = new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                    datasets: [{
                        label: 'Sales',
                        data: [12500, 15000, 14000, 16500, 18000, 21000, 25000],
                        backgroundColor: 'rgba(97, 159, 43, 0.2)',
                        borderColor: '#619F2B',
                        borderWidth: 2,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return 'PHP ' + value;
                                }
                            }
                        }
                    }
                }
            });
            
            // Categories Chart
            var categoriesCtx = document.getElementById('categoriesChart').getContext('2d');
            var categoriesChart = new Chart(categoriesCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Main Dishes', 'Desserts', 'Beverages', 'Appetizers', 'Sides'],
                    datasets: [{
                        data: [45, 20, 15, 10, 10],
                        backgroundColor: [
                            '#619F2B',
                            '#FFC233',
                            '#D12929',
                            '#2196F3',
                            '#9C27B0'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>
