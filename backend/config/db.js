import mongoose from "mongoose";

const DBUsername = process.env.DBUsername;
const DBPassword = process.env.DBPassword;
const DBHost = process.env.DBHost;
const DBPort = process.env.DBPort;

const isProduction = process.env.NODE_ENV === "production";

const DB_URI = isProduction
  ? `mongodb://${DBUsername}:${DBPassword}@${DBHost}:${DBPort}?tls=true&tlsCAFile=global-bundle.pem&retryWrites=false`
  : `mongodb://${DBUsername}:${DBPassword}@${DBHost}:${DBPort}`;

export const connectDB = async () => {
  try {
    const options = isProduction
      ? {
          authMechanism: "DEFAULT",
          tls: true,
          tlsCAFile: "global-bundle.pem",
          tlsAllowInvalidCertificates: false,
        }
      : {
          authMechanism: "DEFAULT",
        };

    const conn = await mongoose.connect(DB_URI, options);
    console.log(`Connected to DocumentDB: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Can't connect to DB: ${error.message}`);
    process.exit(1);
  }
};
