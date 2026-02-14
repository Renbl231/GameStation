const AuthService = require('../services/authService')
const { ValidateRegister } = require('../validators/authValidator')
const TokenService = require('../services/tokenService')


exports.saveVerificationData = async (req, res) => {
  
  try {
    const { email, password } = req.body;
    

    await AuthService.saveForVerification(email, password);
    
    const MagicPayLoad = { email, action: 'register', timestamp: Date.now() };
    const magicToken = TokenService.generateToken(MagicPayLoad);
    
    const verificationUrl = `http://localhost:3001/api/auth/verify?token=${magicToken}`;
    
    console.log(`Email: ${email}`);
    console.log(`Ссылка: ${verificationUrl}`);
    
    res.json({ success: true, message: 'Ссылка готова!' });
    
  } catch (error) {
    console.error('ERROR:', error.message);
    if (error.message === 'EMAIL_EXISTS') {
      return res.status(400).json({ error: 'Email уже занят' });
    }
    res.status(500).json({ error: error.message });
  }
};



exports.verificationRegistationLink = async (req, res) => {
    try {
      const { token } = req.body

      const decoded = TokenService.verifyToken(token)

      if(decoded.action !== 'register') {
        return res.status(400).json({error: 'Неверная ссылка'})
      }

      const user = await AuthService.completeRegistration(decoded.email, null);  // "Registration"
      const loginToken = TokenService.generateToken({ id: user.id });
      res.cookie('token', loginToken, TokenService.getCookieOptions());

      res.json({
        success: true,
        user: { id: user.id, email: decoded.email },
        message: 'Регистрация завершена'
      })
    } catch (error) {
      console.error('VerifyLink ERROR:', error.message);
      res.status(400).json({ error: 'Ссылка недействительна или истекла' });
    }
}

exports.handleVerificationLink = async (req, res) => {
  try {
    const { token } = req.query;
    console.log('🔍 VERIFY TOKEN:', token);
    
    const decoded = TokenService.verifyToken(token);
    console.log('✅ TOKEN ДЕКОДИРОВАН:', decoded.email);
    
    if (decoded.action !== 'register') {
      return res.status(400).send('Неверная ссылка');
    }

    const user = await AuthService.completeRegistration(decoded.email, null);

    const loginToken = TokenService.generateToken({ id: user.id });
    res.cookie('token', loginToken, TokenService.getCookieOptions());
    
    res.redirect('http://localhost:3000/');
    
  } catch (error) {
    console.error('Verify ERROR:', error.message);
    res.status(400).send('Ссылка недействительна или истекла');
  }
};