const { Goal, User } = require('../models');
const { NotFoundError } = require('../utils/errors');
const { Op, Sequelize } = require('sequelize');

/**
 * Get all goals for the authenticated user
 */
exports.getAllGoals = async (req, res, next) => {
  try {
    const goals = await Goal.findAll({
      where: { user_id: req.user.id }
    });

    res.status(200).json({
      success: true,
      count: goals.length,
      data: goals
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get goal by ID
 */
exports.getGoalById = async (req, res, next) => {
  try {
    const goal = await Goal.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!goal) {
      throw new NotFoundError('Goal not found');
    }

    res.status(200).json({
      success: true,
      data: goal
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new goal
 */
exports.createGoal = async (req, res, next) => {
  try {
    const { 
      name, 
      target_amount, 
      current_amount, 
      currency, 
      deadline, 
      category,
      priority,
      status
    } = req.body;

    const goal = await Goal.create({
      user_id: req.user.id,
      name,
      target_amount,
      current_amount: current_amount || 0,
      currency: currency || 'USD',
      deadline: deadline ? new Date(deadline) : null,
      category,
      priority: priority || 1,
      status: status || 'active'
    });

    res.status(201).json({
      success: true,
      data: goal
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update a goal
 */
exports.updateGoal = async (req, res, next) => {
  try {
    const { 
      name, 
      target_amount, 
      current_amount, 
      currency, 
      deadline, 
      category,
      priority,
      status
    } = req.body;

    const goal = await Goal.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!goal) {
      throw new NotFoundError('Goal not found');
    }

    // Update goal
    goal.name = name || goal.name;
    goal.target_amount = target_amount !== undefined ? target_amount : goal.target_amount;
    goal.current_amount = current_amount !== undefined ? current_amount : goal.current_amount;
    goal.currency = currency || goal.currency;
    goal.deadline = deadline ? new Date(deadline) : goal.deadline;
    goal.category = category !== undefined ? category : goal.category;
    goal.priority = priority !== undefined ? priority : goal.priority;
    goal.status = status || goal.status;
    
    await goal.save();

    res.status(200).json({
      success: true,
      data: goal
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a goal
 */
exports.deleteGoal = async (req, res, next) => {
  try {
    const goal = await Goal.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!goal) {
      throw new NotFoundError('Goal not found');
    }

    await goal.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update goal progress
 */
exports.updateGoalProgress = async (req, res, next) => {
  try {
    const { current_amount } = req.body;

    if (current_amount === undefined) {
      throw new ValidationError('Current amount is required');
    }

    const goal = await Goal.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!goal) {
      throw new NotFoundError('Goal not found');
    }

    // Update goal progress
    goal.current_amount = current_amount;
    
    // Check if goal is completed
    if (parseFloat(goal.current_amount) >= parseFloat(goal.target_amount)) {
      goal.status = 'completed';
    }
    
    await goal.save();

    res.status(200).json({
      success: true,
      data: {
        ...goal.toJSON(),
        progress_percentage: (parseFloat(goal.current_amount) / parseFloat(goal.target_amount)) * 100
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get goal recommendations
 */
exports.getGoalRecommendations = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get user's current goals
    const currentGoals = await Goal.findAll({
      where: { 
        user_id: userId,
        status: 'active'
      }
    });
    
    // Get current goal categories
    const currentCategories = currentGoals.map(goal => goal.category);
    
    // Define common financial goals
    const commonGoals = [
      {
        name: 'Emergency Fund',
        category: 'emergency_fund',
        description: 'Save 3-6 months of living expenses for emergencies',
        priority: 1,
        recommended: !currentCategories.includes('emergency_fund')
      },
      {
        name: 'Debt Payoff',
        category: 'debt_payoff',
        description: 'Pay off high-interest debt',
        priority: 1,
        recommended: !currentCategories.includes('debt_payoff')
      },
      {
        name: 'Retirement Savings',
        category: 'retirement',
        description: 'Save for retirement through pension or investment accounts',
        priority: 2,
        recommended: !currentCategories.includes('retirement')
      },
      {
        name: 'Home Purchase',
        category: 'home_purchase',
        description: 'Save for a down payment on a home',
        priority: 2,
        recommended: !currentCategories.includes('home_purchase')
      },
      {
        name: 'Education Fund',
        category: 'education',
        description: 'Save for education expenses',
        priority: 3,
        recommended: !currentCategories.includes('education')
      },
      {
        name: 'Vacation Fund',
        category: 'vacation',
        description: 'Save for your next vacation',
        priority: 4,
        recommended: !currentCategories.includes('vacation')
      },
      {
        name: 'New Car Fund',
        category: 'car_purchase',
        description: 'Save for your next vehicle purchase',
        priority: 3,
        recommended: !currentCategories.includes('car_purchase')
      },
      {
        name: 'Financial Independence',
        category: 'financial_independence',
        description: 'Save enough to achieve financial independence',
        priority: 2,
        recommended: !currentCategories.includes('financial_independence')
      }
    ];
    
    // Filter to only recommended goals
    const recommendations = commonGoals
      .filter(goal => goal.recommended)
      .sort((a, b) => a.priority - b.priority);
    
    res.status(200).json({
      success: true,
      data: {
        current_goals: currentGoals,
        recommendations: recommendations
      }
    });
  } catch (error) {
    next(error);
  }
};
