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
    case 'ADD_TRANSACTION_SUCCESS':
      return { ...state, transactions: [...state.transactions, action.payload] };
    case 'UPDATE_TRANSACTION_SUCCESS':
      return {
        ...state,
        transactions: state.transactions.map(transaction => 
          transaction.id === action.payload.id ? action.payload : transaction
        )
      };
    case 'DELETE_TRANSACTION_SUCCESS':
      return {
        ...state,
        transactions: state.transactions.filter(transaction => transaction.id !== action.payload)
      };
    default:
      return state;
  }
};

const categoriesReducer = (state = { categories: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_CATEGORIES_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_CATEGORIES_SUCCESS':
      return { ...state, categories: action.payload, loading: false };
    case 'FETCH_CATEGORIES_FAILURE':
      return { ...state, error: action.payload, loading: false };
    default:
      return state;
  }
};

const assetsReducer = (state = { assets: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_ASSETS_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_ASSETS_SUCCESS':
      return { ...state, assets: action.payload, loading: false };
    case 'FETCH_ASSETS_FAILURE':
      return { ...state, error: action.payload, loading: false };
    case 'ADD_ASSET_SUCCESS':
      return { ...state, assets: [...state.assets, action.payload] };
    case 'UPDATE_ASSET_SUCCESS':
      return {
        ...state,
        assets: state.assets.map(asset => 
          asset.id === action.payload.id ? action.payload : asset
        )
      };
    case 'DELETE_ASSET_SUCCESS':
      return {
        ...state,
        assets: state.assets.filter(asset => asset.id !== action.payload)
      };
    default:
      return state;
  }
};

const liabilitiesReducer = (state = { liabilities: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_LIABILITIES_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_LIABILITIES_SUCCESS':
      return { ...state, liabilities: action.payload, loading: false };
    case 'FETCH_LIABILITIES_FAILURE':
      return { ...state, error: action.payload, loading: false };
    case 'ADD_LIABILITY_SUCCESS':
      return { ...state, liabilities: [...state.liabilities, action.payload] };
    case 'UPDATE_LIABILITY_SUCCESS':
      return {
        ...state,
        liabilities: state.liabilities.map(liability => 
          liability.id === action.payload.id ? action.payload : liability
        )
      };
    case 'DELETE_LIABILITY_SUCCESS':
      return {
        ...state,
        liabilities: state.liabilities.filter(liability => liability.id !== action.payload)
      };
    default:
      return state;
  }
};

const goalsReducer = (state = { goals: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_GOALS_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_GOALS_SUCCESS':
      return { ...state, goals: action.payload, loading: false };
    case 'FETCH_GOALS_FAILURE':
      return { ...state, error: action.payload, loading: false };
    case 'ADD_GOAL_SUCCESS':
      return { ...state, goals: [...state.goals, action.payload] };
    case 'UPDATE_GOAL_SUCCESS':
      return {
        ...state,
        goals: state.goals.map(goal => 
          goal.id === action.payload.id ? action.payload : goal
        )
      };
    case 'DELETE_GOAL_SUCCESS':
      return {
        ...state,
        goals: state.goals.filter(goal => goal.id !== action.payload)
      };
    default:
      return state;
  }
};

const budgetsReducer = (state = { budgets: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_BUDGETS_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_BUDGETS_SUCCESS':
      return { ...state, budgets: action.payload, loading: false };
    case 'FETCH_BUDGETS_FAILURE':
      return { ...state, error: action.payload, loading: false };
    case 'ADD_BUDGET_SUCCESS':
      return { ...state, budgets: [...state.budgets, action.payload] };
    case 'UPDATE_BUDGET_SUCCESS':
      return {
        ...state,
        budgets: state.budgets.map(budget => 
          budget.id === action.payload.id ? action.payload : budget
        )
      };
    case 'DELETE_BUDGET_SUCCESS':
      return {
        ...state,
        budgets: state.budgets.filter(budget => budget.id !== action.payload)
      };
    default:
      return state;
  }
};

const kpisReducer = (state = { kpis: {}, loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_KPIS_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_KPIS_SUCCESS':
      return { ...state, kpis: action.payload, loading: false };
    case 'FETCH_KPIS_FAILURE':
      return { ...state, error: action.payload, loading: false };
    default:
      return state;
  }
};

const connectionsReducer = (state = { connections: [], loading: false, error: null }, action) => {
  switch (action.type) {
    case 'FETCH_CONNECTIONS_REQUEST':
      return { ...state, loading: true };
    case 'FETCH_CONNECTIONS_SUCCESS':
      return { ...state, connections: action.payload, loading: false };
    case 'FETCH_CONNECTIONS_FAILURE':
      return { ...state, error: action.payload, loading: false };
    case 'ADD_CONNECTION_SUCCESS':
      return { ...state, connections: [...state.connections, action.payload] };
    case 'UPDATE_CONNECTION_SUCCESS':
      return {
        ...state,
        connections: state.connections.map(connection => 
          connection.id === action.payload.id ? action.payload : connection
        )
      };
    case 'DELETE_CONNECTION_SUCCESS':
      return {
        ...state,
        connections: state.connections.filter(connection => connection.id !== action.payload)
      };
    default:
      return state;
  }
};

// Combine all reducers
const rootReducer = combineReducers({
  auth: authReducer,
  accounts: accountsReducer,
  transactions: transactionsReducer,
  categories: categoriesReducer,
  assets: assetsReducer,
  liabilities: liabilitiesReducer,
  goals: goalsReducer,
  budgets: budgetsReducer,
  kpis: kpisReducer,
  connections: connectionsReducer
});

// Create store with middleware
const store = createStore(
  rootReducer,
  applyMiddleware(thunk)
);

export default store;
