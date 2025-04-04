const { Asset, User } = require('../models');
const { NotFoundError } = require('../utils/errors');
const { Op, Sequelize } = require('sequelize');

/**
 * Get all assets for the authenticated user
 */
exports.getAllAssets = async (req, res, next) => {
  try {
    const assets = await Asset.findAll({
      where: { user_id: req.user.id }
    });

    res.status(200).json({
      success: true,
      count: assets.length,
      data: assets
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get asset by ID
 */
exports.getAssetById = async (req, res, next) => {
  try {
    const asset = await Asset.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!asset) {
      throw new NotFoundError('Asset not found');
    }

    res.status(200).json({
      success: true,
      data: asset
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new asset
 */
exports.createAsset = async (req, res, next) => {
  try {
    const { 
      name, 
      type, 
      value, 
      currency, 
      acquisition_date, 
      acquisition_price,
      current_price,
      quantity,
      notes
    } = req.body;

    const asset = await Asset.create({
      user_id: req.user.id,
      name,
      type,
      value,
      currency: currency || 'USD',
      acquisition_date: acquisition_date ? new Date(acquisition_date) : null,
      acquisition_price,
      current_price,
      quantity,
      notes
    });

    res.status(201).json({
      success: true,
      data: asset
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update an asset
 */
exports.updateAsset = async (req, res, next) => {
  try {
    const { 
      name, 
      type, 
      value, 
      currency, 
      acquisition_date, 
      acquisition_price,
      current_price,
      quantity,
      notes
    } = req.body;

    const asset = await Asset.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!asset) {
      throw new NotFoundError('Asset not found');
    }

    // Update asset
    asset.name = name || asset.name;
    asset.type = type || asset.type;
    asset.value = value !== undefined ? value : asset.value;
    asset.currency = currency || asset.currency;
    asset.acquisition_date = acquisition_date ? new Date(acquisition_date) : asset.acquisition_date;
    asset.acquisition_price = acquisition_price !== undefined ? acquisition_price : asset.acquisition_price;
    asset.current_price = current_price !== undefined ? current_price : asset.current_price;
    asset.quantity = quantity !== undefined ? quantity : asset.quantity;
    asset.notes = notes !== undefined ? notes : asset.notes;
    
    await asset.save();

    res.status(200).json({
      success: true,
      data: asset
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete an asset
 */
exports.deleteAsset = async (req, res, next) => {
  try {
    const asset = await Asset.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!asset) {
      throw new NotFoundError('Asset not found');
    }

    await asset.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get asset performance metrics
 */
exports.getAssetPerformance = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get all assets with acquisition data
    const assets = await Asset.findAll({
      where: { 
        user_id: userId,
        acquisition_price: {
          [Op.not]: null
        },
        acquisition_date: {
          [Op.not]: null
        },
        current_price: {
          [Op.not]: null
        }
      }
    });
    
    // Calculate performance metrics
    const assetPerformance = assets.map(asset => {
      const acquisitionValue = parseFloat(asset.acquisition_price) * parseFloat(asset.quantity);
      const currentValue = parseFloat(asset.current_price) * parseFloat(asset.quantity);
      const absoluteReturn = currentValue - acquisitionValue;
      const percentageReturn = acquisitionValue > 0 ? (absoluteReturn / acquisitionValue) * 100 : 0;
      
      // Calculate annualized return
      const acquisitionDate = new Date(asset.acquisition_date);
      const currentDate = new Date();
      const holdingPeriodYears = (currentDate - acquisitionDate) / (1000 * 60 * 60 * 24 * 365);
      
      let annualizedReturn = 0;
      if (holdingPeriodYears > 0 && acquisitionValue > 0) {
        annualizedReturn = (Math.pow((currentValue / acquisitionValue), (1 / holdingPeriodYears)) - 1) * 100;
      }
      
      return {
        id: asset.id,
        name: asset.name,
        type: asset.type,
        acquisition_value: acquisitionValue,
        current_value: currentValue,
        absolute_return: absoluteReturn,
        percentage_return: percentageReturn,
        annualized_return: annualizedReturn,
        holding_period_years: holdingPeriodYears
      };
    });
    
    // Sort by percentage return (descending)
    assetPerformance.sort((a, b) => b.percentage_return - a.percentage_return);
    
    res.status(200).json({
      success: true,
      count: assetPerformance.length,
      data: assetPerformance
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get asset allocation breakdown
 */
exports.getAssetAllocation = async (req, res, next) => {
  try {
    const userId = req.user.id;
    
    // Get asset allocation by type
    const assetsByType = await Asset.findAll({
      where: { user_id: userId },
      attributes: [
        'type',
        [Sequelize.fn('SUM', Sequelize.col('value')), 'total_value']
      ],
      group: ['type']
    });
    
    // Calculate total portfolio value
    const totalValue = assetsByType.reduce(
      (sum, asset) => sum + parseFloat(asset.dataValues.total_value), 
      0
    );
    
    // Calculate percentages
    const allocation = assetsByType.map(asset => ({
      type: asset.type,
      value: parseFloat(asset.dataValues.total_value),
      percentage: totalValue > 0 ? (parseFloat(asset.dataValues.total_value) / totalValue) * 100 : 0
    }));
    
    // Sort by value (descending)
    allocation.sort((a, b) => b.value - a.value);
    
    // Get recommended allocation based on simple age-based rule
    // In a real implementation, this would be more sophisticated
    const user = await User.findByPk(userId);
    let recommendedAllocation = {};
    
    // Default recommendation if we can't determine age
    recommendedAllocation = {
      stock: 60,
      bond: 30,
      cash: 10,
      real_estate: 0,
      crypto: 0,
      other: 0
    };
    
    res.status(200).json({
      success: true,
      data: {
        total_value: totalValue,
        allocation: allocation,
        recommended_allocation: recommendedAllocation
      }
    });
  } catch (error) {
    next(error);
  }
};
