const { TipoContrato } = require('../models');
const { validationResult, check } = require('express-validator');

// Reglas de validación para crear
exports.createValidationRules = [
    check("nombreTipoContrato")
        .notEmpty()
        .withMessage("El nombre del tipo de contrato es obligatorio"),
    check("descripcionTipoContrato")
        .notEmpty()
        .withMessage("La descripción es obligatoria"),
    check("tipoContratoCreadoPor")
        .isNumeric()
        .withMessage("El ID del usuario creador debe ser un número válido"),
];

// Reglas de validación para actualizar
exports.updateValidationRules = [
    check("nombreTipoContrato")
        .optional()
        .notEmpty()
        .withMessage("El nombre del tipo de contrato no puede estar vacío"),
    check("descripcionTipoContrato")
        .optional()
        .notEmpty()
        .withMessage("La descripción no puede estar vacía"),
];

// Crear un tipo de contrato
exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const newTipoContrato = await TipoContrato.create(req.body);
        res.status(201).json(newTipoContrato);
    } catch (err) {
        console.error('Error al crear tipo de contrato:', err);
        res.status(500).json({ message: 'Error al crear tipo de contrato', error: err.message });
    }
};

// Obtener todos los tipos de contrato
exports.getAll = async (req, res) => {
    try {
        const tiposContrato = await TipoContrato.findAll();
        res.json(tiposContrato);
    } catch (err) {
        console.error('Error al obtener tipos de contrato:', err);
        res.status(500).json({ message: 'Error al obtener tipos de contrato', error: err.message });
    }
};

// Obtener un tipo de contrato por ID
exports.getById = async (req, res) => {
    try {
        const tipoContrato = await TipoContrato.findByPk(req.params.id);
        if (!tipoContrato) {
            return res.status(404).json({ message: 'Tipo de contrato no encontrado' });
        }
        res.json(tipoContrato);
    } catch (err) {
        console.error('Error al obtener tipo de contrato:', err);
        res.status(500).json({ message: 'Error al obtener tipo de contrato', error: err.message });
    }
};

// Actualizar un tipo de contrato
exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const tipoContrato = await TipoContrato.findByPk(req.params.id);
        if (!tipoContrato) {
            return res.status(404).json({ message: 'Tipo de contrato no encontrado' });
        }

        await tipoContrato.update(req.body);
        res.json({ message: 'Tipo de contrato actualizado correctamente', tipoContrato });
    } catch (err) {
        console.error('Error al actualizar tipo de contrato:', err);
        res.status(500).json({ message: 'Error al actualizar tipo de contrato', error: err.message });
    }
};

// Eliminar un tipo de contrato
exports.delete = async (req, res) => {
    try {
        const tipoContrato = await TipoContrato.findByPk(req.params.id);
        if (!tipoContrato) {
            return res.status(404).json({ message: 'Tipo de contrato no encontrado' });
        }

        await tipoContrato.destroy();
        res.json({ message: 'Tipo de contrato eliminado correctamente' });
    } catch (err) {
        console.error('Error al eliminar tipo de contrato:', err);
        res.status(500).json({ message: 'Error al eliminar tipo de contrato', error: err.message });
    }
};
