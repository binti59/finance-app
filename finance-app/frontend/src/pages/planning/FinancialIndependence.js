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
  Tooltip,
  Tabs,
  Tab,
  LinearProgress,
  Slider,
  TextField,
  FormControl,
  InputLabel,
  Select,
  MenuItem
} from '@material-ui/core';
import {
  Add as AddIcon,
  Refresh as RefreshIcon,
  Timeline as TimelineIcon,
  TrendingUp as TrendingUpIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import FinancialIndependenceChart from '../components/planning/FinancialIndependenceChart';
import FreedomNumberCalculator from '../components/planning/FreedomNumberCalculator';
import RetirementProjection from '../components/planning/RetirementProjection';
import FIRECalculator from '../components/planning/FIRECalculator';
import SavingsRateChart from '../components/planning/SavingsRateChart';
import MilestoneTimeline from '../components/planning/MilestoneTimeline';

// Actions
import { 
  getFinancialIndependenceIndex,
  getFinancialFreedomNumber,
  getNetWorth,
  getSavingsRate
} from '../actions/kpiActions';

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
  sectionHeader: {
    display: 'flex',
    alignItems: 'center',
    marginBottom: theme.spacing(2),
  },
  actionButton: {
    marginLeft: theme.spacing(1),
  },
  tabs: {
    marginBottom: theme.spacing(2),
  },
  loadingContainer: {
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    height: '50vh',
  },
  spacer: {
    flexGrow: 1,
  },
  divider: {
    margin: theme.spacing(3, 0),
  },
  chartContainer: {
    height: 300,
    marginTop: theme.spacing(2),
  },
  summaryCard: {
    marginBottom: theme.spacing(2),
  },
  kpiValue: {
    fontWeight: 'bold',
    fontSize: '1.8rem',
  },
  kpiLabel: {
    color: theme.palette.text.secondary,
    fontSize: '0.9rem',
  },
  positive: {
    color: theme.palette.success.main,
  },
  negative: {
    color: theme.palette.error.main,
  },
  formControl: {
    marginBottom: theme.spacing(2),
    minWidth: 200,
  },
  sliderContainer: {
    marginTop: theme.spacing(4),
    marginBottom: theme.spacing(2),
  },
  sliderLabel: {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: theme.spacing(1),
  },
  inputField: {
    marginBottom: theme.spacing(2),
  },
  calculatorContainer: {
    marginTop: theme.spacing(2),
  },
  progressContainer: {
    marginTop: theme.spacing(2),
    marginBottom: theme.spacing(2),
  },
  progressLabel: {
    display: 'flex',
    justifyContent: 'space-between',
    marginBottom: theme.spacing(1),
  },
}));

