#!/bin/bash

# Script to implement chart visualizations using Chart.js
# This script adds actual chart visualizations to replace placeholder text

# Set the working directory
WORK_DIR="/opt/personal-finance-system/frontend"
cd $WORK_DIR || { echo "Failed to change to working directory"; exit 1; }

# Install Chart.js and React Chart.js 2
echo "Installing Chart.js and related dependencies..."
npm install --save chart.js react-chartjs-2

# Create a charts directory for reusable chart components
echo "Creating chart components..."
mkdir -p src/components/charts

# Create PieChart component
cat > src/components/charts/PieChart.js << 'EOL'
import React from 'react';
import { Pie } from 'react-chartjs-2';
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js';

// Register Chart.js components
ChartJS.register(ArcElement, Tooltip, Legend);

const PieChart = ({ data, options, title }) => {
  const defaultOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          padding: 20,
          usePointStyle: true,
          pointStyle: 'circle',
        },
      },
      title: {
        display: !!title,
        text: title,
        font: {
          size: 16,
        },
      },
    },
  };

  return (
    <div style={{ height: '300px', width: '100%' }}>
      <Pie data={data} options={{ ...defaultOptions, ...options }} />
    </div>
  );
};

export default PieChart;
EOL

# Create LineChart component
cat > src/components/charts/LineChart.js << 'EOL'
import React from 'react';
import { Line } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';

// Register Chart.js components
ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend
);

const LineChart = ({ data, options, title }) => {
  const defaultOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          padding: 20,
          usePointStyle: true,
          pointStyle: 'circle',
        },
      },
      title: {
        display: !!title,
        text: title,
        font: {
          size: 16,
        },
      },
    },
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  return (
    <div style={{ height: '300px', width: '100%' }}>
      <Line data={data} options={{ ...defaultOptions, ...options }} />
    </div>
  );
};

export default LineChart;
EOL

# Create BarChart component
cat > src/components/charts/BarChart.js << 'EOL'
import React from 'react';
import { Bar } from 'react-chartjs-2';
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';

// Register Chart.js components
ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  Title,
  Tooltip,
  Legend
);

const BarChart = ({ data, options, title }) => {
  const defaultOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          padding: 20,
          usePointStyle: true,
          pointStyle: 'circle',
        },
      },
      title: {
        display: !!title,
        text: title,
        font: {
          size: 16,
        },
      },
    },
    scales: {
      y: {
        beginAtZero: true,
      },
    },
  };

  return (
    <div style={{ height: '300px', width: '100%' }}>
      <Bar data={data} options={{ ...defaultOptions, ...options }} />
    </div>
  );
};

export default BarChart;
EOL

# Create DoughnutChart component
cat > src/components/charts/DoughnutChart.js << 'EOL'
import React from 'react';
import { Doughnut } from 'react-chartjs-2';
import { Chart as ChartJS, ArcElement, Tooltip, Legend } from 'chart.js';

// Register Chart.js components
ChartJS.register(ArcElement, Tooltip, Legend);

const DoughnutChart = ({ data, options, title }) => {
  const defaultOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
        labels: {
          padding: 20,
          usePointStyle: true,
          pointStyle: 'circle',
        },
      },
      title: {
        display: !!title,
        text: title,
        font: {
          size: 16,
        },
      },
    },
    cutout: '70%',
  };

  return (
    <div style={{ height: '300px', width: '100%' }}>
      <Doughnut data={data} options={{ ...defaultOptions, ...options }} />
    </div>
  );
};

export default DoughnutChart;
EOL

# Create index.js to export all chart components
cat > src/components/charts/index.js << 'EOL'
export { default as PieChart } from './PieChart';
export { default as LineChart } from './LineChart';
export { default as BarChart } from './BarChart';
export { default as DoughnutChart } from './DoughnutChart';
EOL

# Update Dashboard.js to use actual charts
echo "Updating Dashboard.js to use actual charts..."
cat > src/pages/Dashboard.js << 'EOL'
import React from 'react';
import { LineChart, PieChart, BarChart } from '../components/charts';

