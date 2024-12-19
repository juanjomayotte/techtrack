// controllers/tipoDispositivoController.js
const { TipoDispositivo } = require('../models');
const { validationResult, check } = require('express-validator');

// Define validation rules
exports.createValidationRules = [
    check('nombreTipoDispositivo').notEmpty().withMessage('El nombre del tipo de dispositivo es obligatorio'),
    check('descripcionTipoDispositivo').optional(),
    check('tipoDispositivoCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

exports.updateValidationRules = [
    check('nombreTipoDispositivo').notEmpty().withMessage('El nombre del tipo de dispositivo es obligatorio'),
    check('descripcionTipoDispositivo').optional(),
    check('tipoDispositivoCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

// ... (rest of the controller methods following a similar pattern as DispositivoController)

exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const newTipoDispositivo = await TipoDispositivo.create(req.body);

        res.status(201).json(newTipoDispositivo);
    } catch (err) {
        console.error('Error creating TipoDispositivo:', err);
        res.status(500).json({ message: 'Error al crear el tipo de dispositivo', error: err.message });
    }
};


exports.getAll = async (req, res) => {
    try {
        const tiposDispositivos = await TipoDispositivo.findAll();
        res.status(200).json(tiposDispositivos);
    } catch (err) {
        console.error('Error getting all TiposDispositivos:', err);
        res.status(500).json({ message: 'Error al obtener los tipos de dispositivos', error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const tipoDispositivo = await TipoDispositivo.findByPk(req.params.id);
        if (!tipoDispositivo) {
            return res.status(404).json({ message: 'Tipo de dispositivo no encontrado' });
        }
        res.status(200).json(tipoDispositivo);
    } catch (err) {
        console.error('Error getting TipoDispositivo by ID:', err);
        res.status(500).json({ message: 'Error al obtener el tipo de dispositivo', error: err.message });
    }
};



exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const [updatedRowsCount, updatedTipoDispositivo] = await TipoDispositivo.update(req.body, {
            where: { idTipoDispositivo: req.params.id },
            returning: true,
        });

        if (updatedRowsCount === 0) {
            return res.status(404).json({ message: 'Tipo de dispositivo no encontrado' });
        }

        res.status(200).json(updatedTipoDispositivo[0]);
    } catch (err) {
        console.error('Error updating TipoDispositivo:', err);
        res.status(500).json({ message: 'Error actualizando el tipo de dispositivo', error: err.message });
    }
};



exports.delete = async (req, res) => {
    try {
        const deletedRowCount = await TipoDispositivo.destroy({ where: { idTipoDispositivo: req.params.id } });
        if (!deletedRowCount) {
            return res.status(404).json({ message: 'Tipo de dispositivo no encontrado' });
        }
        res.status(200).json({ message: 'Tipo de dispositivo eliminado correctamente' });
    } catch (err) {
        console.error('Error deleting TipoDispositivo:', err);
        res.status(500).json({ message: 'Error eliminando el tipo de dispositivo', error: err.message });
    }
};