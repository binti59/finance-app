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
  LinearProgress
} from '@material-ui/core';
import {
  Add as AddIcon,
  Refresh as RefreshIcon,
  Flag as FlagIcon,
  CheckCircle as CheckCircleIcon,
  Delete as DeleteIcon,
  Edit as EditIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import GoalsList from '../components/goals/GoalsList';
import AddGoalModal from '../components/goals/AddGoalModal';
import GoalProgress from '../components/goals/GoalProgress';
import GoalRecommendations from '../components/goals/GoalRecommendations';
import GoalTimeline from '../components/goals/GoalTimeline';

// Actions
import { 
  getGoals, 
  addGoal, 
  updateGoal, 
  deleteGoal,
  updateGoalProgress,
  getGoalRecommendations
} from '../actions/goalActions';

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
  goalCard: {
    marginBottom: theme.spacing(2),
    position: 'relative',
  },
  goalCardContent: {
    paddingBottom: theme.spacing(2),
  },
  goalProgress: {
    marginTop: theme.spacing(1),
    marginBottom: theme.spacing(1),
  },
  goalActions: {
    display: 'flex',
    justifyContent: 'flex-end',
  },
  goalAmount: {
    fontWeight: 'bold',
    fontSize: '1.2rem',
  },
  goalDeadline: {
    color: theme.palette.text.secondary,
    fontSize: '0.9rem',
  },
  goalCategory: {
    display: 'inline-block',
    padding: theme.spacing(0.5, 1),
    borderRadius: theme.spacing(1),
    backgroundColor: theme.palette.primary.light,
    color: theme.palette.primary.contrastText,
    fontSize: '0.8rem',
    marginTop: theme.spacing(1),
  },
  goalPriority: {
    position: 'absolute',
    top: theme.spacing(1),
    right: theme.spacing(1),
    fontSize: '0.8rem',
    color: theme.palette.text.secondary,
  },
  emptyState: {
    textAlign: 'center',
    padding: theme.spacing(4),
  },
  chartContainer: {
    height: 300,
    marginTop: theme.spacing(2),
  },
}));

