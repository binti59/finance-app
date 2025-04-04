const { Transaction, Category, Account } = require('../models');
const { NotFoundError, ValidationError } = require('../utils/errors');
const multer = require('multer');
const csv = require('csv-parser');
const fs = require('fs');
const path = require('path');
const pdfParse = require('pdf-parse');

// Configure multer for file uploads
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    const uploadDir = process.env.UPLOAD_DIR || './uploads';
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }
    cb(null, uploadDir);
  },
  filename: function (req, file, cb) {
    cb(null, `${Date.now()}-${file.originalname}`);
  }
});

const upload = multer({ 
  storage: storage,
  limits: {
    fileSize: parseInt(process.env.MAX_FILE_SIZE) || 10485760 // 10MB default
  },
  fileFilter: function (req, file, cb) {
    const filetypes = /csv|pdf/;
    const mimetype = filetypes.test(file.mimetype);
    const extname = filetypes.test(path.extname(file.originalname).toLowerCase());
    
    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new ValidationError('Only CSV and PDF files are allowed'));
  }
}).single('file');

/**
 * Get all transactions for the authenticated user
 */
exports.getAllTransactions = async (req, res, next) => {
  try {
    const { 
      account_id, 
      category_id, 
      start_date, 
      end_date, 
      transaction_type,
      min_amount,
      max_amount,
      sort_by = 'transaction_date',
      sort_order = 'DESC',
      page = 1,
      limit = 50
    } = req.query;

    // Build query conditions
    const where = { user_id: req.user.id };
    
    if (account_id) where.account_id = account_id;
    if (category_id) where.category_id = category_id;
    if (transaction_type) where.transaction_type = transaction_type;
    
    if (start_date && end_date) {
      where.transaction_date = {
        [Op.between]: [new Date(start_date), new Date(end_date)]
      };
    } else if (start_date) {
      where.transaction_date = {
        [Op.gte]: new Date(start_date)
      };
    } else if (end_date) {
      where.transaction_date = {
        [Op.lte]: new Date(end_date)
      };
    }
    
    if (min_amount && max_amount) {
      where.amount = {
        [Op.between]: [parseFloat(min_amount), parseFloat(max_amount)]
      };
    } else if (min_amount) {
      where.amount = {
        [Op.gte]: parseFloat(min_amount)
      };
    } else if (max_amount) {
      where.amount = {
        [Op.lte]: parseFloat(max_amount)
      };
    }

    // Calculate pagination
    const offset = (page - 1) * limit;
    
    // Get transactions with pagination
    const { count, rows: transactions } = await Transaction.findAndCountAll({
      where,
      include: [
        { model: Category, as: 'category' },
        { model: Account, as: 'account' }
      ],
      order: [[sort_by, sort_order]],
      limit: parseInt(limit),
      offset: parseInt(offset)
    });

    // Calculate pagination metadata
    const totalPages = Math.ceil(count / limit);

    res.status(200).json({
      success: true,
      count,
      pagination: {
        current_page: parseInt(page),
        total_pages: totalPages,
        limit: parseInt(limit),
        total: count
      },
      data: transactions
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get transaction by ID
 */
exports.getTransactionById = async (req, res, next) => {
  try {
    const transaction = await Transaction.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      },
      include: [
        { model: Category, as: 'category' },
        { model: Account, as: 'account' }
      ]
    });

    if (!transaction) {
      throw new NotFoundError('Transaction not found');
    }

    res.status(200).json({
      success: true,
      data: transaction
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new transaction
 */
exports.createTransaction = async (req, res, next) => {
  try {
    const { 
      account_id, 
      category_id, 
      amount, 
      currency,
      description, 
      transaction_date, 
      transaction_type,
      is_recurring,
      recurrence_pattern
    } = req.body;

    // Validate account
    const account = await Account.findOne({
      where: { 
        id: account_id,
        user_id: req.user.id
      }
    });

    if (!account) {
      throw new ValidationError('Invalid account');
    }

    // Validate category if provided
    if (category_id) {
      const category = await Category.findByPk(category_id);
      if (!category) {
        throw new ValidationError('Invalid category');
      }
    }

    // Create transaction
    const transaction = await Transaction.create({
      user_id: req.user.id,
      account_id,
      category_id,
      amount,
      currency: currency || account.currency,
      description,
      transaction_date: new Date(transaction_date),
      transaction_type,
      is_recurring: is_recurring || false,
      recurrence_pattern
    });

    // Update account balance
    if (transaction_type === 'income') {
      account.balance += parseFloat(amount);
    } else if (transaction_type === 'expense') {
      account.balance -= parseFloat(amount);
    }
    
    await account.save();

    // Return created transaction
    const createdTransaction = await Transaction.findByPk(transaction.id, {
      include: [
        { model: Category, as: 'category' },
        { model: Account, as: 'account' }
      ]
    });

    res.status(201).json({
      success: true,
      data: createdTransaction
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update a transaction
 */
exports.updateTransaction = async (req, res, next) => {
  try {
    const { 
      account_id, 
      category_id, 
      amount, 
      currency,
      description, 
      transaction_date, 
      transaction_type,
      is_recurring,
      recurrence_pattern
    } = req.body;

    // Find transaction
    const transaction = await Transaction.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!transaction) {
      throw new NotFoundError('Transaction not found');
    }

    // If account is changing, validate new account
    let oldAccount, newAccount;
    if (account_id && account_id !== transaction.account_id) {
      oldAccount = await Account.findByPk(transaction.account_id);
      newAccount = await Account.findOne({
        where: { 
          id: account_id,
          user_id: req.user.id
        }
      });

      if (!newAccount) {
        throw new ValidationError('Invalid account');
      }
    } else {
      oldAccount = await Account.findByPk(transaction.account_id);
      newAccount = oldAccount;
    }

    // Validate category if provided
    if (category_id) {
      const category = await Category.findByPk(category_id);
      if (!category) {
        throw new ValidationError('Invalid category');
      }
    }

    // Revert old account balance
    if (transaction.transaction_type === 'income') {
      oldAccount.balance -= parseFloat(transaction.amount);
    } else if (transaction.transaction_type === 'expense') {
      oldAccount.balance += parseFloat(transaction.amount);
    }
    
    await oldAccount.save();

    // Update transaction
    transaction.account_id = account_id || transaction.account_id;
    transaction.category_id = category_id !== undefined ? category_id : transaction.category_id;
    transaction.amount = amount || transaction.amount;
    transaction.currency = currency || transaction.currency;
    transaction.description = description !== undefined ? description : transaction.description;
    transaction.transaction_date = transaction_date ? new Date(transaction_date) : transaction.transaction_date;
    transaction.transaction_type = transaction_type || transaction.transaction_type;
    transaction.is_recurring = is_recurring !== undefined ? is_recurring : transaction.is_recurring;
    transaction.recurrence_pattern = recurrence_pattern !== undefined ? recurrence_pattern : transaction.recurrence_pattern;
    
    await transaction.save();

    // Update new account balance
    if (transaction.transaction_type === 'income') {
      newAccount.balance += parseFloat(transaction.amount);
    } else if (transaction.transaction_type === 'expense') {
      newAccount.balance -= parseFloat(transaction.amount);
    }
    
    await newAccount.save();

    // Return updated transaction
    const updatedTransaction = await Transaction.findByPk(transaction.id, {
      include: [
        { model: Category, as: 'category' },
        { model: Account, as: 'account' }
      ]
    });

    res.status(200).json({
      success: true,
      data: updatedTransaction
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a transaction
 */
exports.deleteTransaction = async (req, res, next) => {
  try {
    const transaction = await Transaction.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!transaction) {
      throw new NotFoundError('Transaction not found');
    }

    // Update account balance
    const account = await Account.findByPk(transaction.account_id);
    
    if (transaction.transaction_type === 'income') {
      account.balance -= parseFloat(transaction.amount);
    } else if (transaction.transaction_type === 'expense') {
      account.balance += parseFloat(transaction.amount);
    }
    
    await account.save();

    // Delete transaction
    await transaction.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Import transactions from CSV/PDF
 */
exports.importTransactions = async (req, res, next) => {
  try {
    // Handle file upload
    upload(req, res, async function (err) {
      if (err) {
        return next(err);
      }
      
      if (!req.file) {
        return next(new ValidationError('No file uploaded'));
      }

      const { account_id } = req.body;
      
      // Validate account
      const account = await Account.findOne({
        where: { 
          id: account_id,
          user_id: req.user.id
        }
      });

      if (!account) {
        return next(new ValidationError('Invalid account'));
      }

      const filePath = req.file.path;
      const fileType = path.extname(req.file.originalname).toLowerCase();
      
      let transactions = [];
      
      // Process file based on type
      if (fileType === '.csv') {
        // Process CSV file
        const results = [];
        
        fs.createReadStream(filePath)
          .pipe(csv())
          .on('data', (data) => results.push(data))
          .on('end', async () => {
            try {
              // Map CSV data to transactions
              // This mapping will depend on the CSV format
              // Here's a simple example assuming columns: date, description, amount, type
              for (const row of results) {
                const amount = parseFloat(row.amount.replace(/[^0-9.-]+/g, ''));
                const transactionType = row.type?.toLowerCase() === 'income' ? 'income' : 'expense';
                
                transactions.push({
                  user_id: req.user.id,
                  account_id,
                  amount: Math.abs(amount),
                  currency: account.currency,
                  description: row.description,
                  transaction_date: new Date(row.date),
                  transaction_type: transactionType
                });
              }
              
              // Save transactions to database
              const createdTransactions = await Transaction.bulkCreate(transactions);
              
              // Update account balance
              let balanceChange = 0;
              for (const transaction of transactions) {
                if (transaction.transaction_type === 'income') {
                  balanceChange += transaction.amount;
                } else if (transaction.transaction_type === 'expense') {
                  balanceChange -= transaction.amount;
                }
              }
              
              account.balance += balanceChange;
              await account.save();
              
              // Clean up uploaded file
              fs.unlinkSync(filePath);
              
              res.status(201).json({
                success: true,
                count: createdTransactions.length,
                data: createdTransactions
              });
            } catch (error) {
              next(error);
            }
          });
      } else if (fileType === '.pdf') {
        // Process PDF file
        try {
          const dataBuffer = fs.readFileSync(filePath);
          const data = await pdfParse(dataBuffer);
          
          // Extract transactions from PDF text
          // This is a complex task and would require specific parsing logic
          // based on the PDF format from each financial institution
          
          // For now, just return a message
          fs.unlinkSync(filePath);
          
          res.status(200).json({
            success: true,
            message: 'PDF parsing is not fully implemented yet. Please use CSV format.',
            data: {
              text_content: data.text.substring(0, 1000) + '...' // First 1000 chars
            }
          });
        } catch (error) {
          next(error);
        }
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Auto-categorize transactions
 */
exports.categorizeTransactions = async (req, res, next) => {
  try {
    const { transaction_ids } = req.body;
    
    if (!transaction_ids || !Array.isArray(transaction_ids)) {
      throw new ValidationError('Transaction IDs array is required');
    }
    
    // Get all categories
    const categories = await Category.findAll();
    
    // Get transactions to categorize
    const transactions = await Transaction.findAll({
      where: { 
        id: transaction_ids,
        user_id: req.user.id,
        category_id: null // Only uncategorized transactions
      }
    });
    
    if (transactions.length === 0) {
      return res.status(200).json({
        success: true,
        message: 'No uncategorized transactions found',
        data: []
      });
    }
    
    // Simple keyword-based categorization
    // In a real implementation, this would use more sophisticated algorithms
    const categorizedTransactions = [];
    
    for (const transaction of transactions) {
      let assigned = false;
      const description = transaction.description.toLowerCase();
      
      // Define category keywords
      const categoryKeywords = {
        'Salary': ['salary', 'payroll', 'income', 'wage'],
        'Investments': ['dividend', 'interest', 'investment'],
        'Housing': ['rent', 'mortgage', 'property'],
        'Transportation': ['uber', 'lyft', 'taxi', 'car', 'gas', 'fuel', 'parking'],
        'Food': ['restaurant', 'grocery', 'food', 'meal', 'cafe', 'coffee'],
        'Utilities': ['electric', 'water', 'gas', 'internet', 'phone', 'utility'],
        'Healthcare': ['doctor', 'medical', 'health', 'pharmacy', 'dental'],
        'Entertainment': ['movie', 'theatre', 'concert', 'netflix', 'spotify'],
        'Shopping': ['amazon', 'walmart', 'target', 'shop', 'store'],
        'Education': ['tuition', 'school', 'book', 'course'],
        'Personal Care': ['haircut', 'salon', 'spa'],
        'Travel': ['hotel', 'flight', 'airbnb', 'airline'],
        'Subscriptions': ['subscription', 'membership'],
        'Insurance': ['insurance', 'premium'],
        'Taxes': ['tax', 'irs']
      };
      
      // Find matching category
      for (const category of categories) {
        const keywords = categoryKeywords[category.name];
        if (keywords && keywords.some(keyword => description.includes(keyword))) {
          transaction.category_id = category.id;
          await transaction.save();
          categorizedTransactions.push({
            id: transaction.id,
            description: transaction.description,
            category: category.name
          });
          assigned = true;
          break;
        }
      }
      
      // If no match found, assign to Miscellaneous
      if (!assigned) {
        const miscCategory = categories.find(c => c.name === 'Miscellaneous');
        if (miscCategory) {
          transaction.category_id = miscCategory.id;
          await transaction.save();
          categorizedTransactions.push({
            id: transaction.id,
            description: transaction.description,
            category: 'Miscellaneous'
          });
        }
      }
    }
    
    res.status(200).json({
      success: true,
      count: categorizedTransactions.length,
      data: categorizedTransactions
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get recurring transactions
 */
exports.getRecurringTransactions = async (req, res, next) => {
  try {
    // Get transactions marked as recurring
    const markedRecurring = await Transaction.findAll({
      where: { 
        user_id: req.user.id,
        is_recurring: true
      },
      include: [
        { model: Category, as: 'category' },
        { model: Account, as: 'account' }
      ]
    });
    
    // Detect potential recurring transactions
    // This is a simplified approach - in a real implementation, 
    // you would use more sophisticated pattern detection
    const allTransactions = await Transaction.findAll({
      where: { 
        user_id: req.user.id,
        is_recurring: false
      },
      order: [['transaction_date', 'ASC']]
    });
    
    // Group by description and amount
    const transactionGroups = {};
    
    for (const transaction of allTransactions) {
      const key = `${transaction.description}-${transaction.amount}-${transaction.transaction_type}`;
      if (!transactionGroups[key]) {
        transactionGroups[key] = [];
      }
      transactionGroups[key].push(transaction);
    }
    
    // Find groups with at least 3 transactions
    const potentialRecurring = [];
    
    for (const key in transactionGroups) {
      const group = transactionGroups[key];
      if (group.length >= 3) {
        // Check if they occur at regular intervals
        const intervals = [];
        for (let i = 1; i < group.length; i++) {
          const daysDiff = Math.round(
            (new Date(group[i].transaction_date) - new Date(group[i-1].transaction_date)) / (1000 * 60 * 60 * 24)
          );
          intervals.push(daysDiff);
        }
        
        // Check if intervals are consistent (within 2 days)
        const avgInterval = intervals.reduce((sum, val) => sum + val, 0) / intervals.length;
        const isConsistent = intervals.every(interval => Math.abs(interval - avgInterval) <= 2);
        
        if (isConsistent) {
          // Determine recurrence pattern
          let pattern;
          if (avgInterval >= 28 && avgInterval <= 31) {
            pattern = 'monthly';
          } else if (avgInterval >= 13 && avgInterval <= 15) {
            pattern = 'bi-weekly';
          } else if (avgInterval >= 6 && avgInterval <= 8) {
            pattern = 'weekly';
          } else if (avgInterval >= 89 && avgInterval <= 92) {
            pattern = 'quarterly';
          } else if (avgInterval >= 364 && avgInterval <= 366) {
            pattern = 'annually';
          } else {
            pattern = `every ${Math.round(avgInterval)} days`;
          }
          
          potentialRecurring.push({
            description: group[0].description,
            amount: group[0].amount,
            transaction_type: group[0].transaction_type,
            occurrences: group.length,
            average_interval: Math.round(avgInterval),
            pattern,
            last_date: group[group.length - 1].transaction_date,
            transaction_ids: group.map(t => t.id)
          });
        }
      }
    }
    
    res.status(200).json({
      success: true,
      data: {
        marked_recurring: markedRecurring,
        potential_recurring: potentialRecurring
      }
    });
  } catch (error) {
    next(error);
  }
};
