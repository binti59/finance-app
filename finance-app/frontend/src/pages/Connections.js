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
  GetApp as DownloadIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import ConnectionsList from '../components/connections/ConnectionsList';
import AddConnectionModal from '../components/connections/AddConnectionModal';
import ConnectionStatus from '../components/connections/ConnectionStatus';
import SyncHistoryList from '../components/connections/SyncHistoryList';
import ConnectionGuide from '../components/connections/ConnectionGuide';

// Actions
import { 
  getConnections, 
  addConnection, 
  deleteConnection, 
  syncConnection,
  authProvider
} from '../actions/connectionActions';

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
  connectionCard: {
    marginBottom: theme.spacing(2),
  },
  emptyState: {
    textAlign: 'center',
    padding: theme.spacing(4),
  },
  syncProgress: {
    marginTop: theme.spacing(2),
  }
}));

const Connections = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [openAddModal, setOpenAddModal] = useState(false);
  const [syncing, setSyncing] = useState(false);
  
  const { connections, syncHistory } = useSelector(
    (state) => state.connections
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await dispatch(getConnections());
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleAddConnection = (connectionData) => {
    dispatch(addConnection(connectionData));
    setOpenAddModal(false);
  };

  const handleDeleteConnection = (id) => {
    dispatch(deleteConnection(id));
  };

  const handleSyncConnection = async (id) => {
    setSyncing(true);
    await dispatch(syncConnection(id));
    setSyncing(false);
  };

  const handleAuthProvider = (provider) => {
    dispatch(authProvider(provider));
  };

  const handleRefresh = () => {
    dispatch(getConnections());
  };

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Financial Connections
        </Typography>
        <div className={classes.spacer} />
        <Tooltip title="Add connection">
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            className={classes.actionButton}
            onClick={() => setOpenAddModal(true)}
          >
            Add Connection
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
        <Tab label="Active Connections" />
        <Tab label="Sync History" />
        <Tab label="Setup Guide" />
      </Tabs>

      {tabValue === 0 && (
        <>
          {loading ? (
            <div className={classes.loadingContainer}>
              <CircularProgress />
            </div>
          ) : (
            <>
              {connections && connections.length > 0 ? (
                <>
                  <ConnectionsList
                    connections={connections}
                    onDeleteConnection={handleDeleteConnection}
                    onSyncConnection={handleSyncConnection}
                  />
                  
                  {syncing && (
                    <Box className={classes.syncProgress}>
                      <Typography variant="body2" gutterBottom>
                        Syncing data from financial institutions...
                      </Typography>
                      <LinearProgress />
                    </Box>
                  )}
                </>
              ) : (
                <Paper className={classes.paper}>
                  <div className={classes.emptyState}>
                    <Typography variant="h6" gutterBottom>
                      No Financial Connections
                    </Typography>
                    <Typography variant="body1" color="textSecondary" paragraph>
                      Connect to your financial institutions to automatically import transactions and account data.
                    </Typography>
                    <Button
                      variant="contained"
                      color="primary"
                      startIcon={<AddIcon />}
                      onClick={() => setOpenAddModal(true)}
                    >
                      Add Your First Connection
                    </Button>
                  </div>
                </Paper>
              )}
            </>
          )}
        </>
      )}

      {tabValue === 1 && (
        <Paper className={classes.paper}>
          <SyncHistoryList syncHistory={syncHistory || []} />
        </Paper>
      )}

      {tabValue === 2 && (
        <Paper className={classes.paper}>
          <ConnectionGuide onConnect={(provider) => setOpenAddModal(true)} />
        </Paper>
      )}

      {/* Modals */}
      <AddConnectionModal
        open={openAddModal}
        onClose={() => setOpenAddModal(false)}
        onSubmit={handleAddConnection}
        onAuth={handleAuthProvider}
      />
    </div>
  );
};

export default Connections;
