import React, { useState } from 'react';
import { makeStyles } from '@material-ui/core/styles';
import {
  AppBar,
  Toolbar,
  Typography,
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Divider,
  IconButton,
  Hidden,
  Avatar,
  Menu,
  MenuItem,
  Collapse
} from '@material-ui/core';
import {
  Dashboard as DashboardIcon,
  Assessment as AssessmentIcon,
  TrendingUp as TrendingUpIcon,
  Description as DescriptionIcon,
  Settings as SettingsIcon,
  AccountBalance as AccountBalanceIcon,
  Receipt as ReceiptIcon,
  Link as LinkIcon,
  CloudUpload as CloudUploadIcon,
  ExpandLess,
  ExpandMore,
  Menu as MenuIcon,
  AccountCircle,
  ExitToApp as LogoutIcon
} from '@material-ui/icons';
import { Link as RouterLink, useLocation } from 'react-router-dom';
import { useDispatch, useSelector } from 'react-redux';
import { logout } from '../actions/authActions';

const drawerWidth = 240;

const useStyles = makeStyles((theme) => ({
  root: {
    display: 'flex',
  },
  appBar: {
    zIndex: theme.zIndex.drawer + 1,
  },
  menuButton: {
    marginRight: theme.spacing(2),
    [theme.breakpoints.up('md')]: {
      display: 'none',
    },
  },
  drawer: {
    [theme.breakpoints.up('md')]: {
      width: drawerWidth,
      flexShrink: 0,
    },
  },
  drawerPaper: {
    width: drawerWidth,
  },
  drawerContainer: {
    overflow: 'auto',
  },
  content: {
    flexGrow: 1,
    padding: theme.spacing(3),
    [theme.breakpoints.up('md')]: {
      marginLeft: drawerWidth,
    },
  },
  toolbar: theme.mixins.toolbar,
  title: {
    flexGrow: 1,
  },
  avatar: {
    cursor: 'pointer',
    width: theme.spacing(4),
    height: theme.spacing(4),
  },
  avatarContainer: {
    display: 'flex',
    alignItems: 'center',
  },
  userName: {
    marginLeft: theme.spacing(1),
    [theme.breakpoints.down('sm')]: {
      display: 'none',
    },
  },
  nested: {
    paddingLeft: theme.spacing(4),
  },
  active: {
    backgroundColor: theme.palette.action.selected,
  },
}));

