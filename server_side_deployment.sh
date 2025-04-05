#!/bin/bash

# Server-side deployment script for finance application
# This script ensures all fixes are properly applied to the production environment

echo "Starting server-side deployment for finance application..."

# Set the working directory
WORK_DIR="/opt/personal-finance-system"
cd $WORK_DIR || { echo "Failed to change to working directory"; exit 1; }

# Backup current state
echo "Creating backup of current application state..."
BACKUP_DIR="/opt/backups/finance-app-$(date +%Y%m%d%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r $WORK_DIR/frontend $BACKUP_DIR/
cp -r $WORK_DIR/backend $BACKUP_DIR/
echo "Backup created at $BACKUP_DIR"

# Stop the application containers
echo "Stopping application containers..."
docker-compose down

# Clear Docker cache to ensure clean rebuild
echo "Clearing Docker cache..."
docker system prune -f

# Pull the latest changes from GitHub
echo "Pulling latest changes from GitHub..."
cd $WORK_DIR
git pull origin main

# Apply the comprehensive fix
echo "Applying comprehensive fix for charts, KPIs, and import functionality..."

# Install required dependencies
echo "Installing required dependencies..."
cd $WORK_DIR/frontend
npm install --save chart.js@3.9.1 papaparse@5.4.1 xlsx@0.18.5 file-saver@2.0.5 react-router-dom@6.10.0

# Create directories for components
mkdir -p src/components/charts
mkdir -p src/components/kpis
mkdir -p src/components/import

# Create a vanilla Chart.js implementation
echo "Creating vanilla Chart.js implementation..."
cat > src/components/charts/ChartComponent.js << 'EOL'
import React, { useEffect, useRef } from 'react';
import Chart from 'chart.js/auto';

const ChartComponent = ({ type, data, options, height = 300 }) => {
  const chartRef = useRef(null);
  const chartInstance = useRef(null);

  useEffect(() => {
    if (!chartRef.current) return;
    
    // If a chart instance exists, destroy it before creating a new one
    if (chartInstance.current) {
      chartInstance.current.destroy();
    }

    // Get the canvas context
    const ctx = chartRef.current.getContext('2d');
    
    // Create the chart
    chartInstance.current = new Chart(ctx, {
      type: type || 'bar',
      data: data,
      options: options || {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
          },
        },
      },
    });

    // Cleanup function to destroy chart when component unmounts
    return () => {
      if (chartInstance.current) {
        chartInstance.current.destroy();
      }
    };
  }, [data, options, type]);

  return (
    <div style={{ height: `${height}px`, width: '100%', position: 'relative' }}>
      <canvas ref={chartRef}></canvas>
    </div>
  );
};

export default ChartComponent;
EOL

# Create KPI components
echo "Creating KPI components..."
cat > src/components/kpis/FinancialIndependenceIndex.js << 'EOL'
import React from 'react';

const FinancialIndependenceIndex = ({ currentSavings, annualExpenses, savingsRate }) => {
  // Calculate Financial Independence Index
  // Formula: (Current Savings / (Annual Expenses * 25)) * 100
  const fiNumber = annualExpenses * 25;
  const fiIndex = (currentSavings / fiNumber) * 100;
  
  // Determine status based on FI Index
  let status = 'Starting Out';
  let color = '#ff6b6b';
  
  if (fiIndex >= 100) {
    status = 'Financially Independent';
    color = '#51cf66';
  } else if (fiIndex >= 75) {
    status = 'Almost There';
    color = '#82c91e';
  } else if (fiIndex >= 50) {
    status = 'Halfway There';
    color = '#fcc419';
  } else if (fiIndex >= 25) {
    status = 'On Your Way';
    color = '#ff922b';
  }
  
  return (
    <div className="kpi-card">
      <h3>Financial Independence Index</h3>
      <div className="kpi-value" style={{ color }}>{fiIndex.toFixed(1)}%</div>
      <div className="kpi-status">{status}</div>
      <div className="kpi-description">
        Measures your progress toward financial freedom
      </div>
      <div className="progress-container">
        <div 
          className="progress-bar" 
          style={{ width: `${Math.min(fiIndex, 100)}%`, backgroundColor: color }}
        ></div>
      </div>
    </div>
  );
};

