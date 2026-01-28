const express = require("express");
const mysql = require("mysql2");

const app = express();
app.use(express.json());

/* =========================
   1. DATABASE CONFIGURATION
========================= */
const dbConfig = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

/* =========================
   2. HEALTH & READINESS PROBES
========================= */

// Liveness: Is the process alive?
app.get("/healthz", (req, res) => {
  res.status(200).send("OK");
});

// Readiness: Is the database connection active?
app.get("/readyz", (req, res) => {
  pool.query("SELECT 1", (err) => {
    if (err) {
      console.error("Readiness check failed:", err.message);
      return res.status(503).json({ status: "Database not ready" });
    }
    res.status(200).json({ status: "Ready" });
  });
});

/* =========================
   3. DB INITIALIZATION LOGIC
========================= */
const initDb = () => {
  const createTableQuery = `
    CREATE TABLE IF NOT EXISTS votes (
      id INT PRIMARY KEY,
      optionA INT DEFAULT 0,
      optionB INT DEFAULT 0
    );`;

  const insertInitialRowQuery = `
    INSERT INTO votes (id, optionA, optionB)
    SELECT 1, 0, 0
    WHERE NOT EXISTS (SELECT 1 FROM votes WHERE id = 1);`;

  pool.query(createTableQuery, (err) => {
    if (err) return console.error("❌ Table creation failed:", err.message);
    
    pool.query(insertInitialRowQuery, (err) => {
      if (err) return console.error("❌ Initial row insert failed:", err.message);
      console.log("✅ Database initialized: Table and Initial Row are ready.");
    });
  });
};

function connectAndInit() {
  pool.getConnection((err, connection) => {
    if (err) {
      console.error("⏳ MySQL not ready yet. Retrying in 5 seconds...");
      setTimeout(connectAndInit, 5000);
    } else {
      console.log("🚀 Connected to MySQL successfully!");
      connection.release();
      initDb();
    }
  });
}

connectAndInit();

/* =========================
   4. API ROUTES
========================= */

app.get("/votes", (req, res) => {
  pool.query("SELECT optionA, optionB FROM votes WHERE id = 1", (err, result) => {
    if (err) return res.status(5