//userController.js

const { Usuario, Rol, Op} = require('../models');
const bcrypt = require('bcryptjs');
const { validationResult } = require('express-validator'); // Importar para validación
const jwt = require('jsonwebtoken'); 


exports.createUser = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { nombreUsuario, correoElectronicoUsuario, passwordUsuario, rolId } = req.body;

    // Verificar si el usuario ya existe (con validación más robusta)
    const existingUser = await Usuario.findOne({ where: { [Op.or]: [{ nombreUsuario }, { correoElectronicoUsuario }] } });
    if (existingUser) {
      return res.status(400).json({ message: 'El usuario o correo ya existe' });
    }

    const hashedPassword = await bcrypt.hash(passwordUsuario, 10);

    const newUser = await Usuario.create({
      nombreUsuario,
      correoElectronicoUsuario,
      passwordUsuario: hashedPassword,
      rolId,
    });
    const token = jwt.sign({ userId: newUser.idUsuario }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.status(201).json({ message: 'Usuario creado', userId: newUser.idUsuario, token: token });
  } catch (error) {
    console.error('Error creando usuario:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

exports.getUsers = async (req, res) => {
  try {
    const users = await Usuario.findAll({
      attributes: { exclude: ['passwordUsuario'] },  // Keep this to exclude the password
      include: [{ model: Rol, as: 'rol' }],       // <-- Add this line to include the role
    });
    res.json(users);
  } catch (error) {
    console.error('Error obteniendo usuarios:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};


exports.getUserById = async (req, res) => {
  try {
    const user = await Usuario.findByPk(req.params.id, {
      attributes: { exclude: ['passwordUsuario'] },
      include: [{ model: Rol, as: 'rol', attributes: ['nombreRol'] }] // Incluir el rol
    });
    if (!user) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }
    res.json(user);
  } catch (error) {
    console.error('Error obteniendo usuario:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

exports.updateUser = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const { nombreUsuario, correoElectronicoUsuario, rolId } = req.body;
    const userId = req.params.id;

    const [updatedRows] = await Usuario.update({ nombreUsuario, correoElectronicoUsuario, rolId }, { where: { idUsuario: userId }, returning: true });

    if (updatedRows === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    const updatedUser = await Usuario.findByPk(userId, { attributes: { exclude: ['passwordUsuario'] } });
    res.json(updatedUser);
  } catch (error) {
    console.error('Error actualizando usuario:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

exports.deleteUser = async (req, res) => {
  try {
    const userId = req.params.id;
    const deletedRows = await Usuario.destroy({ where: { idUsuario: userId } });

    if (deletedRows === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado' });
    }

    res.json({ message: 'Usuario eliminado exitosamente' });
  } catch (error) {
    console.error('Error eliminando usuario:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

exports.loginUser = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  try {
    const { correoElectronicoUsuario, passwordUsuario } = req.body;

    const user = await Usuario.findOne({ where: { correoElectronicoUsuario } });

    if (!user) {
      return res.status(401).json({ message: 'Usuario incorrecto' });
    }

    const passwordMatch = await bcrypt.compare(passwordUsuario, user.passwordUsuario);

    if (!passwordMatch) {
      return res.status(401).json({ message: 'Contraseña incorrecta' });
    }

    // JWT - Reemplaza con tu lógica de generación de JWT
    const jwt = require('jsonwebtoken');
    const token = jwt.sign({ userId: user.idUsuario }, process.env.JWT_SECRET, { expiresIn: '1h' });
    res.json({ token, userId: user.idUsuario });
  } catch (error) {
    console.error('Error al iniciar sesión:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};

module.exports = exports;