const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
  const Connection = sequelize.define('Connection', {
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
    provider: {
      type: DataTypes.STRING(50),
      allowNull: false,
      validate: {
        isIn: [['HSBC', 'Trading212', 'Moneybox']]
      }
    },
    access_token: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    refresh_token: {
      type: DataTypes.TEXT,
      allowNull: true
    },
    token_expires_at: {
      type: DataTypes.DATE,
      allowNull: true
    },
    status: {
      type: DataTypes.STRING(20),
      defaultValue: 'active',
      validate: {
        isIn: [['active', 'inactive', 'error', 'pending']]
      }
    },
    last_sync: {
      type: DataTypes.DATE,
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
    tableName: 'connections',
    timestamps: false,
    indexes: [
      {
        fields: ['user_id']
      },
      {
        fields: ['provider']
      }
    ]
  });

  return Connection;
};
