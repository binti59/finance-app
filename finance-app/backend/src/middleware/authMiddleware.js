const jwt = require('jsonwebtoken');
const { User } = require('../models');
const { AuthenticationError } = require('../utils/errors');

/**
 * Middleware to authenticate user using JWT token
 */
exports.authenticate = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw new AuthenticationError('No token provided');
    }

    const token = authHeader.split(' ')[1];

    // Verify token
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      throw new AuthenticationError('Invalid or expired token');
    }

    // Check if user exists
    const user = await User.findByPk(decoded.id);
    if (!user) {
      throw new AuthenticationError('User not found');
    }

    // Add user to request object
    req.user = {
      id: user.id,
      email: user.email
    };

    next();
  } catch (error) {
    next(error);
  }
};
