#!/bin/bash

# Navigation and Routing Fix Script for Personal Finance Management System
# This script adds navigation and routing components to the application

echo "============================================================"
echo "    Navigation and Routing Fix for Finance Application    "
echo "============================================================"

# Navigate to the installation directory
cd /opt/personal-finance-system

# Create the updated App.js file with navigation
echo "Creating App.js with navigation and routing..."
cat > frontend/src/App.js << 'EOF'
import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import { Provider } from 'react-redux';
import store from './store';
import './App.css';

// Simple placeholder components for different pages
const Dashboard = () => (
  <div className="page-container">
    <h2>Dashboard</h2>
    <p>Your financial overview will appear here.</p>
  </div>
);

const Transactions = () => (
  <div className="page-container">
    <h2>Transactions</h2>
    <p>Your transaction history will appear here.</p>
  </div>
);

const Accounts = () => (
  <div className="page-container">
    <h2>Accounts</h2>
    <p>Your connected accounts will appear here.</p>
  </div>
);

const Investments = () => (
  <div className="page-container">
    <h2>Investments</h2>
    <p>Your investment portfolio will appear here.</p>
  </div>
);

const Settings = () => (
  <div className="page-container">
    <h2>Settings</h2>
    <p>Application settings will appear here.</p>
  </div>
);

const Login = () => (
  <div className="login-container">
    <h2>Login</h2>
    <form className="login-form">
      <div className="form-group">
        <label htmlFor="email">Email</label>
        <input type="email" id="email" placeholder="Enter your email" />
      </div>
      <div className="form-group">
        <label htmlFor="password">Password</label>
        <input type="password" id="password" placeholder="Enter your password" />
      </div>
      <button type="submit" className="login-button">Login</button>
    </form>
    <p className="login-footer">Don't have an account? <a href="#signup">Sign up</a></p>
  </div>
);

function App() {
  return (
    <Provider store={store}>
      <Router>
        <div className="App">
          <header className="App-header">
            <h1>Personal Finance Management System</h1>
            <p>Your comprehensive financial dashboard</p>
            <nav className="main-nav">
              <ul>
                <li><Link to="/">Dashboard</Link></li>
                <li><Link to="/transactions">Transactions</Link></li>
                <li><Link to="/accounts">Accounts</Link></li>
                <li><Link to="/investments">Investments</Link></li>
                <li><Link to="/settings">Settings</Link></li>
                <li className="login-link"><Link to="/login">Login</Link></li>
              </ul>
            </nav>
          </header>
          <main>
            <Routes>
              <Route path="/" element={<Dashboard />} />
              <Route path="/transactions" element={<Transactions />} />
              <Route path="/accounts" element={<Accounts />} />
              <Route path="/investments" element={<Investments />} />
              <Route path="/settings" element={<Settings />} />
              <Route path="/login" element={<Login />} />
            </Routes>
          </main>
          <footer>
            <p>Enhanced Personal Finance Management System</p>
          </footer>
        </div>
      </Router>
    </Provider>
  );
}

export default App;
EOF
echo "✓ App.js with navigation created"

# Create the CSS file with navigation styles
echo "Creating CSS file with navigation styles..."
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

/* Navigation and login styles */
.main-nav {
  background-color: #34495e;
  padding: 0.5rem 0;
  margin-top: 1rem;
}

.main-nav ul {
  display: flex;
  list-style: none;
  margin: 0;
  padding: 0;
  justify-content: center;
}

.main-nav li {
  margin: 0 1rem;
}

.main-nav a {
  color: white;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.main-nav a:hover {
  background-color: #2c3e50;
}

.login-link a {
  background-color: #e74c3c;
}

.login-link a:hover {
  background-color: #c0392b;
}

.page-container {
  max-width: 1200px;
  margin: 2rem auto;
  padding: 2rem;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.login-container {
  max-width: 500px;
  margin: 2rem auto;
  padding: 2rem;
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  margin: 1.5rem 0;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.form-group label {
  font-weight: 500;
  color: #2c3e50;
}

.form-group input {
  padding: 0.75rem;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 1rem;
}

.login-button {
  background-color: #3498db;
  color: white;
  border: none;
  padding: 0.75rem;
  border-radius: 4px;
  font-size: 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s;
}

.login-button:hover {
  background-color: #2980b9;
}

.login-footer {
  text-align: center;
  margin-top: 1.5rem;
  color: #7f8c8d;
}

.login-footer a {
  color: #3498db;
  text-decoration: none;
}

.login-footer a:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .feature-item {
    width: 100%;
  }
  
  .main-nav ul {
    flex-direction: column;
    align-items: center;
  }
  
  .main-nav li {
    margin: 0.5rem 0;
  }
}
EOF
echo "✓ CSS file with navigation styles created"

# Update package.json to include react-router-dom
echo "Updating package.json to include react-router-dom..."
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
echo "✓ package.json updated with react-router-dom"

# Rebuild and restart everything
echo "Rebuilding and restarting containers..."
docker-compose down
docker-compose build frontend
docker-compose up -d

echo "✓ Navigation and routing fix applied successfully!"
echo "Please wait a few moments for the application to start, then access it at your domain."
echo "If you still encounter issues, please try clearing your browser cache or using incognito mode."