const MainLayout = ({ children }) => {
  const classes = useStyles();
  const location = useLocation();
  const dispatch = useDispatch();
  const { user } = useSelector((state) => state.auth);
  
  const [mobileOpen, setMobileOpen] = useState(false);
  const [accountsOpen, setAccountsOpen] = useState(false);
  const [planningOpen, setPlanningOpen] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);
  
  const handleDrawerToggle = () => {
    setMobileOpen(!mobileOpen);
  };
  
  const handleAccountsClick = () => {
    setAccountsOpen(!accountsOpen);
  };
  
  const handlePlanningClick = () => {
    setPlanningOpen(!planningOpen);
  };
  
  const handleProfileMenuOpen = (event) => {
    setAnchorEl(event.currentTarget);
  };
  
  const handleProfileMenuClose = () => {
    setAnchorEl(null);
  };
  
  const handleLogout = () => {
    dispatch(logout());
    handleProfileMenuClose();
  };
  
  const isActive = (path) => {
    return location.pathname === path;
  };
  
  const drawer = (
    <div>
      <div className={classes.toolbar} />
      <List>
        <ListItem 
          button 
          component={RouterLink} 
          to="/"
          className={isActive('/') ? classes.active : ''}
        >
          <ListItemIcon>
            <DashboardIcon />
          </ListItemIcon>
          <ListItemText primary="Dashboard" />
        </ListItem>
        
        <ListItem 
          button 
          component={RouterLink} 
          to="/advanced-kpis"
          className={isActive('/advanced-kpis') ? classes.active : ''}
        >
          <ListItemIcon>
            <AssessmentIcon />
          </ListItemIcon>
          <ListItemText primary="KPIs" />
        </ListItem>
        
        <ListItem 
          button 
          component={RouterLink} 
          to="/planning/financial-independence"
          className={isActive('/planning/financial-independence') ? classes.active : ''}
        >
          <ListItemIcon>
            <TrendingUpIcon />
          </ListItemIcon>
          <ListItemText primary="Financial Independence" />
        </ListItem>
        
        <ListItem 
          button 
          component={RouterLink} 
          to="/reports"
          className={isActive('/reports') ? classes.active : ''}
        >
          <ListItemIcon>
            <DescriptionIcon />
          </ListItemIcon>
          <ListItemText primary="Reports" />
        </ListItem>
        
        <ListItem 
          button 
          component={RouterLink} 
          to="/settings"
          className={isActive('/settings') ? classes.active : ''}
        >
          <ListItemIcon>
            <SettingsIcon />
          </ListItemIcon>
          <ListItemText primary="Settings" />
        </ListItem>
      </List>
      
      <Divider />
      
      <List>
        <ListItem button onClick={handleAccountsClick}>
          <ListItemIcon>
            <AccountBalanceIcon />
          </ListItemIcon>
          <ListItemText primary="Accounts & Transactions" />
          {accountsOpen ? <ExpandLess /> : <ExpandMore />}
        </ListItem>
        
        <Collapse in={accountsOpen} timeout="auto" unmountOnExit>
          <List component="div" disablePadding>
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/accounts') ? classes.active : ''}`}
              component={RouterLink} 
              to="/accounts"
            >
              <ListItemIcon>
                <AccountBalanceIcon />
              </ListItemIcon>
              <ListItemText primary="Accounts" />
            </ListItem>
            
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/transactions') ? classes.active : ''}`}
              component={RouterLink} 
              to="/transactions"
            >
              <ListItemIcon>
                <ReceiptIcon />
              </ListItemIcon>
              <ListItemText primary="Transactions" />
            </ListItem>
            
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/connections') ? classes.active : ''}`}
              component={RouterLink} 
              to="/connections"
            >
              <ListItemIcon>
                <LinkIcon />
              </ListItemIcon>
              <ListItemText primary="Connections" />
            </ListItem>
            
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/import') ? classes.active : ''}`}
              component={RouterLink} 
              to="/import"
            >
              <ListItemIcon>
                <CloudUploadIcon />
              </ListItemIcon>
              <ListItemText primary="Import Data" />
            </ListItem>
          </List>
        </Collapse>
        
        <ListItem button onClick={handlePlanningClick}>
          <ListItemIcon>
            <TrendingUpIcon />
          </ListItemIcon>
          <ListItemText primary="Planning & Investments" />
          {planningOpen ? <ExpandLess /> : <ExpandMore />}
        </ListItem>
        
        <Collapse in={planningOpen} timeout="auto" unmountOnExit>
          <List component="div" disablePadding>
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/goals') ? classes.active : ''}`}
              component={RouterLink} 
              to="/goals"
            >
              <ListItemIcon>
                <TrendingUpIcon />
              </ListItemIcon>
              <ListItemText primary="Goals" />
            </ListItem>
            
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/investments') ? classes.active : ''}`}
              component={RouterLink} 
              to="/investments"
            >
              <ListItemIcon>
                <TrendingUpIcon />
              </ListItemIcon>
              <ListItemText primary="Investments" />
            </ListItem>
            
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/planning/retirement') ? classes.active : ''}`}
              component={RouterLink} 
              to="/planning/retirement"
            >
              <ListItemIcon>
                <TrendingUpIcon />
              </ListItemIcon>
              <ListItemText primary="Retirement Planning" />
            </ListItem>
            
            <ListItem 
              button 
              className={`${classes.nested} ${isActive('/planning/debt-payoff') ? classes.active : ''}`}
              component={RouterLink} 
              to="/planning/debt-payoff"
            >
              <ListItemIcon>
                <TrendingUpIcon />
              </ListItemIcon>
              <ListItemText primary="Debt Payoff" />
            </ListItem>
          </List>
        </Collapse>
      </List>
    </div>
  );
  
  return (
    <div className={classes.root}>
      <AppBar position="fixed" className={classes.appBar}>
        <Toolbar>
          <IconButton
            color="inherit"
            aria-label="open drawer"
            edge="start"
            onClick={handleDrawerToggle}
            className={classes.menuButton}
          >
            <MenuIcon />
          </IconButton>
          <Typography variant="h6" className={classes.title}>
            Finance Manager
          </Typography>
          <div className={classes.avatarContainer}>
            <Avatar 
              className={classes.avatar}
              onClick={handleProfileMenuOpen}
            >
              {user?.name?.charAt(0) || 'J'}
            </Avatar>
            <Typography variant="body1" className={classes.userName}>
              {user?.name || 'John Doe'}
            </Typography>
          </div>
          <Menu
            anchorEl={anchorEl}
            keepMounted
            open={Boolean(anchorEl)}
            onClose={handleProfileMenuClose}
          >
            <MenuItem component={RouterLink} to="/profile">Profile</MenuItem>
            <MenuItem component={RouterLink} to="/settings">Settings</MenuItem>
            <MenuItem onClick={handleLogout}>
              <ListItemIcon>
                <LogoutIcon fontSize="small" />
              </ListItemIcon>
              <ListItemText primary="Logout" />
            </MenuItem>
          </Menu>
        </Toolbar>
      </AppBar>
      
      <nav className={classes.drawer}>
        <Hidden mdUp implementation="css">
          <Drawer
            variant="temporary"
            open={mobileOpen}
            onClose={handleDrawerToggle}
            classes={{
              paper: classes.drawerPaper,
            }}
            ModalProps={{
              keepMounted: true, // Better open performance on mobile.
            }}
          >
            {drawer}
          </Drawer>
        </Hidden>
        <Hidden smDown implementation="css">
          <Drawer
            classes={{
              paper: classes.drawerPaper,
            }}
            variant="permanent"
            open
          >
            {drawer}
          </Drawer>
        </Hidden>
      </nav>
      
      <main className={classes.content}>
        <div className={classes.toolbar} />
        {children}
      </main>
    </div>
  );
};

export default MainLayout;
