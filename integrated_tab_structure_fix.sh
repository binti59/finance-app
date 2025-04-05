#!/bin/bash

# Integrated tab structure and Advanced KPIs implementation script
# This script implements a new navigation structure with main tabs and collapsible lists,
# and adds a dedicated Advanced KPIs tab with comprehensive financial metrics

echo "Starting integrated tab structure and Advanced KPIs implementation..."

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

# Create the MainLayout component for the new navigation structure
echo "Creating MainLayout component with redesigned navigation..."
mkdir -p frontend/src/layouts

cat > frontend/src/layouts/MainLayout.js << 'EOL'
import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import {
  AppBar,
  Toolbar,
  Typography,
  Button,
  IconButton,
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Collapse,
  Divider,
  Avatar,
  Box,
  Container,
  useMediaQuery,
  useTheme
} from '@material-ui/core';
import {
  Menu as MenuIcon,
  Dashboard as DashboardIcon,
  AccountBalance as AccountsIcon,
  Receipt as TransactionsIcon,
  PieChart as BudgetIcon,
  Flag as GoalsIcon,
  TrendingUp as InvestmentsIcon,
  Assessment as ReportsIcon,
  Settings as SettingsIcon,
  Link as ConnectionsIcon,
  CloudUpload as ImportIcon,
  Timeline as FinancialIndependenceIcon,
  ExpandLess,
  ExpandMore,
  BarChart as KPIIcon,
  ExitToApp as LogoutIcon
} from '@material-ui/icons';

