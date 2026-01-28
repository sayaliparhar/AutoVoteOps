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
app.get("/healthz", (req, res) => {
  res.status(200).send("OK");
});

app.get("/readyz", (req, res) => {
  pool.query("SELECT 1", (err) => {
    if (err) {
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
      console.log("✅ Database initialized.");
    });
  });
};

function connectAndInit() {
  pool.getConnection((err, connection) => {
    if (err) {
      console.error("⏳ MySQL not ready yet. Retrying in 5 seconds...");
      setTimeout(connectAndInit, 5000);
    } else {
      console.log("🚀 Connected to MySQL!");
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
    if (err) return res.status(500).json({ error: err.message });
    res.json(result[0] || { optionA: 0, optionB: 0 });
  });
});

app.post("/vote", (req, res) => {
  const { option } = req.body;
  if (option !== "optionA" && option !== "optionB") {
    return res.status(400).json({ error: "Invalid option" });
  }

  const query = `UPDATE votes SET ${option} = ${option} + 1 WHERE id = 1`;
  pool.query(query, (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Vote recorded successfully" });
  });
});

app.get("/winner", (req, res) => {
  pool.query("SELECT optionA, optionB FROM votes WHERE id = 1", (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    
    const votes = result[0];
    let winner = "Tie";
    if (votes && votes.optionA > votes.optionB) winner = "Option A";
    else if (votes && votes.optionB > votes.optionA) winner = "Option B";

    res.json({ winner });
  });
});

/* =========================
   5. START SERVER
========================= */
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Backend server is running on port ${PORT}`);
});