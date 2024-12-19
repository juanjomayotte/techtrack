// controllers/mantenimientoController.js
const { Mantenimiento } = require('../models');
const { validationResult, check } = require('express-validator');

// Define validation rules
exports.createValidationRules = [
  check('dispositivoAsociadoMantenimientoId').optional().isNumeric().withMessage('El ID del dispositivo debe ser numérico'),
  check('softwareAsociadoMantenimientoId').optional().isNumeric().withMessage('El ID del software debe ser numérico'),
  check('descripcionMantenimiento').optional(),
  check('situacionMantenimiento').isIn(['Pendiente', 'En Progreso', 'Finalizado']).withMessage('Situación de mantenimiento inválida'),
  check('prioridadMantenimiento').isIn(['Baja', 'Media', 'Alta']).withMessage('Prioridad de mantenimiento inválida'),
  check('observacionesMantenimiento').optional(),
  check('mantenimientoCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

exports.updateValidationRules = [
  check('dispositivoAsociadoMantenimientoId').optional().isNumeric().withMessage('El ID del dispositivo debe ser numérico'),
  check('softwareAsociadoMantenimientoId').optional().isNumeric().withMessage('El ID del software debe ser numérico'),
  check('descripcionMantenimiento').optional(),
  check('situacionMantenimiento').isIn(['Pendiente', 'En Progreso', 'Finalizado']).withMessage('Situación de mantenimiento inválida'),
  check('prioridadMantenimiento').isIn(['Baja', 'Media', 'Alta']).withMessage('Prioridad de mantenimiento inválida'),
  check('observacionesMantenimiento').optional(),
  check('mantenimientoCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

// Crear un mantenimiento
exports.create = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
  }

  try {
      const newMantenimiento = await Mantenimiento.create(req.body);
      res.status(201).json(newMantenimiento);
  } catch (err) {
      console.error('Error creating Mantenimiento:', err);
      res.status(500).json({ message: 'Error al crear el mantenimiento', error: err.message });
  }
};

// Obtener todos los mantenimientos
exports.getAll = async (req, res) => {
  try {
    const mantenimientos = await Mantenimiento.findAll();
    res.status(200).json(mantenimientos);
  } catch (err) {
    res.status(500).json({ message: 'Error obteniendo los mantenimientos', error: err });
  }
};

// Obtener un mantenimiento por ID
exports.getById = async (req, res) => {
  try {
    const mantenimiento = await Mantenimiento.findByPk(req.params.id);
    if (!mantenimiento) {
      return res.status(404).json({ message: 'Mantenimiento no encontrado' });
    }
    res.status(200).json(mantenimiento);
  } catch (err) {
    res.status(500).json({ message: 'Error obteniendo el mantenimiento', error: err });
  }
};

// Actualizar un mantenimiento
exports.update = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
  }
  try {
      const [updatedRowsCount, updatedMantenimiento] = await Mantenimiento.update(req.body, {
          where: { idMantenimiento: req.params.id },
          returning: true
      });

      if (updatedRowsCount === 0) {
          return res.status(404).json({ message: 'Mantenimiento no encontrado' });
      }
      res.status(200).json(updatedMantenimiento[0]);

  } catch (err) {
      console.error('Error updating Mantenimiento:', err);
      res.status(500).json({ message: 'Error actualizando el mantenimiento', error: err.message });
  }
};


// Eliminar un mantenimiento
exports.delete = async (req, res) => {
  try {
    const mantenimiento = await Mantenimiento.destroy({
      where: { idMantenimiento: req.params.id },
    });
    if (!mantenimiento) {
      return res.status(404).json({ message: 'Mantenimiento no encontrado' });
    }
    res.status(200).json({ message: 'Mantenimiento eliminado correctamente' });
  } catch (err) {
    res.status(500).json({ message: 'Error eliminando el mantenimiento', error: err });
  }
};