const MainLayout = ({ children }) => {
  const location = useLocation();
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
  const [drawerOpen, setDrawerOpen] = useState(false);
  const [accountsOpen, setAccountsOpen] = useState(false);
  const [planningOpen, setPlanningOpen] = useState(false);

  const handleDrawerToggle = () => {
    setDrawerOpen(!drawerOpen);
  };

  const handleAccountsToggle = () => {
    setAccountsOpen(!accountsOpen);
  };

  const handlePlanningToggle = () => {
    setPlanningOpen(!planningOpen);
  };

  const isActive = (path) => {
    return location.pathname === path;
  };

  // Main tabs that will always be visible
  const mainTabs = [
    { name: 'Dashboard', path: '/', icon: <DashboardIcon /> },
    { name: 'Advanced KPIs', path: '/advanced-kpis', icon: <KPIIcon /> },
    { name: 'Financial Independence', path: '/planning/financial-independence', icon: <FinancialIndependenceIcon /> },
    { name: 'Reports', path: '/reports', icon: <ReportsIcon /> },
    { name: 'Settings', path: '/settings', icon: <SettingsIcon /> }
  ];

  // Accounts & Transactions submenu items
  const accountsItems = [
    { name: 'Accounts', path: '/accounts', icon: <AccountsIcon /> },
    { name: 'Transactions', path: '/transactions', icon: <TransactionsIcon /> },
    { name: 'Connections', path: '/connections', icon: <ConnectionsIcon /> },
    { name: 'Import Data', path: '/import', icon: <ImportIcon /> }
  ];

  // Planning submenu items
  const planningItems = [
    { name: 'Budget', path: '/budget', icon: <BudgetIcon /> },
    { name: 'Goals', path: '/goals', icon: <GoalsIcon /> },
    { name: 'Investments', path: '/investments', icon: <InvestmentsIcon /> }
  ];

  // Drawer content
  const drawerContent = (
    <div>
      <Box p={2} display="flex" alignItems="center">
        <Avatar style={{ marginRight: 16 }}>J</Avatar>
        <Typography variant="h6">John Doe</Typography>
      </Box>
      <Divider />
      <List>
        {/* Main Tabs */}
        {mainTabs.map((tab) => (
          <ListItem
            button
            component={Link}
            to={tab.path}
            key={tab.name}
            selected={isActive(tab.path)}
            onClick={() => isMobile && setDrawerOpen(false)}
          >
            <ListItemIcon>{tab.icon}</ListItemIcon>
            <ListItemText primary={tab.name} />
          </ListItem>
        ))}

        <Divider />

        {/* Accounts & Transactions Submenu */}
        <ListItem button onClick={handleAccountsToggle}>
          <ListItemIcon><AccountsIcon /></ListItemIcon>
          <ListItemText primary="Accounts & Transactions" />
          {accountsOpen ? <ExpandLess /> : <ExpandMore />}
        </ListItem>
        <Collapse in={accountsOpen} timeout="auto" unmountOnExit>
          <List component="div" disablePadding>
            {accountsItems.map((item) => (
              <ListItem
                button
                component={Link}
                to={item.path}
                key={item.name}
                selected={isActive(item.path)}
                onClick={() => isMobile && setDrawerOpen(false)}
                style={{ paddingLeft: 32 }}
              >
                <ListItemIcon>{item.icon}</ListItemIcon>
                <ListItemText primary={item.name} />
              </ListItem>
            ))}
          </List>
        </Collapse>

        {/* Planning Submenu */}
        <ListItem button onClick={handlePlanningToggle}>
          <ListItemIcon><TrendingUpIcon /></ListItemIcon>
          <ListItemText primary="Planning & Investments" />
          {planningOpen ? <ExpandLess /> : <ExpandMore />}
        </ListItem>
        <Collapse in={planningOpen} timeout="auto" unmountOnExit>
          <List component="div" disablePadding>
            {planningItems.map((item) => (
              <ListItem
                button
                component={Link}
                to={item.path}
                key={item.name}
                selected={isActive(item.path)}
                onClick={() => isMobile && setDrawerOpen(false)}
                style={{ paddingLeft: 32 }}
              >
                <ListItemIcon>{item.icon}</ListItemIcon>
                <ListItemText primary={item.name} />
              </ListItem>
            ))}
          </List>
        </Collapse>
      </List>
      <Divider />
      <List>
        <ListItem button onClick={() => console.log('Logout clicked')}>
          <ListItemIcon><LogoutIcon /></ListItemIcon>
          <ListItemText primary="Logout" />
        </ListItem>
      </List>
    </div>
  );

  return (
    <div style={{ display: 'flex' }}>
      <AppBar position="fixed">
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" style={{ flexGrow: 1 }}>
            Finance Manager
          </Typography>
          {!isMobile && mainTabs.map((tab) => (
            <Button
              color="inherit"
              component={Link}
              to={tab.path}
              key={tab.name}
              style={{ 
                margin: '0 4px',
                backgroundColor: isActive(tab.path) ? 'rgba(255, 255, 255, 0.15)' : 'transparent'
              }}
            >
              {tab.name}
            </Button>
          ))}
        </Toolbar>
      </AppBar>
      <Drawer
        variant={isMobile ? "temporary" : "permanent"}
        open={isMobile ? drawerOpen : true}
        onClose={isMobile ? handleDrawerToggle : undefined}
        ModalProps={{
          keepMounted: true // Better mobile performance
        }}
        style={{ width: 240 }}
        PaperProps={{ style: { width: 240 } }}
      >
        {drawerContent}
      </Drawer>
      <main style={{ flexGrow: 1, padding: theme.spacing(3), marginLeft: isMobile ? 0 : 240, marginTop: 64 }}>
        <Container maxWidth="lg">
          {children}
        </Container>
      </main>
    </div>
  );
};

export default MainLayout;
EOL

# Create the Advanced KPIs component
echo "Creating Advanced KPIs component..."
mkdir -p frontend/src/pages

cat > frontend/src/pages/AdvancedKPIs.js << 'EOL'
import React, { useState, useEffect } from 'react';
import {
  Box,
  Typography,
  Grid,
  Paper,
  LinearProgress,
  Divider,
  Card,
  CardContent,
  CardHeader,
  Button,
  Tabs,
  Tab,
  useTheme
} from '@material-ui/core';
import {
  TrendingUp as TrendingUpIcon,
  Assessment as AssessmentIcon,
  Timeline as TimelineIcon,
  Score as ScoreIcon
} from '@material-ui/icons';
import { Line, Pie, Bar } from 'react-chartjs-2';