const Goals = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [openAddModal, setOpenAddModal] = useState(false);
  
  const { goals, recommendations } = useSelector(
    (state) => state.goals
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await Promise.all([
        dispatch(getGoals()),
        dispatch(getGoalRecommendations())
      ]);
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleAddGoal = (goalData) => {
    dispatch(addGoal(goalData));
    setOpenAddModal(false);
  };

  const handleUpdateGoal = (id, goalData) => {
    dispatch(updateGoal(id, goalData));
  };

  const handleDeleteGoal = (id) => {
    dispatch(deleteGoal(id));
  };

  const handleUpdateProgress = (id, amount) => {
    dispatch(updateGoalProgress(id, amount));
  };

  const handleRefresh = () => {
    dispatch(getGoals());
    dispatch(getGoalRecommendations());
  };

  // Filter goals by status
  const activeGoals = goals ? goals.filter(goal => goal.status === 'active') : [];
  const completedGoals = goals ? goals.filter(goal => goal.status === 'completed') : [];

  // Sort goals by priority
  const sortedActiveGoals = [...activeGoals].sort((a, b) => a.priority - b.priority);

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Financial Goals
        </Typography>
        <div className={classes.spacer} />
        <Tooltip title="Add goal">
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            className={classes.actionButton}
            onClick={() => setOpenAddModal(true)}
          >
            Add Goal
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
        <Tab label="Active Goals" />
        <Tab label="Completed Goals" />
        <Tab label="Timeline" />
        <Tab label="Recommendations" />
      </Tabs>

      {loading ? (
        <div className={classes.loadingContainer}>
          <CircularProgress />
        </div>
      ) : (
        <>
          {tabValue === 0 && (
            <>
              {sortedActiveGoals.length > 0 ? (
                <Grid container spacing={3}>
                  {sortedActiveGoals.map((goal) => {
                    const progressPercentage = (parseFloat(goal.current_amount) / parseFloat(goal.target_amount)) * 100;
                    
                    return (
                      <Grid item xs={12} sm={6} md={4} key={goal.id}>
                        <Card className={classes.goalCard}>
                          <CardContent className={classes.goalCardContent}>
                            <Typography variant="h6" gutterBottom>
                              {goal.name}
                            </Typography>
                            
                            <div className={classes.goalPriority}>
                              Priority: {goal.priority}
                            </div>
                            
                            <Typography className={classes.goalAmount} gutterBottom>
                              ${goal.current_amount.toLocaleString()} / ${goal.target_amount.toLocaleString()}
                            </Typography>
                            
                            {goal.deadline && (
                              <Typography className={classes.goalDeadline} gutterBottom>
                                Deadline: {new Date(goal.deadline).toLocaleDateString()}
                              </Typography>
                            )}
                            
                            <div className={classes.goalProgress}>
                              <LinearProgress 
                                variant="determinate" 
                                value={Math.min(progressPercentage, 100)} 
                                color="primary"
                              />
                              <Typography variant="body2" align="right" style={{ marginTop: 4 }}>
                                {progressPercentage.toFixed(1)}%
                              </Typography>
                            </div>
                            
                            <div className={classes.goalCategory}>
                              {goal.category}
                            </div>
                            
                            <Box mt={2}>
                              <TextField
                                label="Update Progress"
                                type="number"
                                size="small"
                                InputProps={{ startAdornment: '$' }}
                                defaultValue={goal.current_amount}
                                onBlur={(e) => {
                                  const newAmount = parseFloat(e.target.value);
                                  if (!isNaN(newAmount) && newAmount !== parseFloat(goal.current_amount)) {
                                    handleUpdateProgress(goal.id, newAmount);
                                  }
                                }}
                              />
                            </Box>
                          </CardContent>
                          
                          <Divider />
                          
                          <Box p={1} className={classes.goalActions}>
                            <Tooltip title="Edit">
                              <IconButton size="small" onClick={() => handleUpdateGoal(goal.id, goal)}>
                                <EditIcon fontSize="small" />
                              </IconButton>
                            </Tooltip>
                            <Tooltip title="Delete">
                              <IconButton size="small" onClick={() => handleDeleteGoal(goal.id)}>
                                <DeleteIcon fontSize="small" />
                              </IconButton>
                            </Tooltip>
                          </Box>
                        </Card>
                      </Grid>
                    );
                  })}
                </Grid>
              ) : (
                <Paper className={classes.paper}>
                  <div className={classes.emptyState}>
                    <Typography variant="h6" gutterBottom>
                      No Active Goals
                    </Typography>
                    <Typography variant="body1" color="textSecondary" paragraph>
                      Set financial goals to track your progress and stay motivated.
                    </Typography>
                    <Button
                      variant="contained"
                      color="primary"
                      startIcon={<AddIcon />}
                      onClick={() => setOpenAddModal(true)}
                    >
                      Add Your First Goal
                    </Button>
                  </div>
                </Paper>
              )}
            </>
          )}

          {tabValue === 1 && (
            <Paper className={classes.paper}>
              {completedGoals.length > 0 ? (
                <GoalsList 
                  goals={completedGoals} 
                  onUpdateGoal={handleUpdateGoal}
                  onDeleteGoal={handleDeleteGoal}
                />
              ) : (
                <div className={classes.emptyState}>
                  <Typography variant="h6" gutterBottom>
                    No Completed Goals
                  </Typography>
                  <Typography variant="body1" color="textSecondary">
                    You haven't completed any goals yet. Keep working on your active goals!
                  </Typography>
                </div>
              )}
            </Paper>
          )}

          {tabValue === 2 && (
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Goal Timeline
              </Typography>
              <GoalTimeline goals={goals || []} />
            </Paper>
          )}

          {tabValue === 3 && (
            <Paper className={classes.paper}>
              <GoalRecommendations 
                recommendations={recommendations?.recommendations || []} 
                onAddGoal={() => setOpenAddModal(true)} 
              />
            </Paper>
          )}
        </>
      )}

      {/* Modals */}
      <AddGoalModal
        open={openAddModal}
        onClose={() => setOpenAddModal(false)}
        onSubmit={handleAddGoal}
      />
    </div>
  );
};

export default Goals;
