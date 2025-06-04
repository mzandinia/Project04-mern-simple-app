import Product from "../models/products.model.js";

export const getAllProducts = async (req, res) => {
  try {
    const products = await Product.find().sort({ createdAt: -1 });
    res.status(200).json({ success: true, data: products });
  } catch (error) {
    console.log(`Error in fetching products: ${error.message}`);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};

export const createProduct = async (req, res) => {
  const product = req.body; // get the product from the request body

  if (!product.name || !product.price || !product.image) {
    return res
      .status(400)
      .json({ success: false, message: "Please provide all fields" });
  }

  const newProduct = new Product(product);

  try {
    await newProduct.save();
    res.status(201).json({ success: true, data: newProduct });
  } catch (error) {
    console.log(`Error in creating product: ${error.message}`);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};

export const getAProduct = async (req, res) => {
  const id = req.params.id;
  try {
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }
    res.status(200).json({ success: true, data: product });
  } catch (error) {
    console.log(`Error in fetching product: ${error.message}`);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};

export const updateAProduct = async (req, res) => {
  const id = req.params.id;
  const updates = req.body;

  // Ensure at least one field is provided for update
  if (Object.keys(updates).length === 0) {
    return res.status(400).json({
      success: false,
      message: "Please provide at least one field to update",
    });
  }

  try {
    // First check if product exists
    const existingProduct = await Product.findById(id);
    if (!existingProduct) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }

    // If product exists, update only the provided fields
    const product = await Product.findByIdAndUpdate(
      id,
      { $set: updates },
      {
        new: true,
        runValidators: true, // This ensures the updates meet the schema requirements
      }
    );
    res.status(200).json({ success: true, data: product });
  } catch (error) {
    console.log(`Error in updating product: ${error.message}`);
    if (error.name === "ValidationError") {
      return res.status(400).json({
        success: false,
        message: "Invalid field values provided",
      });
    }
    res.status(500).json({ success: false, message: "Server Error" });
  }
};

export const deleteAProduct = async (req, res) => {
  const id = req.params.id;
  try {
    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({
        success: false,
        message: "Product not found",
      });
    }
    await Product.findByIdAndDelete(id);
    console.log(`id: ${id} deleted`);
    res
      .status(200)
      .json({ success: true, message: "Product deleted successfully" });
  } catch (error) {
    console.log(`Error in deleting product: ${error.message}`);
    res.status(500).json({ success: false, message: "Server Error" });
  }
};