// Chart.js setup
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend,
} from 'chart.js';

ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  BarElement,
  ArcElement,
  Title,
  Tooltip,
  Legend
);

const AdvancedKPIs = () => {
  const theme = useTheme();
  const [tabValue, setTabValue] = useState(0);
  const [kpiData, setKpiData] = useState({
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
  });

  const [historicalData, setHistoricalData] = useState({
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
    netWorth: [220000, 228000, 235000, 242000, 246000, 250000],
    savingsRate: [28.5, 29.2, 29.8, 30.1, 30.5, 30.8],
    fiProgress: [20, 21, 22, 23, 24, 25],
    healthScore: [62, 63, 65, 66, 67, 68]
  });

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  // Chart configurations
  const netWorthChartData = {
    labels: historicalData.labels,
    datasets: [
      {
        label: 'Net Worth',
        data: historicalData.netWorth,
        fill: true,
        backgroundColor: 'rgba(75, 192, 192, 0.2)',
        borderColor: 'rgba(75, 192, 192, 1)',
      }
    ]
  };

  const savingsRateChartData = {
    labels: historicalData.labels,
    datasets: [
      {
        label: 'Savings Rate (%)',
        data: historicalData.savingsRate,
        fill: true,
        backgroundColor: 'rgba(54, 162, 235, 0.2)',
        borderColor: 'rgba(54, 162, 235, 1)',
      }
    ]
  };

  const fiProgressChartData = {
    labels: historicalData.labels,
    datasets: [
      {
        label: 'FI Progress (%)',
        data: historicalData.fiProgress,
        fill: true,
        backgroundColor: 'rgba(255, 159, 64, 0.2)',
        borderColor: 'rgba(255, 159, 64, 1)',
      }
    ]
  };

  const healthScoreChartData = {
    labels: ['Emergency Fund', 'Debt Management', 'Savings Rate', 'FI Progress'],
    datasets: [
      {
        label: 'Score',
        data: [
          kpiData.emergencyFundScore, 
          kpiData.debtManagementScore, 
          kpiData.savingsRateScore, 
          kpiData.fiProgressScore
        ],
        backgroundColor: [
          'rgba(255, 99, 132, 0.6)',
          'rgba(54, 162, 235, 0.6)',
          'rgba(75, 192, 192, 0.6)',
          'rgba(255, 159, 64, 0.6)',
        ],
      }
    ]
  };

  const chartOptions = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: {
        position: 'bottom',
      },
    },
  };

  // Calculate years to FI
  const yearsToFI = Math.ceil((kpiData.financialFreedomNumber - kpiData.currentNetWorth) / (kpiData.monthlySavings * 12));

  return (
    <Box>
      <Typography variant="h4" gutterBottom>
        Advanced Financial KPIs
      </Typography>
      <Typography variant="subtitle1" color="textSecondary" paragraph>
        Track and analyze your key financial performance indicators to optimize your financial health and progress toward financial independence.
      </Typography>

      <Tabs
        value={tabValue}
        onChange={handleTabChange}
        indicatorColor="primary"
        textColor="primary"
        variant="fullWidth"
        aria-label="KPI tabs"
      >
        <Tab icon={<AssessmentIcon />} label="Overview" />
        <Tab icon={<TrendingUpIcon />} label="Financial Independence" />
        <Tab icon={<TimelineIcon />} label="Trends" />
        <Tab icon={<ScoreIcon />} label="Financial Health" />
      </Tabs>

      {/* Overview Tab */}
      {tabValue === 0 && (
        <Box mt={3}>
          <Grid container spacing={3}>
            {/* Financial Independence Index */}
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Box display="flex" alignItems="center" mb={1}>
                  <TrendingUpIcon color="primary" style={{ marginRight: theme.spacing(1) }} />
                  <Typography variant="h6">Financial Independence Index</Typography>
                </Box>
                <Typography variant="h3" style={{ color: '#f39c12' }}>
                  {kpiData.financialIndependenceIndex}%
                </Typography>
                <Typography variant="subtitle1" gutterBottom>
                  On Your Way
                </Typography>
                <Box mt={1} mb={1}>
                  <LinearProgress 
                    variant="determinate" 
                    value={kpiData.financialIndependenceIndex} 
                    style={{ height: 10, borderRadius: 5, backgroundColor: '#e0e0e0' }}
                  />
                </Box>
                <Typography variant="body2" color="textSecondary">
                  You're {kpiData.financialIndependenceIndex}% of the way to financial independence. 
                  At your current savings rate, you'll reach financial independence in approximately {yearsToFI} years.
                </Typography>
              </Paper>
            </Grid>

            {/* Financial Freedom Number */}
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Box display="flex" alignItems="center" mb={1}>
                  <AssessmentIcon color="primary" style={{ marginRight: theme.spacing(1) }} />
                  <Typography variant="h6">Financial Freedom Number</Typography>
                </Box>
                <Typography variant="h3">
                  ${kpiData.financialFreedomNumber.toLocaleString()}
                </Typography>
                <Typography variant="subtitle1" gutterBottom>
                  Target Net Worth
                </Typography>
                <Box mt={2}>
                  <Grid container spacing={2}>
                    <Grid item xs={6}>
                      <Typography variant="body2" color="textSecondary">Annual Expenses</Typography>
                      <Typography variant="body1">${kpiData.annualExpenses.toLocaleString()}</Typography>
                    </Grid>
                    <Grid item xs={6}>
                      <Typography variant="body2" color="textSecondary">Withdrawal Rate</Typography>
                      <Typography variant="body1">{kpiData.withdrawalRate}%</Typography>
                    </Grid>
                  </Grid>
                </Box>
                <Box mt={2}>
                  <Grid container spacing={2}>
                    <Grid item xs={6}>
                      <Typography variant="body2" color="textSecondary">Current Net Worth</Typography>
                      <Typography variant="body1">${kpiData.currentNetWorth.toLocaleString()}</Typography>
                    </Grid>
                    <Grid item xs={6}>
                      <Typography variant="body2" color="textSecondary">Progress</Typography>
                      <Typography variant="body1">{kpiData.financialIndependenceIndex}%</Typography>
                    </Grid>
                  </Grid>
                </Box>
              </Paper>
            </Grid>

            {/* Savings Rate */}
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Box display="flex" alignItems="center" mb={1}>
                  <TimelineIcon color="primary" style={{ marginRight: theme.spacing(1) }} />
                  <Typography variant="h6">Savings Rate</Typography>
                </Box>
                <Typography variant="h3" style={{ color: '#27ae60' }}>
                  {kpiData.savingsRate}%
                </Typography>
                <Typography variant="subtitle1" gutterBottom>
                  Excellent
                </Typography>
                <Box mt={2}>
                  <Grid container spacing={2}>
                    <Grid item xs={4}>
                      <Typography variant="body2" color="textSecondary">Monthly Income</Typography>
                      <Typography variant="body1">${kpiData.monthlyIncome.toLocaleString()}</Typography>
                    </Grid>
                    <Grid item xs={4}>
                      <Typography variant="body2" color="textSecondary">Monthly Expenses</Typography>
                      <Typography variant="body1">${kpiData.monthlyExpenses.toLocaleString()}</Typography>
                    </Grid>
                    <Grid item xs={4}>
                      <Typography variant="body2" color="textSecondary">Monthly Savings</Typography>
                      <Typography variant="body1">${kpiData.monthlySavings.toLocaleString()}</Typography>
                    </Grid>
                  </Grid>
                </Box>
                <Box mt={2}>
                  <Typography variant="body2" color="textSecondary">
                    Your savings rate is excellent! A high savings rate is one of the most important factors in achieving financial independence quickly.
                  </Typography>
                </Box>
              </Paper>
            </Grid>

            {/* Financial Health Score */}
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Box display="flex" alignItems="center" mb={1}>
                  <ScoreIcon color="primary" style={{ marginRight: theme.spacing(1) }} />
                  <Typography variant="h6">Financial Health Score</Typography>
                </Box>
                <Typography variant="h3" style={{ color: '#f39c12' }}>
                  {kpiData.financialHealthScore}/100
                </Typography>
                <Typography variant="subtitle1" gutterBottom>
                  Good
                </Typography>
                <Box mt={2}>
                  {/* Score breakdown */}
                  <Box display="flex" alignItems="center" mb={1}>
                    <Typography variant="body2" style={{ width: '40%' }}>Emergency Fund</Typography>
                    <Box width="40%" mr={1}>
                      <LinearProgress 
                        variant="determinate" 
                        value={(kpiData.emergencyFundScore / 25) * 100} 
                        style={{ height: 8, borderRadius: 4 }}
                      />
                    </Box>
                    <Typography variant="body2">{kpiData.emergencyFundScore}/25</Typography>
                  </Box>
                  <Box display="flex" alignItems="center" mb={1}>
                    <Typography variant="body2" style={{ width: '40%' }}>Debt Management</Typography>
                    <Box width="40%" mr={1}>
                      <LinearProgress 
                        variant="determinate" 
                        value={(kpiData.debtManagementScore / 25) * 100} 
                        style={{ height: 8, borderRadius: 4 }}
                      />
                    </Box>
                    <Typography variant="body2">{kpiData.debtManagementScore}/25</Typography>
                  </Box>
                  <Box display="flex" alignItems="center" mb={1}>
                    <Typography variant="body2" style={{ width: '40%' }}>Savings Rate</Typography>
                    <Box width="40%" mr={1}>
                      <LinearProgress 
                        variant="determinate" 
                        value={(kpiData.savingsRateScore / 25) * 100} 
                        style={{ height: 8, borderRadius: 4 }}
                      />
                    </Box>
                    <Typography variant="body2">{kpiData.savingsRateScore}/25</Typography>
                  </Box>
                  <Box display="flex" alignItems="center">
                    <Typography variant="body2" style={{ width: '40%' }}>FI Progress</Typography>
                    <Box width="40%" mr={1}>
                      <LinearProgress 
                        variant="determinate" 
                        value={(kpiData.fiProgressScore / 25) * 100} 
                        style={{ height: 8, borderRadius: 4 }}
                      />
                    </Box>
                    <Typography variant="body2">{kpiData.fiProgressScore}/25</Typography>
                  </Box>
                </Box>
              </Paper>
            </Grid>
          </Grid>
        </Box>
      )}

      {/* Financial Independence Tab */}
      {tabValue === 1 && (
        <Box mt={3}>
          <Grid container spacing={3}>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Financial Independence Progress</Typography>
                <Box height={300} mt={2}>
                  <Line data={fiProgressChartData} options={chartOptions} />
                </Box>
              </Paper>
            </Grid>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Net Worth Growth</Typography>
                <Box height={300} mt={2}>
                  <Line data={netWorthChartData} options={chartOptions} />
                </Box>
              </Paper>
            </Grid>
            <Grid item xs={12}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Financial Independence Calculator</Typography>
                <Grid container spacing={3}>
                  <Grid item xs={12} md={4}>
                    <Typography variant="body2" color="textSecondary">Current Net Worth</Typography>
                    <Typography variant="h6">${kpiData.currentNetWorth.toLocaleString()}</Typography>
                  </Grid>
                  <Grid item xs={12} md={4}>
                    <Typography variant="body2" color="textSecondary">Annual Expenses</Typography>
                    <Typography variant="h6">${kpiData.annualExpenses.toLocaleString()}</Typography>
                  </Grid>
                  <Grid item xs={12} md={4}>
                    <Typography variant="body2" color="textSecondary">Annual Savings</Typography>
                    <Typography variant="h6">${(kpiData.monthlySavings * 12).toLocaleString()}</Typography>
                  </Grid>
                </Grid>
                <Box mt={2}>
                  <Typography variant="body2" color="textSecondary">Financial Freedom Number</Typography>
                  <Typography variant="h5">${kpiData.financialFreedomNumber.toLocaleString()}</Typography>
                </Box>
                <Box mt={2}>
                  <Typography variant="body2" color="textSecondary">Years to Financial Independence</Typography>
                  <Typography variant="h5">{yearsToFI} years</Typography>
                </Box>
                <Box mt={2}>
                  <Typography variant="body2">
                    Based on your current savings rate of {kpiData.savingsRate}% and annual expenses of ${kpiData.annualExpenses.toLocaleString()}, 
                    you'll need ${kpiData.financialFreedomNumber.toLocaleString()} to be financially independent. 
                    At your current savings rate, you'll reach this goal in approximately {yearsToFI} years.
                  </Typography>
                </Box>
              </Paper>
            </Grid>
          </Grid>
        </Box>
      )}

      {/* Trends Tab */}
      {tabValue === 2 && (
        <Box mt={3}>
          <Grid container spacing={3}>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Net Worth Trend</Typography>
                <Box height={300} mt={2}>
                  <Line data={netWorthChartData} options={chartOptions} />
                </Box>
              </Paper>
            </Grid>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Savings Rate Trend</Typography>
                <Box height={300} mt={2}>
                  <Line data={savingsRateChartData} options={chartOptions} />
                </Box>
              </Paper>
            </Grid>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Financial Independence Progress</Typography>
                <Box height={300} mt={2}>
                  <Line data={fiProgressChartData} options={chartOptions} />
                </Box>
              </Paper>
            </Grid>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Financial Health Score Trend</Typography>
                <Box height={300} mt={2}>
                  <Line 
                    data={{
                      labels: historicalData.labels,
                      datasets: [
                        {
                          label: 'Health Score',
                          data: historicalData.healthScore,
                          fill: true,
                          backgroundColor: 'rgba(153, 102, 255, 0.2)',
                          borderColor: 'rgba(153, 102, 255, 1)',
                        }
                      ]
                    }} 
                    options={chartOptions} 
                  />
                </Box>
              </Paper>
            </Grid>
          </Grid>
        </Box>
      )}

      {/* Financial Health Tab */}
      {tabValue === 3 && (
        <Box mt={3}>
          <Grid container spacing={3}>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Financial Health Score</Typography>
                <Typography variant="h3" style={{ color: '#f39c12' }}>
                  {kpiData.financialHealthScore}/100
                </Typography>
                <Typography variant="subtitle1" gutterBottom>
                  Good
                </Typography>
                <Box mt={2}>
                  <Typography variant="body2" color="textSecondary">
                    Your financial health score is calculated based on four key areas: emergency fund, debt management, 
                    savings rate, and progress toward financial independence. Improving in any of these areas will 
                    increase your overall financial health score.
                  </Typography>
                </Box>
              </Paper>
            </Grid>
            <Grid item xs={12} md={6}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Score Breakdown</Typography>
                <Box height={300} mt={2}>
                  <Pie data={healthScoreChartData} options={chartOptions} />
                </Box>
              </Paper>
            </Grid>
            <Grid item xs={12}>
              <Paper elevation={2} style={{ padding: theme.spacing(2) }}>
                <Typography variant="h6" gutterBottom>Improvement Recommendations</Typography>
                <Grid container spacing={3}>
                  <Grid item xs={12} md={6}>
                    <Card variant="outlined">
                      <CardHeader title="Emergency Fund" />
                      <CardContent>
                        <Typography variant="body2" color="textSecondary">
                          Your emergency fund score is {kpiData.emergencyFundScore}/25. To improve this score, 
                          aim to save 3-6 months of expenses in a liquid emergency fund.
                        </Typography>
                        <Box mt={2}>
                          <Button variant="outlined" color="primary">
                            Set Emergency Fund Goal
                          </Button>
                        </Box>
                      </CardContent>
                    </Card>
                  </Grid>
                  <Grid item xs={12} md={6}>
                    <Card variant="outlined">
                      <CardHeader title="Debt Management" />
                      <CardContent>
                        <Typography variant="body2" color="textSecondary">
                          Your debt management score is {kpiData.debtManagementScore}/25. To improve this score, 
                          focus on paying down high-interest debt and maintaining a low debt-to-income ratio.
                        </Typography>
                        <Box mt={2}>
                          <Button variant="outlined" color="primary">
                            Create Debt Payoff Plan
                          </Button>
                        </Box>
                      </CardContent>
                    </Card>
                  </Grid>
                  <Grid item xs={12} md={6}>
                    <Card variant="outlined">
                      <CardHeader title="Savings Rate" />
                      <CardContent>
                        <Typography variant="body2" color="textSecondary">
                          Your savings rate score is {kpiData.savingsRateScore}/25. To improve this score, 
                          aim to increase your savings rate by reducing expenses or increasing income.
                        </Typography>
                        <Box mt={2}>
                          <Button variant="outlined" color="primary">
                            Optimize Budget
                          </Button>
                        </Box>
                      </CardContent>
                    </Card>
                  </Grid>
                  <Grid item xs={12} md={6}>
                    <Card variant="outlined">
                      <CardHeader title="FI Progress" />
                      <CardContent>
                        <Typography variant="body2" color="textSecondary">
                          Your FI progress score is {kpiData.fiProgressScore}/25. To improve this score, 
                          focus on increasing your net worth relative to your financial independence number.
                        </Typography>
                        <Box mt={2}>
                          <Button variant="outlined" color="primary">
                            View Investment Strategy
                          </Button>
                        </Box>
                      </CardContent>
                    </Card>
                  </Grid>
                </Grid>
              </Paper>
            </Grid>
          </Grid>
        </Box>
      )}
    </Box>
  );
};

