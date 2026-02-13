const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const db = require('../config/db');

exports.register = async (req, res) => {
  try {
    const { email, password } = req.body;

    const [existing] = await db.execute(
      'SELECT idUser FROM Users WHERE email = ?', [email]
    );

    if (existing.length > 0) {
      return res.status(400).json({ error: 'Email уже занят' });
    }

    const hashedPassword = await bcrypt.hash(password, 12);

    const [result] = await db.execute(
      'INSERT INTO Users (email, password) VALUES (?, ?)',
      [email, hashedPassword]
    );

    const token = jwt.sign({ id: result.insertId }, process.env.JWT_SECRET, { expiresIn: '7d' });

    res.cookie('token', token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 7 * 24 * 60 * 60 * 1000
    });
    
    res.status(201).json({ 
      success: true, 
      user: { id: result.insertId },
      token: token 
    }); 

  } catch (error) {
    res.status(500).json({ error: 'Ошибка сервера' });
  }
};