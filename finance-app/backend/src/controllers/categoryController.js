const { Category } = require('../models');
const { NotFoundError } = require('../utils/errors');

/**
 * Get all categories
 */
exports.getAllCategories = async (req, res, next) => {
  try {
    const categories = await Category.findAll({
      include: [
        { model: Category, as: 'subcategories' }
      ]
    });

    res.status(200).json({
      success: true,
      count: categories.length,
      data: categories
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get category by ID
 */
exports.getCategoryById = async (req, res, next) => {
  try {
    const category = await Category.findOne({
      where: { id: req.params.id },
      include: [
        { model: Category, as: 'subcategories' }
      ]
    });

    if (!category) {
      throw new NotFoundError('Category not found');
    }

    res.status(200).json({
      success: true,
      data: category
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Create a new category
 */
exports.createCategory = async (req, res, next) => {
  try {
    const { name, type, icon, color, parent_id } = req.body;

    // Validate parent category if provided
    if (parent_id) {
      const parentCategory = await Category.findByPk(parent_id);
      if (!parentCategory) {
        throw new NotFoundError('Parent category not found');
      }
    }

    const category = await Category.create({
      name,
      type,
      icon,
      color,
      parent_id
    });

    res.status(201).json({
      success: true,
      data: category
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Update a category
 */
exports.updateCategory = async (req, res, next) => {
  try {
    const { name, type, icon, color, parent_id } = req.body;

    const category = await Category.findByPk(req.params.id);

    if (!category) {
      throw new NotFoundError('Category not found');
    }

    // Validate parent category if provided
    if (parent_id) {
      const parentCategory = await Category.findByPk(parent_id);
      if (!parentCategory) {
        throw new NotFoundError('Parent category not found');
      }
      
      // Prevent circular references
      if (parent_id === category.id) {
        throw new ValidationError('Category cannot be its own parent');
      }
    }

    // Update category
    category.name = name || category.name;
    category.type = type || category.type;
    category.icon = icon !== undefined ? icon : category.icon;
    category.color = color || category.color;
    category.parent_id = parent_id !== undefined ? parent_id : category.parent_id;
    
    await category.save();

    res.status(200).json({
      success: true,
      data: category
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Delete a category
 */
exports.deleteCategory = async (req, res, next) => {
  try {
    const category = await Category.findByPk(req.params.id);

    if (!category) {
      throw new NotFoundError('Category not found');
    }

    // Check if category has subcategories
    const subcategories = await Category.findAll({
      where: { parent_id: category.id }
    });

    if (subcategories.length > 0) {
      // Update subcategories to have no parent
      for (const subcategory of subcategories) {
        subcategory.parent_id = null;
        await subcategory.save();
      }
    }

    await category.destroy();

    res.status(200).json({
      success: true,
      data: {}
    });
  } catch (error) {
    next(error);
  }
};

/**
 * Get default categories
 */
exports.getDefaultCategories = async (req, res, next) => {
  try {
    // Get all top-level categories (no parent)
    const categories = await Category.findAll({
      where: { parent_id: null },
      include: [
        { model: Category, as: 'subcategories' }
      ]
    });

    res.status(200).json({
      success: true,
      count: categories.length,
      data: categories
    });
  } catch (error) {
    next(error);
  }
};
