import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Switch, Redirect } from 'react-router-dom';
import { Provider } from 'react-redux';
import { ThemeProvider, createTheme } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';
import store from './store';

// Layout Components
import MainLayout from './layouts/MainLayout';
import AuthLayout from './layouts/AuthLayout';

// Auth Pages
import Login from './pages/auth/Login';
import Register from './pages/auth/Register';
import ForgotPassword from './pages/auth/ForgotPassword';
import ResetPassword from './pages/auth/ResetPassword';

// Main Pages
import Dashboard from './pages/Dashboard';
import Accounts from './pages/Accounts';
import Transactions from './pages/Transactions';
import Budget from './pages/Budget';
import Goals from './pages/Goals';
import Investments from './pages/Investments';
import Reports from './pages/Reports';
import Settings from './pages/Settings';
import Profile from './pages/Profile';

// Data Connection Pages
import Connections from './pages/Connections';
import ImportData from './pages/ImportData';

// Financial Planning Pages
import FinancialIndependence from './pages/planning/FinancialIndependence';
import RetirementPlanning from './pages/planning/RetirementPlanning';
import DebtPayoff from './pages/planning/DebtPayoff';

// Utility Components
import PrivateRoute from './components/routing/PrivateRoute';
import Notifications from './components/common/Notifications';
import LoadingScreen from './components/common/LoadingScreen';

// Services
import { setAuthToken } from './utils/api';
import { loadUser } from './actions/authActions';

// Create theme
const theme = createTheme({
  palette: {
    primary: {
      main: '#1976d2',
    },
    secondary: {
      main: '#dc004e',
    },
    background: {
      default: '#f5f5f5',
    },
  },
  typography: {
    fontFamily: [
      'Roboto',
      'Arial',
      'sans-serif',
    ].join(','),
  },
  overrides: {
    MuiCssBaseline: {
      '@global': {
        body: {
          backgroundColor: '#f5f5f5',
        },
      },
    },
  },
});

const App = () => {
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check for token in storage
    const token = localStorage.getItem('token');
    if (token) {
      // Set auth token in axios headers
      setAuthToken(token);
      // Load user data
      store.dispatch(loadUser());
    }
    
    // Set loading to false after initial auth check
    setTimeout(() => setLoading(false), 1000);
  }, []);

  if (loading) {
    return <LoadingScreen />;
  }

  return (
    <Provider store={store}>
      <ThemeProvider theme={theme}>
        <CssBaseline />
        <Router>
          <Notifications />
          <Switch>
            {/* Auth Routes */}
            <Route exact path="/login">
              <AuthLayout>
                <Login />
              </AuthLayout>
            </Route>
            <Route exact path="/register">
              <AuthLayout>
                <Register />
              </AuthLayout>
            </Route>
            <Route exact path="/forgot-password">
              <AuthLayout>
                <ForgotPassword />
              </AuthLayout>
            </Route>
            <Route exact path="/reset-password/:token">
              <AuthLayout>
                <ResetPassword />
              </AuthLayout>
            </Route>

            {/* Private Routes */}
            <PrivateRoute exact path="/">
              <MainLayout>
                <Dashboard />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/accounts">
              <MainLayout>
                <Accounts />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/transactions">
              <MainLayout>
                <Transactions />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/budget">
              <MainLayout>
                <Budget />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/goals">
              <MainLayout>
                <Goals />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/investments">
              <MainLayout>
                <Investments />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/reports">
              <MainLayout>
                <Reports />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/connections">
              <MainLayout>
                <Connections />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/import">
              <MainLayout>
                <ImportData />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/planning/financial-independence">
              <MainLayout>
                <FinancialIndependence />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/planning/retirement">
              <MainLayout>
                <RetirementPlanning />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/planning/debt-payoff">
              <MainLayout>
                <DebtPayoff />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/settings">
              <MainLayout>
                <Settings />
              </MainLayout>
            </PrivateRoute>
            
            <PrivateRoute exact path="/profile">
              <MainLayout>
                <Profile />
              </MainLayout>
            </PrivateRoute>

            {/* Redirect to dashboard if logged in, otherwise to login */}
            <Route path="*">
              <Redirect to="/" />
            </Route>
          </Switch>
        </Router>
      </ThemeProvider>
    </Provider>
  );
};

export default App;
