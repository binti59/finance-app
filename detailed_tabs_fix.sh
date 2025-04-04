#!/bin/bash

# Script to implement detailed tabs for the finance application
# This script adds comprehensive tab implementations with proper styling

# Set the working directory
WORK_DIR="/opt/personal-finance-system/frontend/src"
cd $WORK_DIR || { echo "Failed to change to working directory"; exit 1; }

# Backup original files
echo "Creating backups of original files..."
cp App.js App.js.bak
if [ -f App.css ]; then
  cp App.css App.css.bak
fi

# Create the detailed App.js implementation
echo "Creating detailed tabs implementation..."
cat > App.js << 'EOL'
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link, useLocation } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from './store';
import './App.css';

// Dashboard Component
const Dashboard = () => {
  return (
    <div className="page-container">
      <h2>Financial Dashboard</h2>
      
      <div className="dashboard-metrics">
        <div className="metric-card">
          <h3>Net Worth</h3>
          <div className="metric-value">$124,500</div>
          <div className="metric-change positive">↑ 3.2% from last month</div>
        </div>
        <div className="metric-card">
          <h3>Monthly Income</h3>
          <div className="metric-value">$8,750</div>
          <div className="metric-change positive">↑ 5.0% from last month</div>
        </div>
        <div className="metric-card">
          <h3>Monthly Expenses</h3>
          <div className="metric-value">$5,320</div>
          <div className="metric-change negative">↑ 2.1% from last month</div>
        </div>
        <div className="metric-card">
          <h3>Savings Rate</h3>
          <div className="metric-value">39.2%</div>
          <div className="metric-change positive">↑ 1.5% from last month</div>
        </div>
      </div>
      
      <div className="dashboard-charts">
        <div className="chart-container">
          <h3>Income vs. Expenses</h3>
          <div className="chart-placeholder">
            [Income and Expense Bar Chart Visualization]
          </div>
        </div>
        <div className="chart-container">
          <h3>Expense Breakdown</h3>
          <div className="chart-placeholder">
            [Expense Pie Chart Visualization]
          </div>
        </div>
      </div>
      
      <div className="dashboard-sections">
        <div className="section-container">
          <div className="section-header">
            <h3>Recent Transactions</h3>
            <Link to="/transactions" className="view-all">View All</Link>
          </div>
          <div className="transaction-list">
            <div className="transaction-item">
              <div className="transaction-icon grocery">🛒</div>
              <div className="transaction-details">
                <div className="transaction-title">Grocery Shopping</div>
                <div className="transaction-date">Apr 3, 2025</div>
              </div>
              <div className="transaction-amount negative">-$125.40</div>
            </div>
            <div className="transaction-item">
              <div className="transaction-icon income">💼</div>
              <div className="transaction-details">
                <div className="transaction-title">Salary Deposit</div>
                <div className="transaction-date">Apr 1, 2025</div>
              </div>
              <div className="transaction-amount positive">+$4,375.00</div>
            </div>
            <div className="transaction-item">
              <div className="transaction-icon housing">🏠</div>
              <div className="transaction-details">
                <div className="transaction-title">Rent Payment</div>
                <div className="transaction-date">Apr 1, 2025</div>
              </div>
              <div className="transaction-amount negative">-$1,800.00</div>
            </div>
          </div>
        </div>
        
        <div className="section-container">
          <h3>Monthly Budget</h3>
          <div className="budget-progress">
            <div className="budget-category">
              <div className="budget-label">Housing</div>
              <div className="budget-bar">
                <div className="budget-progress-bar" style={{width: '90%'}}></div>
              </div>
              <div className="budget-values">$1,800 / $2,000</div>
            </div>
            <div className="budget-category">
              <div className="budget-label">Food & Groceries</div>
              <div className="budget-bar">
                <div className="budget-progress-bar" style={{width: '97%'}}></div>
              </div>
              <div className="budget-values">$580 / $600</div>
            </div>
            <div className="budget-category">
              <div className="budget-label">Transportation</div>
              <div className="budget-bar">
                <div className="budget-progress-bar" style={{width: '80%'}}></div>
              </div>
              <div className="budget-values">$320 / $400</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

// Accounts Component
const Accounts = () => {
  return (
    <div className="page-container">
      <div className="page-header">
        <h2>Accounts</h2>
        <button className="primary-button">+ Add Account</button>
      </div>
      
      <div className="accounts-overview">
        <h3>Total Balance: $125,750.00</h3>
        <div className="last-updated">Last Updated: Today, 10:30 AM</div>
      </div>
      
      <div className="accounts-table">
        <table>
          <thead>
            <tr>
              <th>Account Name</th>
              <th>Type</th>
              <th>Institution</th>
              <th>Balance</th>
              <th>Last Updated</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Checking Account</td>
              <td>Bank</td>
              <td>Chase Bank</td>
              <td className="positive">$12,500.00</td>
              <td>Today</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Savings Account</td>
              <td>Bank</td>
              <td>Chase Bank</td>
              <td className="positive">$35,000.00</td>
              <td>Today</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Investment Portfolio</td>
              <td>Investment</td>
              <td>Vanguard</td>
              <td className="positive">$68,250.00</td>
              <td>Yesterday</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Retirement Account</td>
              <td>Retirement</td>
              <td>Fidelity</td>
              <td className="positive">$10,000.00</td>
              <td>3 days ago</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Credit Card</td>
              <td>Credit</td>
              <td>American Express</td>
              <td className="negative">-$2,300.00</td>
              <td>Today</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Mortgage</td>
              <td>Loan</td>
              <td>Wells Fargo</td>
              <td className="negative">-$250,000.00</td>
              <td>1 week ago</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div className="pagination">
        <button className="pagination-button active">1</button>
        <button className="pagination-button">2</button>
        <button className="pagination-button">3</button>
      </div>
    </div>
  );
};

// Transactions Component
const Transactions = () => {
  return (
    <div className="page-container">
      <div className="page-header">
        <h2>Transactions</h2>
        <button className="primary-button">+ Add Transaction</button>
      </div>
      
      <div className="filters-container">
        <div className="filter-group">
          <label>Date Range:</label>
          <select>
            <option>Last 30 days</option>
            <option>Last 90 days</option>
            <option>This year</option>
            <option>Custom range</option>
          </select>
        </div>
        
        <div className="filter-group">
          <label>Account:</label>
          <select>
            <option>All Accounts</option>
            <option>Checking Account</option>
            <option>Savings Account</option>
            <option>Credit Card</option>
          </select>
        </div>
        
        <div className="filter-group">
          <label>Category:</label>
          <select>
            <option>All Categories</option>
            <option>Food</option>
            <option>Housing</option>
            <option>Transportation</option>
            <option>Utilities</option>
            <option>Income</option>
          </select>
        </div>
        
        <div className="search-group">
          <input type="text" placeholder="Search..." />
        </div>
      </div>
      
      <div className="transactions-table">
        <table>
          <thead>
            <tr>
              <th>Date</th>
              <th>Description</th>
              <th>Category</th>
              <th>Account</th>
              <th>Amount</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Mar 30, 2025</td>
              <td>Grocery Store</td>
              <td>Food</td>
              <td>Checking Account</td>
              <td className="negative">-$125.45</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Mar 29, 2025</td>
              <td>Salary Deposit</td>
              <td>Income</td>
              <td>Checking Account</td>
              <td className="positive">+$4,250.00</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Mar 28, 2025</td>
              <td>Electric Bill</td>
              <td>Utilities</td>
              <td>Checking Account</td>
              <td className="negative">-$85.20</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Mar 27, 2025</td>
              <td>Gas Station</td>
              <td>Transportation</td>
              <td>Credit Card</td>
              <td className="negative">-$45.75</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Mar 26, 2025</td>
              <td>Restaurant</td>
              <td>Dining Out</td>
              <td>Credit Card</td>
              <td className="negative">-$78.50</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Mar 25, 2025</td>
              <td>Online Shopping</td>
              <td>Shopping</td>
              <td>Credit Card</td>
              <td className="negative">-$129.99</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
            <tr>
              <td>Mar 24, 2025</td>
              <td>Mortgage Payment</td>
              <td>Housing</td>
              <td>Checking Account</td>
              <td className="negative">-$1,500.00</td>
              <td>
                <button className="action-button">Edit</button>
                <button className="action-button">Delete</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
      
      <div className="pagination">
        <button className="pagination-button active">1</button>
        <button className="pagination-button">2</button>
        <button className="pagination-button">3</button>
      </div>
    </div>
  );
};

// Investments Component
const Investments = () => {
  return (
    <div className="page-container">
      <div className="page-header">
        <h2>Investments</h2>
        <button className="primary-button">+ Add Investment</button>
      </div>
      
      <div className="portfolio-overview">
        <h3>Total Value: $78,250.00</h3>
        <div className="portfolio-return positive">Total Return: +$8,250.00 (+11.8%)</div>
        <div className="last-updated">Last Updated: Today, 10:30 AM</div>
      </div>
      
      <div className="portfolio-charts">
        <div className="chart-container">
          <h3>Asset Allocation</h3>
          <div className="chart-placeholder">
            [Asset Allocation Pie Chart]
          </div>
          <div className="chart-legend">
            <div className="legend-item"><span className="legend-color stocks"></span>Stocks (60%)</div>
            <div className="legend-item"><span className="legend-color bonds"></span>Bonds (20%)</div>
            <div className="legend-item"><span className="legend-color cash"></span>Cash (10%)</div>
            <div className="legend-item"><span className="legend-color real-estate"></span>Real Estate (5%)</div>
            <div className="legend-item"><span className="legend-color crypto"></span>Crypto (5%)</div>
          </div>
        </div>
        
        <div className="chart-container">
          <h3>Portfolio Performance</h3>
          <div className="chart-placeholder">
            [Portfolio Performance Line Chart]
          </div>
        </div>
      </div>
      
      <div className="investments-table">
        <h3>Investment Holdings</h3>
        <table>
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
            <tr>
              <td>AAPL</td>
              <td>Apple Inc.</td>
              <td>25</td>
              <td>$175.50</td>
              <td>$4,387.50</td>
              <td className="positive">+15.2%</td>
              <td>5.6%</td>
            </tr>
            <tr>
              <td>MSFT</td>
              <td>Microsoft Corp.</td>
              <td>20</td>
              <td>$325.75</td>
              <td>$6,515.00</td>
              <td className="positive">+22.5%</td>
              <td>8.3%</td>
            </tr>
            <tr>
              <td>AMZN</td>
              <td>Amazon.com Inc.</td>
              <td>10</td>
              <td>$180.25</td>
              <td>$1,802.50</td>
              <td className="positive">+8.7%</td>
              <td>2.3%</td>
            </tr>
            <tr>
              <td>VTI</td>
              <td>Vanguard Total Stock</td>
              <td>100</td>
              <td>$240.50</td>
              <td>$24,050.00</td>
              <td className="positive">+10.5%</td>
              <td>30.7%</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  );
};

// Budgets Component
const Budgets = () => {
  return (
    <div className="page-container">
      <div className="page-header">
        <h2>Budgets</h2>
        <button className="primary-button">+ Create Budget</button>
      </div>
      
      <div className="month-selector">
        <button className="month-nav">←</button>
        <h3>April 2025</h3>
        <button className="month-nav">→</button>
      </div>
      
      <div className="budget-summary">
        <div className="summary-card">
          <h3>Total Budget</h3>
          <div className="summary-value">$5,000.00</div>
        </div>
        <div className="summary-card">
          <h3>Spent So Far</h3>
          <div className="summary-value">$2,850.00</div>
        </div>
        <div className="summary-card">
          <h3>Remaining</h3>
          <div className="summary-value positive">$2,150.00</div>
        </div>
        <div className="summary-card">
          <h3>Days Remaining</h3>
          <div className="summary-value">26</div>
        </div>
      </div>
      
      <div className="budget-categories">
        <h3>Budget Categories</h3>
        
        <div className="budget-category-item">
          <div className="category-header">
            <div className="category-name">Housing</div>
            <div className="category-values">$1,800 / $2,000</div>
          </div>
          <div className="budget-bar">
            <div className="budget-progress-bar" style={{width: '90%'}}></div>
          </div>
          <div className="category-details">
            <div className="remaining">$200 remaining</div>
            <div className="percentage">90% used</div>
          </div>
        </div>
        
        <div className="budget-category-item">
          <div className="category-header">
            <div className="category-name">Food & Groceries</div>
            <div className="category-values">$580 / $600</div>
          </div>
          <div className="budget-bar">
            <div className="budget-progress-bar warning" style={{width: '97%'}}></div>
          </div>
          <div className="category-details">
            <div className="remaining">$20 remaining</div>
            <div className="percentage">97% used</div>
          </div>
        </div>
        
        <div className="budget-category-item">
          <div className="category-header">
            <div className="category-name">Transportation</div>
            <div className="category-values">$320 / $400</div>
          </div>
          <div className="budget-bar">
            <div className="budget-progress-bar" style={{width: '80%'}}></div>
          </div>
          <div className="category-details">
            <div className="remaining">$80 remaining</div>
            <div className="percentage">80% used</div>
          </div>
        </div>
        
        <div className="budget-category-item">
          <div className="category-header">
            <div className="category-name">Utilities</div>
            <div className="category-values">$150 / $300</div>
          </div>
          <div className="budget-bar">
            <div className="budget-progress-bar" style={{width: '50%'}}></div>
          </div>
          <div className="category-details">
            <div className="remaining">$150 remaining</div>
            <div className="percentage">50% used</div>
          </div>
        </div>
        
        <div className="budget-category-item">
          <div className="category-header">
            <div className="category-name">Entertainment</div>
            <div className="category-values">$250 / $200</div>
          </div>
          <div className="budget-bar">
            <div className="budget-progress-bar danger" style={{width: '125%'}}></div>
          </div>
          <div className="category-details">
            <div className="remaining negative">$50 over budget</div>
            <div className="percentage">125% used</div>
          </div>
        </div>
      </div>
    </div>
  );
};

// Goals Component
const Goals = () => {
  return (
    <div className="page-container">
      <div className="page-header">
        <h2>Financial Goals</h2>
        <button className="primary-button">+ Add Goal</button>
      </div>
      
      <div className="goals-summary">
        <div className="summary-card">
          <h3>Active Goals</h3>
          <div className="summary-value">4</div>
        </div>
        <div className="summary-card">
          <h3>Completed Goals</h3>
          <div className="summary-value">2</div>
        </div>
        <div className="summary-card">
          <h3>Total Saved</h3>
          <div className="summary-value">$28,500.00</div>
        </div>
        <div className="summary-card">
          <h3>Target Amount</h3>
          <div className="summary-value">$75,000.00</div>
        </div>
      </div>
      
      <div className="goals-list">
        <div className="goal-item">
          <div className="goal-icon emergency">💰</div>
          <div className="goal-details">
            <h3>Emergency Fund</h3>
            <div className="goal-progress-container">
              <div className="goal-progress-bar" style={{width: '90%'}}></div>
            </div>
            <div className="goal-stats">
              <div className="goal-progress">$9,000 of $10,000 (90%)</div>
              <div className="goal-target-date">Target: June 2025</div>
            </div>
          </div>
          <div className="goal-actions">
            <button className="action-button">Edit</button>
            <button className="action-button">Delete</button>
          </div>
        </div>
        
        <div className="goal-item">
          <div className="goal-icon home">🏠</div>
          <div className="goal-details">
            <h3>Down Payment</h3>
            <div className="goal-progress-container">
              <div className="goal-progress-bar" style={{width: '45%'}}></div>
            </div>
            <div className="goal-stats">
              <div className="goal-progress">$18,000 of $40,000 (45%)</div>
              <div className="goal-target-date">Target: December 2026</div>
            </div>
          </div>
          <div className="goal-actions">
            <button className="action-button">Edit</button>
            <button className="action-button">Delete</button>
          </div>
        </div>
        
        <div className="goal-item">
          <div className="goal-icon vacation">✈️</div>
          <div className="goal-details">
            <h3>Vacation</h3>
            <div className="goal-progress-container">
              <div className="goal-progress-bar" style={{width: '70%'}}></div>
            </div>
            <div className="goal-stats">
              <div className="goal-progress">$3,500 of $5,000 (70%)</div>
              <div className="goal-target-date">Target: August 2025</div>
            </div>
          </div>
          <div className="goal-actions">
            <button className="action-button">Edit</button>
            <button className="action-button">Delete</button>
          </div>
        </div>
        
        <div className="goal-item">
          <div className="goal-icon retirement">👴</div>
          <div className="goal-details">
            <h3>Retirement</h3>
            <div className="goal-progress-container">
              <div className="goal-progress-bar" style={{width: '30%'}}></div>
            </div>
            <div className="goal-stats">
              <div className="goal-progress">$60,000 of $200,000 (30%)</div>
              <div className="goal-target-date">Target: January 2045</div>
            </div>
          </div>
          <div className="goal-actions">
            <button className="action-button">Edit</button>
            <button className="action-button">Delete</button>
          </div>
        </div>
      </div>
      
      <div className="completed-goals">
        <h3>Completed Goals</h3>
        <div className="goal-item completed">
          <div className="goal-icon car">🚗</div>
          <div className="goal-details">
            <h3>New Car</h3>
            <div className="goal-progress-container">
              <div className="goal-progress-bar complete" style={{width: '100%'}}></div>
            </div>
            <div className="goal-stats">
              <div className="goal-progress">$15,000 of $15,000 (100%)</div>
              <div className="goal-target-date">Completed: January 2025</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

// Reports Component
const Reports = () => {
  return (
    <div className="page-container">
      <div className="page-header">
        <h2>Financial Reports</h2>
        <div className="report-actions">
          <button className="secondary-button">Export</button>
          <button className="secondary-button">Print</button>
        </div>
      </div>
      
      <div className="report-filters">
        <div className="filter-group">
          <label>Report Type:</label>
          <select>
            <option>Income vs. Expenses</option>
            <option>Net Worth</option>
            <option>Spending by Category</option>
            <option>Investment Performance</option>
            <option>Cash Flow</option>
          </select>
        </div>
        
        <div className="filter-group">
          <label>Time Period:</label>
          <select>
            <option>This Month</option>
            <option>Last Month</option>
            <option>Last 3 Months</option>
            <option>Last 6 Months</option>
            <option>This Year</option>
            <option>Last Year</option>
            <option>Custom Range</option>
          </select>
        </div>
        
        <button className="primary-button">Generate Report</button>
      </div>
      
      <div className="report-content">
        <h3>Income vs. Expenses: April 2025</h3>
        
        <div className="report-summary">
          <div className="summary-card">
            <h4>Total Income</h4>
            <div className="summary-value">$8,750.00</div>
          </div>
          <div className="summary-card">
            <h4>Total Expenses</h4>
            <div className="summary-value">$5,320.00</div>
          </div>
          <div className="summary-card">
            <h4>Net Savings</h4>
            <div className="summary-value positive">$3,430.00</div>
          </div>
          <div className="summary-card">
            <h4>Savings Rate</h4>
            <div className="summary-value">39.2%</div>
          </div>
        </div>
        
        <div className="report-chart">
          <div className="chart-placeholder">
            [Income vs. Expenses Bar Chart for April 2025]
          </div>
        </div>
        
        <div className="report-tables">
          <div className="report-table">
            <h4>Income Breakdown</h4>
            <table>
              <thead>
                <tr>
                  <th>Category</th>
                  <th>Amount</th>
                  <th>Percentage</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Salary</td>
                  <td>$8,500.00</td>
                  <td>97.1%</td>
                </tr>
                <tr>
                  <td>Interest</td>
                  <td>$150.00</td>
                  <td>1.7%</td>
                </tr>
                <tr>
                  <td>Other</td>
                  <td>$100.00</td>
                  <td>1.2%</td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <td><strong>Total</strong></td>
                  <td><strong>$8,750.00</strong></td>
                  <td><strong>100%</strong></td>
                </tr>
              </tfoot>
            </table>
          </div>
          
          <div className="report-table">
            <h4>Expense Breakdown</h4>
            <table>
              <thead>
                <tr>
                  <th>Category</th>
                  <th>Amount</th>
                  <th>Percentage</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td>Housing</td>
                  <td>$1,800.00</td>
                  <td>33.8%</td>
                </tr>
                <tr>
                  <td>Food</td>
                  <td>$850.00</td>
                  <td>16.0%</td>
                </tr>
                <tr>
                  <td>Transportation</td>
                  <td>$450.00</td>
                  <td>8.5%</td>
                </tr>
                <tr>
                  <td>Utilities</td>
                  <td>$350.00</td>
                  <td>6.6%</td>
                </tr>
                <tr>
                  <td>Entertainment</td>
                  <td>$500.00</td>
                  <td>9.4%</td>
                </tr>
                <tr>
                  <td>Other</td>
                  <td>$1,370.00</td>
                  <td>25.7%</td>
                </tr>
              </tbody>
              <tfoot>
                <tr>
                  <td><strong>Total</strong></td>
                  <td><strong>$5,320.00</strong></td>
                  <td><strong>100%</strong></td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
};

// Settings Component
const Settings = () => {
  return (
    <div className="page-container">
      <h2>Settings</h2>
      
      <div className="settings-sections">
        <div className="settings-section">
          <h3>Account Settings</h3>
          <div className="settings-form">
            <div className="form-group">
              <label>Name</label>
              <input type="text" value="John Doe" />
            </div>
            <div className="form-group">
              <label>Email</label>
              <input type="email" value="john.doe@example.com" />
            </div>
            <div className="form-group">
              <label>Password</label>
              <input type="password" value="********" />
              <button className="text-button">Change Password</button>
            </div>
            <button className="primary-button">Save Changes</button>
          </div>
        </div>
        
        <div className="settings-section">
          <h3>Preferences</h3>
          <div className="settings-form">
            <div className="form-group">
              <label>Currency</label>
              <select>
                <option>USD ($)</option>
                <option>EUR (€)</option>
                <option>GBP (£)</option>
                <option>JPY (¥)</option>
              </select>
            </div>
            <div className="form-group">
              <label>Date Format</label>
              <select>
                <option>MM/DD/YYYY</option>
                <option>DD/MM/YYYY</option>
                <option>YYYY-MM-DD</option>
              </select>
            </div>
            <div className="form-group">
              <label>Theme</label>
              <select>
                <option>Light</option>
                <option>Dark</option>
                <option>System Default</option>
              </select>
            </div>
            <div className="form-group checkbox">
              <input type="checkbox" id="notifications" checked />
              <label htmlFor="notifications">Enable Email Notifications</label>
            </div>
            <button className="primary-button">Save Preferences</button>
          </div>
        </div>
        
        <div className="settings-section">
          <h3>Data Management</h3>
          <div className="settings-actions">
            <div className="action-item">
              <div className="action-description">
                <h4>Export Data</h4>
                <p>Download all your financial data in CSV format</p>
              </div>
              <button className="secondary-button">Export</button>
            </div>
            <div className="action-item">
              <div className="action-description">
                <h4>Import Data</h4>
                <p>Import transactions from CSV files</p>
              </div>
              <button className="secondary-button">Import</button>
            </div>
            <div className="action-item">
              <div className="action-description">
                <h4>Delete Account</h4>
                <p>Permanently delete your account and all data</p>
              </div>
              <button className="danger-button">Delete Account</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

// Login Component
const Login = () => {
  return (
    <div className="login-container">
      <h2>Login</h2>
      <form className="login-form">
        <div className="form-group">
          <label htmlFor="email">Email</label>
          <input type="email" id="email" placeholder="Enter your email" />
        </div>
        <div className="form-group">
          <label htmlFor="password">Password</label>
          <input type="password" id="password" placeholder="Enter your password" />
        </div>
        <button type="submit" className="login-button">Login</button>
      </form>
      <p className="login-footer">Don't have an account? <a href="#signup">Sign up</a></p>
    </div>
  );
};

// NavItem Component for active link styling
const NavItem = ({ to, children }) => {
  const location = useLocation();
  const isActive = location.pathname === to;
  
  return (
    <li className={isActive ? 'active' : ''}>
      <Link to={to}>{children}</Link>
    </li>
  );
};

function App() {
  return (
    <Provider store={store}>
      <Router>
        <div className="App">
          <header className="App-header">
            <div className="header-content">
              <h1>Finance Manager</h1>
              <div className="user-profile">
                <div className="user-avatar">J</div>
                <span className="user-name">John Doe</span>
              </div>
            </div>
            <nav className="main-nav">
              <ul>
                <NavItem to="/">Dashboard</NavItem>
                <NavItem to="/accounts">Accounts</NavItem>
                <NavItem to="/transactions">Transactions</NavItem>
                <NavItem to="/investments">Investments</NavItem>
                <NavItem to="/budgets">Budgets</NavItem>
                <NavItem to="/goals">Goals</NavItem>
                <NavItem to="/reports">Reports</NavItem>
                <NavItem to="/settings">Settings</NavItem>
                <li className="login-link"><Link to="/login">Login</Link></li>
              </ul>
            </nav>
          </header>
          <main>
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/accounts" element={<Accounts />} />
              <Route path="/transactions" element={<Transactions />} />
              <Route path="/investments" element={<Investments />} />
              <Route path="/budgets" element={<Budgets />} />
              <Route path="/goals" element={<Goals />} />
              <Route path="/reports" element={<Reports />} />
              <Route path="/settings" element={<Settings />} />
              <Route path="/login" element={<Login />} />
            </Routes>
          </main>
          <footer>
            <p>Enhanced Personal Finance Management System</p>
          </footer>
        </div>
      </Router>
    </Provider>
  );
}

export default App;
EOL

# Create the CSS file
echo "Creating CSS styles for the detailed tabs..."
cat > App.css << 'EOL'
/* Global Styles */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  line-height: 1.6;
  color: #333;
  background-color: #f5f7fa;
}

.App {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

/* Header Styles */
.App-header {
  background-color: #2c3e50;
  color: white;
  padding: 0.5rem 2rem;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0.5rem 0;
}

.user-profile {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.user-avatar {
  width: 2.5rem;
  height: 2.5rem;
  background-color: #3498db;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
}

/* Navigation Styles */
.main-nav {
  margin-top: 0.5rem;
}

.main-nav ul {
  display: flex;
  list-style: none;
  gap: 1rem;
  padding: 0.5rem 0;
}

.main-nav li a {
  color: #ecf0f1;
  text-decoration: none;
  padding: 0.5rem 0.75rem;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.main-nav li a:hover {
  background-color: #34495e;
}

.main-nav li.active a {
  background-color: #3498db;
  color: white;
}

.login-link {
  margin-left: auto;
}

/* Main Content Styles */
main {
  flex: 1;
  padding: 2rem;
}

.page-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  padding: 2rem;
  margin-bottom: 2rem;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

/* Dashboard Styles */
.dashboard-metrics {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.metric-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.metric-value {
  font-size: 1.8rem;
  font-weight: bold;
  margin: 0.5rem 0;
}

.metric-change {
  font-size: 0.9rem;
}

.positive {
  color: #27ae60;
}

.negative {
  color: #e74c3c;
}

.dashboard-charts {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.chart-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.chart-placeholder {
  height: 250px;
  background-color: #f8f9fa;
  border: 1px dashed #ccc;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 1rem 0;
  color: #777;
}

.dashboard-sections {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 1.5rem;
}

.section-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.view-all {
  color: #3498db;
  text-decoration: none;
  font-size: 0.9rem;
}

/* Transaction List Styles */
.transaction-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.transaction-item {
  display: flex;
  align-items: center;
  padding: 0.75rem;
  border-radius: 6px;
  background-color: #f8f9fa;
}

.transaction-icon {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 50%;
  background-color: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1rem;
  font-size: 1.2rem;
}

.transaction-details {
  flex: 1;
}

.transaction-title {
  font-weight: 500;
}

.transaction-date {
  font-size: 0.8rem;
  color: #777;
}

.transaction-amount {
  font-weight: 500;
}

/* Budget Styles */
.budget-progress {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.budget-category {
  margin-bottom: 0.75rem;
}

.budget-label {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.25rem;
}

.budget-bar {
  height: 0.5rem;
  background-color: #ecf0f1;
  border-radius: 4px;
  overflow: hidden;
  margin-bottom: 0.25rem;
}

.budget-progress-bar {
  height: 100%;
  background-color: #3498db;
  border-radius: 4px;
}

.budget-progress-bar.warning {
  background-color: #f39c12;
}

.budget-progress-bar.danger {
  background-color: #e74c3c;
}

.budget-values {
  font-size: 0.8rem;
  color: #777;
  text-align: right;
}

/* Accounts Styles */
.accounts-overview {
  background-color: #f8f9fa;
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.last-updated {
  font-size: 0.8rem;
  color: #777;
}

.accounts-table {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 1.5rem;
}

th, td {
  padding: 0.75rem 1rem;
  text-align: left;
  border-bottom: 1px solid #ecf0f1;
}

th {
  background-color: #f8f9fa;
  font-weight: 600;
}

.pagination {
  display: flex;
  justify-content: center;
  gap: 0.5rem;
}

.pagination-button {
  padding: 0.5rem 0.75rem;
  border: 1px solid #ddd;
  background-color: white;
  border-radius: 4px;
  cursor: pointer;
}

.pagination-button.active {
  background-color: #3498db;
  color: white;
  border-color: #3498db;
}

/* Button Styles */
.primary-button {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
}

.secondary-button {
  background-color: #ecf0f1;
  color: #333;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
}

.danger-button {
  background-color: #e74c3c;
  color: white;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
}

.action-button {
  background-color: transparent;
  color: #3498db;
  border: none;
  padding: 0.25rem 0.5rem;
  cursor: pointer;
  font-size: 0.9rem;
}

/* Filters Styles */
.filters-container {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 2rem;
  padding: 1rem;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.filter-group select, .filter-group input {
  padding: 0.5rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

/* Investments Styles */
.portfolio-overview {
  background-color: #f8f9fa;
  padding: 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.portfolio-return {
  margin: 0.5rem 0;
  font-weight: 500;
}

.chart-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-top: 1rem;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.9rem;
}

.legend-color {
  width: 1rem;
  height: 1rem;
  border-radius: 2px;
}

.legend-color.stocks {
  background-color: #3498db;
}

.legend-color.bonds {
  background-color: #f39c12;
}

.legend-color.cash {
  background-color: #2ecc71;
}

.legend-color.real-estate {
  background-color: #9b59b6;
}

.legend-color.crypto {
  background-color: #e74c3c;
}

/* Goals Styles */
.goals-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.goals-list {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.goal-item {
  display: flex;
  align-items: center;
  padding: 1.5rem;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.goal-icon {
  width: 3rem;
  height: 3rem;
  border-radius: 50%;
  background-color: #f0f0f0;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1.5rem;
  font-size: 1.5rem;
}

.goal-details {
  flex: 1;
}

.goal-progress-container {
  height: 0.5rem;
  background-color: #ecf0f1;
  border-radius: 4px;
  overflow: hidden;
  margin: 0.75rem 0;
}

.goal-progress-bar {
  height: 100%;
  background-color: #3498db;
  border-radius: 4px;
}

.goal-progress-bar.complete {
  background-color: #2ecc71;
}

.goal-stats {
  display: flex;
  justify-content: space-between;
  font-size: 0.9rem;
  color: #777;
}

.goal-actions {
  display: flex;
  gap: 0.5rem;
}

.completed-goals {
  margin-top: 2rem;
}

.goal-item.completed {
  opacity: 0.7;
}

/* Reports Styles */
.report-filters {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background-color: #f8f9fa;
  border-radius: 8px;
  align-items: flex-end;
}

.report-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.report-tables {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
  gap: 1.5rem;
}

/* Settings Styles */
.settings-sections {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.settings-section {
  background-color: #f8f9fa;
  padding: 1.5rem;
  border-radius: 8px;
}

.settings-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin-top: 1rem;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 500;
}

.form-group input, .form-group select {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
}

.form-group.checkbox {
  flex-direction: row;
  align-items: center;
  gap: 0.75rem;
}

.text-button {
  background: none;
  border: none;
  color: #3498db;
  cursor: pointer;
  padding: 0;
  font-size: 0.9rem;
  text-align: left;
}

.settings-actions {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.action-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  background-color: white;
  border-radius: 6px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.action-description p {
  font-size: 0.9rem;
  color: #777;
  margin-top: 0.25rem;
}

/* Login Styles */
.login-container {
  max-width: 400px;
  margin: 2rem auto;
  padding: 2rem;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin: 1.5rem 0;
}

.login-button {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.75rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  margin-top: 1rem;
}

.login-footer {
  text-align: center;
  font-size: 0.9rem;
  margin-top: 1.5rem;
}

.login-footer a {
  color: #3498db;
  text-decoration: none;
}

/* Footer Styles */
footer {
  background-color: #2c3e50;
  color: white;
  text-align: center;
  padding: 1rem;
  margin-top: auto;
}

/* Responsive Styles */
@media (max-width: 768px) {
  .main-nav ul {
    flex-wrap: wrap;
  }
  
  .dashboard-metrics,
  .dashboard-charts,
  .dashboard-sections,
  .goals-summary,
  .report-summary,
  .report-tables {
    grid-template-columns: 1fr;
  }
  
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
  
  .accounts-overview {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.5rem;
  }
  
  .action-item {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }
}
EOL

# Update package.json to include react-router-dom
echo "Updating package.json to include react-router-dom..."
if [ -f package.json ]; then
  # Check if react-router-dom is already in dependencies
  if ! grep -q '"react-router-dom"' package.json; then
    # Add react-router-dom to dependencies
    sed -i 's/"dependencies": {/"dependencies": {\n    "react-router-dom": "^6.10.0",/g' package.json
  fi
fi

# Restart the application
echo "Restarting the application..."
cd /opt/personal-finance-system
docker-compose restart frontend

echo "Detailed tabs implementation completed successfully!"
echo "You can now navigate to your application and use the detailed tabs."