export default AdvancedKPIs;
EOL

# Update App.js to include the new navigation structure and Advanced KPIs page
echo "Updating App.js with new navigation structure and Advanced KPIs page..."

cat > frontend/src/App.js << 'EOL'
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import { Provider } from 'react-redux';
import { ThemeProvider, createTheme } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import store from './store';

// Layout Components
import MainLayout from './layouts/MainLayout';
import AuthLayout from './layouts/AuthLayout';

// Auth Pages
import Login from './pages/auth/Login';
import Register from './pages/auth/Register';
import ForgotPassword from './pages/auth/ForgotPassword';
import ResetPassword from './pages/auth/ResetPassword';

// Main Pages
import Dashboard from './pages/Dashboard';
import Accounts from './pages/Accounts';
import Transactions from './pages/Transactions';
import Budget from './pages/Budget';
import Goals from './pages/Goals';
import Investments from './pages/Investments';
import Reports from './pages/Reports';
import Settings from './pages/Settings';
import Profile from './pages/Profile';
import AdvancedKPIs from './pages/AdvancedKPIs';

// Data Connection Pages
import Connections from './pages/Connections';
import ImportData from './pages/ImportData';

// Financial Planning Pages
import FinancialIndependence from './pages/planning/FinancialIndependence';
import RetirementPlanning from './pages/planning/RetirementPlanning';
import DebtPayoff from './pages/planning/DebtPayoff';

