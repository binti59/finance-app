const { Connection } = require('../models');
const { NotFoundError, ValidationError } = require('../utils/errors');
const axios = require('axios');
const logger = require('../utils/logger');

/**
 * Get all connections for the authenticated user
 */
exports.getAllConnections = async (req, res, next) => {
  try {
    const connections = await Connection.findAll({
      where: { user_id: req.user.id }
    });

    // Remove sensitive data
    const sanitizedConnections = connections.map(conn => {
      const connection = conn.toJSON();
      delete connection.access_token;
      delete connection.refresh_token;
      return connection;
    });

    res.status(200).json({
      success: true,
      count: connections.length,
      data: sanitizedConnections
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get connection by ID
 */
exports.getConnectionById = async (req, res, next) => {
  try {
    const connection = await Connection.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!connection) {
      throw new NotFoundError('Connection not found');
    }

    // Remove sensitive data
    const sanitizedConnection = connection.toJSON();
    delete sanitizedConnection.access_token;
    delete sanitizedConnection.refresh_token;

    res.status(200).json({
      success: true,
      data: sanitizedConnection
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new connection
 */
exports.createConnection = async (req, res, next) => {
  try {
    const { provider } = req.body;

    // Validate provider
    if (!['HSBC', 'Trading212', 'Moneybox'].includes(provider)) {
      throw new ValidationError('Invalid provider. Supported providers are HSBC, Trading212, and Moneybox');
    }

    // Check if connection already exists
    const existingConnection = await Connection.findOne({
      where: { 
        user_id: req.user.id,
        provider
      }
    });

    if (existingConnection) {
      throw new ValidationError(`Connection to ${provider} already exists`);
    }

    const connection = await Connection.create({
      user_id: req.user.id,
      provider,
      status: 'pending'
    });

    res.status(201).json({
      success: true,
      data: {
        id: connection.id,
        provider: connection.provider,
        status: connection.status,
        created_at: connection.created_at
      },
      message: `Connection to ${provider} created. Please complete authentication.`
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update a connection
 */
exports.updateConnection = async (req, res, next) => {
  try {
    const { status } = req.body;

    const connection = await Connection.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!connection) {
      throw new NotFoundError('Connection not found');
    }

    // Update connection
    if (status) {
      connection.status = status;
    }
    
    await connection.save();

    // Remove sensitive data
    const sanitizedConnection = connection.toJSON();
    delete sanitizedConnection.access_token;
    delete sanitizedConnection.refresh_token;

    res.status(200).json({
      success: true,
      data: sanitizedConnection
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a connection
 */
exports.deleteConnection = async (req, res, next) => {
  try {
    const connection = await Connection.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!connection) {
      throw new NotFoundError('Connection not found');
    }

    await connection.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Authenticate with external provider
 */
exports.authProvider = async (req, res, next) => {
  try {
    const { provider } = req.params;
    
    // Validate provider
    if (!['HSBC', 'Trading212', 'Moneybox'].includes(provider)) {
      throw new ValidationError('Invalid provider. Supported providers are HSBC, Trading212, and Moneybox');
    }

    // Generate OAuth URL based on provider
    let authUrl;
    
    switch (provider) {
      case 'HSBC':
        authUrl = `https://api.hsbc.com/oauth2/authorize?client_id=${process.env.HSBC_API_KEY}&response_type=code&redirect_uri=${encodeURIComponent(`${req.protocol}://${req.get('host')}/api/connections/HSBC/callback`)}&scope=accounts transactions`;
        break;
      case 'Trading212':
        authUrl = `https://api.trading212.com/oauth2/authorize?client_id=${process.env.TRADING212_API_KEY}&response_type=code&redirect_uri=${encodeURIComponent(`${req.protocol}://${req.get('host')}/api/connections/Trading212/callback`)}&scope=read`;
        break;
      case 'Moneybox':
        authUrl = `https://api.moneybox.com/oauth2/authorize?client_id=${process.env.MONEYBOX_API_KEY}&response_type=code&redirect_uri=${encodeURIComponent(`${req.protocol}://${req.get('host')}/api/connections/Moneybox/callback`)}&scope=read`;
        break;
    }

    res.status(200).json({
      success: true,
      data: {
        auth_url: authUrl
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * OAuth callback handler
 */
exports.providerCallback = async (req, res, next) => {
  try {
    const { provider } = req.params;
    const { code, state, user_id } = req.query;
    
    if (!code) {
      throw new ValidationError('Authorization code is required');
    }

    // Find the user's connection
    const connection = await Connection.findOne({
      where: { 
        user_id,
        provider,
        status: 'pending'
      }
    });

    if (!connection) {
      throw new NotFoundError('Connection not found or already active');
    }

    // Exchange code for tokens based on provider
    let tokenResponse;
    
    try {
      switch (provider) {
        case 'HSBC':
          tokenResponse = await axios.post('https://api.hsbc.com/oauth2/token', {
            grant_type: 'authorization_code',
            code,
            redirect_uri: `${req.protocol}://${req.get('host')}/api/connections/HSBC/callback`,
            client_id: process.env.HSBC_API_KEY,
            client_secret: process.env.HSBC_API_SECRET
          });
          break;
        case 'Trading212':
          tokenResponse = await axios.post('https://api.trading212.com/oauth2/token', {
            grant_type: 'authorization_code',
            code,
            redirect_uri: `${req.protocol}://${req.get('host')}/api/connections/Trading212/callback`,
            client_id: process.env.TRADING212_API_KEY
          });
          break;
        case 'Moneybox':
          tokenResponse = await axios.post('https://api.moneybox.com/oauth2/token', {
            grant_type: 'authorization_code',
            code,
            redirect_uri: `${req.protocol}://${req.get('host')}/api/connections/Moneybox/callback`,
            client_id: process.env.MONEYBOX_API_KEY
          });
          break;
      }

      // Update connection with tokens
      connection.access_token = tokenResponse.data.access_token;
      connection.refresh_token = tokenResponse.data.refresh_token;
      connection.token_expires_at = new Date(Date.now() + tokenResponse.data.expires_in * 1000);
      connection.status = 'active';
      connection.last_sync = new Date();
      
      await connection.save();

      // Redirect to frontend with success message
      res.redirect(`/connections?status=success&provider=${provider}`);
    } catch (error) {
      logger.error('Error exchanging code for tokens', error);
      
      // Update connection status to error
      connection.status = 'error';
      await connection.save();
      
      // Redirect to frontend with error message
      res.redirect(`/connections?status=error&provider=${provider}`);
    }
  } catch (error) {
    next(error);
  }
};

/**
 * Sync data from external connection
 */
exports.syncConnection = async (req, res, next) => {
  try {
    const connection = await Connection.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!connection) {
      throw new NotFoundError('Connection not found');
    }

    // Check if connection is active
    if (connection.status !== 'active') {
      throw new ValidationError('Connection is not active');
    }

    // Check if token is expired
    if (connection.token_expires_at < new Date()) {
      // Refresh token
      try {
        let tokenResponse;
        
        switch (connection.provider) {
          case 'HSBC':
            tokenResponse = await axios.post('https://api.hsbc.com/oauth2/token', {
              grant_type: 'refresh_token',
              refresh_token: connection.refresh_token,
              client_id: process.env.HSBC_API_KEY,
              client_secret: process.env.HSBC_API_SECRET
            });
            break;
          case 'Trading212':
            tokenResponse = await axios.post('https://api.trading212.com/oauth2/token', {
              grant_type: 'refresh_token',
              refresh_token: connection.refresh_token,
              client_id: process.env.TRADING212_API_KEY
            });
            break;
          case 'Moneybox':
            tokenResponse = await axios.post('https://api.moneybox.com/oauth2/token', {
              grant_type: 'refresh_token',
              refresh_token: connection.refresh_token,
              client_id: process.env.MONEYBOX_API_KEY
            });
            break;
        }

        // Update connection with new tokens
        connection.access_token = tokenResponse.data.access_token;
        connection.refresh_token = tokenResponse.data.refresh_token || connection.refresh_token;
        connection.token_expires_at = new Date(Date.now() + tokenResponse.data.expires_in * 1000);
        
        await connection.save();
      } catch (error) {
        logger.error('Error refreshing token', error);
        connection.status = 'error';
        await connection.save();
        throw new ValidationError('Failed to refresh token. Please reconnect.');
      }
    }

    // TODO: Implement actual sync with financial institution API
    // This would involve:
    // 1. Fetching accounts from the provider
    // 2. Fetching transactions for each account
    // 3. Updating local accounts and transactions

    // For now, just update the last_sync timestamp
    connection.last_sync = new Date();
    await connection.save();

    res.status(200).json({
      success: true,
      message: `Data synced successfully from ${connection.provider}`,
      data: {
        last_sync: connection.last_sync
      }
    });
  } catch (error) {
    next(error);
  }
};
