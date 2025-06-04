import express from "express";
import cors from "cors";
import { connectDB } from "./config/db.js";

import productRoutes from "./routes/product.route.js";

const port = process.env.PORT ? parseInt(process.env.PORT, 10) : 3000;

const app = express();

const allowedOrigins = [process.env.CORS_ORIGIN || "http://localhost:5173"];

app.use(
  cors({
    origin: function (origin, callback) {
      // allow requests with no origin like mobile apps or curl requests
      if (!origin) return callback(null, true);
      if (allowedOrigins.indexOf(origin) === -1) {
        const msg =
          "The CORS policy for this site does not allow access from the specified Origin.";
        return callback(new Error(msg), false);
      }
      return callback(null, true);
    },
  })
);

app.use(express.json());

app.use("/api/products", productRoutes);

app.listen(port, () => {
  connectDB();
  console.log(`Server is running on port ${port}`);
});
