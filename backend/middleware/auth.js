const jwt = require('jsonwebtoken');

const auth = (req, res, next) => {
  console.log('TOKEN:', req.cookies?.token ? 'найден' : 'НЕТ');
  
  try {
    const token = req.cookies?.token;
    
    if (!token) {
      console.log('NO TOKEN');
      return res.status(401).json({ error: 'Нет доступа' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    console.log('DECODED:', decoded);
    
    req.user = decoded;
    console.log('req.user SET:', req.user);
    
    next();
  } catch (error) {
    console.error('AUTH ERROR:', error.message);
    res.status(401).json({ error: 'Неверный токен' });
  }
};

module.exports = auth;