const Dashboard = () => {
  // Sample data for Income vs Expenses chart
  const incomeExpensesData = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
    datasets: [
      {
        label: 'Income',
        data: [4500, 4700, 4900, 5000, 4800, 5200],
        borderColor: 'rgba(75, 192, 192, 1)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        tension: 0.4,
      },
      {
        label: 'Expenses',
        data: [3200, 3500, 3300, 3700, 3400, 3600],
        borderColor: 'rgba(255, 99, 132, 1)',
        backgroundColor: 'rgba(255, 99, 132, 0.2)',
        tension: 0.4,
      },
    ],
  };

  // Sample data for Expense Breakdown chart
  const expenseBreakdownData = {
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
        borderColor: [
          'rgba(255, 99, 132, 1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 159, 64, 1)',
        ],
        borderWidth: 1,
      },
    ],
  };

  // Sample data for Net Worth chart
  const netWorthData = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
    datasets: [
      {
        label: 'Net Worth',
        data: [25000, 27000, 29000, 31000, 33000, 36000],
        borderColor: 'rgba(75, 192, 192, 1)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        fill: true,
        tension: 0.4,
      },
    ],
  };

  // Sample data for Monthly Budget chart
  const monthlyBudgetData = {
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
      },
    ],
  };

  // Sample transactions
  const transactions = [
    { id: 1, date: '2025-04-01', description: 'Salary', category: 'Income', amount: 5000 },
    { id: 2, date: '2025-04-02', description: 'Rent', category: 'Housing', amount: -1500 },
    { id: 3, date: '2025-04-03', description: 'Groceries', category: 'Food', amount: -200 },
    { id: 4, date: '2025-04-05', description: 'Gas', category: 'Transportation', amount: -50 },
    { id: 5, date: '2025-04-10', description: 'Restaurant', category: 'Dining Out', amount: -75 },
  ];

  return (
    <div className="page-container">
      <h2>Dashboard</h2>
      
      <div className="dashboard-metrics">
        <div className="metric-card">
          <h3>Net Worth</h3>
          <div className="metric-value">$36,000</div>
          <div className="metric-change positive">+$3,000 (9.1%)</div>
        </div>
        <div className="metric-card">
          <h3>Monthly Income</h3>
          <div className="metric-value">$5,200</div>
          <div className="metric-change positive">+$400 (8.3%)</div>
        </div>
        <div className="metric-card">
          <h3>Monthly Expenses</h3>
          <div className="metric-value">$3,600</div>
          <div className="metric-change negative">+$200 (5.9%)</div>
        </div>
        <div className="metric-card">
          <h3>Savings Rate</h3>
          <div className="metric-value">30.8%</div>
          <div className="metric-change positive">+1.5%</div>
        </div>
      </div>
      
      <div className="dashboard-charts">
        <div className="chart-container">
          <h3>Income vs. Expenses</h3>
          <LineChart data={incomeExpensesData} />
        </div>
        <div className="chart-container">
          <h3>Expense Breakdown</h3>
          <PieChart data={expenseBreakdownData} />
        </div>
      </div>
      
      <div className="dashboard-charts">
        <div className="chart-container">
          <h3>Net Worth Trend</h3>
          <LineChart data={netWorthData} />
        </div>
        <div className="chart-container">
          <h3>Monthly Budget</h3>
          <BarChart data={monthlyBudgetData} />
        </div>
      </div>
      
      <div className="dashboard-section">
        <h3>Recent Transactions</h3>
        <div className="transactions-list">
          <table>
            <thead>
              <tr>
                <th>Date</th>
                <th>Description</th>
                <th>Category</th>
                <th>Amount</th>
              </tr>
            </thead>
            <tbody>
              {transactions.map(transaction => (
                <tr key={transaction.id}>
                  <td>{transaction.date}</td>
                  <td>{transaction.description}</td>
                  <td>{transaction.category}</td>
                  <td className={transaction.amount >= 0 ? 'positive' : 'negative'}>
                    {transaction.amount >= 0 ? '+' : ''}${Math.abs(transaction.amount).toFixed(2)}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
        <div className="view-all">
          <a href="#/transactions">View All Transactions</a>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
EOL

# Update Investments.js to use actual charts
echo "Updating Investments.js to use actual charts..."
cat > src/pages/Investments.js << 'EOL'
import React from 'react';
import { PieChart, LineChart } from '../components/charts';

const Investments = () => {
  // Sample data for Asset Allocation chart
  const assetAllocationData = {
    labels: ['Stocks', 'Bonds', 'Cash', 'Real Estate', 'Crypto'],
    datasets: [
      {
        data: [60, 20, 10, 5, 5],
        backgroundColor: [
          'rgba(54, 162, 235, 0.7)',
          'rgba(255, 159, 64, 0.7)',
          'rgba(75, 192, 192, 0.7)',
          'rgba(153, 102, 255, 0.7)',
          'rgba(255, 99, 132, 0.7)',
        ],
        borderColor: [
          'rgba(54, 162, 235, 1)',
          'rgba(255, 159, 64, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 99, 132, 1)',
        ],
        borderWidth: 1,
      },
    ],
  };

  // Sample data for Portfolio Performance chart
  const portfolioPerformanceData = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
    datasets: [
      {
        label: 'Portfolio Value',
        data: [100000, 102000, 105000, 103000, 108000, 112000],
        borderColor: 'rgba(75, 192, 192, 1)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        fill: true,
        tension: 0.4,
      },
      {
        label: 'Benchmark (S&P 500)',
        data: [100000, 101000, 103000, 102000, 105000, 107000],
        borderColor: 'rgba(255, 99, 132, 1)',
        backgroundColor: 'rgba(255, 99, 132, 0.0)',
        borderDash: [5, 5],
        tension: 0.4,
      },
    ],
  };

  // Sample investment holdings
  const holdings = [
    { id: 1, symbol: 'AAPL', name: 'Apple Inc.', shares: 50, price: 175.25, value: 8762.50, return: 32.5, allocation: 7.8 },
    { id: 2, symbol: 'MSFT', name: 'Microsoft Corp.', shares: 30, price: 290.50, value: 8715.00, return: 28.7, allocation: 7.8 },
    { id: 3, symbol: 'AMZN', name: 'Amazon.com Inc.', shares: 20, price: 132.80, value: 2656.00, return: 15.2, allocation: 2.4 },
    { id: 4, symbol: 'GOOGL', name: 'Alphabet Inc.', shares: 15, price: 142.30, value: 2134.50, return: 18.9, allocation: 1.9 },
    { id: 5, symbol: 'BRK.B', name: 'Berkshire Hathaway', shares: 25, price: 352.75, value: 8818.75, return: 22.3, allocation: 7.9 },
    { id: 6, symbol: 'VTI', name: 'Vanguard Total Stock Market ETF', shares: 100, price: 235.40, value: 23540.00, return: 19.8, allocation: 21.0 },
    { id: 7, symbol: 'VXUS', name: 'Vanguard Total International Stock ETF', shares: 120, price: 58.25, value: 6990.00, return: 8.5, allocation: 6.2 },
    { id: 8, symbol: 'BND', name: 'Vanguard Total Bond Market ETF', shares: 200, price: 72.80, value: 14560.00, return: 2.1, allocation: 13.0 },
    { id: 9, symbol: 'VNQ', name: 'Vanguard Real Estate ETF', shares: 50, price: 85.30, value: 4265.00, return: 5.7, allocation: 3.8 },
    { id: 10, symbol: 'VTIP', name: 'Vanguard Short-Term Inflation-Protected Securities ETF', shares: 150, price: 47.90, value: 7185.00, return: 3.2, allocation: 6.4 },
  ];

  return (
    <div className="page-container">
      <h2>Investments</h2>
      
      <div className="investment-summary">
        <div className="summary-card">
          <h3>Portfolio Value</h3>
          <div className="summary-value">$112,000</div>
          <div className="summary-change positive">+$4,000 (3.7%)</div>
        </div>
        <div className="summary-card">
          <h3>Total Return</h3>
          <div className="summary-value">+$12,000</div>
          <div className="summary-change positive">+12.0%</div>
        </div>
        <div className="summary-card">
          <h3>YTD Return</h3>
          <div className="summary-value">+$7,000</div>
          <div className="summary-change positive">+6.7%</div>
        </div>
        <div className="summary-card">
          <h3>Dividend Yield</h3>
          <div className="summary-value">2.3%</div>
          <div className="summary-change">$2,576 annually</div>
        </div>
      </div>
      
      <div className="investment-charts">
        <div className="chart-container">
          <h3>Asset Allocation</h3>
          <PieChart data={assetAllocationData} />
          <div className="chart-legend">
            <div className="legend-item"><span className="legend-color" style={{backgroundColor: 'rgba(54, 162, 235, 0.7)'}}></span>Stocks (60%)</div>
            <div className="legend-item"><span className="legend-color" style={{backgroundColor: 'rgba(255, 159, 64, 0.7)'}}></span>Bonds (20%)</div>
            <div className="legend-item"><span className="legend-color" style={{backgroundColor: 'rgba(75, 192, 192, 0.7)'}}></span>Cash (10%)</div>
            <div className="legend-item"><span className="legend-color" style={{backgroundColor: 'rgba(153, 102, 255, 0.7)'}}></span>Real Estate (5%)</div>
            <div className="legend-item"><span className="legend-color" style={{backgroundColor: 'rgba(255, 99, 132, 0.7)'}}></span>Crypto (5%)</div>
          </div>
        </div>
        <div className="chart-container">
          <h3>Portfolio Performance</h3>
          <LineChart data={portfolioPerformanceData} />
        </div>
      </div>
      
      <div className="investment-holdings">
        <h3>Investment Holdings</h3>
        <table className="holdings-table">
          <thead>
            <tr>
              <th>Symbol</th>
              <th>Name</th>
              <th>Shares</th>
              <th>Price</th>
              <th>Value</th>
              <th>Return</th>
              <th>Allocation</th>
            </tr>
          </thead>
          <tbody>
            {holdings.map(holding => (
              <tr key={holding.id}>
                <td>{holding.symbol}</td>
                <td>{holding.name}</td>
                <td>{holding.shares}</td>
                <td>${holding.price.toFixed(2)}</td>
                <td>${holding.value.toFixed(2)}</td>
                <td className={holding.return >= 0 ? 'positive' : 'negative'}>
                  {holding.return >= 0 ? '+' : ''}{holding.return}%
                </td>
                <td>{holding.allocation}%</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default Investments;
EOL

# Update Budget.js to use actual charts
echo "Updating Budget.js to use actual charts..."
cat > src/pages/Budget.js << 'EOL'
import React from 'react';
import { BarChart, PieChart } from '../components/charts';

const Budget = () => {
  // Sample data for Monthly Budget Overview chart
  const monthlyBudgetData = {
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
      },
    ],
  };

  // Sample data for Budget Distribution chart
  const budgetDistributionData = {
    labels: ['Housing', 'Food', 'Transportation', 'Utilities', 'Entertainment', 'Other'],
    datasets: [
      {
        data: [1800, 700, 500, 350, 300, 700],
        backgroundColor: [
          'rgba(255, 99, 132, 0.7)',
          'rgba(54, 162, 235, 0.7)',
          'rgba(255, 206, 86, 0.7)',
          'rgba(75, 192, 192, 0.7)',
          'rgba(153, 102, 255, 0.7)',
          'rgba(255, 159, 64, 0.7)',
        ],
        borderColor: [
          'rgba(255, 99, 132, 1)',
          'rgba(54, 162, 235, 1)',
          'rgba(255, 206, 86, 1)',
          'rgba(75, 192, 192, 1)',
          'rgba(153, 102, 255, 1)',
          'rgba(255, 159, 64, 1)',
        ],
        borderWidth: 1,
      },
    ],
  };

  // Sample budget categories
  const budgetCategories = [
    { id: 1, name: 'Housing', budget: 1800, spent: 1500, remaining: 300, progress: 83 },
    { id: 2, name: 'Food', budget: 700, spent: 600, remaining: 100, progress: 86 },
    { id: 3, name: 'Transportation', budget: 500, spent: 400, remaining: 100, progress: 80 },
    { id: 4, name: 'Utilities', budget: 350, spent: 300, remaining: 50, progress: 86 },
    { id: 5, name: 'Entertainment', budget: 300, spent: 200, remaining: 100, progress: 67 },
    { id: 6, name: 'Other', budget: 700, spent: 600, remaining: 100, progress: 86 },
  ];

  return (
    <div className="page-container">
      <h2>Budget</h2>
      
      <div className="budget-summary">
        <div className="summary-card">
          <h3>Total Budget</h3>
          <div className="summary-value">$4,350</div>
        </div>
        <div className="summary-card">
          <h3>Spent So Far</h3>
          <div className="summary-value">$3,600</div>
          <div className="summary-subtext">82.8% of budget</div>
        </div>
        <div className="summary-card">
          <h3>Remaining</h3>
          <div className="summary-value">$750</div>
          <div className="summary-subtext">17.2% of budget</div>
        </div>
        <div className="summary-card">
          <h3>Days Remaining</h3>
          <div className="summary-value">12</div>
          <div className="summary-subtext">in this month</div>
        </div>
      </div>
      
      <div className="budget-charts">
        <div className="chart-container">
          <h3>Monthly Budget Overview</h3>
          <BarChart data={monthlyBudgetData} />
        </div>
        <div className="chart-container">
          <h3>Budget Distribution</h3>
          <PieChart data={budgetDistributionData} />
        </div>
      </div>
      
      <div className="budget-categories">
        <h3>Budget Categories</h3>
        <div className="categories-list">
          {budgetCategories.map(category => (
            <div key={category.id} className="category-item">
              <div className="category-header">
                <div className="category-name">{category.name}</div>
                <div className="category-amounts">
                  <span className="spent">${category.spent}</span>
                  <span className="separator"> / </span>
                  <span className="budget">${category.budget}</span>
                </div>
              </div>
              <div className="progress-container">
                <div 
                  className={`progress-bar ${category.progress > 90 ? 'danger' : category.progress > 75 ? 'warning' : ''}`}
                  style={{ width: `${category.progress}%` }}
                ></div>
              </div>
              <div className="category-footer">
                <div className="remaining">${category.remaining} remaining</div>
                <div className="progress-text">{category.progress}%</div>
              </div>
            </div>
          ))}
        </div>
      </div>
      
      <div className="budget-actions">
        <button className="primary-button">Create New Budget</button>
        <button className="secondary-button">Adjust Current Budget</button>
      </div>
    </div>
  );
};

export default Budget;
EOL

# Update Goals.js to use actual charts
echo "Updating Goals.js to use actual charts..."
cat > src/pages/Goals.js << 'EOL'
import React from 'react';
import { LineChart } from '../components/charts';

const Goals = () => {
  // Sample data for Goal Progress chart
  const goalProgressData = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    datasets: [
      {
        label: 'Actual Savings',
        data: [1000, 2200, 3500, 5000, null, null, null, null, null, null, null, null],
        borderColor: 'rgba(75, 192, 192, 1)',
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        fill: true,
        tension: 0.4,
      },
      {
        label: 'Target Path',
        data: [0, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 12000],
        borderColor: 'rgba(255, 99, 132, 1)',
        backgroundColor: 'rgba(255, 99, 132, 0.0)',
        borderDash: [5, 5],
        tension: 0.4,
      },
    ],
  };

  // Sample goals
  const activeGoals = [
    { 
      id: 1, 
      name: 'Emergency Fund', 
      target: 10000, 
      current: 5000, 
      progress: 50,
      monthly: 500,
      deadline: '2025-12-31',
      timeRemaining: '8 months',
      onTrack: true
    },
    { 
      id: 2, 
      name: 'Down Payment', 
      target: 50000, 
      current: 15000, 
      progress: 30,
      monthly: 1000,
      deadline: '2027-06-30',
      timeRemaining: '2 years, 2 months',
      onTrack: true
    },
    { 
      id: 3, 
      name: 'Vacation Fund', 
      target: 3000, 
      current: 1200, 
      progress: 40,
      monthly: 300,
      deadline: '2025-08-31',
      timeRemaining: '4 months',
      onTrack: false
    },
  ];

  const completedGoals = [
    { 
      id: 4, 
      name: 'New Laptop', 
      target: 1500, 
      current: 1500, 
      progress: 100,
      completedDate: '2025-02-15'
    },
    { 
      id: 5, 
      name: 'Pay Off Credit Card', 
      target: 2500, 
      current: 2500, 
      progress: 100,
      completedDate: '2025-01-10'
    },
  ];

  return (
    <div className="page-container">
      <h2>Financial Goals</h2>
      
      <div className="goals-summary">
        <div className="summary-card">
          <h3>Active Goals</h3>
          <div className="summary-value">{activeGoals.length}</div>
        </div>
        <div className="summary-card">
          <h3>Completed Goals</h3>
          <div className="summary-value">{completedGoals.length}</div>
        </div>
        <div className="summary-card">
          <h3>Total Saved</h3>
          <div className="summary-value">${activeGoals.reduce((sum, goal) => sum + goal.current, 0).toLocaleString()}</div>
        </div>
        <div className="summary-card">
          <h3>Target Amount</h3>
          <div className="summary-value">${activeGoals.reduce((sum, goal) => sum + goal.target, 0).toLocaleString()}</div>
        </div>
      </div>
      
      <div className="goals-chart">
        <h3>Emergency Fund Progress</h3>
        <LineChart data={goalProgressData} />
      </div>
      
      <div className="active-goals">
        <div className="section-header">
          <h3>Active Goals</h3>
          <button className="primary-button">Add New Goal</button>
        </div>
        
        <div className="goals-list">
          {activeGoals.map(goal => (
            <div key={goal.id} className="goal-card">
              <div className="goal-header">
                <h4>{goal.name}</h4>
                <div className={`goal-status ${goal.onTrack ? 'on-track' : 'off-track'}`}>
                  {goal.onTrack ? 'On Track' : 'Off Track'}
                </div>
              </div>
              
              <div className="goal-amounts">
                <span className="current">${goal.current.toLocaleString()}</span>
                <span className="separator"> / </span>
                <span className="target">${goal.target.toLocaleString()}</span>
              </div>
              
              <div className="progress-container">
                <div 
                  className="progress-bar"
                  style={{ width: `${goal.progress}%` }}
                ></div>
              </div>
              
              <div className="goal-details">
                <div className="detail-item">
                  <div className="detail-label">Monthly Contribution:</div>
                  <div className="detail-value">${goal.monthly}</div>
                </div>
                <div className="detail-item">
                  <div className="detail-label">Deadline:</div>
                  <div className="detail-value">{goal.deadline}</div>
                </div>
                <div className="detail-item">
                  <div className="detail-label">Time Remaining:</div>
                  <div className="detail-value">{goal.timeRemaining}</div>
                </div>
              </div>
              
              <div className="goal-actions">
                <button className="secondary-button">Edit</button>
                <button className="secondary-button">Add Funds</button>
              </div>
            </div>
          ))}
        </div>
      </div>
      
      <div className="completed-goals">
        <h3>Completed Goals</h3>
        <div className="goals-list">
          {completedGoals.map(goal => (
            <div key={goal.id} className="goal-card completed">
              <div className="goal-header">
                <h4>{goal.name}</h4>
                <div className="goal-status completed">Completed</div>
              </div>
              
              <div className="goal-amounts">
                <span className="current">${goal.current.toLocaleString()}</span>
                <span className="separator"> / </span>
                <span className="target">${goal.target.toLocaleString()}</span>
              </div>
              
              <div className="progress-container">
                <div 
                  className="progress-bar"
                  style={{ width: '100%' }}
                ></div>
              </div>
              
              <div className="goal-details">
                <div className="detail-item">
                  <div className="detail-label">Completed Date:</div>
                  <div className="detail-value">{goal.completedDate}</div>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default Goals;
EOL

# Update FinancialIndependence.js to use actual charts
echo "Updating FinancialIndependence.js to use actual charts..."
cat > src/pages/planning/FinancialIndependence.js << 'EOL'
import React, { useState } from 'react';
import { LineChart } from '../../components/charts';

// Financial Independence Component
const FinancialIndependence = () => {
  // State for financial independence calculator
  const [currentAge, setCurrentAge] = useState(30);
  const [retirementAge, setRetirementAge] = useState(65);
  const [currentSavings, setCurrentSavings] = useState(50000);
  const [annualIncome, setAnnualIncome] = useState(75000);
  const [savingsRate, setSavingsRate] = useState(20);
  const [expectedReturn, setExpectedReturn] = useState(7);
  const [inflationRate, setInflationRate] = useState(2.5);
  const [withdrawalRate, setWithdrawalRate] = useState(4);
  const [calculationResults, setCalculationResults] = useState(null);

  // Calculate financial independence projections
  const calculateProjections = () => {
    // Convert percentages to decimals
    const savingsRateDecimal = savingsRate / 100;
    const expectedReturnDecimal = expectedReturn / 100;
    const inflationRateDecimal = inflationRate / 100;
    const withdrawalRateDecimal = withdrawalRate / 100;
    
    // Calculate annual savings
    const annualSavings = annualIncome * savingsRateDecimal;
    
    // Calculate real rate of return (adjusted for inflation)
    const realReturnRate = (1 + expectedReturnDecimal) / (1 + inflationRateDecimal) - 1;
    
    // Calculate years to retirement
    const yearsToRetirement = retirementAge - currentAge;
    
    // Calculate future value of current savings
    const futureValueCurrentSavings = currentSavings * Math.pow(1 + realReturnRate, yearsToRetirement);
    
    // Calculate future value of annual savings
    let futureValueAnnualSavings = 0;
    for (let i = 0; i < yearsToRetirement; i++) {
      futureValueAnnualSavings += annualSavings * Math.pow(1 + realReturnRate, i);
    }
    
    // Calculate total retirement savings
    const totalRetirementSavings = futureValueCurrentSavings + futureValueAnnualSavings;
    
    // Calculate annual withdrawal amount
    const annualWithdrawal = totalRetirementSavings * withdrawalRateDecimal;
    
    // Calculate monthly withdrawal amount
    const monthlyWithdrawal = annualWithdrawal / 12;
    
    // Calculate financial independence number (25x annual expenses)
    const annualExpenses = annualIncome * (1 - savingsRateDecimal);
    const financialIndependenceNumber = annualExpenses * 25;
    
    // Calculate progress towards financial independence
    const progressPercentage = (totalRetirementSavings / financialIndependenceNumber) * 100;
    
    // Calculate years to financial independence
    // Using the formula: Years = ln(FI Number / Current Savings) / ln(1 + Real Return Rate)
    const yearsToFI = Math.log(financialIndependenceNumber / currentSavings) / Math.log(1 + realReturnRate);
    
    // Calculate FI date
    const today = new Date();
    const fiDate = new Date(today);
    fiDate.setFullYear(today.getFullYear() + Math.round(yearsToFI));
    
    // Generate projection data for chart
    const projectionData = {
      labels: [],
      datasets: [
        {
          label: 'Projected Savings',
          data: [],
          borderColor: 'rgba(75, 192, 192, 1)',
          backgroundColor: 'rgba(75, 192, 192, 0.2)',
          fill: true,
          tension: 0.4,
        },
        {
          label: 'FI Target',
          data: [],
          borderColor: 'rgba(255, 99, 132, 1)',
          backgroundColor: 'rgba(255, 99, 132, 0.0)',
          borderDash: [5, 5],
          tension: 0,
        }
      ]
    };
    
    // Generate data points for each year
    let currentSavingsValue = currentSavings;
    const maxYears = Math.ceil(yearsToFI) + 5; // Show 5 years beyond FI date
    
    for (let year = 0; year <= maxYears; year++) {
      // Add year label
      projectionData.labels.push(`Year ${year}`);
      
      // Calculate savings for this year
      if (year === 0) {
        projectionData.datasets[0].data.push(currentSavingsValue);
      } else {
        currentSavingsValue = currentSavingsValue * (1 + realReturnRate) + annualSavings;
        projectionData.datasets[0].data.push(currentSavingsValue);
      }
      
      // Add FI target line
      projectionData.datasets[1].data.push(financialIndependenceNumber);
    }
    
    // Set calculation results
    setCalculationResults({
      yearsToRetirement,
      totalRetirementSavings: Math.round(totalRetirementSavings),
      annualWithdrawal: Math.round(annualWithdrawal),
      monthlyWithdrawal: Math.round(monthlyWithdrawal),
      financialIndependenceNumber: Math.round(financialIndependenceNumber),
      progressPercentage: Math.min(Math.round(progressPercentage), 100),
      yearsToFI: Math.round(yearsToFI * 10) / 10,
      fiDate: fiDate.toLocaleDateString('en-US', { year: 'numeric', month: 'long' }),
      projectionData
    });
  };

  return (
    <div className="page-container">
      <div className="page-header">
        <h2>Financial Independence Tracker</h2>
        <div className="header-actions">
          <button className="secondary-button">Save Scenario</button>
          <button className="secondary-button">Load Scenario</button>
        </div>
      </div>
      
      <div className="fi-content">
        <div className="fi-calculator">
          <h3>Financial Independence Calculator</h3>
          <div className="calculator-form">
            <div className="form-row">
              <div className="form-group">
                <label>Current Age</label>
                <input 
                  type="number" 
                  value={currentAge} 
                  onChange={(e) => setCurrentAge(parseInt(e.target.value))} 
                />
              </div>
              <div className="form-group">
                <label>Target Retirement Age</label>
                <input 
                  type="number" 
                  value={retirementAge} 
                  onChange={(e) => setRetirementAge(parseInt(e.target.value))} 
                />
              </div>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Current Savings ($)</label>
                <input 
                  type="number" 
                  value={currentSavings} 
                  onChange={(e) => setCurrentSavings(parseInt(e.target.value))} 
                />
              </div>
              <div className="form-group">
                <label>Annual Income ($)</label>
                <input 
                  type="number" 
                  value={annualIncome} 
                  onChange={(e) => setAnnualIncome(parseInt(e.target.value))} 
                />
              </div>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Savings Rate (%)</label>
                <input 
                  type="number" 
                  value={savingsRate} 
                  onChange={(e) => setSavingsRate(parseFloat(e.target.value))} 
                />
              </div>
              <div className="form-group">
                <label>Expected Return (%)</label>
                <input 
                  type="number" 
                  value={expectedReturn} 
                  onChange={(e) => setExpectedReturn(parseFloat(e.target.value))} 
                />
              </div>
            </div>
            
            <div className="form-row">
              <div className="form-group">
                <label>Inflation Rate (%)</label>
                <input 
                  type="number" 
                  value={inflationRate} 
                  onChange={(e) => setInflationRate(parseFloat(e.target.value))} 
                />
              </div>
              <div className="form-group">
                <label>Withdrawal Rate (%)</label>
                <input 
                  type="number" 
                  value={withdrawalRate} 
                  onChange={(e) => setWithdrawalRate(parseFloat(e.target.value))} 
                />
              </div>
            </div>
            
            <button className="primary-button calculate-button" onClick={calculateProjections}>
              Calculate
            </button>
          </div>
        </div>
        
        {calculationResults && (
          <div className="fi-results">
            <h3>Your Financial Independence Projection</h3>
            
            <div className="fi-summary">
              <div className="summary-card">
                <h4>Financial Independence Number</h4>
                <div className="summary-value">${calculationResults.financialIndependenceNumber.toLocaleString()}</div>
                <div className="summary-description">The amount you need to retire</div>
              </div>
              
              <div className="summary-card">
                <h4>Progress to FI</h4>
                <div className="progress-container">
                  <div 
                    className="progress-bar" 
                    style={{width: `${calculationResults.progressPercentage}%`}}
                  ></div>
                </div>
                <div className="progress-value">{calculationResults.progressPercentage}%</div>
              </div>
              
              <div className="summary-card">
                <h4>Years to Financial Independence</h4>
                <div className="summary-value">{calculationResults.yearsToFI}</div>
                <div className="summary-description">Estimated FI date: {calculationResults.fiDate}</div>
              </div>
            </div>
            
            <div className="fi-chart">
              <h4>Projected Savings Growth</h4>
              <LineChart data={calculationResults.projectionData} />
            </div>
            
            <div className="fi-details">
              <div className="detail-section">
                <h4>Retirement Projections</h4>
                <div className="detail-item">
                  <div className="detail-label">Years to Retirement:</div>
                  <div className="detail-value">{calculationResults.yearsToRetirement}</div>
                </div>
                <div className="detail-item">
                  <div className="detail-label">Projected Retirement Savings:</div>
                  <div className="detail-value">${calculationResults.totalRetirementSavings.toLocaleString()}</div>
                </div>
                <div className="detail-item">
                  <div className="detail-label">Annual Withdrawal:</div>
                  <div className="detail-value">${calculationResults.annualWithdrawal.toLocaleString()}</div>
                </div>
                <div className="detail-item">
                  <div className="detail-label">Monthly Withdrawal:</div>
                  <div className="detail-value">${calculationResults.monthlyWithdrawal.toLocaleString()}</div>
                </div>
              </div>
              
              <div className="detail-section">
                <h4>Recommendations</h4>
                <ul className="recommendations-list">
                  <li>Increase your savings rate to reach FI sooner</li>
                  <li>Consider low-cost index funds for long-term investing</li>
                  <li>Review and optimize your tax strategy</li>
                  <li>Build an emergency fund of 3-6 months of expenses</li>
                  <li>Regularly review and adjust your FI plan</li>
                </ul>
              </div>
            </div>
          </div>
        )}
      </div>
      
      <div className="fi-resources">
        <h3>Financial Independence Resources</h3>
        <div className="resources-grid">
          <div className="resource-card">
            <h4>The 4% Rule</h4>
            <p>Learn about the safe withdrawal rate in retirement and how it affects your FI number.</p>
            <a href="#" className="resource-link">Read More</a>
          </div>
          <div className="resource-card">
            <h4>Tax-Efficient Investing</h4>
            <p>Strategies to minimize taxes and maximize returns on your path to financial independence.</p>
            <a href="#" className="resource-link">Read More</a>
          </div>
          <div className="resource-card">
            <h4>Early Retirement Strategies</h4>
            <p>Discover methods to access retirement funds before traditional retirement age.</p>
            <a href="#" className="resource-link">Read More</a>
          </div>
          <div className="resource-card">
            <h4>Coast FI vs. Lean FI vs. Fat FI</h4>
            <p>Understand different approaches to financial independence and which might be right for you.</p>
            <a href="#" className="resource-link">Read More</a>
          </div>
        </div>
      </div>
    </div>
  );
};

export default FinancialIndependence;
EOL

# Add CSS styles for charts
echo "Adding CSS styles for charts..."
cat >> src/App.css << 'EOL'
/* Chart Styles */
.chart-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
  margin-bottom: 1.5rem;
}

.dashboard-charts, .investment-charts, .budget-charts {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

@media (min-width: 992px) {
  .dashboard-charts, .investment-charts, .budget-charts {
    grid-template-columns: 1fr 1fr;
  }
}

.chart-legend {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  margin-top: 1rem;
}

.legend-item {
  display: flex;
  align-items: center;
  margin: 0.5rem 1rem;
}

.legend-color {
  display: inline-block;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  margin-right: 0.5rem;
}
EOL

# Restart the application
echo "Restarting the application..."
cd /opt/personal-finance-system
docker-compose restart frontend

echo "Chart visualizations implemented successfully!"
echo "You can now navigate to your application and see actual charts instead of placeholder text."
