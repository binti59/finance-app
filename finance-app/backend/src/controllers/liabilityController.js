const { Liability, User } = require('../models');
const { NotFoundError } = require('../utils/errors');
const { Op, Sequelize } = require('sequelize');

/**
 * Get all liabilities for the authenticated user
 */
exports.getAllLiabilities = async (req, res, next) => {
  try {
    const liabilities = await Liability.findAll({
      where: { user_id: req.user.id }
    });

    res.status(200).json({
      success: true,
      count: liabilities.length,
      data: liabilities
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get liability by ID
 */
exports.getLiabilityById = async (req, res, next) => {
  try {
    const liability = await Liability.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!liability) {
      throw new NotFoundError('Liability not found');
    }

    res.status(200).json({
      success: true,
      data: liability
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new liability
 */
exports.createLiability = async (req, res, next) => {
  try {
    const { 
      name, 
      type, 
      amount, 
      currency, 
      interest_rate, 
      start_date,
      end_date,
      payment_amount,
      payment_frequency
    } = req.body;

    const liability = await Liability.create({
      user_id: req.user.id,
      name,
      type,
      amount,
      currency: currency || 'USD',
      interest_rate,
      start_date: start_date ? new Date(start_date) : null,
      end_date: end_date ? new Date(end_date) : null,
      payment_amount,
      payment_frequency
    });

    res.status(201).json({
      success: true,
      data: liability
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update a liability
 */
exports.updateLiability = async (req, res, next) => {
  try {
    const { 
      name, 
      type, 
      amount, 
      currency, 
      interest_rate, 
      start_date,
      end_date,
      payment_amount,
      payment_frequency
    } = req.body;

    const liability = await Liability.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!liability) {
      throw new NotFoundError('Liability not found');
    }

    // Update liability
    liability.name = name || liability.name;
    liability.type = type || liability.type;
    liability.amount = amount !== undefined ? amount : liability.amount;
    liability.currency = currency || liability.currency;
    liability.interest_rate = interest_rate !== undefined ? interest_rate : liability.interest_rate;
    liability.start_date = start_date ? new Date(start_date) : liability.start_date;
    liability.end_date = end_date ? new Date(end_date) : liability.end_date;
    liability.payment_amount = payment_amount !== undefined ? payment_amount : liability.payment_amount;
    liability.payment_frequency = payment_frequency || liability.payment_frequency;
    
    await liability.save();

    res.status(200).json({
      success: true,
      data: liability
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a liability
 */
exports.deleteLiability = async (req, res, next) => {
  try {
    const liability = await Liability.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!liability) {
      throw new NotFoundError('Liability not found');
    }

    await liability.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get liability summary
 */
exports.getLiabilitySummary = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get liability summary by type
    const liabilitiesByType = await Liability.findAll({
      where: { user_id: userId },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('amount')), 'total_amount'],
        [Sequelize.fn('AVG', Sequelize.col('interest_rate')), 'avg_interest_rate'],
        [Sequelize.fn('COUNT', Sequelize.col('id')), 'count']
      ],
      group: ['type']
    });
    
    // Calculate total debt
    const totalDebt = liabilitiesByType.reduce(
      (sum, liability) => sum + parseFloat(liability.dataValues.total_amount), 
      0
    );
    
    // Calculate weighted average interest rate
    let weightedInterestRate = 0;
    if (totalDebt > 0) {
      weightedInterestRate = liabilitiesByType.reduce(
        (sum, liability) => {
          const amount = parseFloat(liability.dataValues.total_amount);
          const rate = parseFloat(liability.dataValues.avg_interest_rate);
          return sum + (amount * rate);
        }, 
        0
      ) / totalDebt;
    }
    
    // Calculate monthly payment total
    const liabilities = await Liability.findAll({
      where: { 
        user_id: userId,
        payment_amount: {
          [Op.not]: null
        }
      }
    });
    
    let monthlyPaymentTotal = 0;
    for (const liability of liabilities) {
      const paymentAmount = parseFloat(liability.payment_amount);
      
      // Convert payment to monthly equivalent
      switch (liability.payment_frequency) {
        case 'weekly':
          monthlyPaymentTotal += paymentAmount * 4.33; // Average weeks per month
          break;
        case 'bi-weekly':
          monthlyPaymentTotal += paymentAmount * 2.17; // Average bi-weeks per month
          break;
        case 'monthly':
          monthlyPaymentTotal += paymentAmount;
          break;
        case 'quarterly':
          monthlyPaymentTotal += paymentAmount / 3;
          break;
        case 'annually':
          monthlyPaymentTotal += paymentAmount / 12;
          break;
        default:
          monthlyPaymentTotal += paymentAmount; // Default to monthly
      }
    }
    
    // Get debt payoff projections
    const projections = [];
    let remainingDebt = totalDebt;
    let month = 0;
    
    // Simple projection assuming fixed payment and no new debt
    if (monthlyPaymentTotal > 0) {
      while (remainingDebt > 0 && month < 360) { // Cap at 30 years
        month++;
        
        // Calculate interest for the month (simplified)
        const monthlyInterest = (remainingDebt * (weightedInterestRate / 100)) / 12;
        
        // Apply payment
        let payment = Math.min(monthlyPaymentTotal, remainingDebt + monthlyInterest);
        remainingDebt = remainingDebt + monthlyInterest - payment;
        
        // Add to projections (every 12 months)
        if (month % 12 === 0 || remainingDebt <= 0) {
          projections.push({
            month,
            year: Math.floor(month / 12),
            remaining_debt: Math.max(0, remainingDebt),
            total_paid: month * monthlyPaymentTotal
          });
        }
      }
    }
    
    res.status(200).json({
      success: true,
      data: {
        total_debt: totalDebt,
        weighted_interest_rate: weightedInterestRate,
        monthly_payment_total: monthlyPaymentTotal,
        debt_by_type: liabilitiesByType,
        payoff_projections: projections
      }
    });
  } catch (error) {
    next(error);
  }
};
