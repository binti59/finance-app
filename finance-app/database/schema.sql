# Database Schema Design for Personal Finance Management System

## Database Schema SQL

```sql
-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    profile_image VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Financial Accounts table
CREATE TABLE accounts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL, -- checking, savings, investment, credit, loan, etc.
    institution VARCHAR(100),
    balance DECIMAL(15, 2) NOT NULL DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'USD',
    is_active BOOLEAN DEFAULT TRUE,
    last_sync TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- External Connections table
CREATE TABLE connections (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    provider VARCHAR(50) NOT NULL, -- HSBC, Trading212, Moneybox
    access_token TEXT,
    refresh_token TEXT,
    token_expires_at TIMESTAMP,
    status VARCHAR(20) DEFAULT 'active',
    last_sync TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL, -- income, expense
    icon VARCHAR(50),
    color VARCHAR(20),
    parent_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    account_id INTEGER REFERENCES accounts(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE SET NULL,
    amount DECIMAL(15, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    description TEXT,
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR(20) NOT NULL, -- income, expense, transfer
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_pattern VARCHAR(50), -- monthly, weekly, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Assets table
CREATE TABLE assets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL, -- stock, bond, real_estate, crypto, etc.
    value DECIMAL(15, 2) NOT NULL DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'USD',
    acquisition_date DATE,
    acquisition_price DECIMAL(15, 2),
    current_price DECIMAL(15, 2),
    quantity DECIMAL(15, 6),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Liabilities table
CREATE TABLE liabilities (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL, -- mortgage, loan, credit_card, etc.
    amount DECIMAL(15, 2) NOT NULL DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'USD',
    interest_rate DECIMAL(5, 2),
    start_date DATE,
    end_date DATE,
    payment_amount DECIMAL(15, 2),
    payment_frequency VARCHAR(20), -- monthly, weekly, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Financial Goals table
CREATE TABLE goals (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    target_amount DECIMAL(15, 2) NOT NULL,
    current_amount DECIMAL(15, 2) NOT NULL DEFAULT 0,
    currency VARCHAR(3) DEFAULT 'USD',
    deadline DATE,
    category VARCHAR(50),
    priority INTEGER DEFAULT 1,
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Budgets table
CREATE TABLE budgets (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    amount DECIMAL(15, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    period VARCHAR(20) NOT NULL, -- monthly, yearly
    start_date DATE NOT NULL,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Financial KPIs table
CREATE TABLE kpis (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL, -- net_worth, savings_rate, fi_index, etc.
    value DECIMAL(15, 2) NOT NULL,
    date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Reports table
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    parameters JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50),
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create default categories
INSERT INTO categories (name, type, icon, color) VALUES
('Salary', 'income', '💼', '#27ae60'),
('Investments', 'income', '📈', '#3498db'),
('Gifts', 'income', '🎁', '#9b59b6'),
('Other Income', 'income', '💰', '#f1c40f'),
('Housing', 'expense', '🏠', '#e74c3c'),
('Transportation', 'expense', '🚗', '#e67e22'),
('Food', 'expense', '🍔', '#f39c12'),
('Utilities', 'expense', '💡', '#16a085'),
('Healthcare', 'expense', '⚕️', '#2980b9'),
('Entertainment', 'expense', '🎬', '#8e44ad'),
('Shopping', 'expense', '🛍️', '#d35400'),
('Education', 'expense', '📚', '#2c3e50'),
('Personal Care', 'expense', '💇', '#1abc9c'),
('Travel', 'expense', '✈️', '#3498db'),
('Subscriptions', 'expense', '📱', '#9b59b6'),
('Insurance', 'expense', '🔒', '#34495e'),
('Taxes', 'expense', '📝', '#7f8c8d'),
('Miscellaneous', 'expense', '🔮', '#95a5a6');
```

## Database Indexes

```sql
-- Add indexes for performance optimization
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_category_id ON transactions(category_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);
CREATE INDEX idx_transactions_type ON transactions(transaction_type);

CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_accounts_type ON accounts(type);

CREATE INDEX idx_assets_user_id ON assets(user_id);
CREATE INDEX idx_assets_type ON assets(type);

CREATE INDEX idx_liabilities_user_id ON liabilities(user_id);
CREATE INDEX idx_liabilities_type ON liabilities(type);

CREATE INDEX idx_goals_user_id ON goals(user_id);
CREATE INDEX idx_goals_status ON goals(status);

CREATE INDEX idx_budgets_user_id ON budgets(user_id);
CREATE INDEX idx_budgets_category_id ON budgets(category_id);

CREATE INDEX idx_kpis_user_id ON kpis(user_id);
CREATE INDEX idx_kpis_type ON kpis(type);
CREATE INDEX idx_kpis_date ON kpis(date);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
```

