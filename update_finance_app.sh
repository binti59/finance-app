#!/bin/bash

# Finance App Update Script
# This script implements the changes to rename "Advanced KPIs" to "KPIs",
# add financial statement summaries, and redesign the Goals page
# Created: April 07, 2025

# Text colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display section headers
echo_section() {
  echo -e "\n${BLUE}==== $1 ====${NC}\n"
}

# Function to display success messages
echo_success() {
  echo -e "${GREEN}✓ $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root (with sudo)"
  exit 1
fi

# Welcome message
clear
echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}    Finance App Update Script    ${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
echo -e "This script will update your Finance App with the following changes:"
echo -e "1. Rename 'Advanced KPIs' to 'KPIs'"
echo -e "2. Add financial statement summaries in the Reports section"
echo -e "3. Redesign the Goals page with a vision board layout"
echo

# Configuration
INSTALL_DIR="/opt/personal-finance-system"
FRONTEND_PORT=3000
BACKEND_PORT=4000

# Ask for installation directory
read -p "Installation directory [$INSTALL_DIR]: " input
INSTALL_DIR=${input:-$INSTALL_DIR}

echo_section "Creating backup"
BACKUP_DIR="${INSTALL_DIR}_backup_$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP_DIR"
cp -r "$INSTALL_DIR"/* "$BACKUP_DIR"
echo_success "Backup created at $BACKUP_DIR"

echo_section "Updating frontend files"

# Create directories if they don't exist
mkdir -p ${INSTALL_DIR}/frontend/src/layouts
mkdir -p ${INSTALL_DIR}/frontend/src/pages
mkdir -p ${INSTALL_DIR}/frontend/src/components/routing
mkdir -p ${INSTALL_DIR}/frontend/src/components/common
mkdir -p ${INSTALL_DIR}/frontend/src/reducers
mkdir -p ${INSTALL_DIR}/frontend/src/actions
mkdir -p ${INSTALL_DIR}/frontend/src/utils

# Create MainLayout.js with KPIs instead of Advanced KPIs
cat > ${INSTALL_DIR}/frontend/src/layouts/MainLayout.js << 'EOF'
import React, { useState } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { makeStyles } from '@material-ui/core/styles';
import {
  AppBar,
  Toolbar,
  Typography,
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Divider,
  IconButton,
  Container,
  Collapse,
  Box,
  useMediaQuery,
  useTheme,
  Avatar
} from '@material-ui/core';
import {
  Menu as MenuIcon,
  Dashboard as DashboardIcon,
  AccountBalance as AccountsIcon,
  Receipt as TransactionsIcon,
  AttachMoney as BudgetIcon,
  Flag as GoalsIcon,
  TrendingUp as InvestmentsIcon,
  Assessment as ReportsIcon,
  BarChart as KPIsIcon,
  Settings as SettingsIcon,
  ExpandLess,
  ExpandMore,
  Link as ConnectionsIcon,
  CloudUpload as ImportIcon,
  Timeline as PlanningIcon,
  ExitToApp as LogoutIcon,
  Person as ProfileIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';
import { logout } from '../actions/authActions';

const drawerWidth = 240;

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
  },
  menuButton: {
    marginRight: theme.spacing(2),
    [theme.breakpoints.up('md')]: {
      display: 'none',
    },
  },
  title: {
    flexGrow: 1,
  },
  drawer: {
    width: drawerWidth,
    flexShrink: 0,
  },
  drawerPaper: {
    width: drawerWidth,
  },
  drawerContainer: {
    overflow: 'auto',
  },
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
    backgroundColor: theme.palette.background.default,
    minHeight: '100vh',
  },
  nested: {
    paddingLeft: theme.spacing(4),
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.primary.main,
  },
  userSection: {
    padding: theme.spacing(2),
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
    backgroundColor: theme.palette.background.default,
  },
  userName: {
    marginTop: theme.spacing(1),
  },
  userEmail: {
    fontSize: '0.8rem',
    color: theme.palette.text.secondary,
  },
  toolbar: theme.mixins.toolbar,
}));

const MainLayout = ({ children }) => {
  const classes = useStyles();
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('sm'));
  const [mobileOpen, setMobileOpen] = useState(false);
  const [planningOpen, setPlanningOpen] = useState(false);
  const [accountsOpen, setAccountsOpen] = useState(false);
  const location = useLocation();
  const dispatch = useDispatch();
  const { user } = useSelector(state => state.auth);

  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };

  const handlePlanningClick = () => {
    setPlanningOpen(!planningOpen);
  };

  const handleAccountsClick = () => {
    setAccountsOpen(!accountsOpen);
  };

  const handleLogout = () => {
    dispatch(logout());
  };

  const isActive = (path) => {
    return location.pathname === path;
  };

  const drawer = (
    <div>
      <div className={classes.userSection}>
        <Avatar className={classes.avatar}>
          {user && user.name ? user.name.charAt(0).toUpperCase() : 'U'}
        </Avatar>
        <Typography className={classes.userName} variant="subtitle1">
          {user ? user.name : 'User'}
        </Typography>
        <Typography className={classes.userEmail} variant="body2">
          {user ? user.email : 'user@example.com'}
        </Typography>
      </div>
      <Divider />
      <div className={classes.drawerContainer}>
        <List>
          <ListItem button component={Link} to="/" selected={isActive('/')}>
            <ListItemIcon>
              <DashboardIcon />
            </ListItemIcon>
            <ListItemText primary="Dashboard" />
          </ListItem>

          <ListItem button onClick={handleAccountsClick}>
            <ListItemIcon>
              <AccountsIcon />
            </ListItemIcon>
            <ListItemText primary="Accounts & Transactions" />
            {accountsOpen ? <ExpandLess /> : <ExpandMore />}
          </ListItem>
          <Collapse in={accountsOpen} timeout="auto" unmountOnExit>
            <List component="div" disablePadding>
              <ListItem button className={classes.nested} component={Link} to="/accounts" selected={isActive('/accounts')}>
                <ListItemIcon>
                  <AccountsIcon />
                </ListItemIcon>
                <ListItemText primary="Accounts" />
              </ListItem>
              <ListItem button className={classes.nested} component={Link} to="/transactions" selected={isActive('/transactions')}>
                <ListItemIcon>
                  <TransactionsIcon />
                </ListItemIcon>
                <ListItemText primary="Transactions" />
              </ListItem>
              <ListItem button className={classes.nested} component={Link} to="/connections" selected={isActive('/connections')}>
                <ListItemIcon>
                  <ConnectionsIcon />
                </ListItemIcon>
                <ListItemText primary="Connections" />
              </ListItem>
              <ListItem button className={classes.nested} component={Link} to="/import" selected={isActive('/import')}>
                <ListItemIcon>
                  <ImportIcon />
                </ListItemIcon>
                <ListItemText primary="Import Data" />
              </ListItem>
            </List>
          </Collapse>

          <ListItem button component={Link} to="/budget" selected={isActive('/budget')}>
            <ListItemIcon>
              <BudgetIcon />
            </ListItemIcon>
            <ListItemText primary="Budget" />
          </ListItem>

          <ListItem button component={Link} to="/goals" selected={isActive('/goals')}>
            <ListItemIcon>
              <GoalsIcon />
            </ListItemIcon>
            <ListItemText primary="Goals" />
          </ListItem>

          <ListItem button component={Link} to="/investments" selected={isActive('/investments')}>
            <ListItemIcon>
              <InvestmentsIcon />
            </ListItemIcon>
            <ListItemText primary="Investments" />
          </ListItem>

          <ListItem button component={Link} to="/reports" selected={isActive('/reports')}>
            <ListItemIcon>
              <ReportsIcon />
            </ListItemIcon>
            <ListItemText primary="Reports" />
          </ListItem>

          <ListItem button component={Link} to="/kpis" selected={isActive('/kpis')}>
            <ListItemIcon>
              <KPIsIcon />
            </ListItemIcon>
            <ListItemText primary="KPIs" />
          </ListItem>

          <ListItem button onClick={handlePlanningClick}>
            <ListItemIcon>
              <PlanningIcon />
            </ListItemIcon>
            <ListItemText primary="Planning & Investments" />
            {planningOpen ? <ExpandLess /> : <ExpandMore />}
          </ListItem>
          <Collapse in={planningOpen} timeout="auto" unmountOnExit>
            <List component="div" disablePadding>
              <ListItem button className={classes.nested} component={Link} to="/planning/financial-independence" selected={isActive('/planning/financial-independence')}>
                <ListItemIcon>
                  <PlanningIcon />
                </ListItemIcon>
                <ListItemText primary="Financial Independence" />
              </ListItem>
              <ListItem button className={classes.nested} component={Link} to="/planning/retirement" selected={isActive('/planning/retirement')}>
                <ListItemIcon>
                  <PlanningIcon />
                </ListItemIcon>
                <ListItemText primary="Retirement Planning" />
              </ListItem>
              <ListItem button className={classes.nested} component={Link} to="/planning/debt-payoff" selected={isActive('/planning/debt-payoff')}>
                <ListItemIcon>
                  <PlanningIcon />
                </ListItemIcon>
                <ListItemText primary="Debt Payoff" />
              </ListItem>
            </List>
          </Collapse>
        </List>
        <Divider />
        <List>
          <ListItem button component={Link} to="/profile" selected={isActive('/profile')}>
            <ListItemIcon>
              <ProfileIcon />
            </ListItemIcon>
            <ListItemText primary="Profile" />
          </ListItem>
          <ListItem button component={Link} to="/settings" selected={isActive('/settings')}>
            <ListItemIcon>
              <SettingsIcon />
            </ListItemIcon>
            <ListItemText primary="Settings" />
          </ListItem>
          <ListItem button onClick={handleLogout}>
            <ListItemIcon>
              <LogoutIcon />
            </ListItemIcon>
            <ListItemText primary="Logout" />
          </ListItem>
        </List>
      </div>
    </div>
  );

  return (
    <div className={classes.root}>
      <AppBar position="fixed" className={classes.appBar}>
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            className={classes.menuButton}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" noWrap className={classes.title}>
            Finance Manager
          </Typography>
        </Toolbar>
      </AppBar>
      
      {/* Mobile drawer */}
      <Drawer
        variant="temporary"
        open={mobileOpen}
        onClose={handleDrawerToggle}
        classes={{
          paper: classes.drawerPaper,
        }}
        ModalProps={{
          keepMounted: true, // Better open performance on mobile
        }}
        sx={{
          display: { xs: 'block', sm: 'none' },
        }}
      >
        {drawer}
      </Drawer>
      
      {/* Desktop drawer */}
      <Drawer
        className={classes.drawer}
        variant="permanent"
        classes={{
          paper: classes.drawerPaper,
        }}
        sx={{
          display: { xs: 'none', sm: 'block' },
        }}
        open
      >
        <div className={classes.toolbar} />
        {drawer}
      </Drawer>
      
      <main className={classes.content}>
        <div className={classes.toolbar} />
        <Container maxWidth="xl">
          {children}
        </Container>
      </main>
    </div>
  );
};

