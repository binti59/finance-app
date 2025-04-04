#!/bin/bash

# Docker Volume Fix Script for Personal Finance Management System
# This script ensures the store.js file is properly accessible within the Docker container
# Created: April 04, 2025

# Text colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display section headers
print_section() {
    echo -e "\n${BLUE}==== $1 ====${NC}\n"
}

# Function to display success messages
print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to display warning messages
print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

# Function to display error messages
print_error() {
    echo -e "${RED}✗ $1${NC}"
}

# Check if script is run as root
if [ "$EUID" -ne 0 ]; then
    print_error "This script must be run as root (with sudo)"
    exit 1
fi

# Welcome message
clear
echo -e "${BLUE}============================================================${NC}"
echo -e "${BLUE}    Docker Volume Fix for Personal Finance Management System    ${NC}"
echo -e "${BLUE}============================================================${NC}"
echo
echo -e "This script will fix the store.js file access issue in the Docker container."
echo

# Configuration variables with defaults
INSTALL_DIR="/opt/personal-finance-system"
FRONTEND_CONTAINER_NAME="personal-finance-system_frontend_1"

# Check if installation directory exists
if [ ! -d "$INSTALL_DIR" ]; then
    print_error "Installation directory not found: $INSTALL_DIR"
    read -p "Please enter the correct installation directory: " input_dir
    if [ -z "$input_dir" ]; then
        print_error "No directory specified. Exiting."
        exit 1
    fi
    INSTALL_DIR="$input_dir"
    if [ ! -d "$INSTALL_DIR" ]; then
        print_error "Directory does not exist: $INSTALL_DIR"
        exit 1
    fi
fi

# Check if frontend directory exists
if [ ! -d "$INSTALL_DIR/frontend" ]; then
    print_error "Frontend directory not found: $INSTALL_DIR/frontend"
    exit 1
fi

# Method 1: Create store.js file directly in the source code
print_section "Creating store.js File in Source Code"

mkdir -p "$INSTALL_DIR/frontend/src"
cat > "$INSTALL_DIR/frontend/src/store.js" << 'EOF'
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
    case 'ADD_ACCOUNT_SUCCESS':
      return { ...state, accounts: [...state.accounts, action.payload] };
    case 'UPDATE_ACCOUNT_SUCCESS':
      return {
        ...state,
        accounts: state.accounts.map(account => 
          account.id === action.payload.id ? action.payload : account
        )
      };
    case 'DELETE_ACCOUNT_SUCCESS':
      return {
        ...state,
        accounts: state.accounts.filter(account => account.id !== action.payload)
      };
    default:
      return state;
  }
};

const transactionsReducer = (state = { transactions: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_TRANSACTIONS_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_TRANSACTIONS_SUCCESS':
      return { ...state, transactions: action.payload, loading: false };
    case 'FETCH_TRANSACTIONS_FAILURE':
      return { ...state, error: action.payload, loading: false };
    default:
      return state;
  }
};

// Combine all reducers
const rootReducer = combineReducers({
  auth: authReducer,
  accounts: accountsReducer,
  transactions: transactionsReducer
  // Add other reducers as needed
});

// Create store with middleware
const store = createStore(
  rootReducer,
  applyMiddleware(thunk)
);

export default store;
EOF

print_success "Created store.js file in source code directory"

# Method 2: Update App.js to import store correctly
print_section "Checking App.js Import Statement"