## Database Triggers

```sql
-- Create updated_at triggers for all tables
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_modtime
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_accounts_modtime
BEFORE UPDATE ON accounts
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_connections_modtime
BEFORE UPDATE ON connections
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_categories_modtime
BEFORE UPDATE ON categories
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_transactions_modtime
BEFORE UPDATE ON transactions
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_assets_modtime
BEFORE UPDATE ON assets
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_liabilities_modtime
BEFORE UPDATE ON liabilities
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_goals_modtime
BEFORE UPDATE ON goals
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_budgets_modtime
BEFORE UPDATE ON budgets
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_kpis_modtime
BEFORE UPDATE ON kpis
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_reports_modtime
BEFORE UPDATE ON reports
FOR EACH ROW EXECUTE FUNCTION update_modified_column();

CREATE TRIGGER update_notifications_modtime
BEFORE UPDATE ON notifications
FOR EACH ROW EXECUTE FUNCTION update_modified_column();
```

## Database Views

```sql
-- Net Worth View
CREATE VIEW net_worth_view AS
SELECT 
    user_id,
    (SELECT COALESCE(SUM(value), 0) FROM assets WHERE assets.user_id = users.id) -
    (SELECT COALESCE(SUM(amount), 0) FROM liabilities WHERE liabilities.user_id = users.id) AS net_worth,
    NOW() AS calculated_at
FROM users;

-- Monthly Cash Flow View
CREATE VIEW monthly_cash_flow_view AS
SELECT 
    user_id,
    DATE_TRUNC('month', transaction_date) AS month,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) AS total_income,
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) AS total_expenses,
    SUM(CASE WHEN transaction_type = 'income' THEN amount ELSE 0 END) - 
    SUM(CASE WHEN transaction_type = 'expense' THEN amount ELSE 0 END) AS net_cash_flow
FROM transactions
GROUP BY user_id, DATE_TRUNC('month', transaction_date);

-- Budget Performance View
CREATE VIEW budget_performance_view AS
SELECT 
    b.user_id,
    b.category_id,
    c.name AS category_name,
    b.amount AS budget_amount,
    COALESCE(SUM(t.amount), 0) AS spent_amount,
    b.amount - COALESCE(SUM(t.amount), 0) AS remaining_amount,
    CASE 
        WHEN b.amount = 0 THEN 0
        ELSE (COALESCE(SUM(t.amount), 0) / b.amount) * 100 
    END AS percentage_used
FROM budgets b
JOIN categories c ON b.category_id = c.id
LEFT JOIN transactions t ON 
    t.category_id = b.category_id AND 
    t.user_id = b.user_id AND
    t.transaction_date BETWEEN b.start_date AND COALESCE(b.end_date, CURRENT_DATE)
WHERE t.transaction_type = 'expense'
GROUP BY b.user_id, b.category_id, c.name, b.amount;

-- Expense By Category View
CREATE VIEW expense_by_category_view AS
SELECT 
    t.user_id,
    DATE_TRUNC('month', t.transaction_date) AS month,
    c.name AS category_name,
    SUM(t.amount) AS total_amount,
    COUNT(t.id) AS transaction_count
FROM transactions t
JOIN categories c ON t.category_id = c.id
WHERE t.transaction_type = 'expense'
GROUP BY t.user_id, DATE_TRUNC('month', t.transaction_date), c.name;

-- Asset Allocation View
CREATE VIEW asset_allocation_view AS
SELECT 
    user_id,
    type,
    SUM(value) AS total_value,
    (SUM(value) / (SELECT SUM(value) FROM assets WHERE assets.user_id = a.user_id)) * 100 AS percentage
FROM assets a
GROUP BY user_id, type;

-- Financial Independence Progress View
CREATE VIEW financial_independence_progress_view AS
SELECT 
    k1.user_id,
    k1.value AS current_net_worth,
    k2.value AS freedom_number,
    CASE 
        WHEN k2.value = 0 THEN 0
        ELSE (k1.value / k2.value) * 100 
    END AS fi_percentage
FROM kpis k1
JOIN kpis k2 ON k1.user_id = k2.user_id
WHERE k1.type = 'net_worth' AND k2.type = 'freedom_number'
AND k1.date = (SELECT MAX(date) FROM kpis WHERE type = 'net_worth' AND user_id = k1.user_id)
AND k2.date = (SELECT MAX(date) FROM kpis WHERE type = 'freedom_number' AND user_id = k2.user_id);
```
