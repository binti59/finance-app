const { Budget, Category, Transaction } = require('../models');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { Op, Sequelize } = require('sequelize');

/**
 * Get all budgets for the authenticated user
 */
exports.getAllBudgets = async (req, res, next) => {
  try {
    const budgets = await Budget.findAll({
      where: { user_id: req.user.id },
      include: [
        { model: Category, as: 'category' }
      ]
    });

    res.status(200).json({
      success: true,
      count: budgets.length,
      data: budgets
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get budget by ID
 */
exports.getBudgetById = async (req, res, next) => {
  try {
    const budget = await Budget.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      },
      include: [
        { model: Category, as: 'category' }
      ]
    });

    if (!budget) {
      throw new NotFoundError('Budget not found');
    }

    res.status(200).json({
      success: true,
      data: budget
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new budget
 */
exports.createBudget = async (req, res, next) => {
  try {
    const { 
      category_id, 
      amount, 
      currency, 
      period, 
      start_date, 
      end_date
    } = req.body;

    // Validate category
    const category = await Category.findByPk(category_id);
    if (!category) {
      throw new ValidationError('Invalid category');
    }

    // Check if budget already exists for this category and period
    const existingBudget = await Budget.findOne({
      where: { 
        user_id: req.user.id,
        category_id,
        period,
        start_date: new Date(start_date)
      }
    });

    if (existingBudget) {
      throw new ValidationError('Budget already exists for this category and period');
    }

    const budget = await Budget.create({
      user_id: req.user.id,
      category_id,
      amount,
      currency: currency || 'USD',
      period: period || 'monthly',
      start_date: new Date(start_date),
      end_date: end_date ? new Date(end_date) : null
    });

    // Get created budget with category
    const createdBudget = await Budget.findByPk(budget.id, {
      include: [
        { model: Category, as: 'category' }
      ]
    });

    res.status(201).json({
      success: true,
      data: createdBudget
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update a budget
 */
exports.updateBudget = async (req, res, next) => {
  try {
    const { 
      category_id, 
      amount, 
      currency, 
      period, 
      start_date, 
      end_date
    } = req.body;

    const budget = await Budget.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!budget) {
      throw new NotFoundError('Budget not found');
    }

    // Validate category if provided
    if (category_id) {
      const category = await Category.findByPk(category_id);
      if (!category) {
        throw new ValidationError('Invalid category');
      }
    }

    // Update budget
    budget.category_id = category_id || budget.category_id;
    budget.amount = amount !== undefined ? amount : budget.amount;
    budget.currency = currency || budget.currency;
    budget.period = period || budget.period;
    budget.start_date = start_date ? new Date(start_date) : budget.start_date;
    budget.end_date = end_date ? new Date(end_date) : budget.end_date;
    
    await budget.save();

    // Get updated budget with category
    const updatedBudget = await Budget.findByPk(budget.id, {
      include: [
        { model: Category, as: 'category' }
      ]
    });

    res.status(200).json({
      success: true,
      data: updatedBudget
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a budget
 */
exports.deleteBudget = async (req, res, next) => {
  try {
    const budget = await Budget.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!budget) {
      throw new NotFoundError('Budget not found');
    }

    await budget.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get budget performance metrics
 */
exports.getBudgetPerformance = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { period = 'current' } = req.query;
    
    let startDate, endDate;
    const currentDate = new Date();
    
    // Determine date range based on period
    if (period === 'current') {
      // Current month
      startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
      endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    } else if (period === 'previous') {
      // Previous month
      startDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
      endDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 0);
    } else if (period === 'year_to_date') {
      // Year to date
      startDate = new Date(currentDate.getFullYear(), 0, 1);
      endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    } else if (period === 'custom' && req.query.start_date && req.query.end_date) {
      // Custom date range
      startDate = new Date(req.query.start_date);
      endDate = new Date(req.query.end_date);
    } else {
      // Default to current month
      startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
      endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    }
    
    // Get active budgets
    const budgets = await Budget.findAll({
      where: { 
        user_id: userId,
        start_date: {
          [Op.lte]: endDate
        },
        [Op.or]: [
          { end_date: null },
          { end_date: { [Op.gte]: startDate } }
        ]
      },
      include: [
        { model: Category, as: 'category' }
      ]
    });
    
    // Get transactions for the period
    const transactions = await Transaction.findAll({
      where: { 
        user_id: userId,
        transaction_date: {
          [Op.between]: [startDate, endDate]
        },
        transaction_type: 'expense'
      },
      include: [
        { model: Category, as: 'category' }
      ]
    });
    
    // Calculate budget performance
    const budgetPerformance = [];
    let totalBudgeted = 0;
    let totalSpent = 0;
    
    for (const budget of budgets) {
      // Calculate pro-rated budget amount if budget period doesn't align with query period
      let budgetAmount = parseFloat(budget.amount);
      
      if (budget.period === 'yearly' && period !== 'year_to_date') {
        // Pro-rate yearly budget to monthly
        budgetAmount = budgetAmount / 12;
      }
      
      // Find transactions for this category
      const categoryTransactions = transactions.filter(t => 
        t.category_id === budget.category_id
      );
      
      // Calculate total spent
      const spent = categoryTransactions.reduce(
        (sum, t) => sum + parseFloat(t.amount), 
        0
      );
      
      // Calculate remaining and percentage
      const remaining = budgetAmount - spent;
      const percentage = budgetAmount > 0 ? (spent / budgetAmount) * 100 : 0;
      
      // Determine status
      let status;
      if (percentage < 50) {
        status = 'good';
      } else if (percentage < 85) {
        status = 'warning';
      } else if (percentage < 100) {
        status = 'alert';
      } else {
        status = 'over_budget';
      }
      
      budgetPerformance.push({
        budget_id: budget.id,
        category_id: budget.category_id,
        category_name: budget.category ? budget.category.name : 'Unknown',
        budgeted: budgetAmount,
        spent: spent,
        remaining: remaining,
        percentage: percentage,
        status: status,
        transaction_count: categoryTransactions.length
      });
      
      totalBudgeted += budgetAmount;
      totalSpent += spent;
    }
    
    // Sort by percentage (descending)
    budgetPerformance.sort((a, b) => b.percentage - a.percentage);
    
    // Calculate overall performance
    const overallRemaining = totalBudgeted - totalSpent;
    const overallPercentage = totalBudgeted > 0 ? (totalSpent / totalBudgeted) * 100 : 0;
    
    let overallStatus;
    if (overallPercentage < 50) {
      overallStatus = 'good';
    } else if (overallPercentage < 85) {
      overallStatus = 'warning';
    } else if (overallPercentage < 100) {
      overallStatus = 'alert';
    } else {
      overallStatus = 'over_budget';
    }
    
    res.status(200).json({
      success: true,
      data: {
        period: {
          start_date: startDate,
          end_date: endDate
        },
        overall: {
          budgeted: totalBudgeted,
          spent: totalSpent,
          remaining: overallRemaining,
          percentage: overallPercentage,
          status: overallStatus
        },
        categories: budgetPerformance
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get budget recommendations
 */
exports.getBudgetRecommendations = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get expense categories
    const categories = await Category.findAll({
      where: { type: 'expense' }
    });
    
    // Get existing budgets
    const existingBudgets = await Budget.findAll({
      where: { user_id: userId }
    });
    
    const existingBudgetCategories = existingBudgets.map(b => b.category_id);
    
    // Get transactions for the last 3 months
    const threeMonthsAgo = new Date();
    threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3);
    
    const transactions = await Transaction.findAll({
      where: { 
        user_id: userId,
        transaction_date: {
          [Op.gte]: threeMonthsAgo
        },
        transaction_type: 'expense'
      },
      include: [
        { model: Category, as: 'category' }
      ]
    });
    
    // Group transactions by category
    const expensesByCategory = {};
    
    for (const transaction of transactions) {
      if (!transaction.category_id) continue;
      
      if (!expensesByCategory[transaction.category_id]) {
        expensesByCategory[transaction.category_id] = {
          category_id: transaction.category_id,
          category_name: transaction.category ? transaction.category.name : 'Unknown',
          total: 0,
          count: 0,
          transactions: []
        };
      }
      
      expensesByCategory[transaction.category_id].total += parseFloat(transaction.amount);
      expensesByCategory[transaction.category_id].count += 1;
      expensesByCategory[transaction.category_id].transactions.push(transaction);
    }
    
    // Calculate average monthly expense for each category
    const recommendations = [];
    
    for (const categoryId in expensesByCategory) {
      const categoryData = expensesByCategory[categoryId];
      const averageMonthly = categoryData.total / 3; // 3 months of data
      
      // Only recommend if no budget exists and there are significant expenses
      if (!existingBudgetCategories.includes(parseInt(categoryId)) && averageMonthly > 0) {
        // Round up to nearest 10
        const recommendedBudget = Math.ceil(averageMonthly / 10) * 10;
        
        recommendations.push({
          category_id: categoryData.category_id,
          category_name: categoryData.category_name,
          average_monthly_expense: averageMonthly,
          recommended_budget: recommendedBudget,
          transaction_count: categoryData.count
        });
      }
    }
    
    // Sort by average expense (descending)
    recommendations.sort((a, b) => b.average_monthly_expense - a.average_monthly_expense);
    
    res.status(200).json({
      success: true,
      count: recommendations.length,
      data: recommendations
    });
  } catch (error) {
    next(error);
  }
};
