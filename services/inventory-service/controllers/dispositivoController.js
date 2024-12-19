// controllers/dispositivoController.js
const { Dispositivo } = require("../models");
const { validationResult, check } = require("express-validator");

// Define validation rules
exports.createValidationRules = [
  check("numeroSerieDispositivo")
    .notEmpty()
    .withMessage("El número de serie es obligatorio"),
  check("ubicacionDispositivo")
    .notEmpty()
    .withMessage("La ubicación es obligatoria"),
  check("modeloDispositivoId")
    .isNumeric()
    .withMessage("Modelo de dispositivo inválido"),
  check("estadoDispositivoId")
    .isNumeric()
    .withMessage("Estado de dispositivo inválido"),
  check("softwareInstaladoId")
    .isNumeric()
    .withMessage("Software instalado inválido"),
    check("usuarioAsignadoId")
    .optional({ checkFalsy: true }) // Permite que el campo sea opcional
    .isNumeric()
    .withMessage("Usuario asignado inválido"),
  check("dispositivoCreadoPorId")
    .isNumeric()
    .withMessage("Creado por inválido"),
];

exports.updateValidationRules = [
  check("numeroSerieDispositivo")
    .notEmpty()
    .withMessage("El número de serie es obligatorio"),
  check("ubicacionDispositivo")
    .notEmpty()
    .withMessage("La ubicación es obligatoria"),
  check("modeloDispositivoId")
    .isNumeric()
    .withMessage("Modelo de dispositivo inválido"),
  check("estadoDispositivoId")
    .isNumeric()
    .withMessage("Estado de dispositivo inválido"),
  check("softwareInstaladoId")
    .isNumeric()
    .withMessage("Software instalado inválido"),
  check("usuarioAsignadoId")
    .isNumeric()
    .withMessage("Usuario asignado inválido"),
  check("dispositivoCreadoPorId")
    .isNumeric()
    .withMessage("Creado por inválido"),
];

// Crear un dispositivo
exports.create = async (req, res) => {
  const errors = validationResult(req); // Validar errores de la solicitud
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    // Asegurarse de que usuarioAsignadoId sea null si no se proporciona
    const data = {
      ...req.body,
      usuarioAsignadoId: req.body.usuarioAsignadoId || null,
    };

    const newDispositivo = await Dispositivo.create(data);
    res.status(201).json(newDispositivo); // 201 Created
  } catch (err) {
    console.error("Error al crear el dispositivo", err);
    res
      .status(500)
      .json({ message: "Error al crear el dispositivo", error: err }); // Información más detallada del error
  }
};


// Obtener todos los dispositivos
exports.getAll = async (req, res) => {
  try {
    const dispositivos = await Dispositivo.findAll();
    res.status(200).json(dispositivos);
  } catch (err) {
    res
      .status(500)
      .json({ message: "Error obteniendo los dispositivos", error: err });
  }
};

// Obtener un dispositivo por ID
exports.getById = async (req, res) => {
  try {
    const dispositivo = await Dispositivo.findByPk(req.params.id);
    if (!dispositivo) {
      return res.status(404).json({ message: "Dispositivo no encontrado" });
    }
    res.status(200).json(dispositivo);
  } catch (err) {
    res
      .status(500)
      .json({ message: "Error obteniendo el dispositivo", error: err });
  }
};

// Actualizar un dispositivo
exports.update = async (req, res) => {
  try {
    const dispositivo = await Dispositivo.update(req.body, {
      where: { idDispositivo: req.params.id },
    });
    if (!dispositivo[0]) {
      return res.status(404).json({ message: "Dispositivo no encontrado" });
    }
    res.status(200).json({ message: "Dispositivo actualizado correctamente" });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Error actualizando el dispositivo", error: err });
  }
};

// Eliminar un dispositivo
exports.delete = async (req, res) => {
  try {
    const dispositivo = await Dispositivo.destroy({
      where: { idDispositivo: req.params.id },
    });
    if (!dispositivo) {
      return res.status(404).json({ message: "Dispositivo no encontrado" });
    }
    res.status(200).json({ message: "Dispositivo eliminado correctamente" });
  } catch (err) {
    res
      .status(500)
      .json({ message: "Error eliminando el dispositivo", error: err });
  }
};
