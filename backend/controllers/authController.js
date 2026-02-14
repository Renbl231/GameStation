const AuthService = require('../services/authService')
const { ValidateRegister } = require('../validators/authValidator')
const TokenService = require('../services/tokenService')


exports.register = async (req, res) => {
  try {
    const { email, password } = req.body;

    const validation = ValidateRegister({email, password})
    if(!validation.isValid) {
      return res.status(400).json({
        error: validation.errors.email || validation.errors.password
      })
    }

    const user = await AuthService.register(email, password)

    const token = TokenService.generateToken({id: user.id})
    res.cookie('token', token, TokenService.getCookieOptions());
      res.status(201).json({
        success: true,
        user: { id: user.id }
      })
  }

  catch (error) {
    console.error('🚨 REGISTER ERROR:', error.message);
    if (error.message === 'EMAIL_EXISTS') {
      return res.status(400).json({ error: 'Email уже занят' });
    }

    res.status(500).json({ error: 'Ошибка сервера' });
  }
}



    // валидация

    // if(!email || !password) {
    //   return res.status(400).json({ 
    //     error: 'Email и пароль обязательны' 
    //   })
    // }

    // const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
    // if(!emailRegex.test(email)) {
    //   return res.status(400).json({
    //     error: 'Некорректный Email'
    //   })
    // }

    // if(password.length < 6) {
    //   return res.status(400).json({
    //     error: 'Пароль должен содержать минимум 6 символов'
    //   })
    // }

    // const [existing] = await db.execute(
    //   'SELECT idUser FROM Users WHERE email = ?', [email]
    // );

    // if (existing.length > 0) {
    //   return res.status(400).json({ error: 'Email уже занят' });
    // }

    // const hashedPassword = await bcrypt.hash(password, 12);

    // const [result] = await db.execute(
    //   'INSERT INTO Users (email, password) VALUES (?, ?)',
    //   [email, hashedPassword]
    // );

  //   const token = jwt.sign({ id: result.insertId }, process.env.JWT_SECRET, { expiresIn: '7d' });

  //   res.cookie('token', token, {
  //     httpOnly: true,
  //     secure: process.env.NODE_ENV === 'production',
  //     sameSite: 'strict',
  //     maxAge: 7 * 24 * 60 * 60 * 1000
  //   });
    
  //   res.status(201).json({ 
  //     success: true, 
  //     user: { id: result.insertId },
  //     token: token 
  //   }); 

  // } catch (error) {
  //   res.status(500).json({ error: 'Ошибка сервера' });
  // }
