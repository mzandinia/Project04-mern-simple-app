import mongoose from "mongoose";

const DBUsername = process.env.DBUsername;
const DBPassword = process.env.DBPassword;
const DBHost = process.env.DBHost;
const DBPort = process.env.DBPort;

const DB_URI = `mongodb://${DBUsername}:${DBPassword}@${DBHost}:${DBPort}?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false`;

console.log(`DB_URI: ${DB_URI}`);

export const connectDB = async () => {
  try {
    const conn = await mongoose.connect(DB_URI, {
      authMechanism: "DEFAULT",
      tls: true,
      tlsCAFile: "global-bundle.pem",
      tlsAllowInvalidCertificates: false,
    });
    console.log(`Connected to DocumentDB: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Can't connect to DB: ${error.message}`);
    process.exit(1);
  }
};
