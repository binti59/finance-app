# Personal Finance Management System - Enhanced Architecture

## System Overview
The Personal Finance Management System is a comprehensive web application designed to help users track, analyze, and optimize their financial health. The system integrates data from various financial sources including bank accounts, investment platforms, and cryptocurrency exchanges to provide a holistic view of a user's financial status.

## Architecture Overview
The system follows a modern three-tier architecture with clear separation of concerns:

1. **Presentation Layer**: React.js frontend with Redux state management
2. **Application Layer**: Node.js/Express.js backend API services
3. **Data Layer**: PostgreSQL database with structured financial data models

## Database Schema

### Users
```
users
- id (PK)
- email (unique)
- password_hash
- first_name
- last_name
- profile_image
- created_at
- updated_at
```

### Financial Accounts
```
accounts
- id (PK)
- user_id (FK)
- name
- type (checking, savings, investment, credit, loan, etc.)
- institution
- balance
- currency
- is_active
- last_sync
- created_at
- updated_at
```

### External Connections
```
connections
- id (PK)
- user_id (FK)
- provider (HSBC, Trading212, Moneybox)
- access_token
- refresh_token
- token_expires_at
- status
- last_sync
- created_at
- updated_at
```

### Transactions
```
transactions
- id (PK)
- user_id (FK)
- account_id (FK)
- category_id (FK)
- amount
- currency
- description
- transaction_date
- transaction_type (income, expense, transfer)
- is_recurring
- recurrence_pattern
- created_at
- updated_at
```

### Categories
```
categories
- id (PK)
- name
- type (income, expense)
- icon
- color
- parent_id (FK, self-referential for subcategories)
- created_at
- updated_at
```

### Assets
```
assets
- id (PK)
- user_id (FK)
- name
- type (stock, bond, real_estate, crypto, etc.)
- value
- currency
- acquisition_date
- acquisition_price
- current_price
- quantity
- notes
- created_at
- updated_at
```

### Liabilities
```
liabilities
- id (PK)
- user_id (FK)
- name
- type (mortgage, loan, credit_card, etc.)
- amount
- currency
- interest_rate
- start_date
- end_date
- payment_amount
- payment_frequency
- created_at
- updated_at
```

### Financial Goals
```
goals
- id (PK)
- user_id (FK)
- name
- target_amount
- current_amount
- currency
- deadline
- category
- priority
- status
- created_at
- updated_at
```

### Budgets
```
budgets
- id (PK)
- user_id (FK)
- category_id (FK)
- amount
- currency
- period (monthly, yearly)
- start_date
- end_date
- created_at
- updated_at
```

### Financial KPIs
```
kpis
- id (PK)
- user_id (FK)
- type (net_worth, savings_rate, fi_index, etc.)
- value
- date
- created_at
- updated_at
```

### Reports
```
reports
- id (PK)
- user_id (FK)
- name
- type
- parameters (JSON)
- created_at
- updated_at
```

### Notifications
```
notifications
- id (PK)
- user_id (FK)
- title
- message
- type
- is_read
- created_at
- updated_at
```

## Backend API Services

### Authentication Service
- `/api/auth/register` - User registration
- `/api/auth/login` - User login with JWT token generation
- `/api/auth/refresh` - Refresh JWT token
- `/api/auth/logout` - User logout
- `/api/auth/profile` - Get/update user profile

### Account Service
- `/api/accounts` - CRUD operations for financial accounts
- `/api/accounts/:id/balance` - Get account balance history
- `/api/accounts/:id/sync` - Sync account with financial institution

### Connection Service
- `/api/connections` - CRUD operations for external financial connections
- `/api/connections/:provider/auth` - Authenticate with external provider
- `/api/connections/:provider/callback` - OAuth callback handler
- `/api/connections/:id/sync` - Sync data from external connection

### Transaction Service
- `/api/transactions` - CRUD operations for transactions
- `/api/transactions/import` - Import transactions from CSV/PDF
- `/api/transactions/categorize` - Auto-categorize transactions
- `/api/transactions/recurring` - Identify recurring transactions

### Category Service
- `/api/categories` - CRUD operations for transaction categories
- `/api/categories/default` - Get default category set

### Asset Service
- `/api/assets` - CRUD operations for assets
- `/api/assets/performance` - Get asset performance metrics
- `/api/assets/allocation` - Get asset allocation breakdown

### Liability Service
- `/api/liabilities` - CRUD operations for liabilities
- `/api/liabilities/summary` - Get liability summary

### Goal Service
- `/api/goals` - CRUD operations for financial goals
- `/api/goals/:id/progress` - Update goal progress
- `/api/goals/recommendations` - Get goal recommendations

### Budget Service
- `/api/budgets` - CRUD operations for budgets
- `/api/budgets/performance` - Get budget performance metrics
- `/api/budgets/recommendations` - Get budget recommendations

### KPI Service
- `/api/kpis` - Get financial KPIs
- `/api/kpis/net-worth` - Calculate net worth
- `/api/kpis/savings-rate` - Calculate savings rate
- `/api/kpis/fi-index` - Calculate financial independence index
- `/api/kpis/freedom-number` - Calculate financial freedom number
- `/api/kpis/health-score` - Calculate financial health score

### Report Service
- `/api/reports` - CRUD operations for reports
- `/api/reports/generate` - Generate custom reports
- `/api/reports/export` - Export reports in various formats

