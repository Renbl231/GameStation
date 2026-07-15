const AuthService = require('../services/authService')
const TokenService = require('../services/tokenService')
const VerificationService = require('../services/verificationService');
const { ValidateRegister, ValidateEmail } = require('../validators/authValidator')

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
      subject: 'Регистрация на GameStation',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2>Добро пожаловать в GameStation</h2>
            <p>Код подтверждения:
              <span style="font-weight: bold; font-size: 20px; color: #007bff;">
                      ${verificationCode}
              </span>
            </p>
            
            <a href="${verificationUrl}" 
                style="background: #007bff; color: white; padding: 12px 32px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block; justify-content: center; align-items:center; text-align:center">
                Подтвердить регистрацию
            </a>
            
            <p style="margin-top: 20px; color: #c7c7c7">
                Подтвердите регистрацию в течение часа. Игнорируйте это письмо, если вы не регистрировались.
            </p>
            
            <p style="color: #c7c7c7;">С наилучшими пожеланиями, команда GameStation</p>
        </div>
      `
    };

    await transporter.sendMail(mailOptions)

    return res.json({ 
      success: true
    });
    
  } catch (error) {
    if (error.message === 'EMAIL_EXISTS') {
      return res.status(400).json({ error: 'Email уже занят' });
    }
    console.log('Ошибка', error)
    return res.status(500).json({
       error: error.message || 'Ошибка сервера'
    });
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

exports.handleVerificationLink = async (req, res) => { // Регистрация по ссылке
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

    // res.redirect('http://localhost:3000/')
    res.redirect('http://localhost')
    
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
  try {
    const user = await AuthService.getUserById(req.user.id);
    
    if(!user) {
      return res.status(404).json({ success: false, error: 'Пользователь не найден' });
    }
    
    res.json({
      success: true,
      user: { 
        id: user.idUser,
        nickname: user.nickname,
        role: user.role_id,
        avatar: user.avatar,
      }
    });
  } catch (error) {
    console.error('getCurrentUser ERROR:', error.message);
    return res.status(500).json({ success: false, error: 'Ошибка сервера' });
  }
};


// Сброс пароля

//  POST - отправка ссылки
exports.sendPasswordResetLink = async (req, res) => {
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

        // Создаём токен сброса
        const resetToken = await AuthService.createPasswordResetToken(email);
        const resetUrl = `http://localhost:3001/api/auth/reset-password/${resetToken}`;

        const mailOptions = {
            from: '"GameStation" <renbl231@mail.ru>',
            to: email,
            subject: 'Сброс пароля GameStation',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2>Сброс пароля</h2>
                    <p>Вы запросили сброс пароля. Перейдите по ссылке для сброса пароля:</p>
                    <a href="${resetUrl}" 
                        style="background: #007bff; color: white; padding: 12px 32px; text-decoration: none; border-radius: 5px; font-weight: bold; display: inline-block; justify-content: center; align-items:center; text-align:center">
                        Сбросить пароль
                    </a>

                    <p style="margin-top: 20px; color: #c7c7c7">
                        Ссылка действительна в течение 30 минут. Игнорируйте письмо, если вы не запрашивали сброс пароля.
                    </p>

                    <p style="color: #c7c7c7;">С наилучшими пожеланиями, команда GameStation</p>
                </div>
            `
        };

        await transporter.sendMail(mailOptions);

        return res.json({ 
            success: true,
            message: 'Ссылка для сброса пароля отправлена на email'
        });

    } catch (error) {
        return res.status(500).json({ error: 'Ошибка сервера' });
    }
};


// GET - обработка ссылки
exports.handlePasswordResetLink = async (req, res) => {
    try {
        const { token } = req.params;

        if (!token) {
            return res.status(400).send('Отсутствует токен в ссылке');
        }

        // Проверяем токен
        const email = await AuthService.verifyPasswordResetToken(token);
        if (!email) {
            return res.status(400).send('Ссылка недействительна или истекла');
        }

        const length = Math.floor(Math.random() * 5) + 6; // 6-10 символов
        const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz123456789';
        let newPassword = '';
        for (let i = 0; i < length; i++) {
            newPassword += chars.charAt(Math.floor(Math.random() * chars.length));
        }

        await AuthService.updatePassword(email, newPassword);
        await AuthService.deletePasswordResetToken(token);

        // Отправляем новый пароль пользователю
        const mailOptions = {
            from: '"GameStation" <renbl231@mail.ru>',
            to: email,
            subject: 'Новый пароль GameStation',
            html: `
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <h2>Пароль успешно сброшен</h2>

                    <p>Ваш новый пароль для входа:
                        <span style="font-weight: bold; font-size: 20px; color: #007bff;">
                            ${newPassword}
                        </span>
                    </p>
                    
                    <p style="margin-top: 20px; color: #c7c7c7">
                        Рекомендуем сменить пароль после входа
                    </p>

                    <p style="color: #c7c7c7;">С наилучшими пожеланиями, команда GameStation</p>
                </div>
            `
        };

        await transporter.sendMail(mailOptions);

        // return res.redirect('http://localhost:3000/');
        return res.redirect('http://localhost');
        
    } catch (error) {
        console.error('handlePasswordResetLink ERROR:', error);
        return res.status(400).send('Ошибка сброса пароля. Попробуйте снова.');
    }
};