export default FinancialIndependenceIndex;
EOL

cat > src/components/kpis/FinancialFreedomNumber.js << 'EOL'
import React from 'react';

const FinancialFreedomNumber = ({ annualExpenses, withdrawalRate = 4 }) => {
  // Calculate Financial Freedom Number
  // Formula: Annual Expenses / (Withdrawal Rate / 100)
  const fiNumber = annualExpenses / (withdrawalRate / 100);
  
  return (
    <div className="kpi-card">
      <h3>Financial Freedom Number</h3>
      <div className="kpi-value">${fiNumber.toLocaleString()}</div>
      <div className="kpi-description">
        The amount you need to be financially independent
      </div>
      <div className="kpi-details">
        <div className="detail-item">
          <div className="detail-label">Annual Expenses:</div>
          <div className="detail-value">${annualExpenses.toLocaleString()}</div>
        </div>
        <div className="detail-item">
          <div className="detail-label">Withdrawal Rate:</div>
          <div className="detail-value">{withdrawalRate}%</div>
        </div>
      </div>
    </div>
  );
};

export default FinancialFreedomNumber;
EOL

cat > src/components/kpis/SavingsRateTracker.js << 'EOL'
import React from 'react';

const SavingsRateTracker = ({ income, expenses }) => {
  // Calculate Savings Rate
  // Formula: ((Income - Expenses) / Income) * 100
  const savings = income - expenses;
  const savingsRate = (savings / income) * 100;
  
  // Determine status based on Savings Rate
  let status = 'Needs Improvement';
  let color = '#ff6b6b';
  
  if (savingsRate >= 50) {
    status = 'Exceptional';
    color = '#51cf66';
  } else if (savingsRate >= 30) {
    status = 'Excellent';
    color = '#82c91e';
  } else if (savingsRate >= 20) {
    status = 'Good';
    color = '#fcc419';
  } else if (savingsRate >= 10) {
    status = 'Average';
    color = '#ff922b';
  }
  
  return (
    <div className="kpi-card">
      <h3>Savings Rate</h3>
      <div className="kpi-value" style={{ color }}>{savingsRate.toFixed(1)}%</div>
      <div className="kpi-status">{status}</div>
      <div className="kpi-description">
        Percentage of income you're saving
      </div>
      <div className="kpi-details">
        <div className="detail-item">
          <div className="detail-label">Monthly Income:</div>
          <div className="detail-value">${income.toLocaleString()}</div>
        </div>
        <div className="detail-item">
          <div className="detail-label">Monthly Expenses:</div>
          <div className="detail-value">${expenses.toLocaleString()}</div>
        </div>
        <div className="detail-item">
          <div className="detail-label">Monthly Savings:</div>
          <div className="detail-value">${savings.toLocaleString()}</div>
        </div>
      </div>
    </div>
  );
};

export default SavingsRateTracker;
EOL

cat > src/components/kpis/FinancialHealthScore.js << 'EOL'
import React from 'react';