export default MainLayout;
EOF

# Create KPIs.js (renamed from Advanced KPIs)
cat > ${INSTALL_DIR}/frontend/src/pages/KPIs.js << 'EOF'
import React, { useState, useEffect } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Box,
  Tabs,
  Tab,
  CircularProgress,
  Divider,
  Card,
  CardContent,
  CardHeader,
  IconButton,
  Tooltip
} from '@material-ui/core';
import {
  Refresh as RefreshIcon,
  Info as InfoIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

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
  subtitle: {
    marginBottom: theme.spacing(3),
    color: theme.palette.text.secondary,
  },
  tabsContainer: {
    marginBottom: theme.spacing(3),
  },
  card: {
    height: '100%',
    display: 'flex',
    flexDirection: 'column',
  },
  cardHeader: {
    backgroundColor: theme.palette.primary.light,
    color: theme.palette.primary.contrastText,
  },
  cardContent: {
    flexGrow: 1,
  },
  kpiValue: {
    fontSize: '2rem',
    fontWeight: 'bold',
    marginBottom: theme.spacing(1),
    color: theme.palette.primary.main,
  },
  kpiChange: {
    display: 'flex',
    alignItems: 'center',
    marginBottom: theme.spacing(1),
  },
  positiveChange: {
    color: theme.palette.success.main,
  },
  negativeChange: {
    color: theme.palette.error.main,
  },
  neutralChange: {
    color: theme.palette.text.secondary,
  },
  kpiDescription: {
    marginTop: theme.spacing(2),
    color: theme.palette.text.secondary,
  },
  divider: {
    margin: theme.spacing(2, 0),
  },
  loadingContainer: {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    height: '50vh',
  },
  sectionHeader: {
    marginTop: theme.spacing(4),
    marginBottom: theme.spacing(2),
  },
  headerActions: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: theme.spacing(3),
  },
}));

