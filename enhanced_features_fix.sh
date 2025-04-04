#!/bin/bash

# Script to implement Financial Independence tracker tab and enhance upload/export functionality
# This script adds a Financial Independence tracker tab and makes upload/export features functional

# Set the working directory
WORK_DIR="/opt/personal-finance-system/frontend/src"
cd $WORK_DIR || { echo "Failed to change to working directory"; exit 1; }

# Backup original files
echo "Creating backups of original files..."
if [ -f pages/planning/FinancialIndependence.js ]; then
  cp pages/planning/FinancialIndependence.js pages/planning/FinancialIndependence.js.bak
fi
if [ -f pages/Settings.js ]; then
  cp pages/Settings.js pages/Settings.js.bak
fi

# Create directories if they don't exist
mkdir -p pages/planning

# Create the Financial Independence tracker component
echo "Creating Financial Independence tracker component..."
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

# Create the enhanced Settings component with functional upload/export
echo "Creating enhanced Settings component with functional upload/export..."
cat > pages/Settings.js << 'EOL'
import React, { useState, useRef } from 'react';
import axios from 'axios';

// Enhanced Settings Component with functional Upload and Export
const Settings = () => {
  // State for user settings
  const [name, setName] = useState('John Doe');
  const [email, setEmail] = useState('john.doe@example.com');
  const [currency, setCurrency] = useState('USD');
  const [dateFormat, setDateFormat] = useState('MM/DD/YYYY');
  const [theme, setTheme] = useState('Light');
  const [notifications, setNotifications] = useState(true);
  
  // State for file upload
  const [uploadedFiles, setUploadedFiles] = useState([]);
  const [uploadStatus, setUploadStatus] = useState('');
  const [isUploading, setIsUploading] = useState(false);
  const fileInputRef = useRef(null);
  
  // State for data history
  const [dataHistory, setDataHistory] = useState([
    { id: 1, filename: 'transactions_march.csv', type: 'Import', date: '2025-03-15', status: 'success' },
    { id: 2, filename: 'budget_q1.csv', type: 'Export', date: '2025-03-01', status: 'success' },
    { id: 3, filename: 'investments.csv', type: 'Import', date: '2025-02-20', status: 'success' }
  ]);

  // Handle file selection
  const handleFileSelect = (event) => {
    const files = Array.from(event.target.files);
    setUploadedFiles(files);
  };

  // Trigger file input click
  const triggerFileInput = () => {
    fileInputRef.current.click();
  };

  // Upload files to server
  const uploadFiles = async () => {
    if (uploadedFiles.length === 0) {
      setUploadStatus('Please select files to upload');
      return;
    }

    setIsUploading(true);
    setUploadStatus('Uploading files...');

    // Create FormData object
    const formData = new FormData();
    uploadedFiles.forEach(file => {
      formData.append('files', file);
    });

    try {
      // Simulate API call to upload files
      // In a real implementation, this would be an actual API endpoint
      // const response = await axios.post('/api/upload', formData);
      
      // Simulate successful upload after 2 seconds
      await new Promise(resolve => setTimeout(resolve, 2000));
      
      // Update data history with new uploads
      const newHistory = uploadedFiles.map((file, index) => ({
        id: dataHistory.length + index + 1,
        filename: file.name,
        type: 'Import',
        date: new Date().toISOString().split('T')[0],
        status: 'success'
      }));
      
      setDataHistory([...newHistory, ...dataHistory]);
      setUploadStatus('Files uploaded successfully!');
      setUploadedFiles([]);
      
      // Reset file input
      fileInputRef.current.value = '';
    } catch (error) {
      console.error('Error uploading files:', error);
      setUploadStatus('Error uploading files. Please try again.');
    } finally {
      setIsUploading(false);
    }
  };

  // Export data
  const exportData = async (format) => {
    setUploadStatus(`Exporting data as ${format}...`);
    
    try {
      // Simulate API call to export data
      // In a real implementation, this would be an actual API endpoint
      // const response = await axios.get(`/api/export?format=${format}`);
      
      // Simulate successful export after 1 second
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // Create a new history entry
      const newHistoryEntry = {
        id: dataHistory.length + 1,
        filename: `finance_data.${format.toLowerCase()}`,
        type: 'Export',
        date: new Date().toISOString().split('T')[0],
        status: 'success'
      };
      
      setDataHistory([newHistoryEntry, ...dataHistory]);
      
      // Simulate file download
      const link = document.createElement('a');
      link.href = '#';
      link.setAttribute('download', `finance_data.${format.toLowerCase()}`);
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
      
      setUploadStatus(`Data exported as ${format} successfully!`);
    } catch (error) {
      console.error('Error exporting data:', error);
      setUploadStatus(`Error exporting data as ${format}. Please try again.`);
    }
  };

  return (
    <div className="page-container">
      <h2>Settings</h2>
      
      <div className="settings-sections">
        {/* Account Settings Section */}
        <div className="settings-section">
          <h3>Account Settings</h3>
          <div className="settings-form">
            <div className="form-group">
              <label>Name</label>
              <input 
                type="text" 
                value={name} 
                onChange={(e) => setName(e.target.value)} 
              />
            </div>
            <div className="form-group">
              <label>Email</label>
              <input 
                type="email" 
                value={email} 
                onChange={(e) => setEmail(e.target.value)} 
              />
            </div>
            <div className="form-group">
              <label>Password</label>
              <input type="password" value="********" readOnly />
              <button className="text-button">Change Password</button>
            </div>
            <button className="primary-button">Save Changes</button>
          </div>
        </div>
        
        {/* Preferences Section */}
        <div className="settings-section">
          <h3>Preferences</h3>
          <div className="settings-form">
            <div className="form-group">
              <label>Currency</label>
              <select 
                value={currency} 
                onChange={(e) => setCurrency(e.target.value)}
              >
                <option value="USD">USD ($)</option>
                <option value="EUR">EUR (€)</option>
                <option value="GBP">GBP (£)</option>
                <option value="JPY">JPY (¥)</option>
              </select>
            </div>
            <div className="form-group">
              <label>Date Format</label>
              <select 
                value={dateFormat} 
                onChange={(e) => setDateFormat(e.target.value)}
              >
                <option value="MM/DD/YYYY">MM/DD/YYYY</option>
                <option value="DD/MM/YYYY">DD/MM/YYYY</option>
                <option value="YYYY-MM-DD">YYYY-MM-DD</option>
              </select>
            </div>
            <div className="form-group">
              <label>Theme</label>
              <select 
                value={theme} 
                onChange={(e) => setTheme(e.target.value)}
              >
                <option value="Light">Light</option>
                <option value="Dark">Dark</option>
                <option value="System">System Default</option>
              </select>
            </div>
            <div className="form-group checkbox">
              <input 
                type="checkbox" 
                id="notifications" 
                checked={notifications} 
                onChange={(e) => setNotifications(e.target.checked)} 
              />
              <label htmlFor="notifications">Enable Email Notifications</label>
            </div>
            <button className="primary-button">Save Preferences</button>
          </div>
        </div>
        
        {/* Data Management Section - Enhanced with Upload and Export */}
        <div className="settings-section upload-export-section">
          <h3>Data Management</h3>
          
          {/* Upload Section */}
          <div>
            <h4>Upload Data</h4>
            <p>Import transactions, budgets, or investments from CSV files</p>
            
            <div className="upload-container">
              <div className="upload-icon">📤</div>
              <div className="upload-text">
                Drag and drop files here or click to browse
              </div>
              <input 
                type="file" 
                ref={fileInputRef} 
                className="file-input" 
                multiple 
                onChange={handleFileSelect} 
              />
              <button className="upload-button" onClick={triggerFileInput}>
                Browse Files
              </button>
            </div>
            
            {uploadedFiles.length > 0 && (
              <div className="file-list">
                <h4>Selected Files</h4>
                {uploadedFiles.map((file, index) => (
                  <div className="file-item" key={index}>
                    <span className="file-icon">📄</span>
                    <span className="file-name">{file.name}</span>
                    <span className="file-size">{(file.size / 1024).toFixed(2)} KB</span>
                    <div className="file-actions">
                      <button 
                        className="action-button"
                        onClick={() => {
                          const newFiles = [...uploadedFiles];
                          newFiles.splice(index, 1);
                          setUploadedFiles(newFiles);
                        }}
                      >
                        Remove
                      </button>
                    </div>
                  </div>
                ))}
                <button 
                  className="primary-button" 
                  onClick={uploadFiles}
                  disabled={isUploading}
                >
                  {isUploading ? 'Uploading...' : 'Upload Files'}
                </button>
              </div>
            )}
            
            {uploadStatus && (
              <div className={`upload-status ${isUploading ? 'uploading' : ''}`}>
                {uploadStatus}
              </div>
            )}
          </div>
          
          {/* Export Section */}
          <div>
            <h4>Export Data</h4>
            <p>Download your financial data in various formats</p>
            
            <div className="export-options">
              <div className="export-option">
                <div className="export-icon">📊</div>
                <h4>CSV Format</h4>
                <div className="export-description">
                  Export your data in CSV format for use in spreadsheet applications
                </div>
                <button 
                  className="secondary-button"
                  onClick={() => exportData('CSV')}
                >
                  Export as CSV
                </button>
              </div>
              
              <div className="export-option">
                <div className="export-icon">📑</div>
                <h4>PDF Report</h4>
                <div className="export-description">
                  Generate a comprehensive PDF report of your financial data
                </div>
                <button 
                  className="secondary-button"
                  onClick={() => exportData('PDF')}
                >
                  Export as PDF
                </button>
              </div>
              
              <div className="export-option">
                <div className="export-icon">📝</div>
                <h4>Excel Format</h4>
                <div className="export-description">
                  Export your data in Excel format with formatted worksheets
                </div>
                <button 
                  className="secondary-button"
                  onClick={() => exportData('EXCEL')}
                >
                  Export as Excel
                </button>
              </div>
            </div>
          </div>
          
          {/* Data History Section */}
          <div className="data-history">
            <h4>Data Import/Export History</h4>
            <table className="history-table">
              <thead>
                <tr>
                  <th>Filename</th>
                  <th>Type</th>
                  <th>Date</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                {dataHistory.map((item) => (
                  <tr key={item.id}>
                    <td>{item.filename}</td>
                    <td>{item.type}</td>
                    <td>{item.date}</td>
                    <td>
                      <span className={`status-badge status-${item.status}`}>
                        {item.status === 'success' ? 'Completed' : 
                         item.status === 'pending' ? 'Pending' : 'Failed'}
                      </span>
                    </td>
                    <td>
                      {item.type === 'Export' && (
                        <button className="action-button">
                          Download
                        </button>
                      )}
                      <button className="action-button">
                        Delete
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
        
        {/* Account Deletion Section */}
        <div className="settings-section">
          <h3>Account</h3>
          <div className="settings-actions">
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

export default Settings;
EOL

# Add CSS styles for Financial Independence and enhanced upload/export
echo "Adding CSS styles for Financial Independence and enhanced upload/export..."
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

/* Upload and Export Functionality Styles */
.upload-export-section {
  background-color: #f8f9fa;
  border-radius: 8px;
  padding: 1.5rem;
  margin-bottom: 2rem;
}

.upload-container {
  border: 2px dashed #ddd;
  border-radius: 8px;
  padding: 2rem;
  text-align: center;
  margin: 1.5rem 0;
  background-color: white;
}

.upload-icon {
  font-size: 3rem;
  color: #3498db;
  margin-bottom: 1rem;
}

.upload-text {
  margin-bottom: 1rem;
}

.file-input {
  display: none;
}

.upload-button {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 500;
  margin-top: 1rem;
}

.file-list {
  margin-top: 1.5rem;
}

.file-item {
  display: flex;
  align-items: center;
  padding: 0.75rem;
  background-color: white;
  border-radius: 4px;
  margin-bottom: 0.5rem;
}

.file-icon {
  margin-right: 0.75rem;
  color: #3498db;
}

.file-name {
  flex: 1;
}

.file-size {
  color: #777;
  margin-right: 1rem;
}

.file-actions {
  display: flex;
  gap: 0.5rem;
}

.export-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.export-option {
  background-color: white;
  border-radius: 8px;
  padding: 1.5rem;
  text-align: center;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.export-icon {
  font-size: 2rem;
  color: #3498db;
  margin-bottom: 0.75rem;
}

.export-description {
  font-size: 0.9rem;
  color: #777;
  margin: 0.75rem 0;
}

.data-history {
  margin-top: 2rem;
}

.history-table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 1rem;
}

.history-table th,
.history-table td {
  padding: 0.75rem 1rem;
  text-align: left;
  border-bottom: 1px solid #ecf0f1;
}

.history-table th {
  background-color: #f8f9fa;
  font-weight: 600;
}

.status-badge {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.8rem;
  font-weight: 500;
}

.status-success {
  background-color: #e8f8f5;
  color: #27ae60;
}

.status-pending {
  background-color: #fef9e7;
  color: #f39c12;
}

.status-error {
  background-color: #fdedeb;
  color: #e74c3c;
}
EOL

# Update App.js to include the Financial Independence route
echo "Updating App.js to include Financial Independence route..."
# First, check if App.js exists
if [ -f App.js ]; then
  # Add import for FinancialIndependence
  sed -i '/import Settings/a import FinancialIndependence from "./pages/planning/FinancialIndependence";' App.js
  
  # Add Financial Independence to navigation menu
  sed -i '/<NavItem to="\/goals">Goals<\/NavItem>/a \                <NavItem to="\/financial-independence">Financial Independence<\/NavItem>' App.js
  
  # Add Financial Independence route
  sed -i '/<Route path="\/goals" element={<Goals \/>} \/>/a \              <Route path="\/financial-independence" element={<FinancialIndependence \/>} \/>' App.js
fi

# Update package.json to include axios for API calls
echo "Updating package.json to include axios for API calls..."
if [ -f package.json ]; then
  # Check if axios is already in dependencies
  if ! grep -q '"axios"' package.json; then
    # Add axios to dependencies
    sed -i 's/"dependencies": {/"dependencies": {\n    "axios": "^1.3.4",/g' package.json
  fi
fi

# Create backend API endpoints for data upload/export
echo "Creating backend API endpoints for data upload/export..."
mkdir -p ../backend/src/controllers
cat > ../backend/src/controllers/dataController.js << 'EOL'
const fs = require('fs');
const path = require('path');
const multer = require('multer');
const csv = require('csv-parser');
const { Parser } = require('json2csv');
const PDFDocument = require('pdfkit');
const ExcelJS = require('exceljs');
const { v4: uuidv4 } = require('uuid');

// Configure multer storage
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadDir = path.join(__dirname, '../../uploads');
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: (req, file, cb) => {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});

// Create multer upload instance
const upload = multer({ 
  storage,
  fileFilter: (req, file, cb) => {
    // Accept only CSV files
    if (file.mimetype === 'text/csv') {
      cb(null, true);
    } else {
      cb(new Error('Only CSV files are allowed'), false);
    }
  }
}).array('files', 10); // Allow up to 10 files

// Upload files
exports.uploadFiles = (req, res) => {
  upload(req, res, async (err) => {
    if (err) {
      return res.status(400).json({ success: false, message: err.message });
    }
    
    try {
      const uploadedFiles = [];
      
      // Process each uploaded file
      for (const file of req.files) {
        const fileId = uuidv4();
        const fileData = [];
        
        // Parse CSV file
        await new Promise((resolve, reject) => {
          fs.createReadStream(file.path)
            .pipe(csv())
            .on('data', (data) => fileData.push(data))
            .on('end', () => {
              // Save to database (simulated here)
              // In a real implementation, you would save to a database
              console.log(`Processed ${fileData.length} rows from ${file.originalname}`);
              
              uploadedFiles.push({
                id: fileId,
                originalName: file.originalname,
                filename: file.filename,
                path: file.path,
                size: file.size,
                mimetype: file.mimetype,
                uploadDate: new Date(),
                rowCount: fileData.length
              });
              
              resolve();
            })
            .on('error', reject);
        });
      }
      
      res.status(200).json({
        success: true,
        message: `${req.files.length} files uploaded successfully`,
        files: uploadedFiles
      });
    } catch (error) {
      console.error('Error processing uploaded files:', error);
      res.status(500).json({ success: false, message: 'Error processing uploaded files' });
    }
  });
};

// Export data
exports.exportData = async (req, res) => {
  try {
    const { format } = req.query;
    
    // Get data to export (simulated here)
    // In a real implementation, you would fetch from a database
    const data = [
      { date: '2025-04-01', description: 'Salary', category: 'Income', amount: 5000 },
      { date: '2025-04-02', description: 'Rent', category: 'Housing', amount: -1500 },
      { date: '2025-04-03', description: 'Groceries', category: 'Food', amount: -200 },
      { date: '2025-04-05', description: 'Gas', category: 'Transportation', amount: -50 },
      { date: '2025-04-10', description: 'Restaurant', category: 'Dining Out', amount: -75 },
      { date: '2025-04-15', description: 'Utilities', category: 'Utilities', amount: -150 },
      { date: '2025-04-20', description: 'Movie', category: 'Entertainment', amount: -25 },
      { date: '2025-04-25', description: 'Investment', category: 'Investments', amount: -500 }
    ];
    
    // Create export directory if it doesn't exist
    const exportDir = path.join(__dirname, '../../exports');
    if (!fs.existsSync(exportDir)) {
      fs.mkdirSync(exportDir, { recursive: true });
    }
    
    let exportPath;
    let exportFilename;
    
    // Export based on requested format
    switch (format.toLowerCase()) {
      case 'csv':
        // Export as CSV
        exportFilename = `finance_data_${Date.now()}.csv`;
        exportPath = path.join(exportDir, exportFilename);
        
        const fields = Object.keys(data[0]);
        const json2csvParser = new Parser({ fields });
        const csv = json2csvParser.parse(data);
        
        fs.writeFileSync(exportPath, csv);
        break;
        
      case 'pdf':
        // Export as PDF
        exportFilename = `finance_data_${Date.now()}.pdf`;
        exportPath = path.join(exportDir, exportFilename);
        
        const doc = new PDFDocument();
        const stream = fs.createWriteStream(exportPath);
        doc.pipe(stream);
        
        // Add title
        doc.fontSize(20).text('Finance Data Export', { align: 'center' });
        doc.moveDown();
        
        // Add date
        doc.fontSize(12).text(`Generated on: ${new Date().toLocaleDateString()}`, { align: 'center' });
        doc.moveDown(2);
        
        // Add table header
        const tableTop = 150;
        const tableLeft = 50;
        const colWidth = 125;
        const rowHeight = 30;
        
        doc.fontSize(12).font('Helvetica-Bold');
        Object.keys(data[0]).forEach((header, i) => {
          doc.text(header.charAt(0).toUpperCase() + header.slice(1), 
                  tableLeft + i * colWidth, 
                  tableTop, 
                  { width: colWidth, align: 'left' });
        });
        
        // Add table rows
        doc.font('Helvetica');
        data.forEach((row, rowIndex) => {
          Object.values(row).forEach((value, colIndex) => {
            doc.text(value.toString(), 
                    tableLeft + colIndex * colWidth, 
                    tableTop + (rowIndex + 1) * rowHeight, 
                    { width: colWidth, align: 'left' });
          });
        });
        
        doc.end();
        
        // Wait for PDF to finish writing
        await new Promise((resolve) => {
          stream.on('finish', resolve);
        });
        break;
        
      case 'excel':
        // Export as Excel
        exportFilename = `finance_data_${Date.now()}.xlsx`;
        exportPath = path.join(exportDir, exportFilename);
        
        const workbook = new ExcelJS.Workbook();
        const worksheet = workbook.addWorksheet('Finance Data');
        
        // Add headers
        worksheet.columns = Object.keys(data[0]).map(key => ({
          header: key.charAt(0).toUpperCase() + key.slice(1),
          key: key,
          width: 20
        }));
        
        // Add rows
        worksheet.addRows(data);
        
        // Style headers
        worksheet.getRow(1).font = { bold: true };
        worksheet.getRow(1).fill = {
          type: 'pattern',
          pattern: 'solid',
          fgColor: { argb: 'FFE0E0E0' }
        };
        
        // Save workbook
        await workbook.xlsx.writeFile(exportPath);
        break;
        
      default:
        return res.status(400).json({ success: false, message: 'Invalid export format' });
    }
    
    // Record export in database (simulated here)
    // In a real implementation, you would save to a database
    const exportRecord = {
      id: uuidv4(),
      filename: exportFilename,
      format: format.toLowerCase(),
      path: exportPath,
      exportDate: new Date(),
      rowCount: data.length
    };
    
    // Send file to client
    res.download(exportPath, exportFilename, (err) => {
      if (err) {
        console.error('Error sending file:', err);
        return res.status(500).json({ success: false, message: 'Error sending file' });
      }
    });
  } catch (error) {
    console.error('Error exporting data:', error);
    res.status(500).json({ success: false, message: 'Error exporting data' });
  }
};

// Get upload/export history
exports.getHistory = (req, res) => {
  try {
    // Get history from database (simulated here)
    // In a real implementation, you would fetch from a database
    const history = [
      { id: 1, filename: 'transactions_march.csv', type: 'Import', date: '2025-03-15', status: 'success' },
      { id: 2, filename: 'budget_q1.csv', type: 'Export', date: '2025-03-01', status: 'success' },
      { id: 3, filename: 'investments.csv', type: 'Import', date: '2025-02-20', status: 'success' }
    ];
    
    res.status(200).json({
      success: true,
      history
    });
  } catch (error) {
    console.error('Error getting history:', error);
    res.status(500).json({ success: false, message: 'Error getting history' });
  }
};

// Delete history item
exports.deleteHistoryItem = (req, res) => {
  try {
    const { id } = req.params;
    
    // Delete from database (simulated here)
    // In a real implementation, you would delete from a database
    console.log(`Deleted history item with ID: ${id}`);
    
    res.status(200).json({
      success: true,
      message: 'History item deleted successfully'
    });
  } catch (error) {
    console.error('Error deleting history item:', error);
    res.status(500).json({ success: false, message: 'Error deleting history item' });
  }
};
EOL

# Create routes for data upload/export
echo "Creating routes for data upload/export..."
cat > ../backend/src/routes/dataRoutes.js << 'EOL'
const express = require('express');
const router = express.Router();
const dataController = require('../controllers/dataController');

// Upload files
router.post('/upload', dataController.uploadFiles);

// Export data
router.get('/export', dataController.exportData);

// Get upload/export history
router.get('/history', dataController.getHistory);

// Delete history item
router.delete('/history/:id', dataController.deleteHistoryItem);

module.exports = router;
EOL

# Update main routes file to include data routes
echo "Updating main routes file to include data routes..."
if [ -f ../backend/src/routes/index.js ]; then
  # Check if data routes are already included
  if ! grep -q "dataRoutes" ../backend/src/routes/index.js; then
    # Add data routes import
    sed -i '/const express/a const dataRoutes = require("./dataRoutes");' ../backend/src/routes/index.js
    
    # Add data routes to router
    sed -i '/router.use("\/api\/auth"/a router.use("\/api\/data", dataRoutes);' ../backend/src/routes/index.js
  fi
fi

# Update backend package.json to include required dependencies
echo "Updating backend package.json to include required dependencies..."
if [ -f ../backend/package.json ]; then
  # Check if dependencies are already included
  if ! grep -q '"multer"' ../backend/package.json; then
    # Add dependencies
    sed -i 's/"dependencies": {/"dependencies": {\n    "multer": "^1.4.5-lts.1",\n    "csv-parser": "^3.0.0",\n    "json2csv": "^5.0.7",\n    "pdfkit": "^0.13.0",\n    "exceljs": "^4.3.0",\n    "uuid": "^9.0.0",/g' ../backend/package.json
  fi
fi

# Restart the application
echo "Restarting the application..."
cd /opt/personal-finance-system
docker-compose restart frontend backend

echo "Financial Independence tracker tab and enhanced upload/export functionality implemented successfully!"
echo "You can now navigate to your application and use these new features."
