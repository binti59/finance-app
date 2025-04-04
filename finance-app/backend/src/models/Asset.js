const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Asset = sequelize.define('Asset', {
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
        isIn: [['stock', 'bond', 'real_estate', 'crypto', 'cash', 'retirement', 'other']]
      }
    },
    value: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: false,
      defaultValue: 0
    },
    currency: {
      type: DataTypes.STRING(3),
      allowNull: false,
      defaultValue: 'USD'
    },
    acquisition_date: {
      type: DataTypes.DATEONLY,
      allowNull: true
    },
    acquisition_price: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: true
    },
    current_price: {
      type: DataTypes.DECIMAL(15, 2),
      allowNull: true
    },
    quantity: {
      type: DataTypes.DECIMAL(15, 6),
      allowNull: true
    },
    notes: {
      type: DataTypes.TEXT,
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
    tableName: 'assets',
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

  return Asset;
};