// Sample KPI data
const kpiData = {
  overview: [
    {
      id: 1,
      title: 'Net Worth',
      value: 250000,
      change: 3.2,
      period: 'month',
      description: 'Total assets minus total liabilities',
      tooltip: 'Net Worth = Total Assets - Total Liabilities'
    },
    {
      id: 2,
      title: 'Savings Rate',
      value: 30.8,
      change: 1.5,
      period: 'month',
      description: 'Percentage of income saved',
      tooltip: 'Savings Rate = (Income - Expenses) / Income × 100%',
      format: 'percent'
    },
    {
      id: 3,
      title: 'Debt-to-Income Ratio',
      value: 28.5,
      change: -2.1,
      period: 'month',
      description: 'Monthly debt payments divided by monthly income',
      tooltip: 'DTI = Total Monthly Debt Payments / Gross Monthly Income × 100%',
      format: 'percent',
      inverted: true
    },
    {
      id: 4,
      title: 'Emergency Fund Ratio',
      value: 4.2,
      change: 0.3,
      period: 'month',
      description: 'Months of expenses covered by emergency fund',
      tooltip: 'Emergency Fund Ratio = Emergency Fund / Monthly Expenses'
    }
  ],
  financialIndependence: [
    {
      id: 5,
      title: 'Financial Independence Index',
      value: 25,
      change: 2.0,
      period: 'quarter',
      description: 'Progress toward financial independence',
      tooltip: 'FI Index = (Current Net Worth / Financial Independence Number) × 100%',
      format: 'percent'
    },
    {
      id: 6,
      title: 'Financial Freedom Number',
      value: 1000000,
      change: 0,
      period: 'year',
      description: 'Target net worth for financial independence',
      tooltip: 'Financial Freedom Number = Annual Expenses × 25'
    },
    {
      id: 7,
      title: 'Years to Financial Independence',
      value: 15.3,
      change: -0.5,
      period: 'quarter',
      description: 'Estimated years until financial independence',
      tooltip: 'Based on current savings rate and investment returns',
      inverted: true
    },
    {
      id: 8,
      title: 'Safe Withdrawal Rate',
      value: 4.0,
      change: 0,
      period: 'year',
      description: 'Sustainable withdrawal rate in retirement',
      tooltip: 'Traditional SWR = 4% based on the Trinity Study',
      format: 'percent'
    }
  ],
  trends: [
    {
      id: 9,
      title: 'Income Growth Rate',
      value: 5.2,
      change: 1.1,
      period: 'year',
      description: 'Annual growth rate of income',
      tooltip: 'Income Growth Rate = (Current Income - Previous Income) / Previous Income × 100%',
      format: 'percent'
    },
    {
      id: 10,
      title: 'Expense Growth Rate',
      value: 2.8,
      change: -0.3,
      period: 'year',
      description: 'Annual growth rate of expenses',
      tooltip: 'Expense Growth Rate = (Current Expenses - Previous Expenses) / Previous Expenses × 100%',
      format: 'percent',
      inverted: true
    },
    {
      id: 11,
      title: 'Net Worth Growth Rate',
      value: 12.5,
      change: 1.8,
      period: 'year',
      description: 'Annual growth rate of net worth',
      tooltip: 'Net Worth Growth Rate = (Current Net Worth - Previous Net Worth) / Previous Net Worth × 100%',
      format: 'percent'
    },
    {
      id: 12,
      title: 'Investment Return Rate',
      value: 8.7,
      change: 0.9,
      period: 'year',
      description: 'Annual return on investments',
      tooltip: 'Investment Return Rate = (Current Value - Previous Value - Contributions) / Previous Value × 100%',
      format: 'percent'
    }
  ],
  financialHealth: [
    {
      id: 13,
      title: 'Debt-to-Asset Ratio',
      value: 32.4,
      change: -1.5,
      period: 'quarter',
      description: 'Total debt divided by total assets',
      tooltip: 'Debt-to-Asset Ratio = Total Debt / Total Assets × 100%',
      format: 'percent',
      inverted: true
    },
    {
      id: 14,
      title: 'Liquidity Ratio',
      value: 2.8,
      change: 0.2,
      period: 'month',
      description: 'Liquid assets divided by monthly expenses',
      tooltip: 'Liquidity Ratio = Liquid Assets / Monthly Expenses'
    },
    {
      id: 15,
      title: 'Credit Utilization',
      value: 15.3,
      change: -3.2,
      period: 'month',
      description: 'Credit used divided by total available credit',
      tooltip: 'Credit Utilization = Total Credit Used / Total Available Credit × 100%',
      format: 'percent',
      inverted: true
    },
    {
      id: 16,
      title: 'Financial Stress Index',
      value: 22.5,
      change: -5.0,
      period: 'quarter',
      description: 'Composite measure of financial stress factors',
      tooltip: 'Lower values indicate less financial stress',
      format: 'percent',
      inverted: true
    }
  ]
};

