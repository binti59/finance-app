const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Liability = sequelize.define('Liability', {
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
    name: {
      type: DataTypes.STRING(100),
      allowNull: false
    },
    type: {
      type: DataTypes.STRING(50),
      allowNull: false,
      validate: {
        isIn: [['mortgage', 'loan', 'credit_card', 'student_loan', 'tax', 'other']]
      }
    },
    amount: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      defaultValue: 0
    },
    currency: {
      type: DataTypes.STRING(3),
      allowNull: false,
      defaultValue: 'USD'
    },
    interest_rate: {
      type: DataTypes.DECIMAL(5, 2),
      allowNull: true
    },
    start_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    end_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    payment_amount: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: true
    },
    payment_frequency: {
      type: DataTypes.STRING(20),
      allowNull: true,
      validate: {
        isIn: [['monthly', 'weekly', 'bi-weekly', 'quarterly', 'annually']]
      }
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
    tableName: 'liabilities',
    timestamps: false,
    indexes: [
      {
        fields: ['user_id']
      },
      {
        fields: ['type']
      }
    ]
  });

  return Liability;
};
