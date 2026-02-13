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

app.use(express.json());
app.use(cookieParser());


const auth = require('./middleware/auth');
app.use('/api/auth', require('./routes/auth'));


app.listen(PORT, () => {
  console.log(`Server: http://localhost:${PORT}`);
});