const KPIs = () => {
  const classes = useStyles();
  const [tabValue, setTabValue] = useState(0);
  const [loading, setLoading] = useState(false);
  
  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };
  
  const handleRefresh = () => {
    setLoading(true);
    // Simulate API call
    setTimeout(() => {
      setLoading(false);
    }, 1000);
  };
  
  const formatValue = (kpi) => {
    if (kpi.format === 'percent') {
      return `${kpi.value}%`;
    } else if (kpi.value >= 1000) {
      return `$${kpi.value.toLocaleString()}`;
    } else {
      return kpi.value.toLocaleString();
    }
  };
  
  const getChangeColor = (kpi) => {
    if (kpi.change === 0) return classes.neutralChange;
    if (kpi.inverted) {
      return kpi.change < 0 ? classes.positiveChange : classes.negativeChange;
    } else {
      return kpi.change > 0 ? classes.positiveChange : classes.negativeChange;
    }
  };
  
  const getChangeSymbol = (kpi) => {
    if (kpi.change === 0) return '';
    if (kpi.inverted) {
      return kpi.change < 0 ? '↓' : '↑';
    } else {
      return kpi.change > 0 ? '↑' : '↓';
    }
  };
  
  const renderKPICards = (kpis) => {
    return (
      <Grid container spacing={3}>
        {kpis.map((kpi) => (
          <Grid item xs={12} sm={6} md={3} key={kpi.id}>
            <Card className={classes.card}>
              <CardHeader
                title={kpi.title}
                className={classes.cardHeader}
                action={
                  <Tooltip title={kpi.tooltip}>
                    <IconButton size="small" aria-label="info">
                      <InfoIcon fontSize="small" />
                    </IconButton>
                  </Tooltip>
                }
              />
              <CardContent className={classes.cardContent}>
                <Typography className={classes.kpiValue}>
                  {formatValue(kpi)}
                </Typography>
                <Typography className={`${classes.kpiChange} ${getChangeColor(kpi)}`}>
                  {getChangeSymbol(kpi)} {Math.abs(kpi.change)}% from last {kpi.period}
                </Typography>
                <Divider className={classes.divider} />
                <Typography variant="body2" className={classes.kpiDescription}>
                  {kpi.description}
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>
    );
  };
  
  return (
    <div className={classes.root}>
      <div className={classes.headerActions}>
        <div>
          <Typography variant="h4" component="h1" className={classes.title}>
            Financial KPIs
          </Typography>
          <Typography variant="subtitle1" className={classes.subtitle}>
            Track and analyze your key financial performance indicators to optimize your financial health and progress toward financial independence.
          </Typography>
        </div>
        <Tooltip title="Refresh data">
          <IconButton onClick={handleRefresh} disabled={loading}>
            {loading ? <CircularProgress size={24} /> : <RefreshIcon />}
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
          <Tab label="Overview" />
          <Tab label="Financial Independence" />
          <Tab label="Trends" />
          <Tab label="Financial Health" />
        </Tabs>
      </Paper>
      
      {loading ? (
        <div className={classes.loadingContainer}>
          <CircularProgress />
        </div>
      ) : (
        <>
          {tabValue === 0 && renderKPICards(kpiData.overview)}
          {tabValue === 1 && renderKPICards(kpiData.financialIndependence)}
          {tabValue === 2 && renderKPICards(kpiData.trends)}
          {tabValue === 3 && renderKPICards(kpiData.financialHealth)}
        </>
      )}
    </div>
  );
};

export default KPIs;
EOF

# Create Reports.js with financial statement summaries
cat > ${INSTALL_DIR}/frontend/src/pages/Reports.js << 'EOF'
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
EOF

# Create Goals.js with vision board layout
cat > ${INSTALL_DIR}/frontend/src/pages/Goals.js << 'EOF'
import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Box,
  Tabs,
  Tab,
  Card,
  CardContent,
  CardMedia,
  Divider,
  TextField,
  Button,
  IconButton
} from '@material-ui/core';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Image as ImageIcon
} from '@material-ui/icons';

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
  title: {
    marginBottom: theme.spacing(3),
  },
  tabsContainer: {
    marginBottom: theme.spacing(3),
  },
  card: {
    height: '100%',
    display: 'flex',
    flexDirection: 'column',
    position: 'relative',
  },
  cardMedia: {
    paddingTop: '56.25%', // 16:9
    backgroundSize: 'cover',
    backgroundPosition: 'center',
  },
  cardContent: {
    flexGrow: 1,
  },
  cardActions: {
    display: 'flex',
    justifyContent: 'flex-end',
    padding: theme.spacing(1),
  },
  addButton: {
    marginTop: theme.spacing(2),
  },
  categoryTitle: {
    marginTop: theme.spacing(4),
    marginBottom: theme.spacing(2),
    position: 'relative',
    '&:after': {
      content: '""',
      position: 'absolute',
      bottom: -8,
      left: 0,
      width: 60,
      height: 4,
      backgroundColor: theme.palette.primary.main,
    },
  },
  visionQuote: {
    fontStyle: 'italic',
    color: theme.palette.text.secondary,
    marginBottom: theme.spacing(4),
    padding: theme.spacing(2),
    borderLeft: `4px solid ${theme.palette.primary.main}`,
    backgroundColor: theme.palette.background.default,
  },
  goalDescription: {
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(1),
  },
  goalDeadline: {
    color: theme.palette.text.secondary,
    fontSize: '0.875rem',
  },
  goalCategory: {
    position: 'absolute',
    top: theme.spacing(1),
    right: theme.spacing(1),
    backgroundColor: theme.palette.primary.main,
    color: theme.palette.primary.contrastText,
    padding: theme.spacing(0.5, 1),
    borderRadius: theme.spacing(1),
    fontSize: '0.75rem',
  },
  addCategoryButton: {
    marginBottom: theme.spacing(3),
  },
  divider: {
    margin: theme.spacing(4, 0),
  },
  visionBoard: {
    marginTop: theme.spacing(4),
  },
  visionBoardHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: theme.spacing(3),
  },
  visionImage: {
    height: 200,
    backgroundSize: 'cover',
    backgroundPosition: 'center',
    borderRadius: theme.shape.borderRadius,
    position: 'relative',
    cursor: 'pointer',
    '&:hover $visionImageOverlay': {
      opacity: 1,
    },
  },
  visionImageOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    width: '100%',
    height: '100%',
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    opacity: 0,
    transition: 'opacity 0.3s ease',
    borderRadius: theme.shape.borderRadius,
  },
  visionImageActions: {
    display: 'flex',
  },
  visionImageActionButton: {
    color: 'white',
    margin: theme.spacing(0, 1),
  },
  categorySection: {
    marginBottom: theme.spacing(4),
  },
  categoryHeader: {
    display: 'flex',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: theme.spacing(2),
  },
  visionText: {
    marginTop: theme.spacing(2),
    padding: theme.spacing(2),
    backgroundColor: theme.palette.background.default,
    borderRadius: theme.shape.borderRadius,
  },
}));

