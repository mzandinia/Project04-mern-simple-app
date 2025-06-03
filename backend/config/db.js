import mongoose from "mongoose";

const DBUsername = process.env.docdb_master_username;
const DBPassword = process.env.docdb_master_password;
const DBHost = process.env.docdb_host;
const DBPort = process.env.docdb_port;

const DB_URI = `mongodb://${DBUsername}:${DBPassword}@${DBHost}:${DBPort}/trivia?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false`;

export const connectDB = async () => {
  try {
    const conn = await mongoose.connect(DB_URI);
    console.log(`Connected to DocumentDB: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Error: ${error.message}`);
    process.exit(1);
  }
};
