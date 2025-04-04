import React, { useState, useEffect } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import {
  Container,
  Grid,
  Paper,
  Typography,
  Button,
  Box,
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
  TrendingUp as TrendingUpIcon,
  TrendingDown as TrendingDownIcon,
  ArrowUpward as ArrowUpwardIcon,
  ArrowDownward as ArrowDownwardIcon,
  Info as InfoIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import NetWorthChart from '../components/dashboard/NetWorthChart';
import CashFlowChart from '../components/dashboard/CashFlowChart';
import ExpenseBreakdownChart from '../components/dashboard/ExpenseBreakdownChart';
import AssetAllocationChart from '../components/dashboard/AssetAllocationChart';
import RecentTransactions from '../components/dashboard/RecentTransactions';
import BudgetProgress from '../components/dashboard/BudgetProgress';
import FinancialHealthCard from '../components/dashboard/FinancialHealthCard';
import AccountsList from '../components/dashboard/AccountsList';
import GoalProgress from '../components/dashboard/GoalProgress';

// Actions
import { getDashboardData } from '../actions/dashboardActions';
import { getFinancialSummary } from '../actions/dashboardActions';
import { getCashFlowData } from '../actions/dashboardActions';
import { getExpenseBreakdown } from '../actions/dashboardActions';

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
    padding: theme.spacing(3),
  },
  paper: {
    padding: theme.spacing(2),
    height: '100%',
  },
  title: {
    marginBottom: theme.spacing(2),
  },
  kpiCard: {
    height: '100%',
    position: 'relative',
  },
  kpiValue: {
    fontWeight: 'bold',
    fontSize: '1.8rem',
  },
  kpiLabel: {
    color: theme.palette.text.secondary,
    fontSize: '0.9rem',
  },
  kpiChange: {
    display: 'flex',
    alignItems: 'center',
    marginTop: theme.spacing(1),
  },
  positive: {
    color: theme.palette.success.main,
  },
  negative: {
    color: theme.palette.error.main,
  },
  chartContainer: {
    height: 300,
    marginTop: theme.spacing(2),
  },
  refreshButton: {
    marginLeft: 'auto',
  },
  sectionHeader: {
    display: 'flex',
    alignItems: 'center',
    marginBottom: theme.spacing(2),
  },
  divider: {
    margin: theme.spacing(3, 0),
  },
  loadingContainer: {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100vh',
  },
}));

