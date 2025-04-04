const { Dashboard, User, Account, Transaction, Category, Asset, Liability, KPI } = require('../models');
const { NotFoundError } = require('../utils/errors');
const { Op, Sequelize } = require('sequelize');

/**
 * Get dashboard data for the authenticated user
 */
exports.getDashboardData = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get user's accounts
    const accounts = await Account.findAll({
      where: { user_id: userId }
    });
    
    // Get user's assets
    const assets = await Asset.findAll({
      where: { user_id: userId }
    });
    
    // Get user's liabilities
    const liabilities = await Liability.findAll({
      where: { user_id: userId }
    });
    
    // Calculate net worth
    const totalAssets = assets.reduce((sum, asset) => sum + parseFloat(asset.value), 0);
    const totalLiabilities = liabilities.reduce((sum, liability) => sum + parseFloat(liability.amount), 0);
    const netWorth = totalAssets - totalLiabilities;
    
    // Get recent transactions
    const recentTransactions = await Transaction.findAll({
      where: { user_id: userId },
      include: [
        { model: Category, as: 'category' },
        { model: Account, as: 'account' }
      ],
      order: [['transaction_date', 'DESC']],
      limit: 5
    });
    
    // Calculate monthly income and expenses
    const currentDate = new Date();
    const firstDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
    const lastDayOfMonth = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    
    const monthlyTransactions = await Transaction.findAll({
      where: { 
        user_id: userId,
        transaction_date: {
          [Op.between]: [firstDayOfMonth, lastDayOfMonth]
        }
      }
    });
    
    const monthlyIncome = monthlyTransactions
      .filter(t => t.transaction_type === 'income')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);
      
    const monthlyExpenses = monthlyTransactions
      .filter(t => t.transaction_type === 'expense')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);
    
    // Calculate savings rate
    const savingsRate = monthlyIncome > 0 ? ((monthlyIncome - monthlyExpenses) / monthlyIncome) * 100 : 0;
    
    // Get previous month's data for comparison
    const prevMonthFirstDay = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
    const prevMonthLastDay = new Date(currentDate.getFullYear(), currentDate.getMonth(), 0);
    
    const prevMonthTransactions = await Transaction.findAll({
      where: { 
        user_id: userId,
        transaction_date: {
          [Op.between]: [prevMonthFirstDay, prevMonthLastDay]
        }
      }
    });
    
    const prevMonthIncome = prevMonthTransactions
      .filter(t => t.transaction_type === 'income')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);
      
    const prevMonthExpenses = prevMonthTransactions
      .filter(t => t.transaction_type === 'expense')
      .reduce((sum, t) => sum + parseFloat(t.amount), 0);
    
    const prevMonthSavingsRate = prevMonthIncome > 0 ? ((prevMonthIncome - prevMonthExpenses) / prevMonthIncome) * 100 : 0;
    
    // Calculate changes from previous month
    const incomeChange = prevMonthIncome > 0 ? ((monthlyIncome - prevMonthIncome) / prevMonthIncome) * 100 : 0;
    const expensesChange = prevMonthExpenses > 0 ? ((monthlyExpenses - prevMonthExpenses) / prevMonthExpenses) * 100 : 0;
    const savingsRateChange = prevMonthSavingsRate > 0 ? (savingsRate - prevMonthSavingsRate) : 0;
    
    // Get previous net worth for comparison
    const prevMonthKPI = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'net_worth',
        date: {
          [Op.between]: [prevMonthFirstDay, prevMonthLastDay]
        }
      },
      order: [['date', 'DESC']]
    });
    
    const prevNetWorth = prevMonthKPI ? parseFloat(prevMonthKPI.value) : 0;
    const netWorthChange = prevNetWorth > 0 ? ((netWorth - prevNetWorth) / prevNetWorth) * 100 : 0;
    
    // Store current net worth as KPI
    await KPI.create({
      user_id: userId,
      type: 'net_worth',
      value: netWorth,
      date: new Date()
    });
    
    // Store current savings rate as KPI
    await KPI.create({
      user_id: userId,
      type: 'savings_rate',
      value: savingsRate,
      date: new Date()
    });
    
    res.status(200).json({
      success: true,
      data: {
        net_worth: {
          value: netWorth,
          change: netWorthChange,
          change_type: netWorthChange >= 0 ? 'positive' : 'negative'
        },
        monthly_income: {
          value: monthlyIncome,
          change: incomeChange,
          change_type: incomeChange >= 0 ? 'positive' : 'negative'
        },
        monthly_expenses: {
          value: monthlyExpenses,
          change: expensesChange,
          change_type: expensesChange <= 0 ? 'positive' : 'negative'
        },
        savings_rate: {
          value: savingsRate,
          change: savingsRateChange,
          change_type: savingsRateChange >= 0 ? 'positive' : 'negative'
        },
        accounts: accounts,
        recent_transactions: recentTransactions
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get financial summary
 */
exports.getFinancialSummary = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get total balances by account type
    const accountBalances = await Account.findAll({
      where: { user_id: userId },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('balance')), 'total_balance']
      ],
      group: ['type']
    });
    
    // Get asset allocation
    const assetAllocation = await Asset.findAll({
      where: { user_id: userId },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('value')), 'total_value']
      ],
      group: ['type']
    });
    
    // Get liability breakdown
    const liabilityBreakdown = await Liability.findAll({
      where: { user_id: userId },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total_amount']
      ],
      group: ['type']
    });
    
    // Get historical net worth
    const netWorthHistory = await KPI.findAll({
      where: {
        user_id: userId,
        type: 'net_worth'
      },
      order: [['date', 'ASC']],
      limit: 12
    });
    
    // Get historical savings rate
    const savingsRateHistory = await KPI.findAll({
      where: {
        user_id: userId,
        type: 'savings_rate'
      },
      order: [['date', 'ASC']],
      limit: 12
    });
    
    res.status(200).json({
      success: true,
      data: {
        account_balances: accountBalances,
        asset_allocation: assetAllocation,
        liability_breakdown: liabilityBreakdown,
        net_worth_history: netWorthHistory,
        savings_rate_history: savingsRateHistory
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get cash flow data
 */
exports.getCashFlowData = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { period = 'monthly', start_date, end_date } = req.query;
    
    let startDate, endDate;
    
    if (start_date && end_date) {
      startDate = new Date(start_date);
      endDate = new Date(end_date);
    } else {
      // Default to last 12 months
      endDate = new Date();
      startDate = new Date();
      startDate.setMonth(startDate.getMonth() - 11);
      startDate.setDate(1);
    }
    
    // Get all transactions in date range
    const transactions = await Transaction.findAll({
      where: { 
        user_id: userId,
        transaction_date: {
          [Op.between]: [startDate, endDate]
        }
      },
      order: [['transaction_date', 'ASC']]
    });
    
    // Group transactions by period
    const cashFlowData = {};
    
    for (const transaction of transactions) {
      const date = new Date(transaction.transaction_date);
      let periodKey;
      
      if (period === 'monthly') {
        periodKey = `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
      } else if (period === 'quarterly') {
        const quarter = Math.floor(date.getMonth() / 3) + 1;
        periodKey = `${date.getFullYear()}-Q${quarter}`;
      } else if (period === 'yearly') {
        periodKey = `${date.getFullYear()}`;
      } else if (period === 'weekly') {
        // Get the week number
        const firstDayOfYear = new Date(date.getFullYear(), 0, 1);
        const pastDaysOfYear = (date - firstDayOfYear) / 86400000;
        const weekNumber = Math.ceil((pastDaysOfYear + firstDayOfYear.getDay() + 1) / 7);
        periodKey = `${date.getFullYear()}-W${String(weekNumber).padStart(2, '0')}`;
      }
      
      if (!cashFlowData[periodKey]) {
        cashFlowData[periodKey] = {
          period: periodKey,
          income: 0,
          expenses: 0,
          net: 0
        };
      }
      
      if (transaction.transaction_type === 'income') {
        cashFlowData[periodKey].income += parseFloat(transaction.amount);
      } else if (transaction.transaction_type === 'expense') {
        cashFlowData[periodKey].expenses += parseFloat(transaction.amount);
      }
      
      cashFlowData[periodKey].net = cashFlowData[periodKey].income - cashFlowData[periodKey].expenses;
    }
    
    // Convert to array and sort by period
    const result = Object.values(cashFlowData).sort((a, b) => a.period.localeCompare(b.period));
    
    res.status(200).json({
      success: true,
      data: result
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get expense breakdown
 */
exports.getExpenseBreakdown = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { period = 'current_month' } = req.query;
    
    let startDate, endDate;
    
    const currentDate = new Date();
    
    if (period === 'current_month') {
      startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
      endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    } else if (period === 'previous_month') {
      startDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1);
      endDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 0);
    } else if (period === 'current_year') {
      startDate = new Date(currentDate.getFullYear(), 0, 1);
      endDate = new Date(currentDate.getFullYear(), 11, 31);
    } else if (period === 'custom' && req.query.start_date && req.query.end_date) {
      startDate = new Date(req.query.start_date);
      endDate = new Date(req.query.end_date);
    } else {
      // Default to current month
      startDate = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
      endDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 0);
    }
    
    // Get expense transactions with categories
    const expenses = await Transaction.findAll({
      where: { 
        user_id: userId,
        transaction_type: 'expense',
        transaction_date: {
          [Op.between]: [startDate, endDate]
        }
      },
      include: [
        { model: Category, as: 'category' }
      ]
    });
    
    // Group by category
    const expensesByCategory = {};
    let totalExpenses = 0;
    
    for (const expense of expenses) {
      const categoryName = expense.category ? expense.category.name : 'Uncategorized';
      const categoryId = expense.category ? expense.category.id : 0;
      const amount = parseFloat(expense.amount);
      
      if (!expensesByCategory[categoryId]) {
        expensesByCategory[categoryId] = {
          category_id: categoryId,
          category_name: categoryName,
          amount: 0,
          count: 0
        };
      }
      
      expensesByCategory[categoryId].amount += amount;
      expensesByCategory[categoryId].count += 1;
      totalExpenses += amount;
    }
    
    // Calculate percentages and convert to array
    const result = Object.values(expensesByCategory).map(category => ({
      ...category,
      percentage: totalExpenses > 0 ? (category.amount / totalExpenses) * 100 : 0
    }));
    
    // Sort by amount descending
    result.sort((a, b) => b.amount - a.amount);
    
    res.status(200).json({
      success: true,
      data: {
        total_expenses: totalExpenses,
        period: {
          start_date: startDate,
          end_date: endDate
        },
        breakdown: result
      }
    });
  } catch (error) {
    next(error);
  }
};
