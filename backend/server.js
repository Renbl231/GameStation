require('dotenv').config();
const PORT = process.env.PORT || 3001;

const express = require('express');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const app = express();
const db = require('./config/db');

app.use(cors({
  origin: 'http://localhost:3000',
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));


// потом убрать лог
app.use((req, res, next) => {
  console.log(`${req.method} ${req.path} ← ЛОГ РЕКВЕСТОВ!`);
  next();
});

app.use(express.json());
app.use(cookieParser());

app.use('/api/auth', require('./routes/auth'));
app.use('/api', require('./routes/game'));
app.use('/api', require('./routes/newsRouter'));




app.listen(PORT, () => {
  console.log(`Server: http://localhost:${PORT}`);
});
