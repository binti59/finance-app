import React, { useState, useEffect } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Button,
  Box,
  Tabs,
  Tab,
  Divider,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  IconButton,
  Tooltip
} from '@material-ui/core';
import {
  GetApp as DownloadIcon,
  Print as PrintIcon,
  Refresh as RefreshIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components for financial statements
const IncomeStatement = () => {
  const classes = useStyles();
  
  // Sample data - would be replaced with actual data from API
  const incomeData = [
    { category: 'Income', items: [
      { name: 'Salary', amount: 85000 },
      { name: 'Dividends', amount: 2500 },
      { name: 'Interest', amount: 1200 },
      { name: 'Other Income', amount: 3000 }
    ]},
    { category: 'Expenses', items: [
      { name: 'Housing', amount: 24000 },
      { name: 'Transportation', amount: 8000 },
      { name: 'Food', amount: 7200 },
      { name: 'Utilities', amount: 4800 },
      { name: 'Insurance', amount: 6000 },
      { name: 'Healthcare', amount: 5000 },
      { name: 'Entertainment', amount: 3600 },
      { name: 'Personal Care', amount: 2400 },
      { name: 'Education', amount: 1500 },
      { name: 'Miscellaneous', amount: 3000 }
    ]}
  ];
  
  // Calculate totals
  const totalIncome = incomeData[0].items.reduce((sum, item) => sum + item.amount, 0);
  const totalExpenses = incomeData[1].items.reduce((sum, item) => sum + item.amount, 0);
  const netIncome = totalIncome - totalExpenses;
  
  return (
    <div>
      <Typography variant="h6" gutterBottom>
        Income Statement Summary
      </Typography>
      <Typography variant="subtitle2" gutterBottom color="textSecondary">
        For the period ending {new Date().toLocaleDateString()}
      </Typography>
      
      <TableContainer component={Paper} className={classes.tableContainer}>
        <Table className={classes.table}>
          <TableHead>
            <TableRow>
              <TableCell className={classes.headerCell}>Category</TableCell>
              <TableCell align="right" className={classes.headerCell}>Amount ($)</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {/* Income Section */}
            <TableRow>
              <TableCell colSpan={2} className={classes.sectionHeader}>
                Income
              </TableCell>
            </TableRow>
            {incomeData[0].items.map((item) => (
              <TableRow key={item.name}>
                <TableCell className={classes.itemCell}>{item.name}</TableCell>
                <TableCell align="right">{item.amount.toLocaleString()}</TableCell>
              </TableRow>
            ))}
            <TableRow className={classes.totalRow}>
              <TableCell className={classes.totalCell}>Total Income</TableCell>
              <TableCell align="right" className={classes.totalCell}>{totalIncome.toLocaleString()}</TableCell>
            </TableRow>
            
            {/* Expenses Section */}
            <TableRow>
              <TableCell colSpan={2} className={classes.sectionHeader}>
                Expenses
              </TableCell>
            </TableRow>
            {incomeData[1].items.map((item) => (
              <TableRow key={item.name}>
                <TableCell className={classes.itemCell}>{item.name}</TableCell>
                <TableCell align="right">{item.amount.toLocaleString()}</TableCell>
              </TableRow>
            ))}
            <TableRow className={classes.totalRow}>
              <TableCell className={classes.totalCell}>Total Expenses</TableCell>
              <TableCell align="right" className={classes.totalCell}>{totalExpenses.toLocaleString()}</TableCell>
            </TableRow>
            
            {/* Net Income */}
            <TableRow className={classes.netIncomeRow}>
              <TableCell className={classes.netIncomeCell}>Net Income</TableCell>
              <TableCell align="right" className={classes.netIncomeCell}>{netIncome.toLocaleString()}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </TableContainer>
      
      <Box mt={3}>
        <Typography variant="subtitle2" gutterBottom>
          Key Insights:
        </Typography>
        <ul className={classes.insightsList}>
          <li>Your savings rate is {((netIncome / totalIncome) * 100).toFixed(1)}% of your income</li>
          <li>Largest expense category: Housing (${incomeData[1].items[0].amount.toLocaleString()})</li>
          <li>Monthly average income: ${(totalIncome / 12).toLocaleString()}</li>
          <li>Monthly average expenses: ${(totalExpenses / 12).toLocaleString()}</li>
        </ul>
      </Box>
    </div>
  );
};

const BalanceSheet = () => {
  const classes = useStyles();
  
  // Sample data - would be replaced with actual data from API
  const balanceData = [
    { category: 'Assets', items: [
      { name: 'Cash & Equivalents', amount: 25000 },
      { name: 'Investments', amount: 120000 },
      { name: 'Retirement Accounts', amount: 180000 },
      { name: 'Real Estate', amount: 350000 },
      { name: 'Vehicles', amount: 25000 },
      { name: 'Other Assets', amount: 15000 }
    ]},
    { category: 'Liabilities', items: [
      { name: 'Mortgage', amount: 280000 },
      { name: 'Auto Loans', amount: 15000 },
      { name: 'Student Loans', amount: 35000 },
      { name: 'Credit Card Debt', amount: 5000 },
      { name: 'Other Liabilities', amount: 10000 }
    ]}
  ];
  
  // Calculate totals
  const totalAssets = balanceData[0].items.reduce((sum, item) => sum + item.amount, 0);
  const totalLiabilities = balanceData[1].items.reduce((sum, item) => sum + item.amount, 0);
  const netWorth = totalAssets - totalLiabilities;
  
  return (
    <div>
      <Typography variant="h6" gutterBottom>
        Balance Sheet Summary
      </Typography>
      <Typography variant="subtitle2" gutterBottom color="textSecondary">
        As of {new Date().toLocaleDateString()}
      </Typography>
      
      <TableContainer component={Paper} className={classes.tableContainer}>
        <Table className={classes.table}>
          <TableHead>
            <TableRow>
              <TableCell className={classes.headerCell}>Category</TableCell>
              <TableCell align="right" className={classes.headerCell}>Amount ($)</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {/* Assets Section */}
            <TableRow>
              <TableCell colSpan={2} className={classes.sectionHeader}>
                Assets
              </TableCell>
            </TableRow>
            {balanceData[0].items.map((item) => (
              <TableRow key={item.name}>
                <TableCell className={classes.itemCell}>{item.name}</TableCell>
                <TableCell align="right">{item.amount.toLocaleString()}</TableCell>
              </TableRow>
            ))}
            <TableRow className={classes.totalRow}>
              <TableCell className={classes.totalCell}>Total Assets</TableCell>
              <TableCell align="right" className={classes.totalCell}>{totalAssets.toLocaleString()}</TableCell>
            </TableRow>
            
            {/* Liabilities Section */}
            <TableRow>
              <TableCell colSpan={2} className={classes.sectionHeader}>
                Liabilities
              </TableCell>
            </TableRow>
            {balanceData[1].items.map((item) => (
              <TableRow key={item.name}>
                <TableCell className={classes.itemCell}>{item.name}</TableCell>
                <TableCell align="right">{item.amount.toLocaleString()}</TableCell>
              </TableRow>
            ))}
            <TableRow className={classes.totalRow}>
              <TableCell className={classes.totalCell}>Total Liabilities</TableCell>
              <TableCell align="right" className={classes.totalCell}>{totalLiabilities.toLocaleString()}</TableCell>
            </TableRow>
            
            {/* Net Worth */}
            <TableRow className={classes.netWorthRow}>
              <TableCell className={classes.netWorthCell}>Net Worth</TableCell>
              <TableCell align="right" className={classes.netWorthCell}>{netWorth.toLocaleString()}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </TableContainer>
      
      <Box mt={3}>
        <Typography variant="subtitle2" gutterBottom>
          Key Insights:
        </Typography>
        <ul className={classes.insightsList}>
          <li>Your debt-to-asset ratio is {((totalLiabilities / totalAssets) * 100).toFixed(1)}%</li>
          <li>Largest asset: Real Estate (${balanceData[0].items[3].amount.toLocaleString()})</li>
          <li>Largest liability: Mortgage (${balanceData[1].items[0].amount.toLocaleString()})</li>
          <li>Liquid assets (Cash & Investments): ${(balanceData[0].items[0].amount + balanceData[0].items[1].amount).toLocaleString()}</li>
        </ul>
      </Box>
    </div>
  );
};

const CashFlowStatement = () => {
  const classes = useStyles();
  
  // Sample data - would be replaced with actual data from API
  const cashflowData = [
    { category: 'Operating Activities', items: [
      { name: 'Income from Employment', amount: 85000 },
      { name: 'Investment Income', amount: 3700 },
      { name: 'Living Expenses', amount: -65500 },
      { name: 'Taxes Paid', amount: -21250 }
    ]},
    { category: 'Investing Activities', items: [
      { name: 'Purchase of Investments', amount: -12000 },
      { name: 'Sale of Investments', amount: 5000 },
      { name: 'Home Improvements', amount: -8000 }
    ]},
    { category: 'Financing Activities', items: [
      { name: 'Mortgage Payments (Principal)', amount: -8000 },
      { name: 'Auto Loan Payments (Principal)', amount: -3600 },
      { name: 'Student Loan Payments (Principal)', amount: -4800 },
      { name: 'Credit Card Payments (Principal)', amount: -2400 }
    ]}
  ];
  
  // Calculate totals
  const operatingCashflow = cashflowData[0].items.reduce((sum, item) => sum + item.amount, 0);
  const investingCashflow = cashflowData[1].items.reduce((sum, item) => sum + item.amount, 0);
  const financingCashflow = cashflowData[2].items.reduce((sum, item) => sum + item.amount, 0);
  const netCashflow = operatingCashflow + investingCashflow + financingCashflow;
  
  return (
    <div>
      <Typography variant="h6" gutterBottom>
        Cash Flow Statement Summary
      </Typography>
      <Typography variant="subtitle2" gutterBottom color="textSecondary">
        For the period ending {new Date().toLocaleDateString()}
      </Typography>
      
      <TableContainer component={Paper} className={classes.tableContainer}>
        <Table className={classes.table}>
          <TableHead>
            <TableRow>
              <TableCell className={classes.headerCell}>Category</TableCell>
              <TableCell align="right" className={classes.headerCell}>Amount ($)</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {/* Operating Activities */}
            <TableRow>
              <TableCell colSpan={2} className={classes.sectionHeader}>
                Operating Activities
              </TableCell>
            </TableRow>
            {cashflowData[0].items.map((item) => (
              <TableRow key={item.name}>
                <TableCell className={classes.itemCell}>{item.name}</TableCell>
                <TableCell align="right">{item.amount.toLocaleString()}</TableCell>
              </TableRow>
            ))}
            <TableRow className={classes.totalRow}>
              <TableCell className={classes.totalCell}>Net Cash from Operating Activities</TableCell>
              <TableCell align="right" className={classes.totalCell}>{operatingCashflow.toLocaleString()}</TableCell>
            </TableRow>
            
            {/* Investing Activities */}
            <TableRow>
              <TableCell colSpan={2} className={classes.sectionHeader}>
                Investing Activities
              </TableCell>
            </TableRow>
            {cashflowData[1].items.map((item) => (
              <TableRow key={item.name}>
                <TableCell className={classes.itemCell}>{item.name}</TableCell>
                <TableCell align="right">{item.amount.toLocaleString()}</TableCell>
              </TableRow>
            ))}
            <TableRow className={classes.totalRow}>
              <TableCell className={classes.totalCell}>Net Cash from Investing Activities</TableCell>
              <TableCell align="right" className={classes.totalCell}>{investingCashflow.toLocaleString()}</TableCell>
            </TableRow>
            
            {/* Financing Activities */}
            <TableRow>
              <TableCell colSpan={2} className={classes.sectionHeader}>
                Financing Activities
              </TableCell>
            </TableRow>
            {cashflowData[2].items.map((item) => (
              <TableRow key={item.name}>
                <TableCell className={classes.itemCell}>{item.name}</TableCell>
                <TableCell align="right">{item.amount.toLocaleString()}</TableCell>
              </TableRow>
            ))}
            <TableRow className={classes.totalRow}>
              <TableCell className={classes.totalCell}>Net Cash from Financing Activities</TableCell>
              <TableCell align="right" className={classes.totalCell}>{financingCashflow.toLocaleString()}</TableCell>
            </TableRow>
            
            {/* Net Cash Flow */}
            <TableRow className={classes.netCashflowRow}>
              <TableCell className={classes.netCashflowCell}>Net Change in Cash</TableCell>
              <TableCell align="right" className={classes.netCashflowCell}>{netCashflow.toLocaleString()}</TableCell>
            </TableRow>
          </TableBody>
        </Table>
      </TableContainer>
      
      <Box mt={3}>
        <Typography variant="subtitle2" gutterBottom>
          Key Insights:
        </Typography>
        <ul className={classes.insightsList}>
          <li>Your cash flow is {netCashflow > 0 ? 'positive' : 'negative'} at ${Math.abs(netCashflow).toLocaleString()} per year</li>
          <li>Monthly cash flow: ${(netCashflow / 12).toLocaleString()} per month</li>
          <li>Debt repayment represents {Math.abs((financingCashflow / operatingCashflow) * 100).toFixed(1)}% of your operating cash flow</li>
          <li>Investment allocation: ${Math.abs(investingCashflow).toLocaleString()} per year</li>
        </ul>
      </Box>
    </div>
  );
};

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
  paper: {
    padding: theme.spacing(3),
    height: '100%',
  },
  title: {
    marginBottom: theme.spacing(2),
  },
  tabsContainer: {
    marginBottom: theme.spacing(3),
  },
  tableContainer: {
    marginTop: theme.spacing(2),
    marginBottom: theme.spacing(2),
  },
  table: {
    minWidth: 650,
  },
  headerCell: {
    fontWeight: 'bold',
    backgroundColor: theme.palette.primary.light,
    color: theme.palette.primary.contrastText,
  },
  sectionHeader: {
    backgroundColor: theme.palette.grey[100],
    fontWeight: 'bold',
  },
  itemCell: {
    paddingLeft: theme.spacing(4),
  },
  totalRow: {
    backgroundColor: theme.palette.grey[200],
  },
  totalCell: {
    fontWeight: 'bold',
  },
  netIncomeRow: {
    backgroundColor: theme.palette.success.light,
  },
  netIncomeCell: {
    fontWeight: 'bold',
  },
  netWorthRow: {
    backgroundColor: theme.palette.info.light,
  },
  netWorthCell: {
    fontWeight: 'bold',
  },
  netCashflowRow: {
    backgroundColor: theme.palette.primary.light,
  },
  netCashflowCell: {
    fontWeight: 'bold',
    color: theme.palette.primary.contrastText,
  },
  insightsList: {
    paddingLeft: theme.spacing(2),
  },
  actionButtons: {
    display: 'flex',
    justifyContent: 'flex-end',
    marginBottom: theme.spacing(2),
  },
  button: {
    marginLeft: theme.spacing(1),
  },
}));

