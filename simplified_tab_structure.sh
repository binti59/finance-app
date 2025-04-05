#!/bin/bash

# Simplified tab structure implementation script
# This script implements a new navigation structure with main tabs and collapsible lists,
# Compatible with React Router v6 and modern React dependencies

echo "Starting simplified tab structure implementation..."

# Set the working directory
WORK_DIR="/opt/personal-finance-system"
cd $WORK_DIR || { echo "Failed to change to working directory"; exit 1; }

# Create backup of current application state
echo "Creating backup of current application state..."
BACKUP_DIR="/opt/backups/finance-app-$(date +%Y%m%d%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r * $BACKUP_DIR/

# Stop application containers
echo "Stopping application containers..."
docker-compose down

# Create a simple navigation component that works with React Router v6
echo "Creating simplified navigation component..."
mkdir -p frontend/src/components/navigation

cat > frontend/src/components/navigation/MainNavigation.js << 'EOL'
import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import './MainNavigation.css';

const MainNavigation = () => {
  const location = useLocation();
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);
  const [accountsOpen, setAccountsOpen] = useState(false);
  const [planningOpen, setPlanningOpen] = useState(false);

  const toggleMobileMenu = () => {
    setMobileMenuOpen(!mobileMenuOpen);
  };

  const toggleAccounts = () => {
    setAccountsOpen(!accountsOpen);
  };

  const togglePlanning = () => {
    setPlanningOpen(!planningOpen);
  };

  const isActive = (path) => {
    return location.pathname === path;
  };

  return (
    <div className="navigation-container">
      <div className="top-bar">
        <div className="logo">Finance Manager</div>
        <button className="mobile-menu-button" onClick={toggleMobileMenu}>
          ☰
        </button>
        <div className="desktop-menu">
          <Link to="/" className={isActive('/') ? 'active' : ''}>Dashboard</Link>
          <Link to="/advanced-kpis" className={isActive('/advanced-kpis') ? 'active' : ''}>Advanced KPIs</Link>
          <Link to="/financial-independence" className={isActive('/financial-independence') ? 'active' : ''}>Financial Independence</Link>
          <Link to="/reports" className={isActive('/reports') ? 'active' : ''}>Reports</Link>
          <Link to="/settings" className={isActive('/settings') ? 'active' : ''}>Settings</Link>
        </div>
      </div>
      
      <div className={`sidebar ${mobileMenuOpen ? 'open' : ''}`}>
        <div className="user-info">
          <div className="avatar">J</div>
          <div className="user-name">John Doe</div>
        </div>
        
        <div className="sidebar-menu">
          <div className="menu-section">
            <div className="section-title">Main</div>
            <Link to="/" className={isActive('/') ? 'active' : ''}>Dashboard</Link>
            <Link to="/advanced-kpis" className={isActive('/advanced-kpis') ? 'active' : ''}>Advanced KPIs</Link>
            <Link to="/financial-independence" className={isActive('/financial-independence') ? 'active' : ''}>Financial Independence</Link>
            <Link to="/reports" className={isActive('/reports') ? 'active' : ''}>Reports</Link>
            <Link to="/settings" className={isActive('/settings') ? 'active' : ''}>Settings</Link>
          </div>
          
          <div className="menu-section">
            <div className="section-title" onClick={toggleAccounts}>
              Accounts & Transactions {accountsOpen ? '▼' : '▶'}
            </div>
            {accountsOpen && (
              <div className="submenu">
                <Link to="/accounts" className={isActive('/accounts') ? 'active' : ''}>Accounts</Link>
                <Link to="/transactions" className={isActive('/transactions') ? 'active' : ''}>Transactions</Link>
                <Link to="/connections" className={isActive('/connections') ? 'active' : ''}>Connections</Link>
                <Link to="/import" className={isActive('/import') ? 'active' : ''}>Import Data</Link>
              </div>
            )}
          </div>
          
          <div className="menu-section">
            <div className="section-title" onClick={togglePlanning}>
              Planning & Investments {planningOpen ? '▼' : '▶'}
            </div>
            {planningOpen && (
              <div className="submenu">
                <Link to="/budget" className={isActive('/budget') ? 'active' : ''}>Budget</Link>
                <Link to="/goals" className={isActive('/goals') ? 'active' : ''}>Goals</Link>
                <Link to="/investments" className={isActive('/investments') ? 'active' : ''}>Investments</Link>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default MainNavigation;
EOL

# Create CSS for the navigation component
cat > frontend/src/components/navigation/MainNavigation.css << 'EOL'
.navigation-container {
  display: flex;
  flex-direction: column;
  width: 100%;
}

.top-bar {
  display: flex;
  align-items: center;
  background-color: #1976d2;
  color: white;
  padding: 0 20px;
  height: 64px;
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
}

.logo {
  font-size: 1.5rem;
  font-weight: bold;
  flex-grow: 1;
}

.mobile-menu-button {
  display: none;
  background: none;
  border: none;
  color: white;
  font-size: 1.5rem;
  cursor: pointer;
}

.desktop-menu {
  display: flex;
}

.desktop-menu a {
  color: white;
  text-decoration: none;
  padding: 0 15px;
  height: 64px;
  display: flex;
  align-items: center;
}

.desktop-menu a.active {
  background-color: rgba(255, 255, 255, 0.15);
}

.sidebar {
  width: 240px;
  background-color: white;
  height: calc(100vh - 64px);
  position: fixed;
  top: 64px;
  left: 0;
  box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
  overflow-y: auto;
  z-index: 900;
}

.user-info {
  display: flex;
  align-items: center;
  padding: 16px;
  border-bottom: 1px solid #eee;
}

.avatar {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #1976d2;
  color: white;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 12px;
  font-weight: bold;
}

.user-name {
  font-weight: 500;
}

.sidebar-menu {
  padding: 16px 0;
}

.menu-section {
  margin-bottom: 16px;
}

.section-title {
  padding: 8px 16px;
  font-weight: 500;
  color: #555;
  cursor: pointer;
}

.sidebar-menu a {
  display: block;
  padding: 8px 16px;
  color: #333;
  text-decoration: none;
}

.sidebar-menu a.active {
  background-color: rgba(25, 118, 210, 0.1);
  color: #1976d2;
  border-left: 3px solid #1976d2;
}

.submenu {
  padding-left: 16px;
}

.submenu a {
  font-size: 0.95rem;
}

/* Main content area */
.main-content {
  margin-left: 240px;
  margin-top: 64px;
  padding: 20px;
  min-height: calc(100vh - 64px);
  background-color: #f5f5f5;
}

/* Responsive styles */
@media (max-width: 768px) {
  .mobile-menu-button {
    display: block;
  }
  
  .desktop-menu {
    display: none;
  }
  
  .sidebar {
    transform: translateX(-100%);
    transition: transform 0.3s ease;
  }
  
  .sidebar.open {
    transform: translateX(0);
  }
  
  .main-content {
    margin-left: 0;
  }
}
EOL

# Create a simple Advanced KPIs component
echo "Creating simplified Advanced KPIs component..."
mkdir -p frontend/src/pages

cat > frontend/src/pages/AdvancedKPIs.js << 'EOL'
import React, { useState } from 'react';
import './AdvancedKPIs.css';

const AdvancedKPIs = () => {
  const [activeTab, setActiveTab] = useState('overview');
  
  // Sample KPI data
  const kpiData = {
    financialIndependenceIndex: 25,
    financialFreedomNumber: 1000000,
    savingsRate: 30.8,
    financialHealthScore: 68,
    monthlyExpenses: 5320,
    annualExpenses: 63840,
    withdrawalRate: 4,
    currentNetWorth: 250000,
    monthlyIncome: 8750,
    monthlySavings: 3430,
    emergencyFundScore: 15,
    debtManagementScore: 20,
    savingsRateScore: 20,
    fiProgressScore: 13
  };
  
  // Calculate years to FI
  const yearsToFI = Math.ceil((kpiData.financialFreedomNumber - kpiData.currentNetWorth) / (kpiData.monthlySavings * 12));
  
  return (
    <div className="advanced-kpis-container">
      <h1>Advanced Financial KPIs</h1>
      <p className="subtitle">
        Track and analyze your key financial performance indicators to optimize your financial health and progress toward financial independence.
      </p>
      
      <div className="tabs">
        <button 
          className={activeTab === 'overview' ? 'active' : ''} 
          onClick={() => setActiveTab('overview')}
        >
          Overview
        </button>
        <button 
          className={activeTab === 'fi' ? 'active' : ''} 
          onClick={() => setActiveTab('fi')}
        >
          Financial Independence
        </button>
        <button 
          className={activeTab === 'trends' ? 'active' : ''} 
          onClick={() => setActiveTab('trends')}
        >
          Trends
        </button>
        <button 
          className={activeTab === 'health' ? 'active' : ''} 
          onClick={() => setActiveTab('health')}
        >
          Financial Health
        </button>
      </div>
      
      {activeTab === 'overview' && (
        <div className="tab-content">
          <div className="kpi-grid">
            <div className="kpi-card">
              <h2>Financial Independence Index</h2>
              <div className="kpi-value highlight-orange">{kpiData.financialIndependenceIndex}%</div>
              <div className="kpi-subtitle">On Your Way</div>
              <div className="progress-bar">
                <div className="progress" style={{width: `${kpiData.financialIndependenceIndex}%`}}></div>
              </div>
              <p className="kpi-description">
                You're {kpiData.financialIndependenceIndex}% of the way to financial independence. 
                At your current savings rate, you'll reach financial independence in approximately {yearsToFI} years.
              </p>
            </div>
            
            <div className="kpi-card">
              <h2>Financial Freedom Number</h2>
              <div className="kpi-value">${kpiData.financialFreedomNumber.toLocaleString()}</div>
              <div className="kpi-subtitle">Target Net Worth</div>
              <div className="kpi-details">
                <div className="detail-row">
                  <div className="detail">
                    <span>Annual Expenses</span>
                    <span>${kpiData.annualExpenses.toLocaleString()}</span>
                  </div>
                  <div className="detail">
                    <span>Withdrawal Rate</span>
                    <span>{kpiData.withdrawalRate}%</span>
                  </div>
                </div>
                <div className="detail-row">
                  <div className="detail">
                    <span>Current Net Worth</span>
                    <span>${kpiData.currentNetWorth.toLocaleString()}</span>
                  </div>
                  <div className="detail">
                    <span>Progress</span>
                    <span>{kpiData.financialIndependenceIndex}%</span>
                  </div>
                </div>
              </div>
            </div>
            
            <div className="kpi-card">
              <h2>Savings Rate</h2>
              <div className="kpi-value highlight-green">{kpiData.savingsRate}%</div>
              <div className="kpi-subtitle">Excellent</div>
              <div className="kpi-details">
                <div className="detail-row three-columns">
                  <div className="detail">
                    <span>Monthly Income</span>
                    <span>${kpiData.monthlyIncome.toLocaleString()}</span>
                  </div>
                  <div className="detail">
                    <span>Monthly Expenses</span>
                    <span>${kpiData.monthlyExpenses.toLocaleString()}</span>
                  </div>
                  <div className="detail">
                    <span>Monthly Savings</span>
                    <span>${kpiData.monthlySavings.toLocaleString()}</span>
                  </div>
                </div>
              </div>
              <p className="kpi-description">
                Your savings rate is excellent! A high savings rate is one of the most important factors in achieving financial independence quickly.
              </p>
            </div>
            
            <div className="kpi-card">
              <h2>Financial Health Score</h2>
              <div className="kpi-value highlight-orange">{kpiData.financialHealthScore}/100</div>
              <div className="kpi-subtitle">Good</div>
              <div className="score-breakdown">
                <div className="score-item">
                  <div className="score-label">Emergency Fund</div>
                  <div className="score-bar">
                    <div className="score-progress" style={{width: `${(kpiData.emergencyFundScore / 25) * 100}%`}}></div>
                  </div>
                  <div className="score-value">{kpiData.emergencyFundScore}/25</div>
                </div>
                <div className="score-item">
                  <div className="score-label">Debt Management</div>
                  <div className="score-bar">
                    <div className="score-progress" style={{width: `${(kpiData.debtManagementScore / 25) * 100}%`}}></div>
                  </div>
                  <div className="score-value">{kpiData.debtManagementScore}/25</div>
                </div>
                <div className="score-item">
                  <div className="score-label">Savings Rate</div>
                  <div className="score-bar">
                    <div className="score-progress" style={{width: `${(kpiData.savingsRateScore / 25) * 100}%`}}></div>
                  </div>
                  <div className="score-value">{kpiData.savingsRateScore}/25</div>
                </div>
                <div className="score-item">
                  <div className="score-label">FI Progress</div>
                  <div className="score-bar">
                    <div className="score-progress" style={{width: `${(kpiData.fiProgressScore / 25) * 100}%`}}></div>
                  </div>
                  <div className="score-value">{kpiData.fiProgressScore}/25</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
      
      {activeTab === 'fi' && (
        <div className="tab-content">
          <div className="fi-calculator">
            <h2>Financial Independence Calculator</h2>
            <div className="fi-details">
              <div className="fi-detail-row">
                <div className="fi-detail">
                  <span className="detail-label">Current Net Worth</span>
                  <span className="detail-value">${kpiData.currentNetWorth.toLocaleString()}</span>
                </div>
                <div className="fi-detail">
                  <span className="detail-label">Annual Expenses</span>
                  <span className="detail-value">${kpiData.annualExpenses.toLocaleString()}</span>
                </div>
                <div className="fi-detail">
                  <span className="detail-label">Annual Savings</span>
                  <span className="detail-value">${(kpiData.monthlySavings * 12).toLocaleString()}</span>
                </div>
              </div>
              
              <div className="fi-key-metrics">
                <div className="key-metric">
                  <span className="metric-label">Financial Freedom Number</span>
                  <span className="metric-value">${kpiData.financialFreedomNumber.toLocaleString()}</span>
                </div>
                <div className="key-metric">
                  <span className="metric-label">Years to Financial Independence</span>
                  <span className="metric-value">{yearsToFI} years</span>
                </div>
              </div>
              
              <p className="fi-explanation">
                Based on your current savings rate of {kpiData.savingsRate}% and annual expenses of ${kpiData.annualExpenses.toLocaleString()}, 
                you'll need ${kpiData.financialFreedomNumber.toLocaleString()} to be financially independent. 
                At your current savings rate, you'll reach this goal in approximately {yearsToFI} years.
              </p>
            </div>
          </div>
        </div>
      )}
      
      {activeTab === 'trends' && (
        <div className="tab-content">
          <div className="trends-placeholder">
            <h2>Historical Trends</h2>
            <p>
              This tab would normally display charts showing your financial trends over time.
              Charts will be implemented in a future update.
            </p>
            <div className="key-metrics-list">
              <h3>Key metrics tracked:</h3>
              <ul>
                <li>Net Worth: $250,000</li>
                <li>Savings Rate: 30.8%</li>
                <li>FI Progress: 25%</li>
                <li>Financial Health Score: 68/100</li>
              </ul>
            </div>
          </div>
        </div>
      )}
      
      {activeTab === 'health' && (
        <div className="tab-content">
          <div className="health-score">
            <h2>Financial Health Score</h2>
            <div className="big-score">{kpiData.financialHealthScore}/100</div>
            <div className="score-label">Good</div>
            <p className="health-description">
              Your financial health score is calculated based on four key areas: emergency fund, debt management, 
              savings rate, and progress toward financial independence. Improving in any of these areas will 
              increase your overall financial health score.
            </p>
          </div>
          
          <div className="improvement-recommendations">
            <h2>Improvement Recommendations</h2>
            <div className="recommendations-grid">
              <div className="recommendation-card">
                <h3>Emergency Fund</h3>
                <p>
                  Your emergency fund score is {kpiData.emergencyFundScore}/25. To improve this score, 
                  aim to save 3-6 months of expenses in a liquid emergency fund.
                </p>
                <button className="action-button">Set Emergency Fund Goal</button>
              </div>
              <div className="recommendation-card">
                <h3>Debt Management</h3>
                <p>
                  Your debt management score is {kpiData.debtManagementScore}/25. To improve this score, 
                  focus on paying down high-interest debt and maintaining a low debt-to-income ratio.
                </p>
                <button className="action-button">Create Debt Payoff Plan</button>
              </div>
              <div className="recommendation-card">
                <h3>Savings Rate</h3>
                <p>
                  Your savings rate score is {kpiData.savingsRateScore}/25. To improve this score, 
                  aim to increase your savings rate by reducing expenses or increasing income.
                </p>
                <button className="action-button">Optimize Budget</button>
              </div>
              <div className="recommendation-card">
                <h3>FI Progress</h3>
                <p>
                  Your FI progress score is {kpiData.fiProgressScore}/25. To improve this score, 
                  focus on increasing your net worth relative to your financial independence number.
                </p>
                <button className="action-button">View Investment Strategy</button>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default AdvancedKPIs;
EOL

# Create CSS for the Advanced KPIs component
cat > frontend/src/pages/AdvancedKPIs.css << 'EOL'
.advanced-kpis-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.subtitle {
  color: #666;
  margin-bottom: 24px;
}

.tabs {
  display: flex;
  border-bottom: 1px solid #ddd;
  margin-bottom: 24px;
}

.tabs button {
  padding: 12px 24px;
  background: none;
  border: none;
  cursor: pointer;
  font-size: 16px;
  font-weight: 500;
  color: #555;
  position: relative;
}

.tabs button.active {
  color: #1976d2;
}

.tabs button.active::after {
  content: '';
  position: absolute;
  bottom: -1px;
  left: 0;
  right: 0;
  height: 2px;
  background-color: #1976d2;
}

.tab-content {
  margin-top: 24px;
}

.kpi-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(500px, 1fr));
  gap: 24px;
}

.kpi-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.kpi-card h2 {
  margin-top: 0;
  font-size: 18px;
  color: #333;
}

.kpi-value {
  font-size: 36px;
  font-weight: bold;
  margin: 16px 0 8px;
}

.highlight-orange {
  color: #f39c12;
}

.highlight-green {
  color: #27ae60;
}

.kpi-subtitle {
  color: #666;
  margin-bottom: 16px;
}

.progress-bar {
  height: 10px;
  background-color: #e0e0e0;
  border-radius: 5px;
  margin-bottom: 16px;
}

.progress {
  height: 100%;
  background-color: #f39c12;
  border-radius: 5px;
}

.kpi-description {
  color: #666;
  font-size: 14px;
  line-height: 1.5;
}

.kpi-details {
  margin-top: 16px;
}

.detail-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
}

.detail-row.three-columns {
  grid-template-columns: 1fr 1fr 1fr;
}

.detail {
  display: flex;
  flex-direction: column;
}

.detail span:first-child {
  color: #666;
  font-size: 14px;
  margin-bottom: 4px;
}

.detail span:last-child {
  font-weight: 500;
}

.score-breakdown {
  margin-top: 16px;
}

.score-item {
  display: flex;
  align-items: center;
  margin-bottom: 12px;
}

.score-label {
  width: 40%;
  font-size: 14px;
  color: #666;
}

.score-bar {
  width: 40%;
  height: 8px;
  background-color: #e0e0e0;
  border-radius: 4px;
  margin-right: 12px;
}

.score-progress {
  height: 100%;
  background-color: #1976d2;
  border-radius: 4px;
}

.score-value {
  font-size: 14px;
  font-weight: 500;
}

/* Financial Independence Tab */
.fi-calculator {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.fi-details {
  margin-top: 16px;
}

.fi-detail-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  margin-bottom: 24px;
}

.fi-detail {
  display: flex;
  flex-direction: column;
}

.detail-label {
  color: #666;
  font-size: 14px;
  margin-bottom: 4px;
}

.detail-value {
  font-weight: 500;
  font-size: 18px;
}

.fi-key-metrics {
  margin: 24px 0;
}

.key-metric {
  margin-bottom: 16px;
}

.metric-label {
  display: block;
  color: #666;
  font-size: 14px;
  margin-bottom: 4px;
}

.metric-value {
  font-weight: 500;
  font-size: 24px;
}

.fi-explanation {
  color: #333;
  line-height: 1.6;
}

/* Trends Tab */
.trends-placeholder {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.key-metrics-list {
  margin-top: 24px;
}

.key-metrics-list ul {
  padding-left: 20px;
}

.key-metrics-list li {
  margin-bottom: 8px;
}

/* Health Tab */
.health-score {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
  text-align: center;
  margin-bottom: 24px;
}

.big-score {
  font-size: 48px;
  font-weight: bold;
  color: #f39c12;
  margin: 16px 0 8px;
}

.score-label {
  font-size: 18px;
  color: #666;
  margin-bottom: 16px;
}

.health-description {
  color: #666;
  max-width: 600px;
  margin: 0 auto;
  line-height: 1.6;
}

.improvement-recommendations {
  margin-top: 32px;
}

.recommendations-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 24px;
  margin-top: 16px;
}

.recommendation-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.recommendation-card h3 {
  margin-top: 0;
  margin-bottom: 16px;
  font-size: 18px;
}

.recommendation-card p {
  color: #666;
  margin-bottom: 16px;
  line-height: 1.5;
}

.action-button {
  background-color: #1976d2;
  color: white;
  border: none;
  padding: 8px 16px;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
}

.action-button:hover {
  background-color: #1565c0;
}

/* Responsive styles */
@media (max-width: 768px) {
  .kpi-grid {
    grid-template-columns: 1fr;
  }
  
  .fi-detail-row {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .detail-row {
    grid-template-columns: 1fr;
  }
  
  .detail-row.three-columns {
    grid-template-columns: 1fr;
  }
  
  .tabs {
    flex-wrap: wrap;
  }
  
  .tabs button {
    padding: 8px 16px;
    font-size: 14px;
  }
}
EOL

# Create a simple Financial Independence component
cat > frontend/src/pages/FinancialIndependence.js << 'EOL'
import React, { useState } from 'react';
import './FinancialIndependence.css';

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
    
    // Set calculation results
    setCalculationResults({
      yearsToRetirement,
      totalRetirementSavings: Math.round(totalRetirementSavings),
      annualWithdrawal: Math.round(annualWithdrawal),
      monthlyWithdrawal: Math.round(monthlyWithdrawal),
      financialIndependenceNumber: Math.round(financialIndependenceNumber),
      progressPercentage: Math.min(Math.round(progressPercentage), 100),
      yearsToFI: Math.round(yearsToFI * 10) / 10,
      fiDate: fiDate.toLocaleDateString('en-US', { year: 'numeric', month: 'long' })
    });
  };

  return (
    <div className="fi-container">
      <div className="fi-header">
        <h1>Financial Independence Tracker</h1>
        <div className="header-actions">
          <button className="secondary-button">Save Scenario</button>
          <button className="secondary-button">Load Scenario</button>
        </div>
      </div>
      
      <div className="fi-content">
        <div className="fi-calculator">
          <h2>Financial Independence Calculator</h2>
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
            <h2>Your Financial Independence Projection</h2>
            
            <div className="fi-summary">
              <div className="summary-card">
                <h3>Financial Independence Number</h3>
                <div className="summary-value">${calculationResults.financialIndependenceNumber.toLocaleString()}</div>
                <div className="summary-description">The amount you need to retire</div>
              </div>
              
              <div className="summary-card">
                <h3>Progress to FI</h3>
                <div className="progress-container">
                  <div 
                    className="progress-bar" 
                    style={{width: `${calculationResults.progressPercentage}%`}}
                  ></div>
                </div>
                <div className="progress-value">{calculationResults.progressPercentage}%</div>
              </div>
              
              <div className="summary-card">
                <h3>Years to Financial Independence</h3>
                <div className="summary-value">{calculationResults.yearsToFI}</div>
                <div className="summary-description">Estimated FI date: {calculationResults.fiDate}</div>
              </div>
            </div>
            
            <div className="fi-details">
              <div className="detail-section">
                <h3>Retirement Projections</h3>
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
                <h3>Recommendations</h3>
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
        <h2>Financial Independence Resources</h2>
        <div className="resources-grid">
          <div className="resource-card">
            <h3>The 4% Rule</h3>
            <p>Learn about the safe withdrawal rate in retirement and how it affects your FI number.</p>
            <a href="#" className="resource-link">Read More</a>
          </div>
          <div className="resource-card">
            <h3>Tax-Efficient Investing</h3>
            <p>Strategies to minimize taxes and maximize returns on your path to financial independence.</p>
            <a href="#" className="resource-link">Read More</a>
          </div>
          <div className="resource-card">
            <h3>Early Retirement Strategies</h3>
            <p>Discover methods to access retirement funds before traditional retirement age.</p>
            <a href="#" className="resource-link">Read More</a>
          </div>
          <div className="resource-card">
            <h3>Coast FI vs. Lean FI vs. Fat FI</h3>
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

# Create CSS for the Financial Independence component
cat > frontend/src/pages/FinancialIndependence.css << 'EOL'
.fi-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.fi-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.header-actions {
  display: flex;
  gap: 12px;
}

.secondary-button {
  background-color: #f5f5f5;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 8px 16px;
  cursor: pointer;
  font-weight: 500;
}

.secondary-button:hover {
  background-color: #e0e0e0;
}

.fi-content {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
}

.fi-calculator {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.calculator-form {
  margin-top: 16px;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
  margin-bottom: 16px;
}

.form-group {
  display: flex;
  flex-direction: column;
}

.form-group label {
  margin-bottom: 8px;
  font-weight: 500;
}

.form-group input {
  padding: 8px 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
}

.primary-button {
  background-color: #1976d2;
  color: white;
  border: none;
  border-radius: 4px;
  padding: 12px 24px;
  font-size: 16px;
  font-weight: 500;
  cursor: pointer;
  margin-top: 8px;
}

.primary-button:hover {
  background-color: #1565c0;
}

.calculate-button {
  width: 100%;
  margin-top: 16px;
}

.fi-results {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 24px;
}

.fi-summary {
  display: grid;
  grid-template-columns: 1fr;
  gap: 16px;
  margin: 24px 0;
}

.summary-card {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 16px;
}

.summary-card h3 {
  margin-top: 0;
  font-size: 16px;
  color: #555;
}

.summary-value {
  font-size: 24px;
  font-weight: bold;
  margin: 8px 0;
}

.summary-description {
  font-size: 14px;
  color: #666;
}

.progress-container {
  height: 12px;
  background-color: #e0e0e0;
  border-radius: 6px;
  margin: 12px 0;
}

.progress-bar {
  height: 100%;
  background-color: #27ae60;
  border-radius: 6px;
}

.progress-value {
  font-size: 18px;
  font-weight: bold;
  color: #27ae60;
}

.fi-details {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 24px;
  margin-top: 24px;
}

.detail-section {
  background-color: #f9f9f9;
  border-radius: 8px;
  padding: 16px;
}

.detail-section h3 {
  margin-top: 0;
  font-size: 16px;
  color: #555;
  margin-bottom: 16px;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}

.detail-label {
  color: #666;
}

.detail-value {
  font-weight: 500;
}

.recommendations-list {
  margin: 0;
  padding-left: 20px;
}

.recommendations-list li {
  margin-bottom: 8px;
  color: #555;
}

.fi-resources {
  margin-top: 48px;
}

.resources-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 24px;
  margin-top: 16px;
}

.resource-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  padding: 20px;
}

.resource-card h3 {
  margin-top: 0;
  font-size: 18px;
  margin-bottom: 12px;
}

.resource-card p {
  color: #666;
  margin-bottom: 16px;
  line-height: 1.5;
}

.resource-link {
  color: #1976d2;
  text-decoration: none;
  font-weight: 500;
}

.resource-link:hover {
  text-decoration: underline;
}

/* Responsive styles */
@media (max-width: 768px) {
  .fi-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .header-actions {
    margin-top: 12px;
  }
  
  .fi-content {
    grid-template-columns: 1fr;
  }
  
  .form-row {
    grid-template-columns: 1fr;
  }
  
  .fi-details {
    grid-template-columns: 1fr;
  }
}
EOL

# Create a simple App component with React Router v6
echo "Creating App component with React Router v6 compatibility..."

cat > frontend/src/App.js << 'EOL'
import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import MainNavigation from './components/navigation/MainNavigation';
import Dashboard from './pages/Dashboard';
import AdvancedKPIs from './pages/AdvancedKPIs';
import FinancialIndependence from './pages/FinancialIndependence';
import './App.css';

// Placeholder components for other pages
const Accounts = () => <div className="page-container"><h1>Accounts</h1><p>This is the accounts page.</p></div>;
const Transactions = () => <div className="page-container"><h1>Transactions</h1><p>This is the transactions page.</p></div>;
const Budget = () => <div className="page-container"><h1>Budget</h1><p>This is the budget page.</p></div>;
const Goals = () => <div className="page-container"><h1>Goals</h1><p>This is the goals page.</p></div>;
const Investments = () => <div className="page-container"><h1>Investments</h1><p>This is the investments page.</p></div>;
const Reports = () => <div className="page-container"><h1>Reports</h1><p>This is the reports page.</p></div>;
const Settings = () => <div className="page-container"><h1>Settings</h1><p>This is the settings page.</p></div>;
const Connections = () => <div className="page-container"><h1>Connections</h1><p>This is the connections page.</p></div>;
const ImportData = () => <div className="page-container"><h1>Import Data</h1><p>This is the import data page.</p></div>;

function App() {
  return (
    <BrowserRouter>
      <div className="app">
        <MainNavigation />
        <div className="main-content">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/advanced-kpis" element={<AdvancedKPIs />} />
            <Route path="/financial-independence" element={<FinancialIndependence />} />
            <Route path="/accounts" element={<Accounts />} />
            <Route path="/transactions" element={<Transactions />} />
            <Route path="/budget" element={<Budget />} />
            <Route path="/goals" element={<Goals />} />
            <Route path="/investments" element={<Investments />} />
            <Route path="/reports" element={<Reports />} />
            <Route path="/settings" element={<Settings />} />
            <Route path="/connections" element={<Connections />} />
            <Route path="/import" element={<ImportData />} />
            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </div>
      </div>
    </BrowserRouter>
  );
}

export default App;
EOL

# Create CSS for the App component
cat > frontend/src/App.css << 'EOL'
.app {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

.main-content {
  margin-left: 240px;
  margin-top: 64px;
  padding: 20px;
  min-height: calc(100vh - 64px);
  background-color: #f5f5f5;
}

.page-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

/* Responsive styles */
@media (max-width: 768px) {
  .main-content {
    margin-left: 0;
  }
}
EOL

# Create a simple Dashboard component
cat > frontend/src/pages/Dashboard.js << 'EOL'
import React from 'react';
import './Dashboard.css';

const Dashboard = () => {
  return (
    <div className="dashboard-container">
      <h1>Financial Dashboard</h1>
      
      <div className="dashboard-metrics">
        <div className="metric-card">
          <h2>Net Worth</h2>
          <div className="metric-value">$124,500</div>
          <div className="metric-change positive">↑ 3.2% from last month</div>
        </div>
        <div className="metric-card">
          <h2>Monthly Income</h2>
          <div className="metric-value">$8,750</div>
          <div className="metric-change positive">↑ 5.0% from last month</div>
        </div>
        <div className="metric-card">
          <h2>Monthly Expenses</h2>
          <div className="metric-value">$5,320</div>
          <div className="metric-change negative">↑ 2.1% from last month</div>
        </div>
        <div className="metric-card">
          <h2>Savings Rate</h2>
          <div className="metric-value">39.2%</div>
          <div className="metric-change positive">↑ 1.5% from last month</div>
        </div>
      </div>
      
      <div className="dashboard-sections">
        <div className="section-container">
          <div className="section-header">
            <h2>Recent Transactions</h2>
            <a href="/transactions" className="view-all">View All</a>
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
          <h2>Monthly Budget</h2>
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

export default Dashboard;
EOL

# Create CSS for the Dashboard component
cat > frontend/src/pages/Dashboard.css << 'EOL'
.dashboard-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
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
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.metric-card h2 {
  margin-top: 0;
  font-size: 16px;
  color: #666;
  margin-bottom: 10px;
}

.metric-value {
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 5px;
}

.metric-change {
  font-size: 14px;
}

.positive {
  color: #27ae60;
}

.negative {
  color: #e74c3c;
}

.dashboard-sections {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

.section-container {
  background-color: white;
  border-radius: 8px;
  padding: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.section-header h2 {
  margin: 0;
  font-size: 18px;
}

.view-all {
  color: #1976d2;
  text-decoration: none;
  font-size: 14px;
}

.transaction-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.transaction-item {
  display: flex;
  align-items: center;
  padding: 10px 0;
  border-bottom: 1px solid #f0f0f0;
}

.transaction-icon {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  background-color: #f5f5f5;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 15px;
}

.transaction-details {
  flex-grow: 1;
}

.transaction-title {
  font-weight: 500;
  margin-bottom: 4px;
}

.transaction-date {
  font-size: 14px;
  color: #666;
}

.transaction-amount {
  font-weight: 500;
}

.budget-progress {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.budget-category {
  display: flex;
  flex-direction: column;
  gap: 5px;
}

.budget-label {
  font-size: 14px;
  font-weight: 500;
}

.budget-bar {
  height: 8px;
  background-color: #f0f0f0;
  border-radius: 4px;
  overflow: hidden;
}

.budget-progress-bar {
  height: 100%;
  background-color: #1976d2;
  border-radius: 4px;
}

.budget-values {
  display: flex;
  justify-content: space-between;
  font-size: 14px;
  color: #666;
}

/* Responsive styles */
@media (max-width: 768px) {
  .dashboard-sections {
    grid-template-columns: 1fr;
  }
}
EOL

# Update index.js to use the new App component
cat > frontend/src/index.js << 'EOL'
import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';
import App from './App';

ReactDOM.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
  document.getElementById('root')
);
EOL

# Create a simple index.css
cat > frontend/src/index.css << 'EOL'
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  background-color: #f5f5f5;
  color: #333;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}

h1, h2, h3, h4, h5, h6 {
  margin-bottom: 16px;
}

p {
  margin-bottom: 16px;
  line-height: 1.6;
}
EOL

# Rebuild the frontend
echo "Rebuilding the frontend..."
cd frontend && npm run build

# Restart the application
echo "Restarting the application..."
cd ..
docker-compose up -d

echo "Simplified tab structure implementation completed successfully!"
echo "The application now has:"
echo "1. A redesigned navigation structure with main tabs (Dashboard, Advanced KPIs, Financial Independence, Reports, Settings)"
echo "2. Other tabs organized into collapsible lists (Accounts & Transactions, Planning & Investments)"
echo "3. A dedicated Advanced KPIs tab with comprehensive financial metrics"
echo "4. Compatible with React Router v6 and modern React dependencies"
echo "5. Simplified implementation with vanilla React components (no Material-UI dependencies)"
echo ""
echo "Please allow a few minutes for the changes to take effect, then clear your browser cache."
echo "You can access the application at: https://finance.bikramjitchowdhury.com/"