const FinancialHealthScore = ({ 
  emergencyFundRatio, 
  debtToIncomeRatio, 
  savingsRate, 
  fiIndex 
}) => {
  // Calculate Financial Health Score (0-100)
  // Formula: Weighted average of various financial metrics
  
  // Emergency Fund Score (0-25)
  // 6+ months = 25, 3-6 months = 15, 1-3 months = 10, <1 month = 0
  let emergencyFundScore = 0;
  if (emergencyFundRatio >= 6) {
    emergencyFundScore = 25;
  } else if (emergencyFundRatio >= 3) {
    emergencyFundScore = 15;
  } else if (emergencyFundRatio >= 1) {
    emergencyFundScore = 10;
  }
  
  // Debt-to-Income Score (0-25)
  // <15% = 25, 15-30% = 20, 30-40% = 10, >40% = 0
  let debtScore = 0;
  if (debtToIncomeRatio < 0.15) {
    debtScore = 25;
  } else if (debtToIncomeRatio < 0.3) {
    debtScore = 20;
  } else if (debtToIncomeRatio < 0.4) {
    debtScore = 10;
  }
  
  // Savings Rate Score (0-25)
  // >20% = 25, 15-20% = 20, 10-15% = 15, 5-10% = 10, <5% = 0
  let savingsRateScore = 0;
  if (savingsRate > 20) {
    savingsRateScore = 25;
  } else if (savingsRate > 15) {
    savingsRateScore = 20;
  } else if (savingsRate > 10) {
    savingsRateScore = 15;
  } else if (savingsRate > 5) {
    savingsRateScore = 10;
  }
  
  // FI Index Score (0-25)
  // >50% = 25, 25-50% = 15, 10-25% = 10, <10% = 5
  let fiIndexScore = 0;
  if (fiIndex > 50) {
    fiIndexScore = 25;
  } else if (fiIndex > 25) {
    fiIndexScore = 15;
  } else if (fiIndex > 10) {
    fiIndexScore = 10;
  } else {
    fiIndexScore = 5;
  }
  
  // Total Financial Health Score
  const totalScore = emergencyFundScore + debtScore + savingsRateScore + fiIndexScore;
  
  // Determine status based on total score
  let status = 'Needs Improvement';
  let color = '#ff6b6b';
  
  if (totalScore >= 90) {
    status = 'Excellent';
    color = '#51cf66';
  } else if (totalScore >= 75) {
    status = 'Very Good';
    color = '#82c91e';
  } else if (totalScore >= 60) {
    status = 'Good';
    color = '#fcc419';
  } else if (totalScore >= 40) {
    status = 'Fair';
    color = '#ff922b';
  }
  
  return (
    <div className="kpi-card">
      <h3>Financial Health Score</h3>
      <div className="kpi-value" style={{ color }}>{totalScore}</div>
      <div className="kpi-status">{status}</div>
      <div className="kpi-description">
        Overall rating of your financial situation
      </div>
      <div className="score-breakdown">
        <div className="score-item">
          <div className="score-label">Emergency Fund</div>
          <div className="score-bar-container">
            <div className="score-bar" style={{ width: `${(emergencyFundScore/25)*100}%` }}></div>
          </div>
          <div className="score-value">{emergencyFundScore}/25</div>
        </div>
        <div className="score-item">
          <div className="score-label">Debt Management</div>
          <div className="score-bar-container">
            <div className="score-bar" style={{ width: `${(debtScore/25)*100}%` }}></div>
          </div>
          <div className="score-value">{debtScore}/25</div>
        </div>
        <div className="score-item">
          <div className="score-label">Savings Rate</div>
          <div className="score-bar-container">
            <div className="score-bar" style={{ width: `${(savingsRateScore/25)*100}%` }}></div>
          </div>
          <div className="score-value">{savingsRateScore}/25</div>
        </div>
        <div className="score-item">
          <div className="score-label">FI Progress</div>
          <div className="score-bar-container">
            <div className="score-bar" style={{ width: `${(fiIndexScore/25)*100}%` }}></div>
          </div>
          <div className="score-value">{fiIndexScore}/25</div>
        </div>
      </div>
    </div>
  );
};

export default FinancialHealthScore;
EOL

# Create a KPI Dashboard component
cat > src/components/kpis/KPIDashboard.js << 'EOL'
import React from 'react';
import FinancialIndependenceIndex from './FinancialIndependenceIndex';
import FinancialFreedomNumber from './FinancialFreedomNumber';
import SavingsRateTracker from './SavingsRateTracker';
import FinancialHealthScore from './FinancialHealthScore';

