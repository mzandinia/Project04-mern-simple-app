import express from "express";
import mongoose from "mongoose";

import {
  createProduct,
  deleteAProduct,
  getAllProducts,
  getAProduct,
  updateAProduct,
} from "../controllers/product.controller.js";

const router = express.Router();

// Add CORS headers
router.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  next();
});

// Health check endpoint for App Runner
router.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    database:
      mongoose.connection.readyState === 1 ? "connected" : "disconnected",
  });
});

// Get all products
router.get("/", getAllProducts);

// Create a product
router.post("/", createProduct);

// Get a single product
router.get("/:id", getAProduct);

// Update a product
router.put("/:id", updateAProduct);

// Delete a product
router.delete("/:id", deleteAProduct);

export default router;
