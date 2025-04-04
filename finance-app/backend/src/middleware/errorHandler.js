const { AppError } = require('../utils/errors');
const logger = require('../utils/logger');

/**
 * Global error handling middleware
 */
const errorHandler = (err, req, res, next) => {
  // Log error
  logger.error(`${err.name}: ${err.message}`, { stack: err.stack });

  // Operational, trusted error: send message to client
  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      success: false,
      error: err.message
    });
  }

  // Sequelize validation error
  if (err.name === 'SequelizeValidationError' || err.name === 'SequelizeUniqueConstraintError') {
    const errors = err.errors.map(e => e.message);
    return res.status(400).json({
      success: false,
      error: 'Validation Error',
      details: errors
    });
  }

  // JWT error
  if (err.name === 'JsonWebTokenError') {
    return res.status(401).json({
      success: false,
      error: 'Invalid token. Please log in again.'
    });
  }

  // JWT expired error
  if (err.name === 'TokenExpiredError') {
    return res.status(401).json({
      success: false,
      error: 'Your token has expired. Please log in again.'
    });
  }

  // Programming or other unknown error: don't leak error details
  // Send generic message to client
  console.error('ERROR 💥', err);
  return res.status(500).json({
    success: false,
    error: 'Something went wrong'
  });
};

module.exports = errorHandler;