const Dashboard = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  
  const { dashboardData, financialSummary, cashFlowData, expenseBreakdown } = useSelector(
    (state) => state.dashboard
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await Promise.all([
        dispatch(getDashboardData()),
        dispatch(getFinancialSummary()),
        dispatch(getCashFlowData()),
        dispatch(getExpenseBreakdown())
      ]);
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleRefresh = () => {
    dispatch(getDashboardData());
    dispatch(getFinancialSummary());
    dispatch(getCashFlowData());
    dispatch(getExpenseBreakdown());
  };

  if (loading) {
    return (
      <div className={classes.loadingContainer}>
        <CircularProgress />
      </div>
    );
  }

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Financial Dashboard
        </Typography>
        <Tooltip title="Refresh data">
          <IconButton className={classes.refreshButton} onClick={handleRefresh}>
            <RefreshIcon />
          </IconButton>
        </Tooltip>
      </div>

      {/* KPI Cards */}
      <Grid container spacing={3}>
        {/* Net Worth KPI */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.kpiCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Net Worth
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                ${dashboardData?.net_worth?.value.toLocaleString() || '0'}
              </Typography>
              <div className={classes.kpiChange}>
                {dashboardData?.net_worth?.change_type === 'positive' ? (
                  <ArrowUpwardIcon className={classes.positive} fontSize="small" />
                ) : (
                  <ArrowDownwardIcon className={classes.negative} fontSize="small" />
                )}
                <Typography
                  variant="body2"
                  className={
                    dashboardData?.net_worth?.change_type === 'positive'
                      ? classes.positive
                      : classes.negative
                  }
                >
                  {Math.abs(dashboardData?.net_worth?.change || 0).toFixed(2)}%
                </Typography>
              </div>
            </CardContent>
          </Paper>
        </Grid>

        {/* Monthly Income KPI */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.kpiCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Monthly Income
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                ${dashboardData?.monthly_income?.value.toLocaleString() || '0'}
              </Typography>
              <div className={classes.kpiChange}>
                {dashboardData?.monthly_income?.change_type === 'positive' ? (
                  <ArrowUpwardIcon className={classes.positive} fontSize="small" />
                ) : (
                  <ArrowDownwardIcon className={classes.negative} fontSize="small" />
                )}
                <Typography
                  variant="body2"
                  className={
                    dashboardData?.monthly_income?.change_type === 'positive'
                      ? classes.positive
                      : classes.negative
                  }
                >
                  {Math.abs(dashboardData?.monthly_income?.change || 0).toFixed(2)}%
                </Typography>
              </div>
            </CardContent>
          </Paper>
        </Grid>

        {/* Monthly Expenses KPI */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.kpiCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Monthly Expenses
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                ${dashboardData?.monthly_expenses?.value.toLocaleString() || '0'}
              </Typography>
              <div className={classes.kpiChange}>
                {dashboardData?.monthly_expenses?.change_type === 'positive' ? (
                  <ArrowUpwardIcon className={classes.positive} fontSize="small" />
                ) : (
                  <ArrowDownwardIcon className={classes.negative} fontSize="small" />
                )}
                <Typography
                  variant="body2"
                  className={
                    dashboardData?.monthly_expenses?.change_type === 'positive'
                      ? classes.positive
                      : classes.negative
                  }
                >
                  {Math.abs(dashboardData?.monthly_expenses?.change || 0).toFixed(2)}%
                </Typography>
              </div>
            </CardContent>
          </Paper>
        </Grid>

        {/* Savings Rate KPI */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.kpiCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Savings Rate
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                {dashboardData?.savings_rate?.value.toFixed(2) || '0'}%
              </Typography>
              <div className={classes.kpiChange}>
                {dashboardData?.savings_rate?.change_type === 'positive' ? (
                  <ArrowUpwardIcon className={classes.positive} fontSize="small" />
                ) : (
                  <ArrowDownwardIcon className={classes.negative} fontSize="small" />
                )}
                <Typography
                  variant="body2"
                  className={
                    dashboardData?.savings_rate?.change_type === 'positive'
                      ? classes.positive
                      : classes.negative
                  }
                >
                  {Math.abs(dashboardData?.savings_rate?.change || 0).toFixed(2)}%
                </Typography>
              </div>
            </CardContent>
          </Paper>
        </Grid>
      </Grid>

      <Divider className={classes.divider} />

      {/* Charts Section */}
      <Grid container spacing={3}>
        {/* Net Worth Chart */}
        <Grid item xs={12} md={6}>
          <Paper className={classes.paper}>
            <Typography variant="h6" gutterBottom>
              Net Worth Trend
            </Typography>
            <div className={classes.chartContainer}>
              <NetWorthChart data={financialSummary?.net_worth_history || []} />
            </div>
          </Paper>
        </Grid>

        {/* Cash Flow Chart */}
        <Grid item xs={12} md={6}>
          <Paper className={classes.paper}>
            <Typography variant="h6" gutterBottom>
              Cash Flow
            </Typography>
            <div className={classes.chartContainer}>
              <CashFlowChart data={cashFlowData || []} />
            </div>
          </Paper>
        </Grid>

        {/* Expense Breakdown */}
        <Grid item xs={12} md={6}>
          <Paper className={classes.paper}>
            <Typography variant="h6" gutterBottom>
              Expense Breakdown
            </Typography>
            <div className={classes.chartContainer}>
              <ExpenseBreakdownChart data={expenseBreakdown?.breakdown || []} />
            </div>
          </Paper>
        </Grid>

        {/* Asset Allocation */}
        <Grid item xs={12} md={6}>
          <Paper className={classes.paper}>
            <Typography variant="h6" gutterBottom>
              Asset Allocation
            </Typography>
            <div className={classes.chartContainer}>
              <AssetAllocationChart data={financialSummary?.asset_allocation || []} />
            </div>
          </Paper>
        </Grid>
      </Grid>

      <Divider className={classes.divider} />

      {/* Financial Health and Accounts */}
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <FinancialHealthCard />
        </Grid>
        <Grid item xs={12} md={6}>
          <AccountsList accounts={dashboardData?.accounts || []} />
        </Grid>
      </Grid>

      <Divider className={classes.divider} />

      {/* Budget Progress and Goals */}
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <BudgetProgress />
        </Grid>
        <Grid item xs={12} md={6}>
          <GoalProgress />
        </Grid>
      </Grid>

      <Divider className={classes.divider} />

      {/* Recent Transactions */}
      <Grid container spacing={3}>
        <Grid item xs={12}>
          <Paper className={classes.paper}>
            <Typography variant="h6" gutterBottom>
              Recent Transactions
            </Typography>
            <RecentTransactions transactions={dashboardData?.recent_transactions || []} />
          </Paper>
        </Grid>
      </Grid>
    </div>
  );
};

export default Dashboard;
