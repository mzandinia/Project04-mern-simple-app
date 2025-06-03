import mongoose from "mongoose";

const DBUsername = process.env.docdb_master_username;
const DBPassword = process.env.docdb_master_password;
const DBHost = process.env.docdb_host;
const DBPort = process.env.docdb_port;

const DB_URI = `mongodb://${DBUsername}:${DBPassword}@${DBHost}:${DBPort}/trivia?tls=true&tlsCAFile=global-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false`;

console.log(`DB_URI: ${DB_URI}`);

export const connectDB = async () => {
  try {
    const conn = await mongoose.connect(DB_URI);
    console.log(`Connected to DocumentDB: ${conn.connection.host}`);
  } catch (error) {
    console.error(`Can't connect to DB: ${error.message}`);
    process.exit(1);
  }
};