const FinancialIndependence = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [calculatorInputs, setCalculatorInputs] = useState({
    annual_expenses: 50000,
    withdrawal_rate: 4,
    current_savings: 0,
    monthly_contribution: 1000,
    expected_return: 7
  });
  
  const { fiIndex, netWorth, freedomNumber, savingsRate } = useSelector(
    (state) => state.kpi
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await Promise.all([
        dispatch(getFinancialIndependenceIndex()),
        dispatch(getFinancialFreedomNumber()),
        dispatch(getNetWorth()),
        dispatch(getSavingsRate())
      ]);
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleInputChange = (name) => (event) => {
    setCalculatorInputs({
      ...calculatorInputs,
      [name]: parseFloat(event.target.value)
    });
  };

  const handleSliderChange = (name) => (event, newValue) => {
    setCalculatorInputs({
      ...calculatorInputs,
      [name]: newValue
    });
  };

  const handleRefresh = () => {
    dispatch(getFinancialIndependenceIndex());
    dispatch(getFinancialFreedomNumber());
    dispatch(getNetWorth());
    dispatch(getSavingsRate());
  };

  const calculateYearsToFI = () => {
    const { annual_expenses, withdrawal_rate, current_savings, monthly_contribution, expected_return } = calculatorInputs;
    
    // Calculate freedom number
    const targetAmount = annual_expenses / (withdrawal_rate / 100);
    
    // Calculate years to reach target
    const monthlyReturn = expected_return / 100 / 12;
    let currentAmount = current_savings;
    let months = 0;
    
    while (currentAmount < targetAmount && months < 1200) { // Cap at 100 years
      currentAmount = currentAmount * (1 + monthlyReturn) + monthly_contribution;
      months++;
    }
    
    return {
      targetAmount,
      years: months / 12,
      currentAmount: current_savings,
      progressPercentage: (current_savings / targetAmount) * 100
    };
  };

  const fiCalculation = calculateYearsToFI();

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Financial Independence Planning
        </Typography>
        <div className={classes.spacer} />
        <Tooltip title="Refresh">
          <IconButton className={classes.actionButton} onClick={handleRefresh}>
            <RefreshIcon />
          </IconButton>
        </Tooltip>
      </div>

      {/* Summary Cards */}
      <Grid container spacing={3}>
        {/* FI Index */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                FI Index
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                {fiIndex?.fi_index?.toFixed(2) || '0'}%
              </Typography>
              <Typography variant="body2" color="textSecondary">
                Progress to Financial Independence
              </Typography>
            </CardContent>
          </Paper>
        </Grid>

        {/* Freedom Number */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Freedom Number
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                ${freedomNumber?.freedom_number?.toLocaleString() || '0'}
              </Typography>
              <Typography variant="body2" color="textSecondary">
                Target for Financial Independence
              </Typography>
            </CardContent>
          </Paper>
        </Grid>

        {/* Current Net Worth */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Current Net Worth
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                ${netWorth?.current_net_worth?.toLocaleString() || '0'}
              </Typography>
              <Typography variant="body2" color="textSecondary">
                {netWorth?.monthly_growth >= 0 ? '+' : ''}
                {netWorth?.monthly_growth?.toFixed(2) || '0'}% this month
              </Typography>
            </CardContent>
          </Paper>
        </Grid>

        {/* Savings Rate */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Savings Rate
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                {savingsRate?.current_savings_rate?.toFixed(2) || '0'}%
              </Typography>
              <Typography variant="body2" color="textSecondary">
                Avg: {savingsRate?.average_savings_rate?.toFixed(2) || '0'}%
              </Typography>
            </CardContent>
          </Paper>
        </Grid>
      </Grid>

      <Tabs
        value={tabValue}
        onChange={handleTabChange}
        indicatorColor="primary"
        textColor="primary"
        className={classes.tabs}
      >
        <Tab label="FI Progress" />
        <Tab label="FIRE Calculator" />
        <Tab label="Retirement Planning" />
        <Tab label="Milestones" />
      </Tabs>

      {loading ? (
        <div className={classes.loadingContainer}>
          <CircularProgress />
        </div>
      ) : (
        <>
          {tabValue === 0 && (
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Financial Independence Progress
                  </Typography>
                  <div className={classes.progressContainer}>
                    <div className={classes.progressLabel}>
                      <Typography variant="body2">Current: ${netWorth?.current_net_worth?.toLocaleString() || '0'}</Typography>
                      <Typography variant="body2">Target: ${freedomNumber?.freedom_number?.toLocaleString() || '0'}</Typography>
                    </div>
                    <LinearProgress 
                      variant="determinate" 
                      value={Math.min(fiIndex?.fi_index || 0, 100)} 
                      color="primary"
                    />
                    <Typography variant="body2" align="center" style={{ marginTop: 8 }}>
                      {fiIndex?.fi_index?.toFixed(2) || '0'}% Complete
                    </Typography>
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Net Worth Growth
                  </Typography>
                  <div className={classes.chartContainer}>
                    <FinancialIndependenceChart data={fiIndex?.historical_data || []} targetAmount={freedomNumber?.freedom_number || 0} />
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Savings Rate Trend
                  </Typography>
                  <div className={classes.chartContainer}>
                    <SavingsRateChart data={savingsRate?.historical_data || []} />
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Freedom Number Calculator
                  </Typography>
                  <FreedomNumberCalculator />
                </Paper>
              </Grid>
            </Grid>
          )}

          {tabValue === 1 && (
            <Grid container spacing={3}>
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    FIRE Calculator
                  </Typography>
                  <div className={classes.calculatorContainer}>
                    <TextField
                      label="Annual Expenses"
                      type="number"
                      InputProps={{ startAdornment: '$' }}
                      value={calculatorInputs.annual_expenses}
                      onChange={handleInputChange('annual_expenses')}
                      fullWidth
                      className={classes.inputField}
                    />
                    
                    <div className={classes.sliderContainer}>
                      <div className={classes.sliderLabel}>
                        <Typography id="withdrawal-rate-slider" gutterBottom>
                          Withdrawal Rate
                        </Typography>
                        <Typography gutterBottom>
                          {calculatorInputs.withdrawal_rate}%
                        </Typography>
                      </div>
                      <Slider
                        value={calculatorInputs.withdrawal_rate}
                        onChange={handleSliderChange('withdrawal_rate')}
                        aria-labelledby="withdrawal-rate-slider"
                        step={0.1}
                        min={2}
                        max={6}
                        marks={[
                          { value: 2, label: '2%' },
                          { value: 4, label: '4%' },
                          { value: 6, label: '6%' }
                        ]}
                      />
                    </div>
                    
                    <TextField
                      label="Current Savings"
                      type="number"
                      InputProps={{ startAdornment: '$' }}
                      value={calculatorInputs.current_savings}
                      onChange={handleInputChange('current_savings')}
                      fullWidth
                      className={classes.inputField}
                    />
                    
                    <TextField
                      label="Monthly Contribution"
                      type="number"
                      InputProps={{ startAdornment: '$' }}
                      value={calculatorInputs.monthly_contribution}
                      onChange={handleInputChange('monthly_contribution')}
                      fullWidth
                      className={classes.inputField}
                    />
                    
                    <div className={classes.sliderContainer}>
                      <div className={classes.sliderLabel}>
                        <Typography id="expected-return-slider" gutterBottom>
                          Expected Annual Return
                        </Typography>
                        <Typography gutterBottom>
                          {calculatorInputs.expected_return}%
                        </Typography>
                      </div>
                      <Slider
                        value={calculatorInputs.expected_return}
                        onChange={handleSliderChange('expected_return')}
                        aria-labelledby="expected-return-slider"
                        step={0.5}
                        min={3}
                        max={12}
                        marks={[
                          { value: 3, label: '3%' },
                          { value: 7, label: '7%' },
                          { value: 12, label: '12%' }
                        ]}
                      />
                    </div>
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Results
                  </Typography>
                  <div className={classes.calculatorContainer}>
                    <Typography variant="h5" gutterBottom>
                      Target Amount: ${fiCalculation.targetAmount.toLocaleString()}
                    </Typography>
                    
                    <Typography variant="h5" gutterBottom>
                      Time to FI: {fiCalculation.years.toFixed(1)} years
                    </Typography>
                    
                    <div className={classes.progressContainer}>
                      <div className={classes.progressLabel}>
                        <Typography variant="body2">Current: ${calculatorInputs.current_savings.toLocaleString()}</Typography>
                        <Typography variant="body2">Target: ${fiCalculation.targetAmount.toLocaleString()}</Typography>
                      </div>
                      <LinearProgress 
                        variant="determinate" 
                        value={Math.min(fiCalculation.progressPercentage, 100)} 
                        color="primary"
                      />
                      <Typography variant="body2" align="center" style={{ marginTop: 8 }}>
                        {fiCalculation.progressPercentage.toFixed(2)}% Complete
                      </Typography>
                    </div>
                    
                    <Box mt={4}>
                      <Typography variant="body1" gutterBottom>
                        With annual expenses of ${calculatorInputs.annual_expenses.toLocaleString()}, 
                        you'll need ${fiCalculation.targetAmount.toLocaleString()} to be financially independent 
                        using a {calculatorInputs.withdrawal_rate}% withdrawal rate.
                      </Typography>
                      
                      <Typography variant="body1" gutterBottom>
                        At your current savings rate and expected return, you'll reach financial independence in 
                        approximately {fiCalculation.years.toFixed(1)} years.
                      </Typography>
                    </Box>
                  </div>
                </Paper>
              </Grid>
            </Grid>
          )}

          {tabValue === 2 && (
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Retirement Planning
              </Typography>
              <RetirementProjection />
            </Paper>
          )}

          {tabValue === 3 && (
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Financial Milestones
              </Typography>
              <MilestoneTimeline />
            </Paper>
          )}
        </>
      )}
    </div>
  );
};

export default FinancialIndependence;
