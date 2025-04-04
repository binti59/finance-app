const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Transaction = sequelize.define('Transaction', {
    id: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true
    },
    user_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'users',
        key: 'id'
      }
    },
    account_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
      references: {
        model: 'accounts',
        key: 'id'
      }
    },
    category_id: {
      type: DataTypes.INTEGER,
      allowNull: true,
      references: {
        model: 'categories',
        key: 'id'
      }
    },
    amount: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false
    },
    currency: {
      type: DataTypes.STRING(3),
      allowNull: false,
      defaultValue: 'USD'
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    transaction_date: {
      type: DataTypes.DATEONLY,
      allowNull: false
    },
    transaction_type: {
      type: DataTypes.STRING(20),
      allowNull: false,
      validate: {
        isIn: [['income', 'expense', 'transfer']]
      }
    },
    is_recurring: {
      type: DataTypes.BOOLEAN,
      defaultValue: false
    },
    recurrence_pattern: {
      type: DataTypes.STRING(50),
      allowNull: true
    },
    created_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    },
    updated_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW
    }
  }, {
    tableName: 'transactions',
    timestamps: false,
    indexes: [
      {
        fields: ['user_id']
      },
      {
        fields: ['account_id']
      },
      {
        fields: ['category_id']
      },
      {
        fields: ['transaction_date']
      },
      {
        fields: ['transaction_type']
      }
    ]
  });

  return Transaction;
};
