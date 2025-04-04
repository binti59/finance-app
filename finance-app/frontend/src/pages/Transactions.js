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
  TextField,
  MenuItem,
  FormControl,
  InputLabel,
  Select
} from '@material-ui/core';
import {
  Add as AddIcon,
  Refresh as RefreshIcon,
  FilterList as FilterIcon,
  GetApp as DownloadIcon,
  CloudUpload as UploadIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import TransactionList from '../components/transactions/TransactionList';
import TransactionFilters from '../components/transactions/TransactionFilters';
import TransactionImport from '../components/transactions/TransactionImport';
import TransactionStats from '../components/transactions/TransactionStats';
import AddTransactionModal from '../components/transactions/AddTransactionModal';
import CategoryDistribution from '../components/transactions/CategoryDistribution';
import RecurringTransactions from '../components/transactions/RecurringTransactions';

// Actions
import { 
  getTransactions, 
  addTransaction, 
  updateTransaction, 
  deleteTransaction,
  importTransactions,
  categorizeTransactions
} from '../actions/transactionActions';

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
  filterContainer: {
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
}));

const Transactions = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [openAddModal, setOpenAddModal] = useState(false);
  const [openImportModal, setOpenImportModal] = useState(false);
  const [filters, setFilters] = useState({
    account_id: '',
    category_id: '',
    start_date: '',
    end_date: '',
    transaction_type: '',
    min_amount: '',
    max_amount: '',
    search: '',
    sort_by: 'transaction_date',
    sort_order: 'DESC',
    page: 1,
    limit: 50
  });
  
  const { transactions, pagination, stats } = useSelector(
    (state) => state.transactions
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await dispatch(getTransactions(filters));
      setLoading(false);
    };

    fetchData();
  }, [dispatch, filters]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleFilterChange = (newFilters) => {
    setFilters({ ...filters, ...newFilters, page: 1 });
  };

  const handlePageChange = (event, newPage) => {
    setFilters({ ...filters, page: newPage + 1 });
  };

  const handleAddTransaction = (transactionData) => {
    dispatch(addTransaction(transactionData));
    setOpenAddModal(false);
  };

  const handleUpdateTransaction = (id, transactionData) => {
    dispatch(updateTransaction(id, transactionData));
  };

  const handleDeleteTransaction = (id) => {
    dispatch(deleteTransaction(id));
  };

  const handleImportTransactions = (formData) => {
    dispatch(importTransactions(formData));
    setOpenImportModal(false);
  };

  const handleCategorizeTransactions = () => {
    const uncategorizedIds = transactions
      .filter(t => !t.category_id)
      .map(t => t.id);
    
    if (uncategorizedIds.length > 0) {
      dispatch(categorizeTransactions(uncategorizedIds));
    }
  };

  const handleRefresh = () => {
    dispatch(getTransactions(filters));
  };

  const handleExportTransactions = () => {
    // Implementation for exporting transactions
    console.log('Export transactions');
  };

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Transactions
        </Typography>
        <div className={classes.spacer} />
        <Tooltip title="Import transactions">
          <Button
            variant="outlined"
            color="primary"
            startIcon={<UploadIcon />}
            className={classes.actionButton}
            onClick={() => setOpenImportModal(true)}
          >
            Import
          </Button>
        </Tooltip>
        <Tooltip title="Export transactions">
          <Button
            variant="outlined"
            color="primary"
            startIcon={<DownloadIcon />}
            className={classes.actionButton}
            onClick={handleExportTransactions}
          >
            Export
          </Button>
        </Tooltip>
        <Tooltip title="Add transaction">
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            className={classes.actionButton}
            onClick={() => setOpenAddModal(true)}
          >
            Add Transaction
          </Button>
        </Tooltip>
        <Tooltip title="Refresh">
          <IconButton className={classes.actionButton} onClick={handleRefresh}>
            <RefreshIcon />
          </IconButton>
        </Tooltip>
      </div>

      <Tabs
        value={tabValue}
        onChange={handleTabChange}
        indicatorColor="primary"
        textColor="primary"
        className={classes.tabs}
      >
        <Tab label="All Transactions" />
        <Tab label="Analytics" />
        <Tab label="Recurring" />
      </Tabs>

      {tabValue === 0 && (
        <>
          <Paper className={classes.filterContainer}>
            <TransactionFilters 
              filters={filters} 
              onFilterChange={handleFilterChange} 
            />
          </Paper>

          {loading ? (
            <div className={classes.loadingContainer}>
              <CircularProgress />
            </div>
          ) : (
            <>
              <TransactionStats stats={stats} />
              
              <Paper className={classes.paper}>
                <TransactionList
                  transactions={transactions}
                  pagination={pagination}
                  onPageChange={handlePageChange}
                  onUpdateTransaction={handleUpdateTransaction}
                  onDeleteTransaction={handleDeleteTransaction}
                />
              </Paper>
              
              {transactions.filter(t => !t.category_id).length > 0 && (
                <Box mt={2} display="flex" justifyContent="center">
                  <Button
                    variant="outlined"
                    color="primary"
                    onClick={handleCategorizeTransactions}
                  >
                    Auto-Categorize Transactions
                  </Button>
                </Box>
              )}
            </>
          )}
        </>
      )}

      {tabValue === 1 && (
        <Grid container spacing={3}>
          <Grid item xs={12}>
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Monthly Spending Trend
              </Typography>
              {/* Monthly spending trend chart component */}
            </Paper>
          </Grid>
          
          <Grid item xs={12} md={6}>
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Category Distribution
              </Typography>
              <CategoryDistribution />
            </Paper>
          </Grid>
          
          <Grid item xs={12} md={6}>
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Income vs. Expenses
              </Typography>
              {/* Income vs Expenses chart component */}
            </Paper>
          </Grid>
          
          <Grid item xs={12}>
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Top Spending Categories
              </Typography>
              {/* Top spending categories component */}
            </Paper>
          </Grid>
        </Grid>
      )}

      {tabValue === 2 && (
        <Paper className={classes.paper}>
          <RecurringTransactions />
        </Paper>
      )}

      {/* Modals */}
      <AddTransactionModal
        open={openAddModal}
        onClose={() => setOpenAddModal(false)}
        onSubmit={handleAddTransaction}
      />

      <TransactionImport
        open={openImportModal}
        onClose={() => setOpenImportModal(false)}
        onSubmit={handleImportTransactions}
      />
    </div>
  );
};

export default Transactions;
