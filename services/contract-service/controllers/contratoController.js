const { Contrato, TipoContrato } = require('../models');
const { validationResult, check } = require('express-validator');

// Configuración de las URLs de los microservicios
const authServiceUrl = 'http://localhost:3001/api';
// const inventoryServiceUrl = 'http://localhost:3002/api';
// const licenseServiceUrl = 'http://localhost:3003/api';

// Función reutilizable para realizar llamadas a APIs
const makeApiRequest = async (url, options = {}) => {
    const response = await fetch(url, options);
    if (!response.ok) {
        const errorData = await response.json();
        const errorMessage = errorData.message || 'Error en la solicitud a la API';
        throw new Error(`${response.status} ${response.statusText}: ${errorMessage}`);
    }
    return response.json();
};

// Reglas de validación para crear un contrato
// Reglas de validación para crear un contrato
exports.createValidationRules = [
    check("nombreContrato")
        .notEmpty()
        .withMessage("El nombre del contrato es obligatorio"),
    check("descripcionContrato")
        .notEmpty()
        .withMessage("La descripción es obligatoria"),
    check("fechaInicio")
        .isISO8601() // Changed from isDate()
        .withMessage("La fecha de inicio debe ser una fecha válida"),
    check("fechaExpiracion")
         .isISO8601() // Changed from isDate()
        .withMessage("La fecha de fin debe ser una fecha válida"),
    check("tipoContratoId")
        .isNumeric()
        .withMessage("El tipo de contrato debe ser un número válido"),
    check("ContratoCreadoPor")
        .notEmpty()
        .withMessage("El usuario creador del contrato es obligatorio"),
     check('estadoContrato') // Added validation
        .notEmpty()
        .withMessage('El estado del contrato es obligatorio'),
];

// Reglas de validación para actualizar un contrato
exports.updateValidationRules = [
    check("nombreContrato")
        .optional()
        .notEmpty()
        .withMessage("El nombre del contrato no puede estar vacío"),
    check("descripcionContrato")
        .optional()
        .notEmpty()
        .withMessage("La descripción no puede estar vacía"),
    check("fechaInicio")
        .optional()
        .isISO8601()  // Changed from isDate()
        .withMessage("La fecha de inicio debe ser una fecha válida"),
    check("fechaExpiracion")
        .optional()
        .isISO8601()  // Changed from isDate()
        .withMessage("La fecha de fin debe ser una fecha válida"),
    check("tipoContratoId")
        .optional()
        .isNumeric()
        .withMessage("El tipo de contrato debe ser un número válido"),
];

// Crear un contrato
exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const usuario = await makeApiRequest(`${authServiceUrl}/users/${req.body.ContratoCreadoPor}`);
        const newContrato = await Contrato.create({
            ...req.body,
            tipoContratoId: req.body.tipoContratoId,
            creadoPor: usuario.id,
            EstadoContrato: req.body.estadoContrato, //explicitly add the value
        });

        res.status(201).json(newContrato);
    } catch (err) {
        console.error('Error al crear contrato:', err);
        res.status(500).json({ message: 'Error al crear contrato', error: err.message });
    }
};

// Obtener un contrato por ID con datos relacionados
exports.getById = async (req, res) => {
    try {
        const contrato = await Contrato.findByPk(req.params.id, { include: TipoContrato });
        if (!contrato) {
            return res.status(404).json({ message: 'Contrato no encontrado' });
        }

        const usuario = await makeApiRequest(`${authServiceUrl}/users/${contrato.creadoPor}`);

        res.json({
            ...contrato.toJSON(),
            tipoContrato: contrato.TipoContrato,
            creadoPor: usuario,
        });
    } catch (error) {
        console.error('Error al obtener contrato:', error);
        res.status(500).json({ message: 'Error al obtener contrato', error: error.message });
    }
};

// Get all contratos
exports.getAll = async (req, res) => {
    try {
        const contratos = await Contrato.findAll({ include: TipoContrato }); // Include TipoContrato data
        res.json(contratos);
    } catch (err) {
        console.error('Error al obtener contratos:', err);
        res.status(500).json({ message: 'Error al obtener contratos', error: err.message });
    }
};


// Delete a contrato
exports.delete = async (req, res) => {
    try {
        const contrato = await Contrato.findByPk(req.params.id);
        if (!contrato) {
            return res.status(404).json({ message: 'Contrato no encontrado' });
        }

        await contrato.destroy();
        res.json({ message: 'Contrato eliminado correctamente' });
    } catch (err) {
        console.error('Error al eliminar contrato:', err);
        res.status(500).json({ message: 'Error al eliminar contrato', error: err.message });
    }
};
// Update a contrato (replaces modificarTerminos)
exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const contrato = await Contrato.findByPk(req.params.id);
        if (!contrato) {
            return res.status(404).json({ message: 'Contrato no encontrado' });
        }

        // Update the contrato with the data provided in req.body
        await contrato.update(req.body);

        res.json({ message: 'Contrato actualizado correctamente', contrato });

    } catch (err) {
        console.error('Error al actualizar el contrato:', err);
        res.status(500).json({ message: 'Error al actualizar el contrato', error: err.message });
    }
};