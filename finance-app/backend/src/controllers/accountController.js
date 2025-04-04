const { Account, Transaction } = require('../models');
const { NotFoundError, ValidationError } = require('../utils/errors');

/**
 * Get all accounts for the authenticated user
 */
exports.getAllAccounts = async (req, res, next) => {
  try {
    const accounts = await Account.findAll({
      where: { user_id: req.user.id }
    });

    res.status(200).json({
      success: true,
      count: accounts.length,
      data: accounts
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get account by ID
 */
exports.getAccountById = async (req, res, next) => {
  try {
    const account = await Account.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!account) {
      throw new NotFoundError('Account not found');
    }

    res.status(200).json({
      success: true,
      data: account
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new account
 */
exports.createAccount = async (req, res, next) => {
  try {
    const { name, type, institution, balance, currency } = req.body;

    const account = await Account.create({
      user_id: req.user.id,
      name,
      type,
      institution,
      balance,
      currency: currency || 'USD',
      is_active: true
    });

    res.status(201).json({
      success: true,
      data: account
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update an account
 */
exports.updateAccount = async (req, res, next) => {
  try {
    const { name, type, institution, balance, currency, is_active } = req.body;

    const account = await Account.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!account) {
      throw new NotFoundError('Account not found');
    }

    // Update account
    account.name = name || account.name;
    account.type = type || account.type;
    account.institution = institution || account.institution;
    account.balance = balance !== undefined ? balance : account.balance;
    account.currency = currency || account.currency;
    account.is_active = is_active !== undefined ? is_active : account.is_active;
    
    await account.save();

    res.status(200).json({
      success: true,
      data: account
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete an account
 */
exports.deleteAccount = async (req, res, next) => {
  try {
    const account = await Account.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!account) {
      throw new NotFoundError('Account not found');
    }

    await account.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get account balance history
 */
exports.getAccountBalance = async (req, res, next) => {
  try {
    const account = await Account.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!account) {
      throw new NotFoundError('Account not found');
    }

    // Get transactions for this account
    const transactions = await Transaction.findAll({
      where: { 
        account_id: account.id,
        user_id: req.user.id
      },
      order: [['transaction_date', 'ASC']]
    });

    // Calculate balance history
    let balance = account.balance;
    const balanceHistory = [];
    
    // Start from current balance and work backwards
    for (let i = transactions.length - 1; i >= 0; i--) {
      const transaction = transactions[i];
      
      if (transaction.transaction_type === 'expense') {
        balance += transaction.amount;
      } else if (transaction.transaction_type === 'income') {
        balance -= transaction.amount;
      }
      
      balanceHistory.unshift({
        date: transaction.transaction_date,
        balance: balance,
        transaction_id: transaction.id
      });
    }

    res.status(200).json({
      success: true,
      data: {
        current_balance: account.balance,
        currency: account.currency,
        history: balanceHistory
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Sync account with financial institution
 */
exports.syncAccount = async (req, res, next) => {
  try {
    const account = await Account.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!account) {
      throw new NotFoundError('Account not found');
    }

    // Check if account has an institution
    if (!account.institution) {
      throw new ValidationError('Account is not linked to a financial institution');
    }

    // TODO: Implement actual sync with financial institution API
    // This would involve:
    // 1. Finding the connection for this institution
    // 2. Using the access token to fetch latest transactions
    // 3. Updating the account balance
    // 4. Adding new transactions

    // For now, just update the last_sync timestamp
    account.last_sync = new Date();
    await account.save();

    res.status(200).json({
      success: true,
      message: 'Account synced successfully',
      data: {
        last_sync: account.last_sync
      }
    });
  } catch (error) {
    next(error);
  }
};
