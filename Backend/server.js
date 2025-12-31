const express = require("express");
const mysql = require("mysql2");

const app = express();
app.use(express.json());

/* =========================
   1. DATABASE CONFIGURATION
========================= */
const dbConfig = {
  host: "mysql",      // Container name in the docker network
  user: "root",
  password: "root",
  database: "Voting",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

// Create the connection pool
const pool = mysql.createPool(dbConfig);

/* =========================
   2. DB INITIALIZATION LOGIC
========================= */
// This creates the table and the row with ID 1 if they don't exist
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

// Function to keep trying connection until MySQL is ready
function connectAndInit() {
  pool.getConnection((err, connection) => {
    if (err) {
      console.error("⏳ MySQL not ready yet. Retrying in 5 seconds...");
      setTimeout(connectAndInit, 5000);
    } else {
      console.log("🚀 Connected to MySQL successfully!");
      connection.release();
      initDb(); // Setup table and rows
    }
  });
}

connectAndInit();

/* =========================
   3. API ROUTES
========================= */

// GET: Current vote counts
app.get("/votes", (req, res) => {
  pool.query("SELECT optionA, optionB FROM votes WHERE id = 1", (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(result[0] || { optionA: 0, optionB: 0 });
  });
});

// POST: Cast a vote
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

// GET: Determine the winner
app.get("/winner", (req, res) => {
  pool.query("SELECT optionA, optionB FROM votes WHERE id = 1", (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    
    const votes = result[0];
    let winner = "Tie";
    if (votes.optionA > votes.optionB) winner = "Option A";
    if (votes.optionB > votes.optionA) winner = "Option B";

    res.json({ winner });
  });
});

/* =========================
   4. START SERVER
========================= */
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Backend server is running on port ${PORT}`);
});