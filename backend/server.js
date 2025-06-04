import express from "express";
import { connectDB } from "./config/db.js";

import productRoutes from "./routes/product.route.js";

const port = process.env.PORT ? parseInt(process.env.PORT, 10) : 3000;

const app = express();

app.use(express.json());

app.use("/api/products", productRoutes);

app.listen(port, () => {
  connectDB();
  console.log(`Server is running on port ${port}`);
});
