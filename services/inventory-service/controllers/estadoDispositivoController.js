// controllers/estadoDispositivoController.js
const { EstadoDispositivo } = require("../models");
const { validationResult, check } = require("express-validator");

// Define validation rules for creation (optional, but recommended)
//Export the validation rules
exports.createValidationRules = [
  check("nombreEstadoDispositivo")
    .notEmpty()
    .withMessage("El nombre del estado es obligatorio"),
  check("descripcionEstadoDispositivo").optional(), // Optional field
  check("estadoDispositivoCreadoPorId")
    .isNumeric()
    .withMessage("El ID de usuario debe ser numérico"),
];
exports.updateValidationRules = [
  check("nombreEstadoDispositivo")
    .notEmpty()
    .withMessage("El nombre del estado es obligatorio"),
  check("descripcionEstadoDispositivo").optional(),
  check("estadoDispositivoCreadoPorId")
    .isNumeric()
    .withMessage("El ID de usuario debe ser numérico"),
];

// Define your controller methods (now with the correct names and optional validation)
exports.getAll = async (req, res) => {
  try {
    const estados = await EstadoDispositivo.findAll();
    res.json(estados); // Send JSON response
  } catch (err) {
    console.error("Error al obtener estados de dispositivos:", err);
    res.status(500).json({ error: "Error del servidor" });
  }
};

// Controller method for getting an EstadoDispositivo by ID
exports.getById = async (req, res) => {
  // Updated method name to match route
  try {
    const estado = await EstadoDispositivo.findByPk(req.params.id);
    if (!estado) {
      return res
        .status(404)
        .json({ message: "Estado de dispositivo no encontrado" });
    }
    res.status(200).json(estado);
  } catch (err) {
    res
      .status(500)
      .json({
        message: "Error obteniendo el estado de dispositivo",
        error: err,
      });
  }
};

exports.create = [
  exports.createValidationRules, // Use the exported validation rules
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() }); // Send validation errors
    }

    try {
      const newEstado = await EstadoDispositivo.create(req.body);
      res.status(201).json(newEstado); // 201 Created
    } catch (err) {
      console.error("Error creating EstadoDispositivo:", err);
      res.status(500).json({
        message: "Error al crear el estado de dispositivo",
        error: err.message,
      });
    }
  },
];

// Actualizar un estado de dispositivo
exports.update = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const [updatedRowsCount, updatedEstadoDispositivo] =
      await EstadoDispositivo.update(req.body, {
        where: { idEstadoDispositivo: req.params.id },
        returning: true,
      });

    if (updatedRowsCount === 0) {
      return res
        .status(404)
        .json({ message: "Estado de dispositivo no encontrado" });
    }
    res.status(200).json(updatedEstadoDispositivo[0]);
  } catch (err) {
    console.error("Error al actualizar el estado de dispositivo", err);
    res
      .status(500)
      .json({
        message: "Error actualizando el estado de dispositivo",
        error: err.message,
      });
  }
};

exports.delete = async (req, res) => {
  // Renamed for consistency
  try {
    const deletedRowCount = await EstadoDispositivo.destroy({
      where: { idEstadoDispositivo: req.params.id },
    });

    if (deletedRowCount === 0) {
      return res
        .status(404)
        .json({ message: "Estado de dispositivo no encontrado" });
    }
    res.json({ message: "Estado de dispositivo eliminado correctamente" });
  } catch (err) {
    console.error("Error deleting EstadoDispositivo:", err);
    res
      .status(500)
      .json({
        message: "Error eliminando el estado de dispositivo",
        error: err.message,
      });
  }
};
