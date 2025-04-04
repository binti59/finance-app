const { Report, User } = require('../models');
const { NotFoundError, ValidationError } = require('../utils/errors');
const { Op, Sequelize } = require('sequelize');
const fs = require('fs');
const path = require('path');

/**
 * Get all reports for the authenticated user
 */
exports.getAllReports = async (req, res, next) => {
  try {
    const reports = await Report.findAll({
      where: { user_id: req.user.id }
    });

    res.status(200).json({
      success: true,
      count: reports.length,
      data: reports
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get report by ID
 */
exports.getReportById = async (req, res, next) => {
  try {
    const report = await Report.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!report) {
      throw new NotFoundError('Report not found');
    }

    res.status(200).json({
      success: true,
      data: report
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new report
 */
exports.createReport = async (req, res, next) => {
  try {
    const { name, type, parameters } = req.body;

    // Validate report type
    const validTypes = ['income', 'expense', 'net_worth', 'investment', 'budget', 'tax', 'custom'];
    if (!validTypes.includes(type)) {
      throw new ValidationError(`Invalid report type. Valid types are: ${validTypes.join(', ')}`);
    }

    const report = await Report.create({
      user_id: req.user.id,
      name,
      type,
      parameters: parameters || {}
    });

    res.status(201).json({
      success: true,
      data: report
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update a report
 */
exports.updateReport = async (req, res, next) => {
  try {
    const { name, type, parameters } = req.body;

    const report = await Report.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!report) {
      throw new NotFoundError('Report not found');
    }

    // Validate report type if provided
    if (type) {
      const validTypes = ['income', 'expense', 'net_worth', 'investment', 'budget', 'tax', 'custom'];
      if (!validTypes.includes(type)) {
        throw new ValidationError(`Invalid report type. Valid types are: ${validTypes.join(', ')}`);
      }
    }

    // Update report
    report.name = name || report.name;
    report.type = type || report.type;
    report.parameters = parameters || report.parameters;
    
    await report.save();

    res.status(200).json({
      success: true,
      data: report
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a report
 */
exports.deleteReport = async (req, res, next) => {
  try {
    const report = await Report.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!report) {
      throw new NotFoundError('Report not found');
    }

    await report.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Generate a custom report
 */
exports.generateReport = async (req, res, next) => {
  try {
    const { 
      report_id, 
      type, 
      start_date, 
      end_date, 
      categories,
      accounts,
      group_by,
      include_charts
    } = req.body;

    let reportConfig;

    // If report_id is provided, use saved report configuration
    if (report_id) {
      const savedReport = await Report.findOne({
        where: { 
          id: report_id,
          user_id: req.user.id
        }
      });

      if (!savedReport) {
        throw new NotFoundError('Report not found');
      }

      reportConfig = {
        type: savedReport.type,
        parameters: savedReport.parameters
      };
    } else {
      // Otherwise use provided parameters
      reportConfig = {
        type: type || 'expense',
        parameters: {
          start_date: start_date || new Date(new Date().getFullYear(), 0, 1).toISOString().split('T')[0], // Default to start of year
          end_date: end_date || new Date().toISOString().split('T')[0], // Default to today
          categories: categories || [],
          accounts: accounts || [],
          group_by: group_by || 'month',
          include_charts: include_charts !== undefined ? include_charts : true
        }
      };
    }

    // Generate report based on type
    let reportData;
    
    switch (reportConfig.type) {
      case 'income':
        reportData = await generateIncomeReport(req.user.id, reportConfig.parameters);
        break;
      case 'expense':
        reportData = await generateExpenseReport(req.user.id, reportConfig.parameters);
        break;
      case 'net_worth':
        reportData = await generateNetWorthReport(req.user.id, reportConfig.parameters);
        break;
      case 'investment':
        reportData = await generateInvestmentReport(req.user.id, reportConfig.parameters);
        break;
      case 'budget':
        reportData = await generateBudgetReport(req.user.id, reportConfig.parameters);
        break;
      case 'tax':
        reportData = await generateTaxReport(req.user.id, reportConfig.parameters);
        break;
      default:
        throw new ValidationError('Invalid report type');
    }

    res.status(200).json({
      success: true,
      data: {
        report_type: reportConfig.type,
        parameters: reportConfig.parameters,
        generated_at: new Date(),
        report_data: reportData
      }
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Export a report
 */
exports.exportReport = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { format = 'json' } = req.query;

    // Get report
    const report = await Report.findOne({
      where: { 
        id,
        user_id: req.user.id
      }
    });

    if (!report) {
      throw new NotFoundError('Report not found');
    }

    // Generate report data
    let reportData;
    
    switch (report.type) {
      case 'income':
        reportData = await generateIncomeReport(req.user.id, report.parameters);
        break;
      case 'expense':
        reportData = await generateExpenseReport(req.user.id, report.parameters);
        break;
      case 'net_worth':
        reportData = await generateNetWorthReport(req.user.id, report.parameters);
        break;
      case 'investment':
        reportData = await generateInvestmentReport(req.user.id, report.parameters);
        break;
      case 'budget':
        reportData = await generateBudgetReport(req.user.id, report.parameters);
        break;
      case 'tax':
        reportData = await generateTaxReport(req.user.id, report.parameters);
        break;
      default:
        throw new ValidationError('Invalid report type');
    }

    // Format report based on requested format
    let exportData;
    let contentType;
    let fileExtension;
    
    switch (format.toLowerCase()) {
      case 'json':
        exportData = JSON.stringify(reportData, null, 2);
        contentType = 'application/json';
        fileExtension = 'json';
        break;
      case 'csv':
        exportData = convertToCSV(reportData);
        contentType = 'text/csv';
        fileExtension = 'csv';
        break;
      default:
        throw new ValidationError('Unsupported export format. Supported formats: json, csv');
    }

    // Generate filename
    const filename = `${report.name.replace(/\s+/g, '_').toLowerCase()}_${new Date().toISOString().split('T')[0]}.${fileExtension}`;
    
    // Set headers for file download
    res.setHeader('Content-Type', contentType);
    res.setHeader('Content-Disposition', `attachment; filename=${filename}`);
    
    // Send file
    res.send(exportData);
  } catch (error) {
    next(error);
  }
};

/**
 * Helper function to generate income report
 */
async function generateIncomeReport(userId, parameters) {
  // This would be implemented with actual database queries
  // For now, return placeholder data
  return {
    title: "Income Report",
    summary: {
      total_income: 25000,
      average_monthly: 8333.33,
      top_source: "Salary"
    },
    data: [
      { month: "January", amount: 8000, sources: { "Salary": 7500, "Dividends": 500 } },
      { month: "February", amount: 8500, sources: { "Salary": 7500, "Dividends": 500, "Freelance": 500 } },
      { month: "March", amount: 8500, sources: { "Salary": 7500, "Dividends": 500, "Freelance": 500 } }
    ]
  };
}

/**
 * Helper function to generate expense report
 */
async function generateExpenseReport(userId, parameters) {
  // This would be implemented with actual database queries
  // For now, return placeholder data
  return {
    title: "Expense Report",
    summary: {
      total_expenses: 15000,
      average_monthly: 5000,
      top_category: "Housing"
    },
    data: [
      { month: "January", amount: 4800, categories: { "Housing": 2000, "Food": 800, "Transportation": 500, "Utilities": 400, "Entertainment": 600, "Other": 500 } },
      { month: "February", amount: 5100, categories: { "Housing": 2000, "Food": 900, "Transportation": 600, "Utilities": 400, "Entertainment": 700, "Other": 500 } },
      { month: "March", amount: 5100, categories: { "Housing": 2000, "Food": 900, "Transportation": 600, "Utilities": 400, "Entertainment": 700, "Other": 500 } }
    ]
  };
}

/**
 * Helper function to generate net worth report
 */
async function generateNetWorthReport(userId, parameters) {
  // This would be implemented with actual database queries
  // For now, return placeholder data
  return {
    title: "Net Worth Report",
    summary: {
      current_net_worth: 120000,
      change_from_start: 15000,
      percentage_change: 14.3
    },
    data: [
      { date: "2025-01-01", assets: 150000, liabilities: 45000, net_worth: 105000 },
      { date: "2025-02-01", assets: 155000, liabilities: 44000, net_worth: 111000 },
      { date: "2025-03-01", assets: 160000, liabilities: 43000, net_worth: 117000 },
      { date: "2025-04-01", assets: 162000, liabilities: 42000, net_worth: 120000 }
    ]
  };
}

/**
 * Helper function to generate investment report
 */
async function generateInvestmentReport(userId, parameters) {
  // This would be implemented with actual database queries
  // For now, return placeholder data
  return {
    title: "Investment Report",
    summary: {
      total_invested: 80000,
      current_value: 95000,
      total_return: 15000,
      percentage_return: 18.75
    },
    data: [
      { asset: "Stock Portfolio", initial_investment: 50000, current_value: 60000, return: 10000, percentage: 20 },
      { asset: "Real Estate", initial_investment: 20000, current_value: 23000, return: 3000, percentage: 15 },
      { asset: "Cryptocurrency", initial_investment: 10000, current_value: 12000, return: 2000, percentage: 20 }
    ]
  };
}

/**
 * Helper function to generate budget report
 */
async function generateBudgetReport(userId, parameters) {
  // This would be implemented with actual database queries
  // For now, return placeholder data
  return {
    title: "Budget Report",
    summary: {
      total_budgeted: 6000,
      total_spent: 5100,
      remaining: 900,
      percentage_used: 85
    },
    data: [
      { category: "Housing", budgeted: 2000, spent: 2000, remaining: 0, percentage: 100 },
      { category: "Food", budgeted: 1000, spent: 900, remaining: 100, percentage: 90 },
      { category: "Transportation", budgeted: 600, spent: 600, remaining: 0, percentage: 100 },
      { category: "Utilities", budgeted: 500, spent: 400, remaining: 100, percentage: 80 },
      { category: "Entertainment", budgeted: 800, spent: 700, remaining: 100, percentage: 87.5 },
      { category: "Other", budgeted: 1100, spent: 500, remaining: 600, percentage: 45.5 }
    ]
  };
}

/**
 * Helper function to generate tax report
 */
async function generateTaxReport(userId, parameters) {
  // This would be implemented with actual database queries
  // For now, return placeholder data
  return {
    title: "Tax Report",
    summary: {
      total_income: 25000,
      taxable_income: 22000,
      estimated_tax: 4400,
      effective_tax_rate: 17.6
    },
    data: {
      income: [
        { source: "Salary", amount: 22500, taxable: true },
        { source: "Dividends", amount: 1500, taxable: true },
        { source: "Gifts", amount: 1000, taxable: false }
      ],
      deductions: [
        { type: "Retirement Contributions", amount: 3000 },
        { type: "Charitable Donations", amount: 500 }
      ],
      tax_brackets: [
        { bracket: "10%", amount: 1000 },
        { bracket: "12%", amount: 1200 },
        { bracket: "22%", amount: 2200 }
      ]
    }
  };
}

/**
 * Helper function to convert JSON data to CSV
 */
function convertToCSV(jsonData) {
  if (!jsonData || !jsonData.data || !Array.isArray(jsonData.data)) {
    return '';
  }
  
  const items = jsonData.data;
  const replacer = (key, value) => value === null ? '' : value;
  const header = Object.keys(items[0]);
  
  let csv = header.join(',') + '\n';
  
  return items.reduce((csv, row) => {
    return csv + header.map(fieldName => {
      let value = row[fieldName];
      
      // Handle nested objects
      if (typeof value === 'object') {
        value = JSON.stringify(value);
      }
      
      // Escape quotes and wrap in quotes if contains comma
      if (typeof value === 'string') {
        value = value.replace(/"/g, '""');
        if (value.includes(',')) {
          value = `"${value}"`;
        }
      }
      
      return value;
    }).join(',') + '\n';
  }, csv);
}
