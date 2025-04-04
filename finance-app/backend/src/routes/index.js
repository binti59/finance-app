const express = require('express');
const router = express.Router();

// Import controllers
const authController = require('../controllers/authController');
const accountController = require('../controllers/accountController');
const connectionController = require('../controllers/connectionController');
const transactionController = require('../controllers/transactionController');
const categoryController = require('../controllers/categoryController');
const assetController = require('../controllers/assetController');
const liabilityController = require('../controllers/liabilityController');
const goalController = require('../controllers/goalController');
const budgetController = require('../controllers/budgetController');
const kpiController = require('../controllers/kpiController');
const reportController = require('../controllers/reportController');
const dashboardController = require('../controllers/dashboardController');
const notificationController = require('../controllers/notificationController');

// Import middleware
const { authenticate } = require('../middleware/authMiddleware');

// Auth routes
router.post('/auth/register', authController.register);
router.post('/auth/login', authController.login);
router.post('/auth/refresh', authController.refreshToken);
router.post('/auth/logout', authenticate, authController.logout);
router.get('/auth/profile', authenticate, authController.getProfile);
router.put('/auth/profile', authenticate, authController.updateProfile);

// Account routes
router.get('/accounts', authenticate, accountController.getAllAccounts);
router.get('/accounts/:id', authenticate, accountController.getAccountById);
router.post('/accounts', authenticate, accountController.createAccount);
router.put('/accounts/:id', authenticate, accountController.updateAccount);
router.delete('/accounts/:id', authenticate, accountController.deleteAccount);
router.get('/accounts/:id/balance', authenticate, accountController.getAccountBalance);
router.post('/accounts/:id/sync', authenticate, accountController.syncAccount);

// Connection routes
router.get('/connections', authenticate, connectionController.getAllConnections);
router.get('/connections/:id', authenticate, connectionController.getConnectionById);
router.post('/connections', authenticate, connectionController.createConnection);
router.put('/connections/:id', authenticate, connectionController.updateConnection);
router.delete('/connections/:id', authenticate, connectionController.deleteConnection);
router.get('/connections/:provider/auth', authenticate, connectionController.authProvider);
router.get('/connections/:provider/callback', connectionController.providerCallback);
router.post('/connections/:id/sync', authenticate, connectionController.syncConnection);

// Transaction routes
router.get('/transactions', authenticate, transactionController.getAllTransactions);
router.get('/transactions/:id', authenticate, transactionController.getTransactionById);
router.post('/transactions', authenticate, transactionController.createTransaction);
router.put('/transactions/:id', authenticate, transactionController.updateTransaction);
router.delete('/transactions/:id', authenticate, transactionController.deleteTransaction);
router.post('/transactions/import', authenticate, transactionController.importTransactions);
router.post('/transactions/categorize', authenticate, transactionController.categorizeTransactions);
router.get('/transactions/recurring', authenticate, transactionController.getRecurringTransactions);

// Category routes
router.get('/categories', authenticate, categoryController.getAllCategories);
router.get('/categories/:id', authenticate, categoryController.getCategoryById);
router.post('/categories', authenticate, categoryController.createCategory);
router.put('/categories/:id', authenticate, categoryController.updateCategory);
router.delete('/categories/:id', authenticate, categoryController.deleteCategory);
router.get('/categories/default', categoryController.getDefaultCategories);

// Asset routes
router.get('/assets', authenticate, assetController.getAllAssets);
router.get('/assets/:id', authenticate, assetController.getAssetById);
router.post('/assets', authenticate, assetController.createAsset);
router.put('/assets/:id', authenticate, assetController.updateAsset);
router.delete('/assets/:id', authenticate, assetController.deleteAsset);
router.get('/assets/performance', authenticate, assetController.getAssetPerformance);
router.get('/assets/allocation', authenticate, assetController.getAssetAllocation);

// Liability routes
router.get('/liabilities', authenticate, liabilityController.getAllLiabilities);
router.get('/liabilities/:id', authenticate, liabilityController.getLiabilityById);
router.post('/liabilities', authenticate, liabilityController.createLiability);
router.put('/liabilities/:id', authenticate, liabilityController.updateLiability);
router.delete('/liabilities/:id', authenticate, liabilityController.deleteLiability);
router.get('/liabilities/summary', authenticate, liabilityController.getLiabilitySummary);

// Goal routes
router.get('/goals', authenticate, goalController.getAllGoals);
router.get('/goals/:id', authenticate, goalController.getGoalById);
router.post('/goals', authenticate, goalController.createGoal);
router.put('/goals/:id', authenticate, goalController.updateGoal);
router.delete('/goals/:id', authenticate, goalController.deleteGoal);
router.put('/goals/:id/progress', authenticate, goalController.updateGoalProgress);
router.get('/goals/recommendations', authenticate, goalController.getGoalRecommendations);

// Budget routes
router.get('/budgets', authenticate, budgetController.getAllBudgets);
router.get('/budgets/:id', authenticate, budgetController.getBudgetById);
router.post('/budgets', authenticate, budgetController.createBudget);
router.put('/budgets/:id', authenticate, budgetController.updateBudget);
router.delete('/budgets/:id', authenticate, budgetController.deleteBudget);
router.get('/budgets/performance', authenticate, budgetController.getBudgetPerformance);
router.get('/budgets/recommendations', authenticate, budgetController.getBudgetRecommendations);

// KPI routes
router.get('/kpis', authenticate, kpiController.getAllKPIs);
router.get('/kpis/net-worth', authenticate, kpiController.getNetWorth);
router.get('/kpis/savings-rate', authenticate, kpiController.getSavingsRate);
router.get('/kpis/fi-index', authenticate, kpiController.getFinancialIndependenceIndex);
router.get('/kpis/freedom-number', authenticate, kpiController.getFinancialFreedomNumber);
router.get('/kpis/health-score', authenticate, kpiController.getFinancialHealthScore);

// Report routes
router.get('/reports', authenticate, reportController.getAllReports);
router.get('/reports/:id', authenticate, reportController.getReportById);
router.post('/reports', authenticate, reportController.createReport);
router.put('/reports/:id', authenticate, reportController.updateReport);
router.delete('/reports/:id', authenticate, reportController.deleteReport);
router.post('/reports/generate', authenticate, reportController.generateReport);
router.get('/reports/export/:id', authenticate, reportController.exportReport);

// Dashboard routes
router.get('/dashboard', authenticate, dashboardController.getDashboardData);
router.get('/dashboard/summary', authenticate, dashboardController.getFinancialSummary);
router.get('/dashboard/cash-flow', authenticate, dashboardController.getCashFlowData);
router.get('/dashboard/expense-breakdown', authenticate, dashboardController.getExpenseBreakdown);

// Notification routes
router.get('/notifications', authenticate, notificationController.getAllNotifications);
router.get('/notifications/:id', authenticate, notificationController.getNotificationById);
router.post('/notifications', authenticate, notificationController.createNotification);
router.put('/notifications/:id', authenticate, notificationController.updateNotification);
router.delete('/notifications/:id', authenticate, notificationController.deleteNotification);
router.put('/notifications/read', authenticate, notificationController.markNotificationsAsRead);

module.exports = router;