### Dashboard Service
- `/api/dashboard` - Get dashboard data
- `/api/dashboard/summary` - Get financial summary
- `/api/dashboard/cash-flow` - Get cash flow data
- `/api/dashboard/expense-breakdown` - Get expense breakdown

### Notification Service
- `/api/notifications` - CRUD operations for notifications
- `/api/notifications/read` - Mark notifications as read

## Frontend Components

### Core Components
- `App` - Main application component
- `Router` - Application routing
- `AuthProvider` - Authentication context provider
- `ThemeProvider` - Theme context provider
- `Layout` - Main application layout

### Authentication Components
- `Login` - User login form
- `Register` - User registration form
- `ForgotPassword` - Password recovery
- `Profile` - User profile management

### Dashboard Components
- `Dashboard` - Main dashboard page
- `NetWorthCard` - Net worth display
- `IncomeExpenseCard` - Income vs expense summary
- `CashFlowChart` - Cash flow visualization
- `ExpenseBreakdownChart` - Expense category breakdown
- `AssetAllocationChart` - Asset allocation visualization
- `RecentTransactions` - Recent transactions list
- `BudgetSummary` - Budget progress summary
- `GoalProgress` - Financial goals progress

### Account Components
- `AccountsList` - List of financial accounts
- `AccountDetails` - Account details and transactions
- `AddAccount` - Add new account form
- `EditAccount` - Edit account details
- `AccountSync` - Sync account with financial institution

### Connection Components
- `ConnectionsList` - List of external connections
- `ConnectionDetails` - Connection details and status
- `AddConnection` - Add new connection wizard
- `ConnectionSync` - Sync data from external connection

### Transaction Components
- `TransactionsList` - List of transactions with filtering
- `TransactionDetails` - Transaction details
- `AddTransaction` - Add new transaction form
- `EditTransaction` - Edit transaction details
- `ImportTransactions` - Import transactions from CSV/PDF
- `TransactionCategories` - Manage transaction categories

### Asset Components
- `AssetsList` - List of assets
- `AssetDetails` - Asset details and performance
- `AddAsset` - Add new asset form
- `EditAsset` - Edit asset details
- `AssetPerformance` - Asset performance metrics
- `AssetAllocation` - Asset allocation management

### Liability Components
- `LiabilitiesList` - List of liabilities
- `LiabilityDetails` - Liability details
- `AddLiability` - Add new liability form
- `EditLiability` - Edit liability details
- `DebtPayoff` - Debt payoff calculator

### Goal Components
- `GoalsList` - List of financial goals
- `GoalDetails` - Goal details and progress
- `AddGoal` - Add new goal form
- `EditGoal` - Edit goal details
- `GoalRecommendations` - Goal setting recommendations

### Budget Components
- `BudgetsList` - List of budgets
- `BudgetDetails` - Budget details and performance
- `AddBudget` - Add new budget form
- `EditBudget` - Edit budget details
- `BudgetPerformance` - Budget performance metrics

### Report Components
- `ReportsList` - List of saved reports
- `ReportBuilder` - Custom report builder
- `ReportViewer` - Report visualization
- `ExportReport` - Export report in various formats

### Financial Planning Components
- `FinancialIndependence` - Financial independence calculator
- `RetirementPlanner` - Retirement planning tools
- `DebtPayoffPlanner` - Debt payoff strategy planner
- `SavingsCalculator` - Savings goal calculator
- `InvestmentProjections` - Investment growth projections

### Utility Components
- `Notification` - Notification display
- `Modal` - Reusable modal component
- `Dropdown` - Reusable dropdown component
- `DatePicker` - Date selection component
- `FileUpload` - File upload component
- `Chart` - Reusable chart component
- `Table` - Reusable table component
- `Form` - Reusable form components

## External API Integrations

### HSBC Integration
- Account information retrieval
- Transaction history
- Balance updates

### Trading212 Integration
- Investment portfolio retrieval
- Stock performance tracking
- Transaction history

### Moneybox Integration
- Savings account information
- Goal tracking
- Transaction history

## Data Processing Pipeline
1. **Data Collection**
   - API connections to financial institutions
   - CSV/PDF import
   - Manual data entry

2. **Data Transformation**
   - Transaction categorization
   - Currency normalization
   - Data enrichment

3. **Data Analysis**
   - Financial KPI calculation
   - Trend analysis
   - Pattern recognition

4. **Data Visualization**
   - Dashboard generation
   - Report creation
   - Chart rendering

## Security Architecture
- JWT-based authentication
- HTTPS encryption
- Password hashing with bcrypt
- API rate limiting
- Input validation and sanitization
- CSRF protection
- XSS prevention
- Secure credential storage
- Regular security audits

## Mobile Responsiveness
- Responsive design for all screen sizes
- Touch-friendly UI components
- Optimized data loading for mobile
- Progressive Web App (PWA) capabilities

## Deployment Architecture
The system is deployed using Docker containers orchestrated with Docker Compose:
- Nginx web server (SSL/TLS termination)
- Frontend container (React.js)
- Backend container (Node.js/Express)
- Database container (PostgreSQL)

## Future Roadmap
- Decentralized data storage on Solana/Xandeum blockchain
- AI-powered financial insights and recommendations
- Advanced tax planning features
- Multi-currency support
- Expanded financial institution integrations