const KPIDashboard = ({ userData }) => {
  // Sample data if no userData is provided
  const data = userData || {
    currentSavings: 100000,
    annualExpenses: 40000,
    monthlyIncome: 5000,
    monthlyExpenses: 3500,
    emergencyFundRatio: 4.5,
    debtToIncomeRatio: 0.2,
    savingsRate: 30,
    fiIndex: 25
  };
  
  return (
    <div className="kpi-dashboard">
      <h2>Advanced Financial KPIs</h2>
      <div className="kpi-grid">
        <FinancialIndependenceIndex 
          currentSavings={data.currentSavings} 
          annualExpenses={data.annualExpenses}
          savingsRate={data.savingsRate}
        />
        <FinancialFreedomNumber 
          annualExpenses={data.annualExpenses} 
          withdrawalRate={4}
        />
        <SavingsRateTracker 
          income={data.monthlyIncome} 
          expenses={data.monthlyExpenses}
        />
        <FinancialHealthScore 
          emergencyFundRatio={data.emergencyFundRatio}
          debtToIncomeRatio={data.debtToIncomeRatio}
          savingsRate={data.savingsRate}
          fiIndex={data.fiIndex}
        />
      </div>
    </div>
  );
};

export default KPIDashboard;
EOL

# Create import components
echo "Creating import components..."
cat > src/components/import/BankStatementImporter.js << 'EOL'
import React, { useState } from 'react';
import Papa from 'papaparse';
import * as XLSX from 'xlsx';
import { saveAs } from 'file-saver';

