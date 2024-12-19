// controllers/plataformaController.js
const { Plataforma } = require('../models');
const { validationResult, check } = require('express-validator');

// Define validation rules
exports.createValidationRules = [
    check('nombrePlataforma').notEmpty().withMessage('El nombre de la plataforma es obligatorio'),
    check('descripcionPlataforma').optional(),
    check('plataformaCreadaPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

exports.updateValidationRules = [
    check('nombrePlataforma').notEmpty().withMessage('El nombre de la plataforma es obligatorio'),
    check('descripcionPlataforma').optional(),
    check('plataformaCreadaPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

// ... (rest of the controller methods following a similar pattern as DispositivoController)
exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const newPlataforma = await Plataforma.create(req.body);
        res.status(201).json(newPlataforma);
    } catch (err) {
        console.error('Error creating Plataforma:', err);
        res.status(500).json({ message: 'Error al crear la plataforma', error: err.message });
    }
};


exports.getAll = async (req, res) => {
    try {
        const plataformas = await Plataforma.findAll();
        res.status(200).json(plataformas);
    } catch (err) {
        console.error('Error getting all Plataformas:', err);
        res.status(500).json({ message: 'Error al obtener las plataformas', error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const plataforma = await Plataforma.findByPk(req.params.id);
        if (!plataforma) {
            return res.status(404).json({ message: 'Plataforma no encontrada' });
        }
        res.status(200).json(plataforma);
    } catch (err) {
        console.error('Error getting Plataforma by ID:', err);
        res.status(500).json({ message: 'Error al obtener la plataforma', error: err.message });
    }
};


exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const [updatedRowsCount, updatedPlataforma] = await Plataforma.update(req.body, {
            where: { idPlataforma: req.params.id },
            returning: true
        });

        if (updatedRowsCount === 0) {
            return res.status(404).json({ message: 'Plataforma no encontrada' });
        }
        res.status(200).json(updatedPlataforma[0]);

    } catch (err) {
        console.error('Error updating Plataforma:', err);
        res.status(500).json({ message: 'Error actualizando la plataforma', error: err.message });
    }
};


exports.delete = async (req, res) => {
    try {
        const deletedRowCount = await Plataforma.destroy({ where: { idPlataforma: req.params.id } });
        if (!deletedRowCount) {
            return res.status(404).json({ message: 'Plataforma no encontrada' });
        }
        res.status(200).json({ message: 'Plataforma eliminada correctamente' });
    } catch (err) {
        console.error('Error deleting Plataforma:', err);
        res.status(500).json({ message: 'Error al eliminar la plataforma', error: err.message });
    }
};