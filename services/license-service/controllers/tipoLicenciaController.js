// controllers/tipoLicenciaController.js
const { TipoLicencia } = require('../models');
const { validationResult, check } = require('express-validator');

// Reglas de validación
exports.createValidationRules = [
    check('nombreTipoLicencia').notEmpty().withMessage('El nombre del tipo de licencia es obligatorio.'),
    check('descripcionTipoLicencia').notEmpty().withMessage('La descripción del tipo de licencia es obligatoria.'),
    check('tipoLicenciaCreadaPor').isInt().withMessage('El ID del creador debe ser un número entero.'),
];

exports.updateValidationRules = [
    check('nombreTipoLicencia').optional().notEmpty().withMessage('El nombre del tipo de licencia no puede estar vacío.'),
    check('descripcionTipoLicencia').optional().notEmpty().withMessage('La descripción del tipo de licencia no puede estar vacía.'),
];

// Obtener todos los tipos de licencia
exports.getAll = async (req, res) => {
    try {
        const tiposLicencia = await TipoLicencia.findAll();
        res.json(tiposLicencia);
    } catch (error) {
        console.error('Error al obtener tipos de licencia:', error);
        res.status(500).json({ message: 'Error al obtener tipos de licencia', error: error.message });
    }
};

// Obtener un tipo de licencia por ID
exports.getById = async (req, res) => {
    try {
        const tipoLicencia = await TipoLicencia.findByPk(req.params.id);
        if (!tipoLicencia) {
            return res.status(404).json({ message: 'Tipo de licencia no encontrado' });
        }
        res.json(tipoLicencia);
    } catch (error) {
        console.error('Error al obtener tipo de licencia:', error);
        res.status(500).json({ message: 'Error al obtener tipo de licencia', error: error.message });
    }
};

// Crear un tipo de licencia
exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const newTipoLicencia = await TipoLicencia.create(req.body);
       res.status(201).json({tipoLicencia: newTipoLicencia}); // Changed to nest the object
    } catch (error) {
        console.error('Error al crear tipo de licencia:', error);
        res.status(500).json({ message: 'Error al crear tipo de licencia', error: error.message });
    }
};

// Actualizar un tipo de licencia
exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const tipoLicencia = await TipoLicencia.findByPk(req.params.id);
        if (!tipoLicencia) {
            return res.status(404).json({ message: 'Tipo de licencia no encontrado' });
        }
        await tipoLicencia.update(req.body);
        res.json({ message: 'Tipo de licencia actualizado correctamente', tipoLicencia });
    } catch (error) {
        console.error('Error al actualizar el tipo de licencia:', error);
        res.status(500).json({ message: 'Error al actualizar el tipo de licencia', error: error.message });
    }
};

// Eliminar un tipo de licencia
exports.delete = async (req, res) => {
    try {
        const tipoLicencia = await TipoLicencia.findByPk(req.params.id);
        if (!tipoLicencia) {
            return res.status(404).json({ message: 'Tipo de licencia no encontrado' });
        }

        await tipoLicencia.destroy();
        res.json({ message: 'Tipo de licencia eliminado correctamente' });
    } catch (error) {
        console.error('Error al eliminar tipo de licencia:', error);
        res.status(500).json({ message: 'Error al eliminar tipo de licencia', error: error.message });
    }
};