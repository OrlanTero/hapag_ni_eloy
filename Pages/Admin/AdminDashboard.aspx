<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AdminDashboard.aspx.vb" Inherits="Pages_Admin_AdminDashboard" MasterPageFile="~/Pages/Admin/AdminTemplate.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Admin Dashboard</title>
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
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
                    
                    <!-- Dashboard Content -->
                    <div class="dashboard-container">
                        <!-- Stats Cards -->
                        <div class="stats-cards">
                            <div class="stat-card primary">
                                <div class="stat-card-title">Total Orders</div>
                                <div class="stat-card-value">
                                    <asp:Literal ID="TotalOrdersLiteral" runat="server">124</asp:Literal>
                                </div>
                                <div id="OrdersChangeContainer" runat="server" class="stat-card-change positive">
                                    <span><asp:Literal ID="OrdersChangeLiteral" runat="server">↑ 12.5%</asp:Literal></span> from last month
                                </div>
                                <div class="stat-card-icon">📊</div>
                            </div>
                            
                            <div class="stat-card info">
                                <div class="stat-card-title">Total Revenue</div>
                                <div class="stat-card-value">PHP
                                    <asp:Literal ID="TotalRevenueLiteral" runat="server">25,430</asp:Literal>
                                </div>
                                <div id="RevenueChangeContainer" runat="server" class="stat-card-change positive">
                                    <span><asp:Literal ID="RevenueChangeLiteral" runat="server">↑ 8.3%</asp:Literal></span> from last month
                                </div>
                                <div class="stat-card-icon">💰</div>
                            </div>
                            
                            <div class="stat-card warning">
                                <div class="stat-card-title">Active Users</div>
                                <div class="stat-card-value">
                                    <asp:Literal ID="ActiveUsersLiteral" runat="server">45</asp:Literal>
                                </div>
                                <div id="UsersChangeContainer" runat="server" class="stat-card-change positive">
                                    <span><asp:Literal ID="UsersChangeLiteral" runat="server">↑ 5.2%</asp:Literal></span> from last month
                                </div>
                                <div class="stat-card-icon">👥</div>
                            </div>
                            
                            <div class="stat-card danger">
                                <div class="stat-card-title">Menu Items</div>
                                <div class="stat-card-value">
                                    <asp:Literal ID="MenuItemsLiteral" runat="server">78</asp:Literal>
                                </div>
                                <div id="MenuChangeContainer" runat="server" class="stat-card-change positive">
                                    <span><asp:Literal ID="MenuChangeLiteral" runat="server">↑ 3.7%</asp:Literal></span> from last month
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
        
        // Charts data
        var salesChartData = {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            data: [5000, 7500, 6200, 8900, 9100, 12500]
        };
        
        var categoryChartData = {
            labels: ['Main Dish', 'Appetizers', 'Desserts', 'Beverages', 'Specials'],
            data: [45, 15, 20, 10, 10]
        };
        
        // Initialize Charts
        document.addEventListener('DOMContentLoaded', function() {
            // Sales Chart
            var salesCtx = document.getElementById('salesChart').getContext('2d');
            var salesChart = new Chart(salesCtx, {
                type: 'line',
                data: {
                    labels: salesChartData.labels,
                    datasets: [{
                        label: 'Sales',
                        data: salesChartData.data,
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
                    labels: categoryChartData.labels,
                    datasets: [{
                        data: categoryChartData.data,
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
</asp:Content>
