const AuthService = require('../services/authService')
const { ValidateRegister, ValidateEmail } = require('../validators/authValidator')
const TokenService = require('../services/tokenService')
const VerificationService = require('../services/verificationService');

const nodemailer = require('nodemailer')

const transporter = nodemailer.createTransport({
  host: 'smtp.mail.ru',
  port: 587,
  secure: false,
  auth: { 
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASSWORD
   }
})

exports.saveVerificationData = async (req, res) => {
  
  try {
    const { email, password } = req.body;

    const validation = ValidateRegister({ email, password });
    if (!validation.isValid) {
        return res.status(400).json({
            error: validation.errors.email || validation.errors.password
        });
    }
    
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString()

    await AuthService.saveForVerification(email, password, verificationCode);
    

    const MagicPayLoad = { email, action: 'register', timestamp: Date.now() };
    const magicToken = TokenService.generateVerificationToken(MagicPayLoad);
    
    const verificationUrl = `http://localhost:3001/api/auth/verify?token=${magicToken}`;

    const mailOptions = {
      from: '"GameStation" <renbl231@mail.ru>',
      to: email,
      subject: 'Подтвердите регистрацию',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2>Добро пожаловать в GameStation</h2>
            <p>Для завершения регистрации подтвердите ваш email:</p>
            
            <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0;">
                <span style="font-weight: bold; font-size: 24px; color: #007bff;">
                    ${verificationCode}
                </span>
            </div>
            
            <a href="${verificationUrl}" 
                style="background: #007bff; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
                Подтвердить email
            </a>
            
            <p style="margin-top: 20px;"><small>
                Ссылка действует 1 час. Игнорируйте это письмо, если вы не регистрировались.
            </small></p>
            
            <hr style="margin: 30px 0;">
            <p style="color: #666;">С наилучшими пожеланиями,<br>
            Команда GameStation</p>
        </div>
      `
    };

    await transporter.sendMail(mailOptions)

    return res.json({ 
      success: true
    });
    
  } catch (error) {
    console.error('ERROR:', error.message);
    if (error.message === 'EMAIL_EXISTS') {
      return res.status(400).json({ error: 'Email уже занят' });
    }
    return res.status(500).json({ error: error.message });
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

      return res.json({
        success: true,
        user: { id: user.id, email: decoded.email }
      })
    } catch (error) {
      console.error('VerifyLink ERROR:', error.message);

      return res.status(400).json({ error: 'Ссылка недействительна или истекла' });
    }
}

exports.handleVerificationLink = async (req, res) => {
  try {
    const { token } = req.query;
    console.log('🔍 VERIFY TOKEN:', token);

    if (!token) {
      return res.status(400).send('Отсутствует токен в ссылке');
    }
    
    const decoded = TokenService.verifyToken(token);
    
    if (decoded.action !== 'register') {
      return res.status(400).send('Неверная ссылка');
    }

    const user = await AuthService.completeRegistration(decoded.email, null);

    const loginToken = TokenService.generateToken({ id: user.id });
    res.cookie('token', loginToken, TokenService.getCookieOptions());

    res.redirect('http://localhost:3000/')
    
  } catch (error) {
    console.error('Verify ERROR:', error.message);
    return res.status(400).send('Ссылка недействительна или истекла');
  }
};

exports.verifyCode = async (req, res) => {
  try {
    const { code } = req.body;

    const email = VerificationService.getEmailByCode(code);

    if (!email) {
      return res.status(400).json({ 
        error: 'Неверный код подтверждения' 
      });
    }

    const user = await AuthService.completeRegistration(email, null);

    const loginToken = TokenService.generateToken({ id: user.id });
    res.cookie('token', loginToken, TokenService.getCookieOptions());
    
    return res.json({ 
      success: true
    });
    
  } catch(error) {
    console.error('🚨 VERIFY ERROR:', error.message);
    return res.status(400).json({ 
      error: 'Код недействителен' 
    });
  }
};


exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body

    const validation = ValidateRegister({ email, password })

    if(!validation.isValid) {
      return res.status(400).json({
        error: validation.errors.email || validation.errors.password
      })
    }

    const user = await AuthService.login(email, password)

    if(!user) {
      return res.status(400).json({
        error: 'Неверный email или пароль'
      })
    }

    const token = TokenService.generateToken({ 
      id: user.id,
      role: user.role
    });

    res.cookie('token', token, TokenService.getCookieOptions())

    return res.json({
      success: true
    })
  } 
  catch (error) {
    
    return res.status(500).json({
      error: "Ошибка сервера"
    })
  }
}

exports.logoutUser = async (req, res) => {
  try {
    res.clearCookie('token', TokenService.getCookieOptions())
  
    return res.json({
      success: true
    })
  } catch (error) {
    return res.status(500).json({
      error: 'Ошибка Сервера'
    })
  }
}


exports.getCurrentUser = async (req, res) => {
  console.log('👤 req.user:', req.user);
  
  try {
    const user = await AuthService.getUserById(req.user.id);
    
    if(!user) {
      return res.status(404).json({ success: false, error: 'Пользователь не найден' });
    }
    
    res.json({
      success: true,
      user: { 
        id: user.idUser,
        role: user.role_id
      }
    });
  } catch (error) {
    console.error('getCurrentUser ERROR:', error.message);
    return res.status(500).json({ success: false, error: 'Ошибка сервера' });
  }
};


exports.recoverPassword = async (req, res) => {
  try {
    const { email } = req.body;

    const validation = ValidateEmail({ email });
    
    if (!validation.isValid) {
        return res.status(400).json({
            error: validation.errors.email
        });
    }

    const userExists = await AuthService.checkEmailExists(email);
    
    if (!userExists) {
        return res.status(400).json({ error: 'Email не найден' });
    }

    const length = Math.floor(Math.random() * 5) + 6; // 6-10
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz123456789';
    let newPassword = '';
    for (let i = 0; i < length; i++) {
        newPassword += chars.charAt(Math.floor(Math.random() * chars.length));
    }

    await AuthService.updatePassword(email, newPassword);

    const mailOptions = {
        from: '"GameStation" <renbl231@mail.ru>',
        to: email,
        subject: 'Новый пароль для GameStation',
        html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2>Восстановление пароля</h2>
                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; text-align: center;">
                    <span style="font-weight: bold; font-size: 24px; color: #007bff;">
                        ${newPassword}
                    </span>
                </div>
                <p><strong>Ваш новый пароль для входа</strong></p>
                <a href="http://localhost:3001" 
                    style="background: #007bff; color: white; padding: 15px 30px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block;">
                    Войти в GameStation
                </a>
                <p style="margin-top: 20px; color: #666;"><small>Рекомендуем сменить пароль после входа</small></p>
                <hr style="margin: 30px 0;">
                <p>Команда GameStation</p>
            </div>
        `
    };

    await transporter.sendMail(mailOptions);

    return res.json({ 
        success: true
    });


  } catch (error) {
    res.status(500).json({ error: 'Ошибка сервера' });
  }
};
