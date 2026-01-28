const express = require("express");
const mysql = require("mysql2");

const app = express();
app.use(express.json());

const dbConfig = {
  host: "terraform-2026012416564551480000000e.cx6y6kussqol.ap-south-1.rds.amazonaws.com",
  user: "root",
  password: "sayaliparhar",
  database: "Voting",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

const pool = mysql.createPool(dbConfig);

// Health Check Endpoint for K8s and Docker
app.get("/health", (req, res) => {
  res.status(200).json({ status: "UP" });
});

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

app.get("/votes", (req, res) => {
  pool.query("SELECT optionA, optionB FROM votes WHERE id = 1", (err, result) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(result[0] || { optionA: 0, optionB: 0 });
  });
});

app.post("/vote", (req, res) => {
  const { option } = req.body;
  const query = `UPDATE votes SET ${option} = ${option} + 1 WHERE id = 1`;
  pool.query(query, (err) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json({ message: "Vote recorded" });
  });
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Backend running on port ${PORT}`);
});