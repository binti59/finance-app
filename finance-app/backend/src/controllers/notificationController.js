const { Notification, User } = require('../models');
const { NotFoundError } = require('../utils/errors');
const { Op } = require('sequelize');

/**
 * Get all notifications for the authenticated user
 */
exports.getAllNotifications = async (req, res, next) => {
  try {
    const { read } = req.query;
    
    // Build query conditions
    const where = { user_id: req.user.id };
    
    if (read !== undefined) {
      where.read = read === 'true';
    }
    
    const notifications = await Notification.findAll({
      where,
      order: [['created_at', 'DESC']]
    });

    res.status(200).json({
      success: true,
      count: notifications.length,
      data: notifications
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get notification by ID
 */
exports.getNotificationById = async (req, res, next) => {
  try {
    const notification = await Notification.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!notification) {
      throw new NotFoundError('Notification not found');
    }

    res.status(200).json({
      success: true,
      data: notification
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new notification
 */
exports.createNotification = async (req, res, next) => {
  try {
    const { user_id, title, message, type, link, priority } = req.body;

    // Verify user exists
    const user = await User.findByPk(user_id);
    if (!user) {
      throw new NotFoundError('User not found');
    }

    const notification = await Notification.create({
      user_id,
      title,
      message,
      type: type || 'info',
      link,
      priority: priority || 'normal',
      read: false
    });

    res.status(201).json({
      success: true,
      data: notification
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Mark notification as read
 */
exports.markAsRead = async (req, res, next) => {
  try {
    const notification = await Notification.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!notification) {
      throw new NotFoundError('Notification not found');
    }

    notification.read = true;
    await notification.save();

    res.status(200).json({
      success: true,
      data: notification
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Mark all notifications as read
 */
exports.markAllAsRead = async (req, res, next) => {
  try {
    await Notification.update(
      { read: true },
      { 
        where: { 
          user_id: req.user.id,
          read: false
        } 
      }
    );

    res.status(200).json({
      success: true,
      message: 'All notifications marked as read'
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a notification
 */
exports.deleteNotification = async (req, res, next) => {
  try {
    const notification = await Notification.findOne({
      where: { 
        id: req.params.id,
        user_id: req.user.id
      }
    });

    if (!notification) {
      throw new NotFoundError('Notification not found');
    }

    await notification.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete all read notifications
 */
exports.deleteAllRead = async (req, res, next) => {
  try {
    await Notification.destroy({
      where: { 
        user_id: req.user.id,
        read: true
      }
    });

    res.status(200).json({
      success: true,
      message: 'All read notifications deleted'
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get notification count
 */
exports.getNotificationCount = async (req, res, next) => {
  try {
    const unreadCount = await Notification.count({
      where: { 
        user_id: req.user.id,
        read: false
      }
    });

    const totalCount = await Notification.count({
      where: { user_id: req.user.id }
    });

    res.status(200).json({
      success: true,
      data: {
        unread: unreadCount,
        total: totalCount
      }
    });
  } catch (error) {
    next(error);
  }
};
