const TokenService = require('../services/tokenService');

const news_AdminRole = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    const decoded = TokenService.verifyToken(token);
    
    req.user = decoded;
    
    if (![2, 4].includes(decoded.role)) {
      return res.status(403).json({ error: 'Ошибка доступа' });
    }
    
    next();
  } catch (error) {
    return res.status(401).json({ error: error.message });
  }
};

const Moder_AdminRole = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    const decoded = TokenService.verifyToken(token);
    
    req.user = decoded;
    
    if (![3, 4].includes(decoded.role)) {
      return res.status(403).json({ error: 'Ошибка доступа' });
    }
    
    next();
  } catch (error) {
    return res.status(401).json({ error: error.message });
  }
};

const AdminRole = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    const decoded = TokenService.verifyToken(token);
    
    req.user = decoded;
    
    if (![4].includes(decoded.role)) {
      return res.status(403).json({ error: 'Ошибка доступа' });
    }
    
    next();
  } catch (error) {
    return res.status(401).json({ error: error.message });
  }
};

module.exports = { news_AdminRole, Moder_AdminRole, AdminRole };