const Reports = () => {
  const classes = useStyles();
  const [tabValue, setTabValue] = useState(0);
  
  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };
  
  return (
    <div className={classes.root}>
      <Typography variant="h4" component="h1" className={classes.title}>
        Reports
      </Typography>
      
      <div className={classes.actionButtons}>
        <Tooltip title="Refresh data">
          <IconButton className={classes.button}>
            <RefreshIcon />
          </IconButton>
        </Tooltip>
        <Tooltip title="Download as PDF">
          <IconButton className={classes.button}>
            <DownloadIcon />
          </IconButton>
        </Tooltip>
        <Tooltip title="Print report">
          <IconButton className={classes.button}>
            <PrintIcon />
          </IconButton>
        </Tooltip>
      </div>
      
      <Paper className={classes.tabsContainer}>
        <Tabs
          value={tabValue}
          onChange={handleTabChange}
          indicatorColor="primary"
          textColor="primary"
          centered
        >
          <Tab label="Income Statement" />
          <Tab label="Balance Sheet" />
          <Tab label="Cash Flow" />
        </Tabs>
      </Paper>
      
      <Paper className={classes.paper}>
        {tabValue === 0 && <IncomeStatement />}
        {tabValue === 1 && <BalanceSheet />}
        {tabValue === 2 && <CashFlowStatement />}
      </Paper>
    </div>
  );
};

export default Reports;
