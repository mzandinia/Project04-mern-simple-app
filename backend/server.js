import express from "express";
import mongoose from "mongoose";
import { connectDB } from "./config/db.js";
import Product from "./models/products.model.js";

const port = process.env.PORT ? parseInt(process.env.PORT, 10) : 3000;

const app = express();

// Add CORS headers
app.use((req, res, next) => {
  res.setHeader("Access-Control-Allow-Origin", "*");
  res.setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
  res.setHeader("Access-Control-Allow-Headers", "Content-Type");
  next();
});

app.use(express.json());

// Health check endpoint for App Runner
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "healthy",
    timestamp: new Date().toISOString(),
    database:
      mongoose.connection.readyState === 1 ? "connected" : "disconnected",
  });
});

// Add root endpoint to verify server is running
app.get("/", (req, res) => {
  res.json({ message: "Welcome to the MERN Simple App API" });
});

app.post("/api/products", async (req, res) => {
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
});

app.listen(port, () => {
  connectDB();
  console.log(`Server is running on port ${port}`);
});
