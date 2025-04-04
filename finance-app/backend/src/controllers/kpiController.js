const { KPI, User } = require('../models');
const { NotFoundError } = require('../utils/errors');
const { Op, Sequelize } = require('sequelize');

/**
 * Get all KPIs for the authenticated user
 */
exports.getAllKPIs = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { type, start_date, end_date } = req.query;
    
    // Build query conditions
    const where = { user_id: userId };
    
    if (type) {
      where.type = type;
    }
    
    if (start_date && end_date) {
      where.date = {
        [Op.between]: [new Date(start_date), new Date(end_date)]
      };
    } else if (start_date) {
      where.date = {
        [Op.gte]: new Date(start_date)
      };
    } else if (end_date) {
      where.date = {
        [Op.lte]: new Date(end_date)
      };
    }
    
    const kpis = await KPI.findAll({
      where,
      order: [['date', 'DESC']]
    });
    
    res.status(200).json({
      success: true,
      count: kpis.length,
      data: kpis
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Calculate and get net worth
 */
exports.getNetWorth = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get latest net worth KPI
    const latestNetWorth = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'net_worth'
      },
      order: [['date', 'DESC']]
    });
    
    // Get historical net worth data
    const historicalData = await KPI.findAll({
      where: {
        user_id: userId,
        type: 'net_worth'
      },
      order: [['date', 'ASC']],
      limit: 12
    });
    
    // Calculate growth rates
    let monthlyGrowth = 0;
    let yearlyGrowth = 0;
    
    if (historicalData.length >= 2) {
      const currentValue = parseFloat(historicalData[historicalData.length - 1].value);
      const previousMonthValue = parseFloat(historicalData[historicalData.length - 2].value);
      
      if (previousMonthValue > 0) {
        monthlyGrowth = ((currentValue - previousMonthValue) / previousMonthValue) * 100;
      }
      
      if (historicalData.length >= 12) {
        const yearAgoValue = parseFloat(historicalData[historicalData.length - 12].value);
        if (yearAgoValue > 0) {
          yearlyGrowth = ((currentValue - yearAgoValue) / yearAgoValue) * 100;
        }
      }
    }
    
    res.status(200).json({
      success: true,
      data: {
        current_net_worth: latestNetWorth ? parseFloat(latestNetWorth.value) : 0,
        monthly_growth: monthlyGrowth,
        yearly_growth: yearlyGrowth,
        historical_data: historicalData
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Calculate and get savings rate
 */
exports.getSavingsRate = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get latest savings rate KPI
    const latestSavingsRate = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'savings_rate'
      },
      order: [['date', 'DESC']]
    });
    
    // Get historical savings rate data
    const historicalData = await KPI.findAll({
      where: {
        user_id: userId,
        type: 'savings_rate'
      },
      order: [['date', 'ASC']],
      limit: 12
    });
    
    // Calculate average savings rate
    const averageSavingsRate = historicalData.length > 0
      ? historicalData.reduce((sum, kpi) => sum + parseFloat(kpi.value), 0) / historicalData.length
      : 0;
    
    res.status(200).json({
      success: true,
      data: {
        current_savings_rate: latestSavingsRate ? parseFloat(latestSavingsRate.value) : 0,
        average_savings_rate: averageSavingsRate,
        historical_data: historicalData
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Calculate and get financial independence index
 */
exports.getFinancialIndependenceIndex = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get latest net worth and freedom number
    const netWorth = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'net_worth'
      },
      order: [['date', 'DESC']]
    });
    
    const freedomNumber = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'freedom_number'
      },
      order: [['date', 'DESC']]
    });
    
    // Calculate FI index
    let fiIndex = 0;
    if (netWorth && freedomNumber && parseFloat(freedomNumber.value) > 0) {
      fiIndex = (parseFloat(netWorth.value) / parseFloat(freedomNumber.value)) * 100;
    }
    
    // Get or create FI index KPI
    let fiIndexKPI = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'fi_index',
        date: {
          [Op.gte]: new Date(new Date().setHours(0, 0, 0, 0))
        }
      }
    });
    
    if (!fiIndexKPI) {
      fiIndexKPI = await KPI.create({
        user_id: userId,
        type: 'fi_index',
        value: fiIndex,
        date: new Date()
      });
    } else {
      fiIndexKPI.value = fiIndex;
      await fiIndexKPI.save();
    }
    
    // Get historical FI index data
    const historicalData = await KPI.findAll({
      where: {
        user_id: userId,
        type: 'fi_index'
      },
      order: [['date', 'ASC']],
      limit: 12
    });
    
    res.status(200).json({
      success: true,
      data: {
        fi_index: fiIndex,
        net_worth: netWorth ? parseFloat(netWorth.value) : 0,
        freedom_number: freedomNumber ? parseFloat(freedomNumber.value) : 0,
        historical_data: historicalData
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Calculate and get financial freedom number
 */
exports.getFinancialFreedomNumber = async (req, res, next) => {
  try {
    const userId = req.user.id;
    const { annual_expenses, withdrawal_rate = 4 } = req.query;
    
    let freedomNumber;
    
    // If annual expenses provided, calculate freedom number
    if (annual_expenses) {
      freedomNumber = parseFloat(annual_expenses) / (parseFloat(withdrawal_rate) / 100);
      
      // Save as KPI
      await KPI.create({
        user_id: userId,
        type: 'freedom_number',
        value: freedomNumber,
        date: new Date()
      });
    } else {
      // Get latest freedom number KPI
      const latestFreedomNumber = await KPI.findOne({
        where: {
          user_id: userId,
          type: 'freedom_number'
        },
        order: [['date', 'DESC']]
      });
      
      freedomNumber = latestFreedomNumber ? parseFloat(latestFreedomNumber.value) : 0;
    }
    
    // Get latest net worth
    const netWorth = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'net_worth'
      },
      order: [['date', 'DESC']]
    });
    
    // Calculate progress percentage
    const netWorthValue = netWorth ? parseFloat(netWorth.value) : 0;
    const progressPercentage = freedomNumber > 0 ? (netWorthValue / freedomNumber) * 100 : 0;
    
    res.status(200).json({
      success: true,
      data: {
        freedom_number: freedomNumber,
        current_net_worth: netWorthValue,
        progress_percentage: progressPercentage,
        withdrawal_rate: parseFloat(withdrawal_rate)
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Calculate and get financial health score
 */
exports.getFinancialHealthScore = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get latest KPIs
    const netWorth = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'net_worth'
      },
      order: [['date', 'DESC']]
    });
    
    const savingsRate = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'savings_rate'
      },
      order: [['date', 'DESC']]
    });
    
    const fiIndex = await KPI.findOne({
      where: {
        user_id: userId,
        type: 'fi_index'
      },
      order: [['date', 'DESC']]
    });
    
    // Calculate financial health score (simplified version)
    // In a real implementation, this would be more sophisticated
    let healthScore = 0;
    let components = [];
    
    // Net worth component (0-40 points)
    const netWorthValue = netWorth ? parseFloat(netWorth.value) : 0;
    let netWorthScore = 0;
    
    if (netWorthValue > 0) {
      // Simplified scoring based on net worth
      if (netWorthValue < 10000) {
        netWorthScore = 10;
      } else if (netWorthValue < 50000) {
        netWorthScore = 20;
      } else if (netWorthValue < 100000) {
        netWorthScore = 30;
      } else {
        netWorthScore = 40;
      }
    }
    
    components.push({
      name: 'Net Worth',
      score: netWorthScore,
      max_score: 40
    });
    
    // Savings rate component (0-40 points)
    const savingsRateValue = savingsRate ? parseFloat(savingsRate.value) : 0;
    let savingsRateScore = 0;
    
    if (savingsRateValue > 0) {
      // Score based on savings rate percentage
      savingsRateScore = Math.min(40, savingsRateValue);
    }
    
    components.push({
      name: 'Savings Rate',
      score: savingsRateScore,
      max_score: 40
    });
    
    // FI progress component (0-20 points)
    const fiIndexValue = fiIndex ? parseFloat(fiIndex.value) : 0;
    let fiIndexScore = 0;
    
    if (fiIndexValue > 0) {
      // Score based on FI index percentage (max 20 points)
      fiIndexScore = Math.min(20, fiIndexValue / 5);
    }
    
    components.push({
      name: 'Financial Independence Progress',
      score: fiIndexScore,
      max_score: 20
    });
    
    // Calculate total score
    healthScore = netWorthScore + savingsRateScore + fiIndexScore;
    
    // Save health score as KPI
    await KPI.create({
      user_id: userId,
      type: 'health_score',
      value: healthScore,
      date: new Date()
    });
    
    // Get historical health score data
    const historicalData = await KPI.findAll({
      where: {
        user_id: userId,
        type: 'health_score'
      },
      order: [['date', 'ASC']],
      limit: 12
    });
    
    // Determine health status
    let healthStatus;
    if (healthScore >= 80) {
      healthStatus = 'Excellent';
    } else if (healthScore >= 60) {
      healthStatus = 'Good';
    } else if (healthScore >= 40) {
      healthStatus = 'Fair';
    } else {
      healthStatus = 'Needs Improvement';
    }
    
    res.status(200).json({
      success: true,
      data: {
        health_score: healthScore,
        health_status: healthStatus,
        components: components,
        historical_data: historicalData
      }
    });
  } catch (error) {
    next(error);
  }
};
