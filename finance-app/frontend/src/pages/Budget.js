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
  FormControl,
  InputLabel,
  Select,
  MenuItem,
  Table,
  TableBody,
  TableCell,
  TableContainer,
  TableHead,
  TableRow,
  TablePagination
} from '@material-ui/core';
import {
  Add as AddIcon,
  Refresh as RefreshIcon,
  Delete as DeleteIcon,
  Edit as EditIcon,
  GetApp as DownloadIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import BudgetSummary from '../components/budget/BudgetSummary';
import BudgetList from '../components/budget/BudgetList';
import BudgetPerformance from '../components/budget/BudgetPerformance';
import AddBudgetModal from '../components/budget/AddBudgetModal';
import BudgetCategoryChart from '../components/budget/BudgetCategoryChart';
import BudgetTrend from '../components/budget/BudgetTrend';
import BudgetRecommendations from '../components/budget/BudgetRecommendations';

// Actions
import { 
  getBudgets, 
  addBudget, 
  updateBudget, 
  deleteBudget,
  getBudgetPerformance,
  getBudgetRecommendations
} from '../actions/budgetActions';

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
  tableContainer: {
    marginTop: theme.spacing(2),
  },
  statusGood: {
    color: theme.palette.success.main,
  },
  statusWarning: {
    color: theme.palette.warning.main,
  },
  statusAlert: {
    color: theme.palette.error.light,
  },
  statusOverBudget: {
    color: theme.palette.error.main,
  },
  progressBar: {
    height: 10,
    borderRadius: 5,
  },
  progressBarContainer: {
    width: '100%',
    backgroundColor: theme.palette.grey[300],
    borderRadius: 5,
  },
}));

const Budget = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [openAddModal, setOpenAddModal] = useState(false);
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(10);
  
  const { budgets, budgetPerformance, budgetRecommendations } = useSelector(
    (state) => state.budget
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await Promise.all([
        dispatch(getBudgets()),
        dispatch(getBudgetPerformance()),
        dispatch(getBudgetRecommendations())
      ]);
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleAddBudget = (budgetData) => {
    dispatch(addBudget(budgetData));
    setOpenAddModal(false);
  };

  const handleUpdateBudget = (id, budgetData) => {
    dispatch(updateBudget(id, budgetData));
  };

  const handleDeleteBudget = (id) => {
    dispatch(deleteBudget(id));
  };

  const handleRefresh = () => {
    dispatch(getBudgets());
    dispatch(getBudgetPerformance());
    dispatch(getBudgetRecommendations());
  };

  const handleChangePage = (event, newPage) => {
    setPage(newPage);
  };

  const handleChangeRowsPerPage = (event) => {
    setRowsPerPage(parseInt(event.target.value, 10));
    setPage(0);
  };

  const getStatusColor = (status) => {
    switch (status) {
      case 'good':
        return classes.statusGood;
      case 'warning':
        return classes.statusWarning;
      case 'alert':
        return classes.statusAlert;
      case 'over_budget':
        return classes.statusOverBudget;
      default:
        return '';
    }
  };

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Budget Management
        </Typography>
        <div className={classes.spacer} />
        <Tooltip title="Add budget">
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            className={classes.actionButton}
            onClick={() => setOpenAddModal(true)}
          >
            Add Budget
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
        <Tab label="Overview" />
        <Tab label="Budget List" />
        <Tab label="Performance" />
        <Tab label="Recommendations" />
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
                <BudgetSummary performance={budgetPerformance} />
              </Grid>
              
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Budget vs. Actual
                  </Typography>
                  <div className={classes.chartContainer}>
                    <BudgetCategoryChart performance={budgetPerformance} />
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12} md={6}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Monthly Spending Trend
                  </Typography>
                  <div className={classes.chartContainer}>
                    <BudgetTrend />
                  </div>
                </Paper>
              </Grid>
              
              <Grid item xs={12}>
                <Paper className={classes.paper}>
                  <Typography variant="h6" gutterBottom>
                    Top Budget Categories
                  </Typography>
                  <TableContainer className={classes.tableContainer}>
                    <Table>
                      <TableHead>
                        <TableRow>
                          <TableCell>Category</TableCell>
                          <TableCell align="right">Budgeted</TableCell>
                          <TableCell align="right">Spent</TableCell>
                          <TableCell align="right">Remaining</TableCell>
                          <TableCell>Progress</TableCell>
                          <TableCell align="right">Status</TableCell>
                        </TableRow>
                      </TableHead>
                      <TableBody>
                        {budgetPerformance?.categories?.slice(0, 5).map((category) => (
                          <TableRow key={category.category_id}>
                            <TableCell component="th" scope="row">
                              {category.category_name}
                            </TableCell>
                            <TableCell align="right">${category.budgeted.toLocaleString()}</TableCell>
                            <TableCell align="right">${category.spent.toLocaleString()}</TableCell>
                            <TableCell align="right">${category.remaining.toLocaleString()}</TableCell>
                            <TableCell>
                              <div className={classes.progressBarContainer}>
                                <div 
                                  className={`${classes.progressBar} ${getStatusColor(category.status)}`}
                                  style={{ width: `${Math.min(category.percentage, 100)}%` }}
                                />
                              </div>
                            </TableCell>
                            <TableCell align="right" className={getStatusColor(category.status)}>
                              {category.percentage.toFixed(0)}%
                            </TableCell>
                          </TableRow>
                        ))}
                      </TableBody>
                    </Table>
                  </TableContainer>
                </Paper>
              </Grid>
            </Grid>
          )}

          {tabValue === 1 && (
            <Paper className={classes.paper}>
              <BudgetList 
                budgets={budgets} 
                onUpdateBudget={handleUpdateBudget}
                onDeleteBudget={handleDeleteBudget}
                page={page}
                rowsPerPage={rowsPerPage}
                onChangePage={handleChangePage}
                onChangeRowsPerPage={handleChangeRowsPerPage}
              />
            </Paper>
          )}

          {tabValue === 2 && (
            <Paper className={classes.paper}>
              <BudgetPerformance performance={budgetPerformance} />
            </Paper>
          )}

          {tabValue === 3 && (
            <Paper className={classes.paper}>
              <BudgetRecommendations recommendations={budgetRecommendations} onAddBudget={() => setOpenAddModal(true)} />
            </Paper>
          )}
        </>
      )}

      {/* Modals */}
      <AddBudgetModal
        open={openAddModal}
        onClose={() => setOpenAddModal(false)}
        onSubmit={handleAddBudget}
      />
    </div>
  );
};

export default Budget;
