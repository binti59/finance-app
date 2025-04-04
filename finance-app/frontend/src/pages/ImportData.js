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
  CloudUpload as UploadIcon,
  GetApp as DownloadIcon,
  Refresh as RefreshIcon,
  Add as AddIcon,
  Delete as DeleteIcon,
  Edit as EditIcon
} from '@material-ui/icons';
import { useDispatch, useSelector } from 'react-redux';

// Components
import FileUploader from '../components/import/FileUploader';
import ImportHistory from '../components/import/ImportHistory';
import ImportPreview from '../components/import/ImportPreview';
import ImportSettings from '../components/import/ImportSettings';
import ImportStatus from '../components/import/ImportStatus';

// Actions
import { 
  uploadFile, 
  getImportHistory, 
  previewImport, 
  confirmImport,
  cancelImport,
  getImportSettings,
  updateImportSettings
} from '../actions/importActions';

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
  uploadArea: {
    border: `2px dashed ${theme.palette.primary.main}`,
    borderRadius: theme.spacing(1),
    padding: theme.spacing(3),
    textAlign: 'center',
    marginBottom: theme.spacing(3),
    backgroundColor: theme.palette.background.default,
    cursor: 'pointer',
  },
  uploadIcon: {
    fontSize: 48,
    marginBottom: theme.spacing(1),
    color: theme.palette.primary.main,
  },
  fileTypeInfo: {
    marginTop: theme.spacing(2),
    marginBottom: theme.spacing(2),
  },
  fileTypeChip: {
    margin: theme.spacing(0.5),
  },
  tableContainer: {
    marginTop: theme.spacing(2),
  },
  importPreviewContainer: {
    marginTop: theme.spacing(2),
  },
  importStatusContainer: {
    marginTop: theme.spacing(2),
  },
  importHistoryContainer: {
    marginTop: theme.spacing(2),
  },
}));

const ImportData = () => {
  const classes = useStyles();
  const dispatch = useDispatch();
  const [loading, setLoading] = useState(true);
  const [tabValue, setTabValue] = useState(0);
  const [selectedFile, setSelectedFile] = useState(null);
  const [importType, setImportType] = useState('transactions');
  const [isUploading, setIsUploading] = useState(false);
  const [isImporting, setIsImporting] = useState(false);
  
  const { importHistory, previewData, importSettings, importStatus } = useSelector(
    (state) => state.import
  );

  useEffect(() => {
    const fetchData = async () => {
      setLoading(true);
      await Promise.all([
        dispatch(getImportHistory()),
        dispatch(getImportSettings())
      ]);
      setLoading(false);
    };

    fetchData();
  }, [dispatch]);

  const handleTabChange = (event, newValue) => {
    setTabValue(newValue);
  };

  const handleFileSelect = (file) => {
    setSelectedFile(file);
  };

  const handleImportTypeChange = (event) => {
    setImportType(event.target.value);
  };

  const handleUpload = async () => {
    if (!selectedFile) return;
    
    setIsUploading(true);
    
    const formData = new FormData();
    formData.append('file', selectedFile);
    formData.append('type', importType);
    
    await dispatch(uploadFile(formData));
    await dispatch(previewImport());
    
    setIsUploading(false);
  };

  const handleConfirmImport = async () => {
    setIsImporting(true);
    await dispatch(confirmImport());
    await dispatch(getImportHistory());
    setIsImporting(false);
    setSelectedFile(null);
  };

  const handleCancelImport = () => {
    dispatch(cancelImport());
    setSelectedFile(null);
  };

  const handleUpdateSettings = (settings) => {
    dispatch(updateImportSettings(settings));
  };

  const handleRefresh = () => {
    dispatch(getImportHistory());
  };

  return (
    <div className={classes.root}>
      <div className={classes.sectionHeader}>
        <Typography variant="h4" component="h1">
          Import Financial Data
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
      >
        <Tab label="Upload" />
        <Tab label="Import History" />
        <Tab label="Settings" />
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
                    Upload Financial Data
                  </Typography>
                  
                  <FormControl variant="outlined" fullWidth className={classes.formControl}>
                    <InputLabel id="import-type-label">Import Type</InputLabel>
                    <Select
                      labelId="import-type-label"
                      id="import-type"
                      value={importType}
                      onChange={handleImportTypeChange}
                      label="Import Type"
                    >
                      <MenuItem value="transactions">Transactions</MenuItem>
                      <MenuItem value="accounts">Accounts</MenuItem>
                      <MenuItem value="investments">Investments</MenuItem>
                      <MenuItem value="assets">Assets</MenuItem>
                      <MenuItem value="liabilities">Liabilities</MenuItem>
                    </Select>
                  </FormControl>
                  
                  <div className={classes.fileTypeInfo}>
                    <Typography variant="body2" color="textSecondary">
                      Supported file formats: CSV, OFX, QFX, PDF (bank statements)
                    </Typography>
                  </div>
                  
                  <FileUploader 
                    onFileSelect={handleFileSelect} 
                    selectedFile={selectedFile}
                    isUploading={isUploading}
                  />
                  
                  <Box mt={2} display="flex" justifyContent="flex-end">
                    <Button
                      variant="contained"
                      color="primary"
                      startIcon={<UploadIcon />}
                      onClick={handleUpload}
                      disabled={!selectedFile || isUploading}
                    >
                      {isUploading ? 'Uploading...' : 'Upload & Preview'}
                    </Button>
                  </Box>
                </Paper>
              </Grid>
              
              {previewData && (
                <>
                  <Grid item xs={12}>
                    <Paper className={classes.paper}>
                      <Typography variant="h6" gutterBottom>
                        Import Preview
                      </Typography>
                      <ImportPreview data={previewData} type={importType} />
                      
                      <Box mt={2} display="flex" justifyContent="flex-end">
                        <Button
                          variant="outlined"
                          color="secondary"
                          onClick={handleCancelImport}
                          disabled={isImporting}
                          style={{ marginRight: 8 }}
                        >
                          Cancel
                        </Button>
                        <Button
                          variant="contained"
                          color="primary"
                          onClick={handleConfirmImport}
                          disabled={isImporting}
                        >
                          {isImporting ? 'Importing...' : 'Confirm Import'}
                        </Button>
                      </Box>
                    </Paper>
                  </Grid>
                  
                  {importStatus && (
                    <Grid item xs={12}>
                      <Paper className={classes.paper}>
                        <Typography variant="h6" gutterBottom>
                          Import Status
                        </Typography>
                        <ImportStatus status={importStatus} />
                      </Paper>
                    </Grid>
                  )}
                </>
              )}
            </Grid>
          )}

          {tabValue === 1 && (
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Import History
              </Typography>
              <ImportHistory history={importHistory || []} />
            </Paper>
          )}

          {tabValue === 2 && (
            <Paper className={classes.paper}>
              <Typography variant="h6" gutterBottom>
                Import Settings
              </Typography>
              <ImportSettings 
                settings={importSettings} 
                onUpdateSettings={handleUpdateSettings} 
              />
            </Paper>
          )}
        </>
      )}
    </div>
  );
};

export default ImportData;