APP_JS_PATH="$INSTALL_DIR/frontend/src/App.js"
if [ -f "$APP_JS_PATH" ]; then
    # Check if App.js imports store
    if grep -q "import store from './store'" "$APP_JS_PATH"; then
        print_success "App.js already imports store correctly"
    else
        # Check if App.js imports from react-redux
        if grep -q "import { Provider } from 'react-redux'" "$APP_JS_PATH"; then
            print_success "App.js imports Provider from react-redux"
            
            # Create a backup of App.js
            cp "$APP_JS_PATH" "$APP_JS_PATH.bak"
            print_success "Created backup of App.js"
            
            # Add store import to App.js
            sed -i '1s/^/import store from \'\.\/store\';\n/' "$APP_JS_PATH"
            print_success "Added store import to App.js"
        else
            print_warning "App.js does not import Provider from react-redux"
            
            # Create a backup of App.js
            cp "$APP_JS_PATH" "$APP_JS_PATH.bak"
            print_success "Created backup of App.js"
            
            # Add store and Provider imports to App.js
            sed -i '1s/^/import { Provider } from \'react-redux\';\nimport store from \'\.\/store\';\n/' "$APP_JS_PATH"
            print_success "Added store and Provider imports to App.js"
        fi
    }
    
    # Check if App.js wraps the app in Provider
    if grep -q "<Provider store={store}>" "$APP_JS_PATH"; then
        print_success "App.js already wraps the app in Provider"
    else
        # Create a backup of App.js if not already done
        if [ ! -f "$APP_JS_PATH.bak" ]; then
            cp "$APP_JS_PATH" "$APP_JS_PATH.bak"
            print_success "Created backup of App.js"
        fi
        
        # Try to wrap the app in Provider
        if grep -q "return (" "$APP_JS_PATH"; then
            # Find the line with "return ("
            RETURN_LINE=$(grep -n "return (" "$APP_JS_PATH" | head -1 | cut -d: -f1)
            
            # Find the closing parenthesis
            CLOSING_LINE=$(tail -n +$RETURN_LINE "$APP_JS_PATH" | grep -n ")" | head -1 | cut -d: -f1)
            CLOSING_LINE=$((RETURN_LINE + CLOSING_LINE - 1))
            
            # Insert Provider opening tag after "return ("
            sed -i "${RETURN_LINE}s/(/(\\n      <Provider store={store}>/" "$APP_JS_PATH"
            
            # Insert Provider closing tag before closing parenthesis
            sed -i "${CLOSING_LINE}s/)/      <\/Provider>\\n    )/" "$APP_JS_PATH"
            
            print_success "Wrapped the app in Provider"
        else
            print_warning "Could not automatically wrap the app in Provider"
            echo "Please manually update App.js to wrap the app in Provider:"
            echo "import { Provider } from 'react-redux';"
            echo "import store from './store';"
            echo ""
            echo "function App() {"
            echo "  return ("
            echo "    <Provider store={store}>"
            echo "      {/* Your app content */}"
            echo "    </Provider>"
            echo "  );"
            echo "}"
        fi
    fi
else
    print_warning "App.js not found at $APP_JS_PATH"
    
    # Create a basic App.js
    mkdir -p "$(dirname "$APP_JS_PATH")"
    cat > "$APP_JS_PATH" << 'EOF'
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
          <p>Loading application...</p>
        </main>
      </div>
    </Provider>
  );
}

export default App;
EOF
    print_success "Created basic App.js with proper store integration"
fi

# Method 3: Create index.js if it doesn't exist
print_section "Checking index.js"

INDEX_JS_PATH="$INSTALL_DIR/frontend/src/index.js"
if [ -f "$INDEX_JS_PATH" ]; then
    print_success "index.js exists"
else
    print_warning "index.js not found at $INDEX_JS_PATH"
    
    # Create a basic index.js
    mkdir -p "$(dirname "$INDEX_JS_PATH")"
    cat > "$INDEX_JS_PATH" << 'EOF'
import React from 'react';
import ReactDOM from 'react-dom/client';
import './index.css';
import App from './App';
import reportWebVitals from './reportWebVitals';

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
EOF
    print_success "Created basic index.js"
    
    # Create reportWebVitals.js if it doesn't exist
    if [ ! -f "$INSTALL_DIR/frontend/src/reportWebVitals.js" ]; then
        cat > "$INSTALL_DIR/frontend/src/reportWebVitals.js" << 'EOF'