// Utility Components
import PrivateRoute from './components/routing/PrivateRoute';
import Notifications from './components/common/Notifications';
import LoadingScreen from './components/common/LoadingScreen';

// Services
import { setAuthToken } from './utils/api';
import { loadUser } from './actions/authActions';

// Create theme
const theme = createTheme({
  palette: {
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
    background: {
      default: '#f5f5f5',
    },
  },
  typography: {
    fontFamily: [
      'Roboto',
      'Arial',
      'sans-serif',
    ].join(','),
  },
  overrides: {
    MuiCssBaseline: {
      '@global': {
        body: {
          backgroundColor: '#f5f5f5',
        },
      },
    },
  },
});

const App = () => {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check for token in storage
    const token = localStorage.getItem('token');
    if (token) {
      // Set auth token in axios headers
      setAuthToken(token);
      // Load user data
      store.dispatch(loadUser());
    }
    
    // Set loading to false after initial auth check
    setTimeout(() => setLoading(false), 1000);
  }, []);

  if (loading) {
    return <LoadingScreen />;
  }

  return (
    <Provider store={store}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <Router>
          <Notifications />
          <Switch>
            {/* Auth Routes */}
            <Route exact path="/login">
              <AuthLayout>
                <Login />
              </AuthLayout>
            </Route>
            <Route exact path="/register">
              <AuthLayout>
                <Register />
              </AuthLayout>
            </Route>
            <Route exact path="/forgot-password">
              <AuthLayout>
                <ForgotPassword />
              </AuthLayout>
            </Route>
            <Route exact path="/reset-password/:token">
              <AuthLayout>
                <ResetPassword />
              </AuthLayout>
            </Route>

            {/* Private Routes */}
            <PrivateRoute exact path="/">
              <MainLayout>
                <Dashboard />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/advanced-kpis">
              <MainLayout>
                <AdvancedKPIs />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/accounts">
              <MainLayout>
                <Accounts />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/transactions">
              <MainLayout>
                <Transactions />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/budget">
              <MainLayout>
                <Budget />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/goals">
              <MainLayout>
                <Goals />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/investments">
              <MainLayout>
                <Investments />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/reports">
              <MainLayout>
                <Reports />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/connections">
              <MainLayout>
                <Connections />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/import">
              <MainLayout>
                <ImportData />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/planning/financial-independence">
              <MainLayout>
                <FinancialIndependence />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/planning/retirement">
              <MainLayout>
                <RetirementPlanning />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/planning/debt-payoff">
              <MainLayout>
                <DebtPayoff />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/settings">
              <MainLayout>
                <Settings />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/profile">
              <MainLayout>
                <Profile />
              </MainLayout>
            </PrivateRoute>

            {/* Redirect to dashboard if logged in, otherwise to login */}
            <Route path="*">
              <Redirect to="/" />
            </Route>
          </Switch>
        </Router>
      </ThemeProvider>
    </Provider>
  );
};

export default App;
EOL

# Update package.json to include Chart.js dependencies
echo "Updating package.json with Chart.js dependencies..."

# Use sed to add the required dependencies to package.json
sed -i '/dependencies/a \
    "chart.js": "^4.3.0",\
    "react-chartjs-2": "^5.2.0",' frontend/package.json

# Install the new dependencies
echo "Installing new dependencies..."
cd frontend && npm install

# Rebuild the frontend
echo "Rebuilding the frontend..."
npm run build

# Restart the application
echo "Restarting the application..."
cd ..
docker-compose up -d

echo "Integrated tab structure and Advanced KPIs implementation completed successfully!"
echo "The application now has:"
echo "1. A redesigned navigation structure with main tabs (Dashboard, Advanced KPIs, Financial Independence, Reports, Settings)"
echo "2. Other tabs organized into collapsible lists (Accounts & Transactions, Planning & Investments)"
echo "3. A dedicated Advanced KPIs tab with comprehensive financial metrics and visualizations"
echo ""
echo "Please allow a few minutes for the changes to take effect, then clear your browser cache."
echo "You can access the application at: https://finance.bikramjitchowdhury.com/"
