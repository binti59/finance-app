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
  LinearProgress
} from '@material-ui/core';
import {
  Add as AddIcon,
  Refresh as RefreshIcon,
  CloudUpload as UploadIcon,
  GetApp as DownloadIcon,
  AttachMoney as MoneyIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import NetWorthChart from '../components/investments/NetWorthChart';
import AssetAllocationChart from '../components/investments/AssetAllocationChart';
import AssetPerformanceTable from '../components/investments/AssetPerformanceTable';
import AddAssetModal from '../components/investments/AddAssetModal';
import AssetsList from '../components/investments/AssetsList';
import PortfolioDiversification from '../components/investments/PortfolioDiversification';
import InvestmentReturns from '../components/investments/InvestmentReturns';

// Actions
import { 
  getAssets, 
  addAsset, 
  updateAsset, 
  deleteAsset,
  getAssetPerformance,
  getAssetAllocation
} from '../actions/assetActions';

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
}));

const Investments = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [openAddModal, setOpenAddModal] = useState(false);
  
  const { assets, assetPerformance, assetAllocation } = useSelector(
    (state) => state.assets
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await Promise.all([
        dispatch(getAssets()),
        dispatch(getAssetPerformance()),
        dispatch(getAssetAllocation())
      ]);
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleAddAsset = (assetData) => {
    dispatch(addAsset(assetData));
    setOpenAddModal(false);
  };

  const handleUpdateAsset = (id, assetData) => {
    dispatch(updateAsset(id, assetData));
  };

  const handleDeleteAsset = (id) => {
    dispatch(deleteAsset(id));
  };

  const handleRefresh = () => {
    dispatch(getAssets());
    dispatch(getAssetPerformance());
    dispatch(getAssetAllocation());
  };

  // Calculate summary statistics
  const calculateSummary = () => {
    if (!assets || assets.length === 0) {
      return {
        totalValue: 0,
        totalReturn: 0,
        percentageReturn: 0,
        annualizedReturn: 0
      };
    }

    const totalValue = assets.reduce((sum, asset) => sum + parseFloat(asset.value), 0);
    
    if (!assetPerformance || assetPerformance.length === 0) {
      return {
        totalValue,
        totalReturn: 0,
        percentageReturn: 0,
        annualizedReturn: 0
      };
    }

    const totalAcquisitionValue = assetPerformance.reduce(
      (sum, asset) => sum + parseFloat(asset.acquisition_value), 
      0
    );
    
    const totalCurrentValue = assetPerformance.reduce(
      (sum, asset) => sum + parseFloat(asset.current_value), 
      0
    );
    
    const totalReturn = totalCurrentValue - totalAcquisitionValue;
    const percentageReturn = totalAcquisitionValue > 0 
      ? (totalReturn / totalAcquisitionValue) * 100 
      : 0;
    
    // Calculate weighted average annualized return
    let weightedAnnualizedReturn = 0;
    if (totalCurrentValue > 0) {
      weightedAnnualizedReturn = assetPerformance.reduce(
        (sum, asset) => {
          const weight = parseFloat(asset.current_value) / totalCurrentValue;
          return sum + (parseFloat(asset.annualized_return) * weight);
        }, 
        0
      );
    }

    return {
      totalValue,
      totalReturn,
      percentageReturn,
      annualizedReturn: weightedAnnualizedReturn
    };
  };

  const summary = calculateSummary();

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Investment Portfolio
        </Typography>
        <div className={classes.spacer} />
        <Tooltip title="Add asset">
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            className={classes.actionButton}
            onClick={() => setOpenAddModal(true)}
          >
            Add Asset
          </Button>
        </Tooltip>
        <Tooltip title="Refresh">
          <IconButton className={classes.actionButton} onClick={handleRefresh}>
            <RefreshIcon />
          </IconButton>
        </Tooltip>
      </div>

      {/* Summary Cards */}
      <Grid container spacing={3}>
        {/* Total Portfolio Value */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Portfolio Value
              </Typography>
              <Typography className={classes.kpiValue} variant="h4">
                ${summary.totalValue.toLocaleString()}
              </Typography>
            </CardContent>
          </Paper>
        </Grid>

        {/* Total Return */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Total Return
              </Typography>
              <Typography 
                className={`${classes.kpiValue} ${summary.totalReturn >= 0 ? classes.positive : classes.negative}`} 
                variant="h4"
              >
                ${summary.totalReturn.toLocaleString()}
              </Typography>
            </CardContent>
          </Paper>
        </Grid>

        {/* Percentage Return */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Percentage Return
              </Typography>
              <Typography 
                className={`${classes.kpiValue} ${summary.percentageReturn >= 0 ? classes.positive : classes.negative}`} 
                variant="h4"
              >
                {summary.percentageReturn.toFixed(2)}%
              </Typography>
            </CardContent>
          </Paper>
        </Grid>

        {/* Annualized Return */}
        <Grid item xs={12} sm={6} md={3}>
          <Paper className={classes.summaryCard}>
            <CardContent>
              <Typography className={classes.kpiLabel} gutterBottom>
                Annualized Return
              </Typography>
              <Typography 
                className={`${classes.kpiValue} ${summary.annualizedReturn >= 0 ? classes.positive : classes.negative}`} 
                variant="h4"
              >
                {summary.annualizedReturn.toFixed(2)}%
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
        <Tab label="Overview" />
        <Tab label="Assets" />
        <Tab label="Performance" />
        <Tab label="Allocation" />
      </Tabs>

      {loading ? (
        <div className={classes.loadingContainer}>
          <CircularProgress />
        </div>
      ) : (
        <>
          {tabValue === 0 && (
            <Grid container spacing={3}>
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Portfolio Value Over Time
                  </Typography>
                  <div className={classes.chartContainer}>
                    <NetWorthChart />
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Asset Allocation
                  </Typography>
                  <div className={classes.chartContainer}>
                    <AssetAllocationChart data={assetAllocation} />
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Top Performing Assets
                  </Typography>
                  <AssetPerformanceTable 
                    data={assetPerformance ? assetPerformance.slice(0, 5) : []} 
                    showTopPerformers={true}
                  />
                </Paper>
              </Grid>
            </Grid>
          )}

          {tabValue === 1 && (
            <Paper className={classes.paper}>
              <AssetsList 
                assets={assets} 
                onUpdateAsset={handleUpdateAsset}
                onDeleteAsset={handleDeleteAsset}
              />
            </Paper>
          )}

          {tabValue === 2 && (
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Asset Performance
              </Typography>
              <AssetPerformanceTable data={assetPerformance} />
              <Divider className={classes.divider} />
              <InvestmentReturns data={assetPerformance} />
            </Paper>
          )}

          {tabValue === 3 && (
            <Grid container spacing={3}>
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Asset Allocation
                  </Typography>
                  <div className={classes.chartContainer}>
                    <AssetAllocationChart data={assetAllocation} />
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Portfolio Diversification
                  </Typography>
                  <PortfolioDiversification data={assetAllocation} />
                </Paper>
              </Grid>
              
              <Grid item xs={12}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Recommended Allocation
                  </Typography>
                  {/* Recommended allocation component */}
                </Paper>
              </Grid>
            </Grid>
          )}
        </>
      )}

      {/* Modals */}
      <AddAssetModal
        open={openAddModal}
        onClose={() => setOpenAddModal(false)}
        onSubmit={handleAddAsset}
      />
    </div>
  );
};

export default Investments;