const reportWebVitals = onPerfEntry => {
  if (onPerfEntry && onPerfEntry instanceof Function) {
    import('web-vitals').then(({ getCLS, getFID, getFCP, getLCP, getTTFB }) => {
      getCLS(onPerfEntry);
      getFID(onPerfEntry);
      getFCP(onPerfEntry);
      getLCP(onPerfEntry);
      getTTFB(onPerfEntry);
    });
  }
};

export default reportWebVitals;
EOF
        print_success "Created reportWebVitals.js"
    fi
    
    # Create basic CSS files
    if [ ! -f "$INSTALL_DIR/frontend/src/index.css" ]; then
        cat > "$INSTALL_DIR/frontend/src/index.css" << 'EOF'
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
        print_success "Created index.css"
    fi
    
    if [ ! -f "$INSTALL_DIR/frontend/src/App.css" ]; then
        cat > "$INSTALL_DIR/frontend/src/App.css" << 'EOF'
.App {
  text-align: center;
}

.App-header {
  background-color: #282c34;
  min-height: 20vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-size: calc(10px + 2vmin);
  color: white;
}

main {
  padding: 20px;
}
EOF
        print_success "Created App.css"
    fi
fi

# Method 4: Rebuild the frontend container
print_section "Rebuilding Frontend Container"

cd "$INSTALL_DIR"

echo -e "Stopping containers..."
docker-compose down frontend

echo -e "Building frontend container..."
docker-compose build frontend

echo -e "Starting containers..."
docker-compose up -d

if [ $? -eq 0 ]; then
    print_success "Frontend container rebuilt and started successfully."
else
    print_error "Failed to rebuild and start frontend container."
    
    # Try alternative approach - copy file directly into container
    print_section "Trying Alternative Approach - Copy File Directly Into Container"
    
    # Find the frontend container
    FRONTEND_CONTAINER=$(docker ps -qf "name=frontend")
    if [ -z "$FRONTEND_CONTAINER" ]; then
        print_warning "Frontend container is not running."
        echo -e "Starting frontend container..."
        docker-compose up -d frontend
        sleep 5
        FRONTEND_CONTAINER=$(docker ps -qf "name=frontend")
        if [ -z "$FRONTEND_CONTAINER" ]; then
            print_error "Failed to start frontend container."
            exit 1
        fi
    fi
    
    # Copy store.js directly into the container
    echo -e "Copying store.js directly into the container..."
    docker cp "$INSTALL_DIR/frontend/src/store.js" "$FRONTEND_CONTAINER:/app/src/store.js"
    
    if [ $? -eq 0 ]; then
        print_success "Successfully copied store.js into the container."
        
        # Restart the container to apply changes
        echo -e "Restarting frontend container..."
        docker-compose restart frontend
        
        if [ $? -eq 0 ]; then
            print_success "Frontend container restarted successfully."
        else
            print_error "Failed to restart frontend container."
        fi
    else
        print_error "Failed to copy store.js into the container."
    fi
fi

# Method 5: Update Dockerfile to include store.js
print_section "Updating Dockerfile"

DOCKERFILE_PATH="$INSTALL_DIR/frontend/Dockerfile"
if [ -f "$DOCKERFILE_PATH" ]; then
    # Create a backup of Dockerfile
    cp "$DOCKERFILE_PATH" "$DOCKERFILE_PATH.bak"
    print_success "Created backup of Dockerfile"
    
    # Check if Dockerfile already has a command to create store.js
    if grep -q "store.js" "$DOCKERFILE_PATH"; then
        print_warning "Dockerfile already contains store.js-related commands"
    else
        # Add command to create store.js in Dockerfile
        # Find the line with COPY . .
        COPY_LINE=$(grep -n "COPY \. \." "$DOCKERFILE_PATH" | cut -d: -f1)
        
        if [ -n "$COPY_LINE" ]; then
            # Insert commands before COPY . .
            sed -i "${COPY_LINE}i# Create store.js file\nRUN mkdir -p /app/src\nCOPY src/store.js /app/src/store.js" "$DOCKERFILE_PATH"
            print_success "Updated Dockerfile to include store.js"
        else
            print_warning "Could not find 'COPY . .' line in Dockerfile"
            echo -e "Appending store.js commands to the end of the Dockerfile..."
            echo -e "\n# Create store.js file\nRUN mkdir -p /app/src\nCOPY src/store.js /app/src/store.js" >> "$DOCKERFILE_PATH"
            print_success "Updated Dockerfile to include store.js"
        fi
    fi
