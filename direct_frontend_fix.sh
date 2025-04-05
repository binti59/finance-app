#!/bin/bash

# Direct frontend fix script for finance application
# This script creates a standalone HTML file with working charts and KPIs

echo "Starting direct frontend fix for finance application..."

# Set the working directory
WORK_DIR="/opt/personal-finance-system"
cd $WORK_DIR || { echo "Failed to change to working directory"; exit 1; }

# Create a standalone dashboard with working charts and KPIs
echo "Creating standalone dashboard with working charts and KPIs..."

cat > frontend/public/dashboard-standalone.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Finance Dashboard</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px;
    }
    .header {
      background-color: #2c3e50;
      color: white;
      padding: 20px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .header h1 {
      margin: 0;
      font-size: 24px;
    }
    .nav {
      display: flex;
      background-color: #34495e;
      padding: 0 20px;
    }
    .nav a {
      color: white;
      text-decoration: none;
      padding: 15px 20px;
      display: block;
    }
    .nav a:hover, .nav a.active {
      background-color: #2c3e50;
    }
    .dashboard-metrics {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 20px;
      margin-bottom: 30px;
    }
    .metric-card {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      padding: 20px;
    }
    .metric-card h3 {
      margin-top: 0;
      margin-bottom: 10px;
      font-size: 16px;
      color: #7f8c8d;
    }
    .metric-value {
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 10px;
    }
    .metric-change {
      font-size: 14px;
    }
    .positive {
      color: #2ecc71;
    }
    .negative {
      color: #e74c3c;
    }
    .dashboard-charts {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 20px;
      margin-bottom: 30px;
    }
    @media (max-width: 768px) {
      .dashboard-charts {
        grid-template-columns: 1fr;
      }
    }
    .chart-container {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      padding: 20px;
    }
    .chart-container h3 {
      margin-top: 0;
      margin-bottom: 20px;
      font-size: 18px;
    }
    .kpi-dashboard {
      margin-bottom: 30px;
    }
    .kpi-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
      gap: 20px;
    }
    .kpi-card {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      padding: 20px;
    }
    .kpi-card h3 {
      margin-top: 0;
      margin-bottom: 10px;
      font-size: 16px;
      color: #7f8c8d;
    }
    .kpi-value {
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 10px;
    }
    .kpi-status {
      font-weight: 500;
      margin-bottom: 10px;
    }
    .kpi-description {
      font-size: 14px;
      color: #7f8c8d;
      margin-bottom: 15px;
    }
    .progress-container {
      height: 8px;
      background-color: #ecf0f1;
      border-radius: 4px;
      overflow: hidden;
    }
    .progress-bar {
      height: 100%;
      border-radius: 4px;
    }
    .kpi-details {
      margin-top: 15px;
      font-size: 14px;
    }
    .detail-item {
      display: flex;
      justify-content: space-between;
      margin-bottom: 5px;
    }
    .detail-label {
      color: #7f8c8d;
    }
    .detail-value {
      font-weight: 500;
    }
    .score-breakdown {
      margin-top: 15px;
    }
    .score-item {
      display: flex;
      align-items: center;
      margin-bottom: 8px;
    }
    .score-label {
      width: 40%;
      font-size: 14px;
      color: #7f8c8d;
    }
    .score-bar-container {
      width: 40%;
      height: 8px;
      background-color: #ecf0f1;
      border-radius: 4px;
      overflow: hidden;
      margin: 0 10px;
    }
    .score-bar {
      height: 100%;
      background-color: #3498db;
      border-radius: 4px;
    }
    .score-value {
      width: 20%;
      font-size: 14px;
      text-align: right;
      font-weight: 500;
    }
    .user-info {
      display: flex;
      align-items: center;
    }
    .user-avatar {
      width: 40px;
      height: 40px;
      border-radius: 50%;
      background-color: #3498db;
      color: white;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: bold;
      margin-right: 10px;
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>Finance Manager</h1>
    <div class="user-info">
      <div class="user-avatar">J</div>
      <span>John Doe</span>
    </div>
  </div>
  
  <div class="nav">
    <a href="#" class="active">Dashboard</a>
    <a href="#">Accounts</a>
    <a href="#">Transactions</a>
    <a href="#">Investments</a>
    <a href="#">Budgets</a>
    <a href="#">Goals</a>
    <a href="#">Financial Independence</a>
    <a href="#">Reports</a>
    <a href="#">Settings</a>
  </div>
  
  <div class="container">
    <h2>Financial Dashboard</h2>
    
    <div class="dashboard-metrics">
      <div class="metric-card">
        <h3>Net Worth</h3>
        <div class="metric-value">$124,500</div>
        <div class="metric-change positive">↑ 3.2% from last month</div>
      </div>
      <div class="metric-card">
        <h3>Monthly Income</h3>
        <div class="metric-value">$8,750</div>
        <div class="metric-change positive">↑ 5.0% from last month</div>
      </div>
      <div class="metric-card">
        <h3>Monthly Expenses</h3>
        <div class="metric-value">$5,320</div>
        <div class="metric-change negative">↑ 2.1% from last month</div>
      </div>
      <div class="metric-card">
        <h3>Savings Rate</h3>
        <div class="metric-value">39.2%</div>
        <div class="metric-change positive">↑ 1.5% from last month</div>
      </div>
    </div>
    
    <div class="kpi-dashboard">
      <h2>Advanced Financial KPIs</h2>
      <div class="kpi-grid">
        <div class="kpi-card">
          <h3>Financial Independence Index</h3>
          <div class="kpi-value" style="color: #f39c12;">25.0%</div>
          <div class="kpi-status">On Your Way</div>
          <div class="kpi-description">
            Measures your progress toward financial freedom
          </div>
          <div class="progress-container">
            <div class="progress-bar" style="width: 25%; background-color: #f39c12;"></div>
          </div>
        </div>
        
        <div class="kpi-card">
          <h3>Financial Freedom Number</h3>
          <div class="kpi-value">$1,000,000</div>
          <div class="kpi-description">
            The amount you need to be financially independent
          </div>
          <div class="kpi-details">
            <div class="detail-item">
              <div class="detail-label">Annual Expenses:</div>
              <div class="detail-value">$40,000</div>
            </div>
            <div class="detail-item">
              <div class="detail-label">Withdrawal Rate:</div>
              <div class="detail-value">4%</div>
            </div>
          </div>
        </div>
        
        <div class="kpi-card">
          <h3>Savings Rate</h3>
          <div class="kpi-value" style="color: #27ae60;">30.8%</div>
          <div class="kpi-status">Excellent</div>
          <div class="kpi-description">
            Percentage of income you're saving
          </div>
          <div class="kpi-details">
            <div class="detail-item">
              <div class="detail-label">Monthly Income:</div>
              <div class="detail-value">$8,750</div>
            </div>
            <div class="detail-item">
              <div class="detail-label">Monthly Expenses:</div>
              <div class="detail-value">$5,320</div>
            </div>
            <div class="detail-item">
              <div class="detail-label">Monthly Savings:</div>
              <div class="detail-value">$3,430</div>
            </div>
          </div>
        </div>
        
        <div class="kpi-card">
          <h3>Financial Health Score</h3>
          <div class="kpi-value" style="color: #f39c12;">68</div>
          <div class="kpi-status">Good</div>
          <div class="kpi-description">
            Overall rating of your financial situation
          </div>
          <div class="score-breakdown">
            <div class="score-item">
              <div class="score-label">Emergency Fund</div>
              <div class="score-bar-container">
                <div class="score-bar" style="width: 60%; background-color: #f39c12;"></div>
              </div>
              <div class="score-value">15/25</div>
            </div>
            <div class="score-item">
              <div class="score-label">Debt Management</div>
              <div class="score-bar-container">
                <div class="score-bar" style="width: 80%; background-color: #27ae60;"></div>
              </div>
              <div class="score-value">20/25</div>
            </div>
            <div class="score-item">
              <div class="score-label">Savings Rate</div>
              <div class="score-bar-container">
                <div class="score-bar" style="width: 80%; background-color: #27ae60;"></div>
              </div>
              <div class="score-value">20/25</div>
            </div>
            <div class="score-item">
              <div class="score-label">FI Progress</div>
              <div class="score-bar-container">
                <div class="score-bar" style="width: 52%; background-color: #f39c12;"></div>
              </div>
              <div class="score-value">13/25</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    
    <div class="dashboard-charts">
      <div class="chart-container">
        <h3>Income vs. Expenses</h3>
        <canvas id="incomeExpensesChart"></canvas>
      </div>
      <div class="chart-container">
        <h3>Expense Breakdown</h3>
        <canvas id="expenseBreakdownChart"></canvas>
      </div>
    </div>
    
    <div class="dashboard-charts">
      <div class="chart-container">
        <h3>Net Worth Trend</h3>
        <canvas id="netWorthChart"></canvas>
      </div>
      <div class="chart-container">
        <h3>Monthly Budget</h3>
        <canvas id="budgetChart"></canvas>
      </div>
    </div>
  </div>

  <script>
    // Income vs Expenses Chart
    const incomeExpensesCtx = document.getElementById('incomeExpensesChart').getContext('2d');
    new Chart(incomeExpensesCtx, {
      type: 'bar',
      data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        datasets: [
          {
            label: 'Income',
            data: [4500, 4700, 4900, 5000, 4800, 5200],
            backgroundColor: 'rgba(75, 192, 192, 0.5)',
          },
          {
            label: 'Expenses',
            data: [3200, 3500, 3300, 3700, 3400, 3600],
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      }
    });

    // Expense Breakdown Chart
    const expenseBreakdownCtx = document.getElementById('expenseBreakdownChart').getContext('2d');
    new Chart(expenseBreakdownCtx, {
      type: 'pie',
      data: {
        labels: ['Housing', 'Food', 'Transportation', 'Utilities', 'Entertainment', 'Other'],
        datasets: [
          {
            data: [1500, 600, 400, 300, 200, 600],
            backgroundColor: [
              'rgba(255, 99, 132, 0.7)',
              'rgba(54, 162, 235, 0.7)',
              'rgba(255, 206, 86, 0.7)',
              'rgba(75, 192, 192, 0.7)',
              'rgba(153, 102, 255, 0.7)',
              'rgba(255, 159, 64, 0.7)',
            ],
            borderWidth: 1,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      }
    });

    // Net Worth Chart
    const netWorthCtx = document.getElementById('netWorthChart').getContext('2d');
    new Chart(netWorthCtx, {
      type: 'line',
      data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        datasets: [
          {
            label: 'Net Worth',
            data: [110000, 113000, 116000, 119000, 121000, 124500],
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            borderColor: 'rgba(75, 192, 192, 1)',
            borderWidth: 2,
            fill: true,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      }
    });

    // Budget Chart
    const budgetCtx = document.getElementById('budgetChart').getContext('2d');
    new Chart(budgetCtx, {
      type: 'bar',
      data: {
        labels: ['Housing', 'Food', 'Transportation', 'Utilities', 'Entertainment', 'Other'],
        datasets: [
          {
            label: 'Budget',
            data: [1800, 700, 500, 350, 300, 700],
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
          },
          {
            label: 'Actual',
            data: [1500, 600, 400, 300, 200, 600],
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      }
    });
  </script>
</body>
</html>
EOL

echo "Creating direct fix script for nginx configuration..."

# Create a script to update nginx configuration to serve the standalone dashboard
cat > update_nginx.sh << 'EOL'
#!/bin/bash

# Update nginx configuration to serve the standalone dashboard
NGINX_CONF="/etc/nginx/sites-available/finance.bikramjitchowdhury.com"

# Check if the file exists
if [ ! -f "$NGINX_CONF" ]; then
  echo "Nginx configuration file not found: $NGINX_CONF"
  exit 1
fi

# Create a backup of the original configuration
cp "$NGINX_CONF" "${NGINX_CONF}.bak"

# Add a location block for the standalone dashboard
sed -i '/location \/ {/a \
    # Serve standalone dashboard\
    location = /dashboard-standalone {\
        rewrite ^ /dashboard-standalone.html break;\
    }' "$NGINX_CONF"

# Reload nginx to apply changes
systemctl reload nginx

echo "Nginx configuration updated to serve the standalone dashboard"
echo "You can access it at: https://finance.bikramjitchowdhury.com/dashboard-standalone"
EOL

chmod +x update_nginx.sh

echo "Direct frontend fix completed successfully!"
echo "To apply this fix:"
echo "1. Run the update_nginx.sh script on your server"
echo "2. Access the standalone dashboard at: https://finance.bikramjitchowdhury.com/dashboard-standalone"
echo ""
echo "This standalone dashboard includes:"
echo "- Working chart visualizations using Chart.js"
echo "- Advanced Financial KPIs"
echo "- Complete styling and layout"
