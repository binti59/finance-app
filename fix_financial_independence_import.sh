#!/bin/bash

# Script to fix the Financial Independence import error
# This script ensures the FinancialIndependence component is properly imported in App.js

# Set the working directory
WORK_DIR="/opt/personal-finance-system/frontend/src"
cd $WORK_DIR || { echo "Failed to change to working directory"; exit 1; }

# Backup original App.js
echo "Creating backup of App.js..."
cp App.js App.js.bak

# Check if the FinancialIndependence component exists
if [ ! -f "pages/planning/FinancialIndependence.js" ]; then
  echo "Creating planning directory and FinancialIndependence component..."
  mkdir -p pages/planning
  
  # Create the Financial Independence component
  cat > pages/planning/FinancialIndependence.js << 'EOL'
import React, { useState } from 'react';
import { Link } from 'react-router-dom';

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
            
            <div className="fi-chart">
              <h4>Projected Savings Growth</h4>
              <div className="chart-placeholder">
                [Savings Growth Chart - Showing projected growth over time]
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
fi

# Fix the App.js file to properly import and use the FinancialIndependence component
echo "Fixing App.js to properly import the FinancialIndependence component..."

# Check if App.js already imports FinancialIndependence
if ! grep -q "import FinancialIndependence from" App.js; then
  # Add import for FinancialIndependence at the top of the file with other imports
  sed -i '1h;1!H;$!d;x; s/import React from .react.;\n/import React from "react";\nimport FinancialIndependence from ".\/pages\/planning\/FinancialIndependence";\n/g' App.js
fi

# Check if App.js already has the FinancialIndependence route
if ! grep -q "<Route path=\"/financial-independence\"" App.js; then
  # Add FinancialIndependence route to the Routes component
  sed -i '/<Routes>/,/<\/Routes>/ s/<Route path="\/settings" element={<Settings \/>} \/>/<Route path="\/settings" element={<Settings \/>} \/>\n              <Route path="\/financial-independence" element={<FinancialIndependence \/>} \/>/g' App.js
fi

# Check if App.js already has the FinancialIndependence navigation link
if ! grep -q "<NavItem to=\"/financial-independence\"" App.js; then
  # Add FinancialIndependence link to the navigation menu
  sed -i '/<NavItem to="\/settings">Settings<\/NavItem>/i \                <NavItem to="\/financial-independence">Financial Independence<\/NavItem>' App.js
fi

# Add CSS styles for Financial Independence if not already present
if ! grep -q "fi-content" App.css; then
  echo "Adding CSS styles for Financial Independence..."
  cat >> App.css << 'EOL'
/* Financial Independence Tracker Styles */
.fi-content {
  display: grid;
  grid-template-columns: 1fr;
  gap: 2rem;
}

@media (min-width: 992px) {
  .fi-content {
    grid-template-columns: 1fr 1fr;
  }
}

.fi-calculator {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.calculator-form {
  margin-top: 1.5rem;
}

.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
  margin-bottom: 1rem;
}

.calculate-button {
  margin-top: 1rem;
  width: 100%;
  padding: 0.75rem;
}

.fi-results {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.fi-summary {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin: 1.5rem 0;
}

.summary-card {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
}

.summary-value {
  font-size: 1.8rem;
  font-weight: bold;
  margin: 0.5rem 0;
}

.summary-description {
  font-size: 0.9rem;
  color: #777;
}

.progress-container {
  height: 1rem;
  background-color: #ecf0f1;
  border-radius: 4px;
  overflow: hidden;
  margin: 0.75rem 0;
}

.progress-bar {
  height: 100%;
  background-color: #3498db;
  border-radius: 4px;
}

.progress-value {
  font-weight: bold;
}

.fi-details {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 1.5rem 0;
}

.detail-section {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.5rem;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #ecf0f1;
}

.detail-label {
  font-weight: 500;
}

.recommendations-list {
  padding-left: 1.5rem;
}

.recommendations-list li {
  margin-bottom: 0.5rem;
}

.fi-chart {
  margin: 1.5rem 0;
}

.fi-resources {
  margin-top: 2rem;
}

.resources-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.resource-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.resource-card h4 {
  margin-bottom: 0.75rem;
}

.resource-card p {
  color: #777;
  margin-bottom: 1rem;
}

.resource-link {
  color: #3498db;
  text-decoration: none;
  font-weight: 500;
}
EOL
fi

# Restart the application
echo "Restarting the application..."
cd /opt/personal-finance-system
docker-compose restart frontend

echo "Financial Independence import error fixed successfully!"
echo "You can now navigate to your application and use the Financial Independence tracker tab."