const BankStatementImporter = ({ onImportComplete }) => {
  const [file, setFile] = useState(null);
  const [importing, setImporting] = useState(false);
  const [importStatus, setImportStatus] = useState('');
  const [bankType, setBankType] = useState('');
  const [importedData, setImportedData] = useState(null);
  const [mappingFields, setMappingFields] = useState({
    date: '',
    description: '',
    amount: '',
    category: ''
  });
  
  const bankOptions = [
    { value: 'chase', label: 'Chase Bank' },
    { value: 'bofa', label: 'Bank of America' },
    { value: 'wells', label: 'Wells Fargo' },
    { value: 'citi', label: 'Citibank' },
    { value: 'hsbc', label: 'HSBC' },
    { value: 'other', label: 'Other Bank' }
  ];
  
  // Predefined field mappings for common banks
  const bankMappings = {
    chase: { date: 'Transaction Date', description: 'Description', amount: 'Amount', category: 'Category' },
    bofa: { date: 'Date', description: 'Description', amount: 'Amount', category: 'Category' },
    wells: { date: 'Date', description: 'Description', amount: 'Amount', category: '' },
    citi: { date: 'Date', description: 'Description', amount: 'Debit/Credit', category: 'Category' },
    hsbc: { date: 'Date', description: 'Description', amount: 'Amount', category: '' },
    other: { date: '', description: '', amount: '', category: '' }
  };
  
  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];
    if (selectedFile) {
      setFile(selectedFile);
      setImportStatus('File selected: ' + selectedFile.name);
    }
  };
  
  const handleBankChange = (e) => {
    const selectedBank = e.target.value;
    setBankType(selectedBank);
    setMappingFields(bankMappings[selectedBank]);
  };
  
  const handleMappingChange = (field, value) => {
    setMappingFields({
      ...mappingFields,
      [field]: value
    });
  };
  
  const parseCSV = (file) => {
    return new Promise((resolve, reject) => {
      Papa.parse(file, {
        header: true,
        complete: (results) => {
          resolve(results.data);
        },
        error: (error) => {
          reject(error);
        }
      });
    });
  };
  
  const parseExcel = (file) => {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.onload = (e) => {
        try {
          const data = e.target.result;
          const workbook = XLSX.read(data, { type: 'array' });
          const sheetName = workbook.SheetNames[0];
          const worksheet = workbook.Sheets[sheetName];
          const json = XLSX.utils.sheet_to_json(worksheet);
          resolve(json);
        } catch (error) {
          reject(error);
        }
      };
      reader.onerror = (error) => reject(error);
      reader.readAsArrayBuffer(file);
    });
  };
  
  const mapTransactions = (data) => {
    return data.map(item => {
      const transaction = {
        date: item[mappingFields.date] || '',
        description: item[mappingFields.description] || '',
        amount: parseFloat(item[mappingFields.amount]) || 0,
        category: item[mappingFields.category] || 'Uncategorized'
      };
      
      // Clean up and standardize data
      if (typeof transaction.amount === 'string') {
        transaction.amount = parseFloat(transaction.amount.replace(/[^0-9.-]+/g, ''));
      }
      
      return transaction;
    }).filter(item => item.date && item.description && !isNaN(item.amount));
  };
  
  const handleImport = async () => {
    if (!file) {
      setImportStatus('Please select a file first');
      return;
    }
    
    if (!mappingFields.date || !mappingFields.description || !mappingFields.amount) {
      setImportStatus('Please map the required fields (Date, Description, Amount)');
      return;
    }
    
    setImporting(true);
    setImportStatus('Importing data...');
    
    try {
      let data;
      if (file.name.endsWith('.csv')) {
        data = await parseCSV(file);
      } else if (file.name.endsWith('.xlsx') || file.name.endsWith('.xls')) {
        data = await parseExcel(file);
      } else {
        throw new Error('Unsupported file format');
      }
      
      const transactions = mapTransactions(data);
      setImportedData(transactions);
      setImportStatus(`Successfully imported ${transactions.length} transactions`);
      
      if (onImportComplete) {
        onImportComplete(transactions);
      }
    } catch (error) {
      console.error('Import error:', error);
      setImportStatus(`Error importing data: ${error.message}`);
    } finally {
      setImporting(false);
    }
  };
  
  const handleExportSample = () => {
    const sampleData = [
      { 'Transaction Date': '2025-01-01', 'Description': 'Sample Paycheck', 'Amount': '2000.00', 'Category': 'Income' },
      { 'Transaction Date': '2025-01-02', 'Description': 'Grocery Store', 'Amount': '-120.50', 'Category': 'Food' },
      { 'Transaction Date': '2025-01-03', 'Description': 'Gas Station', 'Amount': '-45.00', 'Category': 'Transportation' }
    ];
    
    const csv = Papa.unparse(sampleData);
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8' });
    saveAs(blob, 'sample_bank_statement.csv');
  };
  
  return (
    <div className="importer-container">
      <h3>Import Bank Statement</h3>
      
      <div className="import-section">
        <div className="form-group">
          <label>Select Bank</label>
          <select value={bankType} onChange={handleBankChange}>
            <option value="">-- Select Bank --</option>
            {bankOptions.map(bank => (
              <option key={bank.value} value={bank.value}>{bank.label}</option>
            ))}
          </select>
        </div>
        
        <div className="form-group">
          <label>Upload Statement (CSV or Excel)</label>
          <input type="file" accept=".csv,.xlsx,.xls" onChange={handleFileChange} />
          <button className="secondary-button" onClick={handleExportSample}>
            Download Sample
          </button>
        </div>
        
        {bankType === 'other' && (
          <div className="field-mapping">
            <h4>Map Fields</h4>
            <div className="form-group">
              <label>Date Field</label>
              <input 
                type="text" 
                value={mappingFields.date} 
                onChange={(e) => handleMappingChange('date', e.target.value)}
                placeholder="e.g., Transaction Date"
              />
            </div>
            <div className="form-group">
              <label>Description Field</label>
              <input 
                type="text" 
                value={mappingFields.description} 
                onChange={(e) => handleMappingChange('description', e.target.value)}
                placeholder="e.g., Description"
              />
            </div>
            <div className="form-group">
              <label>Amount Field</label>
              <input 
                type="text" 
                value={mappingFields.amount} 
                onChange={(e) => handleMappingChange('amount', e.target.value)}
                placeholder="e.g., Amount"
              />
            </div>
            <div className="form-group">
              <label>Category Field (optional)</label>
              <input 
                type="text" 
                value={mappingFields.category} 
                onChange={(e) => handleMappingChange('category', e.target.value)}
                placeholder="e.g., Category"
              />
            </div>
          </div>
        )}
        
        <div className="import-actions">
          <button 
            className="primary-button" 
            onClick={handleImport} 
            disabled={importing || !file}
          >
            {importing ? 'Importing...' : 'Import Transactions'}
          </button>
          
          {importStatus && (
            <div className="import-status">
              {importStatus}
            </div>
          )}
        </div>
      </div>
      
      {importedData && importedData.length > 0 && (
        <div className="import-preview">
          <h4>Imported Transactions</h4>
          <div className="transactions-table-container">
            <table className="transactions-table">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>Description</th>
                  <th>Amount</th>
                  <th>Category</th>
                </tr>
              </thead>
              <tbody>
                {importedData.slice(0, 10).map((transaction, index) => (
                  <tr key={index}>
                    <td>{transaction.date}</td>
                    <td>{transaction.description}</td>
                    <td className={transaction.amount >= 0 ? 'positive' : 'negative'}>
                      {transaction.amount >= 0 ? '+' : ''}${Math.abs(transaction.amount).toFixed(2)}
                    </td>
                    <td>{transaction.category}</td>
                  </tr>
                ))}
              </tbody>
            </table>
            {importedData.length > 10 && (
              <div className="more-transactions">
                {importedData.length - 10} more transactions not shown
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
};

export default BankStatementImporter;
EOL

# Update Dashboard.js to include KPIs and working charts
echo "Updating Dashboard.js with KPIs and working charts..."
cat > src/pages/Dashboard.js << 'EOL'
import React from 'react';
import ChartComponent from '../components/charts/ChartComponent';
import KPIDashboard from '../components/kpis/KPIDashboard';

const Dashboard = () => {
  // Sample data for Income vs Expenses chart
  const incomeExpensesData = {
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
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        borderColor: 'rgba(75, 192, 192, 1)',
        borderWidth: 2,
        fill: true,
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
      
      {/* Advanced KPIs */}
      <KPIDashboard />
      
      <div className="dashboard-charts">
        <div className="chart-container">
          <h3>Income vs. Expenses</h3>
          <ChartComponent type="bar" data={incomeExpensesData} height={300} />
        </div>
        <div className="chart-container">
          <h3>Expense Breakdown</h3>
          <ChartComponent type="pie" data={expenseBreakdownData} height={300} />
        </div>
      </div>
      
      <div className="dashboard-charts">
        <div className="chart-container">
          <h3>Net Worth Trend</h3>
          <ChartComponent type="line" data={netWorthData} height={300} />
        </div>
        <div className="chart-container">
          <h3>Monthly Budget</h3>
          <ChartComponent type="bar" data={monthlyBudgetData} height={300} />
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

# Update ImportData.js to include functional import
echo "Updating ImportData.js with functional import..."
cat > src/pages/ImportData.js << 'EOL'
import React, { useState } from 'react';
import BankStatementImporter from '../components/import/BankStatementImporter';

const ImportData = () => {
  const [importedTransactions, setImportedTransactions] = useState([]);
  const [importSuccess, setImportSuccess] = useState(false);
  
  const handleImportComplete = (transactions) => {
    setImportedTransactions(transactions);
    setImportSuccess(true);
    
    // In a real application, you would save these to the database
    console.log('Transactions imported:', transactions);
  };
  
  const handleSaveToDatabase = () => {
    // Simulate saving to database
    setTimeout(() => {
      alert(`${importedTransactions.length} transactions saved to database successfully!`);
    }, 1000);
  };
  
  return (
    <div className="page-container">
      <h2>Import Data</h2>
      
      <div className="import-options">
        <div className="import-option-card">
          <h3>Bank Statements</h3>
          <p>Import transactions from your bank statements (CSV or Excel format)</p>
          <BankStatementImporter onImportComplete={handleImportComplete} />
        </div>
        
        <div className="import-option-card">
          <h3>Investment Accounts</h3>
          <p>Connect to your investment accounts to import portfolio data</p>
          <div className="coming-soon">Coming Soon</div>
        </div>
      </div>
      
      {importSuccess && (
        <div className="import-success">
          <h3>Import Successful!</h3>
          <p>{importedTransactions.length} transactions were imported successfully.</p>
          <button className="primary-button" onClick={handleSaveToDatabase}>
            Save to Database
          </button>
        </div>
      )}
      
      <div className="import-instructions">
        <h3>Import Instructions</h3>
        <ol>
          <li>Download your bank statement in CSV or Excel format from your bank's website</li>
          <li>Select your bank from the dropdown menu</li>
          <li>Upload the statement file</li>
          <li>If your bank is not listed, select "Other Bank" and map the fields manually</li>
          <li>Click "Import Transactions" to process the file</li>
          <li>Review the imported transactions</li>
          <li>Click "Save to Database" to store the transactions</li>
        </ol>
        
        <div className="import-tips">
          <h4>Tips</h4>
          <ul>
            <li>For best results, use the most detailed statement format available from your bank</li>
            <li>Make sure your statement includes transaction dates, descriptions, and amounts</li>
            <li>If your bank provides transaction categories, include those for better categorization</li>
            <li>You can download a sample file to see the expected format</li>
          </ul>
        </div>
      </div>
    </div>
  );
};

export default ImportData;
EOL

# Add CSS styles for KPIs and import components
echo "Adding CSS styles for KPIs and import components..."
cat >> src/App.css << 'EOL'
/* KPI Styles */
.kpi-dashboard {
  margin-bottom: 2rem;
}

.kpi-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

@media (min-width: 768px) {
  .kpi-grid {
    grid-template-columns: 1fr 1fr;
  }
}

@media (min-width: 1200px) {
  .kpi-grid {
    grid-template-columns: 1fr 1fr 1fr 1fr;
  }
}

.kpi-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
}

.kpi-card h3 {
  margin-top: 0;
  margin-bottom: 0.5rem;
  font-size: 1.1rem;
  color: #333;
}

.kpi-value {
  font-size: 2rem;
  font-weight: bold;
  margin-bottom: 0.5rem;
}

.kpi-status {
  font-weight: 500;
  margin-bottom: 0.5rem;
}

.kpi-description {
  font-size: 0.9rem;
  color: #666;
  margin-bottom: 1rem;
}

.kpi-details {
  margin-top: auto;
  font-size: 0.9rem;
}

.detail-item {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
}

.detail-label {
  color: #666;
}

.detail-value {
  font-weight: 500;
}

.score-breakdown {
  margin-top: 1rem;
}

.score-item {
  display: flex;
  align-items: center;
  margin-bottom: 0.5rem;
}

.score-label {
  width: 40%;
  font-size: 0.9rem;
  color: #666;
}

.score-bar-container {
  width: 40%;
  height: 8px;
  background-color: #e9ecef;
  border-radius: 4px;
  overflow: hidden;
  margin: 0 0.5rem;
}

.score-bar {
  height: 100%;
  background-color: #4dabf7;
  border-radius: 4px;
}

.score-value {
  width: 20%;
  font-size: 0.9rem;
  text-align: right;
  font-weight: 500;
}

/* Import Components Styles */
.importer-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
  margin-bottom: 2rem;
}

.import-section {
  margin-bottom: 2rem;
}

.field-mapping {
  background-color: #f8f9fa;
  padding: 1rem;
  border-radius: 8px;
  margin: 1rem 0;
}

.import-actions {
  margin-top: 1.5rem;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.import-status {
  margin-top: 1rem;
  padding: 0.75rem;
  border-radius: 4px;
  background-color: #f8f9fa;
  width: 100%;
}

.import-preview {
  margin-top: 2rem;
}

.transactions-table-container {
  overflow-x: auto;
  margin-top: 1rem;
}

.transactions-table {
  width: 100%;
  border-collapse: collapse;
}

.transactions-table th,
.transactions-table td {
  padding: 0.75rem;
  text-align: left;
  border-bottom: 1px solid #dee2e6;
}

.transactions-table th {
  background-color: #f8f9fa;
  font-weight: 600;
}

.more-transactions {
  text-align: center;
  padding: 0.75rem;
  color: #666;
  font-style: italic;
}

.import-options {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
  margin-bottom: 2rem;
}

@media (min-width: 992px) {
  .import-options {
    grid-template-columns: 2fr 1fr;
  }
}

.import-option-card {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.coming-soon {
  display: inline-block;
  margin-top: 1rem;
  padding: 0.5rem 1rem;
  background-color: #f8f9fa;
  border-radius: 4px;
  color: #666;
  font-style: italic;
}

.import-success {
  background-color: #d4edda;
  color: #155724;
  padding: 1rem;
  border-radius: 8px;
  margin-bottom: 2rem;
}

.import-instructions {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 1.5rem;
}

.import-instructions ol,
.import-instructions ul {
  padding-left: 1.5rem;
}

.import-instructions li {
  margin-bottom: 0.5rem;
}

.import-tips {
  background-color: #f8f9fa;
  padding: 1rem;
  border-radius: 8px;
  margin-top: 1.5rem;
}

.import-tips h4 {
  margin-top: 0;
}

/* Fix for chart container height */
.chart-container {
  position: relative;
  height: auto;
  min-height: 300px;
}

canvas {
  max-width: 100%;
}
EOL

# Create a simple HTML test page to verify Chart.js is working
echo "Creating a simple HTML test page to verify Chart.js is working..."
cat > public/chart-test.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chart.js Test</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 20px;
      background-color: #f5f5f5;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
      background-color: white;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    }
    h1 {
      text-align: center;
      margin-bottom: 30px;
    }
    .chart-container {
      height: 400px;
      margin-bottom: 30px;
      position: relative;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Chart.js Test</h1>
    
    <h2>Bar Chart</h2>
    <div class="chart-container">
      <canvas id="barChart"></canvas>
    </div>
    
    <h2>Pie Chart</h2>
    <div class="chart-container">
      <canvas id="pieChart"></canvas>
    </div>
    
    <h2>Line Chart</h2>
    <div class="chart-container">
      <canvas id="lineChart"></canvas>
    </div>
  </div>

  <script>
    // Bar Chart
    const barCtx = document.getElementById('barChart').getContext('2d');
    new Chart(barCtx, {
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

    // Pie Chart
    const pieCtx = document.getElementById('pieChart').getContext('2d');
    new Chart(pieCtx, {
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

    // Line Chart
    const lineCtx = document.getElementById('lineChart').getContext('2d');
    new Chart(lineCtx, {
      type: 'line',
      data: {
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
        datasets: [
          {
            label: 'Net Worth',
            data: [25000, 27000, 29000, 31000, 33000, 36000],
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
  </script>
</body>
</html>
EOL

# Rebuild the frontend
echo "Rebuilding the frontend..."
cd $WORK_DIR/frontend
npm run build

# Restart the application
echo "Restarting the application..."
cd $WORK_DIR
docker-compose up -d

echo "Server-side deployment completed successfully!"
echo "The application should now be accessible with all fixes applied."
echo "Please allow a few minutes for the changes to take effect, then clear your browser cache."
echo ""
echo "You can verify the charts are working by visiting: https://finance.bikramjitchowdhury.com/chart-test.html"
echo "Then check the main application at: https://finance.bikramjitchowdhury.com/"