else
    print_warning "Dockerfile not found at $DOCKERFILE_PATH"
    
    # Create a basic Dockerfile
    mkdir -p "$(dirname "$DOCKERFILE_PATH")"
    cat > "$DOCKERFILE_PATH" << 'EOF'
FROM node:20-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install

# Create store.js file
RUN mkdir -p /app/src
COPY src/store.js /app/src/store.js

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
EOF
    print_success "Created basic Dockerfile with store.js configuration"
fi

# Method 6: Update docker-compose.yml to use volumes correctly
print_section "Updating docker-compose.yml"

DOCKER_COMPOSE_PATH="$INSTALL_DIR/docker-compose.yml"
if [ -f "$DOCKER_COMPOSE_PATH" ]; then
    # Create a backup of docker-compose.yml
    cp "$DOCKER_COMPOSE_PATH" "$DOCKER_COMPOSE_PATH.bak"
    print_success "Created backup of docker-compose.yml"
    
    # Check if docker-compose.yml already has a volume for store.js
    if grep -q "- ./frontend/src/store.js:/app/src/store.js" "$DOCKER_COMPOSE_PATH"; then
        print_warning "docker-compose.yml already contains volume for store.js"
    else
        # Check if frontend service has volumes section
        if grep -q "frontend:.*volumes:" "$DOCKER_COMPOSE_PATH" -A 10; then
            # Add store.js volume to existing volumes section
            sed -i '/frontend:.*volumes:/,/[^-]/ s/volumes:/volumes:\n      - .\/frontend\/src\/store.js:\/app\/src\/store.js/' "$DOCKER_COMPOSE_PATH"
            print_success "Added store.js volume to existing volumes section"
        else
            # Add volumes section to frontend service
            sed -i '/frontend:/a\    volumes:\n      - ./frontend/src/store.js:/app/src/store.js' "$DOCKER_COMPOSE_PATH"
            print_success "Added volumes section with store.js to frontend service"
        fi
    fi
else
    print_error "docker-compose.yml not found at $DOCKER_COMPOSE_PATH"
    exit 1
fi

# Final step: Rebuild and restart with updated configuration
print_section "Final Rebuild and Restart"

cd "$INSTALL_DIR"

echo -e "Stopping all containers..."
docker-compose down

echo -e "Building frontend container with updated configuration..."
docker-compose build frontend

echo -e "Starting all containers..."
docker-compose up -d

if [ $? -eq 0 ]; then
    print_success "All containers rebuilt and started successfully."
else
    print_error "Failed to rebuild and start containers."
fi

# Final message
print_section "Docker Volume Fix Complete"
echo -e "The Docker volume fix process is complete. The store.js file should now be properly accessible within the container."
echo
echo -e "If you still encounter issues, try accessing the application in a different browser or in incognito mode to rule out browser extension conflicts."
echo
echo -e "You can access your application at:"
if [ -f "/etc/nginx/sites-available/personal-finance.conf" ]; then
    DOMAIN=$(grep "server_name" /etc/nginx/sites-available/personal-finance.conf | awk '{print $2}' | tr -d ';')
    if [ -n "$DOMAIN" ] && [ "$DOMAIN" != "_" ]; then
        echo -e "https://$DOMAIN"
    else
        echo -e "http://$(hostname -I | awk '{print $1}'):3000"
    fi
else
    echo -e "http://$(hostname -I | awk '{print $1}'):3000"
fi
echo
print_success "Thank you for using the Enhanced Personal Finance Management System!"
