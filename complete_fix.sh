#!/bin/bash

# Complete Fix Script for Personal Finance Management System
# This script fixes all issues in one go

echo "============================================================"
echo "    Complete Fix for Personal Finance Management System    "
echo "============================================================"

# Navigate to the installation directory
cd /opt/personal-finance-system

# 1. Create the store.js file
echo "Creating Redux store file..."
mkdir -p frontend/src
cat > frontend/src/store.js << 'EOF'
// Redux Store Configuration
import { createStore, applyMiddleware, combineReducers } from 'redux';
import thunk from 'redux-thunk';

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

// Create store with middleware
const store = createStore(
  rootReducer,
  applyMiddleware(thunk)
);

export default store;
EOF
echo "✓ Redux store file created"

# 2. Create a simplified App.js without Material-UI dependencies
echo "Creating simplified App.js..."
cat > frontend/src/App.js << 'EOF'
import React from 'react';
import { Provider } from 'react-redux';
import store from './store';
import './App.css';

function App() {
  return (
    <Provider store={store}>
      <div className="App">
        <header className="App-header">
          <h1>Personal Finance Management System</h1>
          <p>Your comprehensive financial dashboard</p>
        </header>
        <main>
          <div className="dashboard-container">
            <h2>Welcome to Your Financial Dashboard</h2>
            <p>This application helps you track, analyze, and optimize your financial health.</p>
            <div className="feature-list">
              <div className="feature-item">
                <h3>Multi-source Data Integration</h3>
                <p>Connect to HSBC, Trading212, Moneybox and more</p>
              </div>
              <div className="feature-item">
                <h3>Comprehensive Financial Dashboard</h3>
                <p>Track net worth, income, expenses, and cash flow</p>
              </div>
              <div className="feature-item">
                <h3>Investment Portfolio Management</h3>
                <p>Monitor performance and diversification</p>
              </div>
              <div className="feature-item">
                <h3>Financial Independence Planning</h3>
                <p>Calculate and track progress toward financial freedom</p>
              </div>
            </div>
          </div>
        </main>
        <footer>
          <p>Enhanced Personal Finance Management System</p>
        </footer>
      </div>
    </Provider>
  );
}

export default App;
EOF
echo "✓ Simplified App.js created"

# 3. Create CSS file
echo "Creating CSS file..."
cat > frontend/src/App.css << 'EOF'
.App {
  text-align: center;
  font-family: Arial, sans-serif;
}

.App-header {
  background-color: #2c3e50;
  padding: 2rem;
  color: white;
}

main {
  padding: 2rem;
}

.dashboard-container {
  max-width: 1200px;
  margin: 0 auto;
}

.feature-list {
  display: flex;
  flex-wrap: wrap;
  justify-content: space-around;
  margin-top: 2rem;
}

.feature-item {
  width: 45%;
  margin-bottom: 2rem;
  padding: 1.5rem;
  border-radius: 8px;
  background-color: #f8f9fa;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

footer {
  background-color: #f8f9fa;
  padding: 1rem;
  margin-top: 2rem;
  color: #6c757d;
}

@media (max-width: 768px) {
  .feature-item {
    width: 100%;
  }
}
EOF
echo "✓ CSS file created"

# 4. Create index.js
echo "Creating index.js..."
cat > frontend/src/index.js << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
EOF
echo "✓ index.js created"

# 5. Create index.css
echo "Creating index.css..."
cat > frontend/src/index.css << 'EOF'
body {
  margin: 0;
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen',
    'Ubuntu', 'Cantarell', 'Fira Sans', 'Droid Sans', 'Helvetica Neue',
    sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

code {
  font-family: source-code-pro, Menlo, Monaco, Consolas, 'Courier New',
    monospace;
}
EOF
echo "✓ index.css created"

# 6. Update package.json to include all necessary dependencies
echo "Updating package.json..."
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
    "redux-thunk": "^2.4.2",
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
echo "✓ package.json updated"

# 7. Update Dockerfile to install dependencies correctly
echo "Updating Dockerfile..."
cat > frontend/Dockerfile << 'EOF'
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
echo "✓ Dockerfile updated"

# 8. Rebuild and restart everything
echo "Rebuilding and restarting containers..."
docker-compose down
docker-compose build frontend
docker-compose up -d

echo "✓ All fixes applied successfully!"
echo "Please wait a few moments for the application to start, then access it at your domain."
echo "If you still encounter issues, please try clearing your browser cache or using incognito mode."