// Sample vision board categories
const categories = [
  { id: 1, name: 'Health & Fitness' },
  { id: 2, name: 'Intellectual Life' },
  { id: 3, name: 'Emotional Life' },
  { id: 4, name: 'Character' },
  { id: 5, name: 'Spiritual Life' },
  { id: 6, name: 'Love Relationship' },
  { id: 7, name: 'Parenting' },
  { id: 8, name: 'Social Life' },
  { id: 9, name: 'Financial' },
  { id: 10, name: 'Career' },
  { id: 11, name: 'Quality of Life' },
  { id: 12, name: 'Life Vision' },
];

// Sample vision board images
const visionImages = [
  { id: 1, category: 1, url: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Morning Run' },
  { id: 2, category: 9, url: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Financial Freedom' },
  { id: 3, category: 10, url: 'https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Career Growth' },
  { id: 4, category: 11, url: 'https://images.unsplash.com/photo-1493246507139-91e8fad9978e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Dream Home' },
  { id: 5, category: 6, url: 'https://images.unsplash.com/photo-1516589178581-6cd7833ae3b2?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Loving Relationship' },
  { id: 6, category: 2, url: 'https://images.unsplash.com/photo-1512820790803-83ca734da794?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60', title: 'Continuous Learning' },
];

// Sample vision statements
const visionStatements = {
  1: 'I am in the best shape of my life, exercising regularly and eating nutritious foods that fuel my body. I have abundant energy and vitality.',
  2: 'I am constantly learning and growing intellectually. I read regularly, take courses, and engage in stimulating conversations.',
  3: 'I am emotionally balanced and resilient. I process my feelings in healthy ways and maintain a positive outlook on life.',
  4: 'I live with integrity and strong character. My actions align with my values, and I am known for my reliability and honesty.',
  5: 'I nurture my spiritual life through regular practices that connect me to something greater than myself.',
  6: 'I have a loving, supportive relationship built on mutual respect, trust, and shared values.',
  9: 'I am financially independent with multiple streams of income. I make wise investment decisions and live abundantly while being financially responsible.',
  10: 'I have a fulfilling career that utilizes my strengths and passions. I make a positive impact and am well-compensated for my contributions.',
  11: 'I live in a beautiful home that reflects my personality and provides comfort and inspiration. I travel regularly and enjoy life\'s pleasures.',
};

const Goals = () => {
  const classes = useStyles();
  const [tabValue, setTabValue] = useState(0);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  return (
    <div className={classes.root}>
      <Typography variant="h4" component="h1" className={classes.title}>
        My Goals & Vision Board
      </Typography>

      <Paper className={classes.tabsContainer}>
        <Tabs
          value={tabValue}
          onChange={handleTabChange}
          indicatorColor="primary"
          textColor="primary"
          centered
        >
          <Tab label="Vision Board" />
          <Tab label="Financial Goals" />
          <Tab label="Goal Timeline" />
        </Tabs>
      </Paper>

      {tabValue === 0 && (
        <div className={classes.visionBoard}>
          <Typography variant="h5" className={classes.visionBoardHeader}>
            My Life Vision
            <Button
              variant="contained"
              color="primary"
              startIcon={<AddIcon />}
              size="small"
            >
              Add Category
            </Button>
          </Typography>

          <Typography className={classes.visionQuote}>
            "Your Vision refers to the ideal state you would like to achieve in this important category. Ask yourself: How do you want this area of your life to feel? What do you want it to look like? What do you want to be doing on a consistent basis? Clearly describe your ideal Vision."
          </Typography>

          {categories.map((category) => (
            <div key={category.id} className={classes.categorySection}>
              <div className={classes.categoryHeader}>
                <Typography variant="h6" className={classes.categoryTitle}>
                  {category.name}
                </Typography>
                <Button
                  variant="outlined"
                  color="primary"
                  startIcon={<AddIcon />}
                  size="small"
                >
                  Add Image
                </Button>
              </div>

              {visionStatements[category.id] && (
                <Typography className={classes.visionText}>
                  {visionStatements[category.id]}
                </Typography>
              )}

              <Grid container spacing={3} style={{ marginTop: 16 }}>
                {visionImages
                  .filter((image) => image.category === category.id)
                  .map((image) => (
                    <Grid item xs={12} sm={6} md={4} key={image.id}>
                      <div
                        className={classes.visionImage}
                        style={{ backgroundImage: `url(${image.url})` }}
                      >
                        <div className={classes.visionImageOverlay}>
                          <div className={classes.visionImageActions}>
                            <IconButton className={classes.visionImageActionButton}>
                              <EditIcon />
                            </IconButton>
                            <IconButton className={classes.visionImageActionButton}>
                              <DeleteIcon />
                            </IconButton>
                          </div>
                        </div>
                      </div>
                      <Typography variant="subtitle1" align="center" style={{ marginTop: 8 }}>
                        {image.title}
                      </Typography>
                    </Grid>
                  ))}
              </Grid>
            </div>
          ))}
        </div>
      )}

      {tabValue === 1 && (
        <div>
          <div className={classes.categoryHeader}>
            <Typography variant="h5">
              This Year's Financial Goals
            </Typography>
            <Button
              variant="contained"
              color="primary"
              startIcon={<AddIcon />}
            >
              Add Goal
            </Button>
          </div>

          <Grid container spacing={3}>
            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Savings</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Emergency Fund"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Build 6-Month Emergency Fund
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Save $15,000 for emergency fund to cover 6 months of essential expenses.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2025
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={65} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">65%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>

            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Investment</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1460925895917-afdab827c52f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Investment"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Max Out Retirement Accounts
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Contribute maximum allowed amount to 401(k) and IRA accounts.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2025
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={40} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">40%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>

            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Debt</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1563013544-824ae1b704d3?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Debt Free"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Pay Off Student Loans
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Completely pay off remaining $18,000 in student loan debt.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: June 30, 2025
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={75} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">75%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>
          </Grid>

          <Divider className={classes.divider} />

          <Typography variant="h5" className={classes.categoryTitle}>
            Long-Term Financial Goals
          </Typography>

          <Grid container spacing={3}>
            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Real Estate</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Home"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Buy Rental Property
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Purchase first rental property to generate passive income.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2027
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={25} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">25%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>

            <Grid item xs={12} sm={6} md={4}>
              <Card className={classes.card}>
                <span className={classes.goalCategory}>Financial Independence</span>
                <CardMedia
                  className={classes.cardMedia}
                  image="https://images.unsplash.com/photo-1526304640581-d334cdbbf45e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60"
                  title="Financial Independence"
                />
                <CardContent className={classes.cardContent}>
                  <Typography gutterBottom variant="h6" component="h2">
                    Achieve Financial Independence
                  </Typography>
                  <Typography className={classes.goalDescription}>
                    Build investment portfolio to generate $5,000 monthly passive income.
                  </Typography>
                  <Typography className={classes.goalDeadline}>
                    Deadline: December 31, 2035
                  </Typography>
                  <Box mt={2} display="flex" alignItems="center">
                    <Box width="100%" mr={1}>
                      <LinearProgress variant="determinate" value={15} />
                    </Box>
                    <Box minWidth={35}>
                      <Typography variant="body2" color="textSecondary">15%</Typography>
                    </Box>
                  </Box>
                </CardContent>
                <div className={classes.cardActions}>
                  <IconButton size="small" color="primary">
                    <EditIcon />
                  </IconButton>
                  <IconButton size="small" color="secondary">
                    <DeleteIcon />
                  </IconButton>
                </div>
              </Card>
            </Grid>
          </Grid>
        </div>
      )}

      {tabValue === 2 && (
        <div>
          <Typography variant="h5" gutterBottom>
            Goal Timeline
          </Typography>
          {/* Goal timeline content would go here */}
          <Typography variant="body1" color="textSecondary">
            Timeline visualization of your goals will be displayed here.
          </Typography>
        </div>
      )}
    </div>
  );
};

// Add missing LinearProgress component
const LinearProgress = ({ variant, value }) => {
  const getColor = (value) => {
    if (value < 30) return '#f44336';
    if (value < 70) return '#ff9800';
    return '#4caf50';
  };

  return (
    <div style={{ width: '100%', backgroundColor: '#e0e0e0', borderRadius: 5, height: 10 }}>
      <div
        style={{
          width: `${value}%`,
          backgroundColor: getColor(value),
          height: '100%',
          borderRadius: 5,
          transition: 'width 0.3s ease'
        }}
      />
    </div>
  );
};

export default Goals;
EOF

# Update App.js to include the new components
cat > ${INSTALL_DIR}/frontend/src/App.js << 'EOF'
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
import KPIs from './pages/KPIs';

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
            
            <PrivateRoute exact path="/kpis">
              <MainLayout>
                <KPIs />
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
EOF

echo_section "Updating port configuration"
# Update port configuration in docker-compose.yml
if [ -f "${INSTALL_DIR}/docker-compose.yml" ]; then
  sed -i "s/FRONTEND_PORT=.*/FRONTEND_PORT=${FRONTEND_PORT}/" ${INSTALL_DIR}/docker-compose.yml
  sed -i "s/BACKEND_PORT=.*/BACKEND_PORT=${BACKEND_PORT}/" ${INSTALL_DIR}/docker-compose.yml
  echo_success "Port configuration updated in docker-compose.yml"
fi

echo_section "Restarting services"
# Restart services to apply changes
cd ${INSTALL_DIR}
docker-compose down
docker-compose up -d
echo_success "Services restarted"

echo_section "Summary of Changes"
echo "1. Renamed 'Advanced KPIs' to 'KPIs' throughout the application"
echo "2. Added financial statement summaries in the Reports section"
echo "3. Redesigned the Goals page with a vision board layout"
echo "4. Updated App.js to include all new components"
echo "5. Configured ports: Frontend=${FRONTEND_PORT}, Backend=${BACKEND_PORT}"

echo -e "\n${GREEN}✓ All changes have been successfully implemented!${NC}"
echo -e "You can access your updated Finance App at: http://localhost:${FRONTEND_PORT}"
