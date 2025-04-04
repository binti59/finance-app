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
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  ListItemSecondaryAction,
  Switch
} from '@material-ui/core';
import {
  Settings as SettingsIcon,
  Notifications as NotificationsIcon,
  Security as SecurityIcon,
  AccountCircle as AccountCircleIcon,
  Palette as PaletteIcon,
  Storage as StorageIcon,
  CloudDownload as CloudDownloadIcon,
  Delete as DeleteIcon,
  Refresh as RefreshIcon,
  Save as SaveIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import ProfileSettings from '../components/settings/ProfileSettings';
import SecuritySettings from '../components/settings/SecuritySettings';
import NotificationSettings from '../components/settings/NotificationSettings';
import AppearanceSettings from '../components/settings/AppearanceSettings';
import DataSettings from '../components/settings/DataSettings';
import BackupSettings from '../components/settings/BackupSettings';

// Actions
import { 
  getSettings, 
  updateSettings, 
  updateProfile,
  updatePassword,
  updateNotificationPreferences,
  updateAppearance,
  exportData,
  deleteAccount
} from '../actions/settingsActions';

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
  settingsList: {
    width: '100%',
  },
  settingsSection: {
    marginBottom: theme.spacing(3),
  },
  sectionTitle: {
    marginBottom: theme.spacing(2),
  },
  formControl: {
    marginBottom: theme.spacing(2),
    minWidth: 200,
  },
  dangerZone: {
    border: `1px solid ${theme.palette.error.main}`,
    borderRadius: theme.spacing(1),
    padding: theme.spacing(2),
    marginTop: theme.spacing(4),
  },
  dangerZoneTitle: {
    color: theme.palette.error.main,
    marginBottom: theme.spacing(2),
  },
  saveButton: {
    marginTop: theme.spacing(2),
  },
}));

const Settings = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [isSaving, setIsSaving] = useState(false);
  
  const { settings, profile } = useSelector(
    (state) => state.settings
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await dispatch(getSettings());
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleUpdateProfile = async (profileData) => {
    setIsSaving(true);
    await dispatch(updateProfile(profileData));
    setIsSaving(false);
  };

  const handleUpdatePassword = async (passwordData) => {
    setIsSaving(true);
    await dispatch(updatePassword(passwordData));
    setIsSaving(false);
  };

  const handleUpdateNotifications = async (notificationData) => {
    setIsSaving(true);
    await dispatch(updateNotificationPreferences(notificationData));
    setIsSaving(false);
  };

  const handleUpdateAppearance = async (appearanceData) => {
    setIsSaving(true);
    await dispatch(updateAppearance(appearanceData));
    setIsSaving(false);
  };

  const handleExportData = async (dataTypes) => {
    await dispatch(exportData(dataTypes));
  };

  const handleDeleteAccount = async (confirmationData) => {
    await dispatch(deleteAccount(confirmationData));
  };

  const handleRefresh = () => {
    dispatch(getSettings());
  };

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Settings
        </Typography>
        <div className={classes.spacer} />
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
        variant="scrollable"
        scrollButtons="auto"
      >
        <Tab icon={<AccountCircleIcon />} label="Profile" />
        <Tab icon={<SecurityIcon />} label="Security" />
        <Tab icon={<NotificationsIcon />} label="Notifications" />
        <Tab icon={<PaletteIcon />} label="Appearance" />
        <Tab icon={<StorageIcon />} label="Data" />
        <Tab icon={<CloudDownloadIcon />} label="Backup & Export" />
      </Tabs>

      {loading ? (
        <div className={classes.loadingContainer}>
          <CircularProgress />
        </div>
      ) : (
        <>
          {tabValue === 0 && (
            <Paper className={classes.paper}>
              <ProfileSettings 
                profile={profile} 
                onUpdateProfile={handleUpdateProfile}
                isSaving={isSaving}
              />
            </Paper>
          )}

          {tabValue === 1 && (
            <Paper className={classes.paper}>
              <SecuritySettings 
                onUpdatePassword={handleUpdatePassword}
                isSaving={isSaving}
              />
            </Paper>
          )}

          {tabValue === 2 && (
            <Paper className={classes.paper}>
              <NotificationSettings 
                settings={settings?.notifications || {}} 
                onUpdateNotifications={handleUpdateNotifications}
                isSaving={isSaving}
              />
            </Paper>
          )}

          {tabValue === 3 && (
            <Paper className={classes.paper}>
              <AppearanceSettings 
                settings={settings?.appearance || {}} 
                onUpdateAppearance={handleUpdateAppearance}
                isSaving={isSaving}
              />
            </Paper>
          )}

          {tabValue === 4 && (
            <Paper className={classes.paper}>
              <DataSettings />
              
              <div className={classes.dangerZone}>
                <Typography variant="h6" className={classes.dangerZoneTitle}>
                  Danger Zone
                </Typography>
                <Typography variant="body2" paragraph>
                  Once you delete your account, there is no going back. Please be certain.
                </Typography>
                <Button 
                  variant="outlined" 
                  color="secondary"
                  startIcon={<DeleteIcon />}
                  onClick={() => handleDeleteAccount({ confirm: true })}
                >
                  Delete Account
                </Button>
              </div>
            </Paper>
          )}

          {tabValue === 5 && (
            <Paper className={classes.paper}>
              <BackupSettings onExportData={handleExportData} />
            </Paper>
          )}
        </>
      )}
    </div>
  );
};

export default Settings;
