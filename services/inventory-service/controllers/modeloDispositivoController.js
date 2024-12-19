// controllers/modeloDispositivoController.js
const { ModeloDispositivo } = require('../models');
const { validationResult, check } = require('express-validator');

exports.createValidationRules = [
  check("nombreModeloDispositivo")
    .notEmpty()
    .withMessage("El nombre del modelo es obligatorio"),
  check("marca").notEmpty().withMessage("La marca es obligatoria"),
  check("descripcionModeloDispositivo").optional(), // Optional field
  check("cantidadEnInventario")
    .isNumeric()
    .withMessage("La cantidad en inventario debe ser numérica"),
  check("tipoDispositivoId")
    .isNumeric()
    .withMessage("El ID de tipo de dispositivo debe ser numérico"),
  check("modeloDispositivoCreadoPorId")
    .isNumeric()
    .withMessage("El ID de usuario debe ser numérico"),
];
exports.updateValidationRules = [
  check('nombreModeloDispositivo').notEmpty().withMessage('El nombre del modelo es obligatorio'),
  check('marca').notEmpty().withMessage('La marca es obligatoria'),
  check('descripcionModeloDispositivo').optional(), // Optional field
  check('cantidadEnInventario').isNumeric().withMessage('La cantidad en inventario debe ser numérica'),
  check('tipoDispositivoId').isNumeric().withMessage('El ID de tipo de dispositivo debe ser numérico'),
  check('modeloDispositivoCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];



exports.create = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
  }
  try {
      const newModeloDispositivo = await ModeloDispositivo.create(req.body);
      res.status(201).json(newModeloDispositivo);
  } catch (err) {
      console.error('Error al crear modelo de dispositivo:', err);
      res.status(500).json({ message: 'Error creando el modelo de dispositivo', error: err.message });
  }
};

// Obtener todos los modelos de dispositivos
exports.getAll = async (req, res) => {
  try {
    const modelos = await ModeloDispositivo.findAll();
    res.status(200).json(modelos);
  } catch (err) {
    res.status(500).json({ message: 'Error obteniendo los modelos de dispositivos', error: err });
  }
};

// Obtener un modelo de dispositivo por ID
exports.getById = async (req, res) => {
  try {
    const modelo = await ModeloDispositivo.findByPk(req.params.id);
    if (!modelo) {
      return res.status(404).json({ message: 'Modelo de dispositivo no encontrado' });
    }
    res.status(200).json(modelo);
  } catch (err) {
    res.status(500).json({ message: 'Error obteniendo el modelo de dispositivo', error: err });
  }
};

// Actualizar un modelo de dispositivo
exports.update = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
  }
  try {
      const [updatedRowsCount, updatedModeloDispositivo] = await ModeloDispositivo.update(req.body, {
          where: { idModeloDispositivo: req.params.id },
          returning: true
      });

      if (updatedRowsCount === 0) {
          return res.status(404).json({ message: 'Modelo de dispositivo no encontrado' });
      }
      res.json(updatedModeloDispositivo[0]);

  } catch (err) {
      console.error('Error al actualizar modelo de dispositivo:', err);
      res.status(500).json({ message: 'Error actualizando el modelo de dispositivo', error: err.message });
  }
};

// Eliminar un modelo de dispositivo
exports.delete = async (req, res) => {
  try {
    const modelo = await ModeloDispositivo.destroy({
      where: { idModeloDispositivo: req.params.id },
    });
    if (!modelo) {
      return res.status(404).json({ message: 'Modelo de dispositivo no encontrado' });
    }
    res.status(200).json({ message: 'Modelo de dispositivo eliminado correctamente' });
  } catch (err) {
    res.status(500).json({ message: 'Error eliminando el modelo de dispositivo', error: err });
  }
};
