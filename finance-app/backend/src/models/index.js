const { Sequelize } = require('sequelize');
const logger = require('../utils/logger');

// Initialize Sequelize with PostgreSQL
const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    port: process.env.DB_PORT,
    dialect: 'postgres',
    logging: (msg) => logger.debug(msg),
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  }
);

// Import models
const User = require('./User')(sequelize);
const Account = require('./Account')(sequelize);
const Connection = require('./Connection')(sequelize);
const Category = require('./Category')(sequelize);
const Transaction = require('./Transaction')(sequelize);
const Asset = require('./Asset')(sequelize);
const Liability = require('./Liability')(sequelize);
const Goal = require('./Goal')(sequelize);
const Budget = require('./Budget')(sequelize);
const KPI = require('./KPI')(sequelize);
const Report = require('./Report')(sequelize);
const Notification = require('./Notification')(sequelize);

// Define associations
User.hasMany(Account, { foreignKey: 'user_id', as: 'accounts' });
Account.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Connection, { foreignKey: 'user_id', as: 'connections' });
Connection.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Transaction, { foreignKey: 'user_id', as: 'transactions' });
Transaction.belongsTo(User, { foreignKey: 'user_id' });

Account.hasMany(Transaction, { foreignKey: 'account_id', as: 'transactions' });
Transaction.belongsTo(Account, { foreignKey: 'account_id' });

Category.hasMany(Transaction, { foreignKey: 'category_id', as: 'transactions' });
Transaction.belongsTo(Category, { foreignKey: 'category_id' });

Category.hasMany(Category, { foreignKey: 'parent_id', as: 'subcategories' });
Category.belongsTo(Category, { foreignKey: 'parent_id', as: 'parent' });

User.hasMany(Asset, { foreignKey: 'user_id', as: 'assets' });
Asset.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Liability, { foreignKey: 'user_id', as: 'liabilities' });
Liability.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Goal, { foreignKey: 'user_id', as: 'goals' });
Goal.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Budget, { foreignKey: 'user_id', as: 'budgets' });
Budget.belongsTo(User, { foreignKey: 'user_id' });

Category.hasMany(Budget, { foreignKey: 'category_id', as: 'budgets' });
Budget.belongsTo(Category, { foreignKey: 'category_id' });

User.hasMany(KPI, { foreignKey: 'user_id', as: 'kpis' });
KPI.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Report, { foreignKey: 'user_id', as: 'reports' });
Report.belongsTo(User, { foreignKey: 'user_id' });

User.hasMany(Notification, { foreignKey: 'user_id', as: 'notifications' });
Notification.belongsTo(User, { foreignKey: 'user_id' });

// Export models and Sequelize instance
module.exports = {
  sequelize,
  User,
  Account,
  Connection,
  Category,
  Transaction,
  Asset,
  Liability,
  Goal,
  Budget,
  KPI,
  Report,
  Notification
};
