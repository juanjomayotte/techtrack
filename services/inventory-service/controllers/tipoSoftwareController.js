// controllers/tipoSoftwareController.js
const { TipoSoftware } = require('../models');
const { validationResult, check } = require('express-validator');


// Define validation rules
exports.createValidationRules = [
    check('nombreTipoSoftware').notEmpty().withMessage('El nombre del tipo de software es obligatorio'),
    check('descripcionTipoSoftware').optional(),
    check('tipoSoftwareCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

exports.updateValidationRules = [
    check('nombreTipoSoftware').notEmpty().withMessage('El nombre del tipo de software es obligatorio'),
    check('descripcionTipoSoftware').optional(),
    check('tipoSoftwareCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
];

// ... (rest of the controller methods following a similar pattern as DispositivoController)
exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const newTipoSoftware = await TipoSoftware.create(req.body);

        res.status(201).json(newTipoSoftware);
    } catch (err) {
        console.error('Error creating TipoSoftware:', err);
        res.status(500).json({ message: 'Error al crear el tipo de software', error: err.message });
    }
};



exports.getAll = async (req, res) => {
    try {
        const tipoSoftware = await TipoSoftware.findAll();
        res.status(200).json(tipoSoftware);
    } catch (err) {
        console.error('Error getting all TiposSoftware:', err);
        res.status(500).json({ message: 'Error al obtener los tipos de software', error: err.message });
    }
};

exports.getById = async (req, res) => {
    try {
        const tipoSoftware = await TipoSoftware.findByPk(req.params.id);
        if (!tipoSoftware) {
            return res.status(404).json({ message: 'Tipo de software no encontrado' });
        }
        res.status(200).json(tipoSoftware);
    } catch (err) {
        console.error('Error getting TipoSoftware by ID:', err);
        res.status(500).json({ message: 'Error al obtener el tipo de software', error: err.message });
    }
};


exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const [updatedRowsCount, updatedTipoSoftware] = await TipoSoftware.update(req.body, {
            where: { idTipoSoftware: req.params.id },
            returning: true,
        });


        if (updatedRowsCount === 0) {
            return res.status(404).json({ message: 'Tipo de software no encontrado' });
        }
        res.status(200).json(updatedTipoSoftware[0]);

    } catch (err) {
        console.error('Error updating TipoSoftware:', err);
        res.status(500).json({ message: 'Error al actualizar el tipo de software', error: err.message });
    }
};


exports.delete = async (req, res) => {
    try {
        const deletedRowCount = await TipoSoftware.destroy({ where: { idTipoSoftware: req.params.id } });
        if (!deletedRowCount) {
            return res.status(404).json({ message: 'Tipo de software no encontrado' });
        }
        res.status(200).json({ message: 'Tipo de software eliminado correctamente' });
    } catch (err) {
        console.error('Error deleting TipoSoftware:', err);
        res.status(500).json({ message: 'Error al eliminar el tipo de software', error: err.message });
    }
};