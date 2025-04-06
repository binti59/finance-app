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
