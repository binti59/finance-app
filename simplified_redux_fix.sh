#!/bin/bash

# Simplified Redux Store Fix Script for Personal Finance Management System
# This script provides a minimal Redux store implementation without middleware or extensions

echo "============================================================"
echo "    Simplified Redux Store Fix for Finance Application    "
echo "============================================================"

# Navigate to the installation directory
cd /opt/personal-finance-system

# Create the simplified store.js file
echo "Creating simplified Redux store file..."
mkdir -p frontend/src
cat > frontend/src/store.js << 'EOF'
// Redux Store Configuration - Simplified Version
import { createStore, combineReducers } from 'redux';

// Import reducers
const authReducer = (state = { isAuthenticated: false, user: null, token: null }, action) => {
  switch (action.type) {
    case 'LOGIN_SUCCESS':
      return {
        ...state,
        isAuthenticated: true,
        user: action.payload.user,
        token: action.payload.token
      };
    case 'LOGOUT':
      return {
        ...state,
        isAuthenticated: false,
        user: null,
        token: null
      };
    default:
      return state;
  }
};

const accountsReducer = (state = { accounts: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_ACCOUNTS_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_ACCOUNTS_SUCCESS':
      return { ...state, accounts: action.payload, loading: false };
    case 'FETCH_ACCOUNTS_FAILURE':
      return { ...state, error: action.payload, loading: false };
    default:
      return state;
  }
};

// Combine all reducers
const rootReducer = combineReducers({
  auth: authReducer,
  accounts: accountsReducer
});

// Create store without middleware to avoid errors
const store = createStore(rootReducer);

export default store;
EOF
echo "✓ Simplified Redux store file created"

# Update package.json to remove redux-devtools-extension
echo "Updating package.json to remove unnecessary dependencies..."
cat > frontend/package.json << 'EOF'
{
  "name": "finance-app-frontend",
  "version": "1.0.0",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.16.5",
    "@testing-library/react": "^13.4.0",
    "@testing-library/user-event": "^14.4.3",
    "axios": "^1.3.4",
    "chart.js": "^4.2.1",
    "react": "^18.2.0",
    "react-chartjs-2": "^5.2.0",
    "react-dom": "^18.2.0",
    "react-redux": "^8.0.5",
    "react-router-dom": "^6.9.0",
    "react-scripts": "5.0.1",
    "redux": "^4.2.1",
    "web-vitals": "^3.3.0"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF
echo "✓ package.json updated to remove unnecessary dependencies"

# Rebuild and restart everything
echo "Rebuilding and restarting containers..."
docker-compose down
docker-compose build frontend
docker-compose up -d

echo "✓ Simplified Redux store fix applied successfully!"
echo "Please wait a few moments for the application to start, then access it at your domain."
echo "If you still encounter issues, please try clearing your browser cache or using incognito mode."
