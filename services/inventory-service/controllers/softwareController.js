
// controllers/softwareController.js
const { Software } = require('../models');
const { validationResult, check } = require('express-validator');


// Define validation rules
exports.createValidationRules = [
    check('nombreSoftware').notEmpty().withMessage('El nombre del software es obligatorio'),
    check('versionSoftware').notEmpty().withMessage('La versión del software es obligatoria'),
    check('tipoSoftwareId').isNumeric().withMessage('El ID de tipo de software debe ser numérico'),
    check('requiereActualizacion').isBoolean().withMessage('Requiere actualización debe ser booleano'),
    check('estaEnListaNegra').isBoolean().withMessage('Está en lista negra debe ser booleano'),
    check('softwareCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
    check('licenciaVinculadaSoftwareId')
    .optional({ checkFalsy: true }) // Permite valores undefined, null, o falsy
    .isNumeric().withMessage('El ID de licencia debe ser numérico'),
    check('contratoVinculadoSoftwareId')
    .optional({ checkFalsy: true }) // Permite valores undefined, null, o falsy
    .isNumeric().withMessage('El ID de contrato debe ser numérico'),

];

exports.updateValidationRules = [
    check('nombreSoftware').notEmpty().withMessage('El nombre del software es obligatorio'),
    check('versionSoftware').notEmpty().withMessage('La versión del software es obligatoria'),
    check('tipoSoftwareId').isNumeric().withMessage('El ID de tipo de software debe ser numérico'),
    check('requiereActualizacion').isBoolean().withMessage('Requiere actualización debe ser booleano'),
    check('estaEnListaNegra').isBoolean().withMessage('Está en lista negra debe ser booleano'),
    check('softwareCreadoPorId').isNumeric().withMessage('El ID de usuario debe ser numérico'),
    check('licenciaVinculadaSoftwareId')
    .optional({ checkFalsy: true }) // Permite valores undefined, null, o falsy
    .isNumeric().withMessage('El ID de licencia debe ser numérico'),
    check('contratoVinculadoSoftwareId')
    .optional({ checkFalsy: true }) // Permite valores undefined, null, o falsy
    .isNumeric().withMessage('El ID de contrato debe ser numérico'),
];



// ... (rest of the controller methods following a similar pattern as DispositivoController)

exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }
    try {
        const newSoftware = await Software.create(req.body);
        res.status(201).json(newSoftware);
    } catch (err) {
        console.error('Error creating Software:', err);
        res.status(500).json({ message: 'Error al crear el software', error: err.message });
    }
};

exports.getAll = async (req, res) => {
    try {
        const softwares = await Software.findAll();
        res.status(200).json(softwares);
    } catch (err) {
        console.error('Error getting all Softwares:', err);
        res.status(500).json({ message: 'Error al obtener los softwares', error: err.message });
    }
};


exports.getById = async (req, res) => {
    try {
        const software = await Software.findByPk(req.params.id);
        if (!software) {
            return res.status(404).json({ message: 'Software no encontrado' });
        }
        res.status(200).json(software);
    } catch (err) {
        console.error('Error getting Software by ID:', err);
        res.status(500).json({ message: 'Error al obtener el software', error: err.message });
    }
};



exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const [updatedRowsCount, updatedSoftware] = await Software.update(req.body, {
            where: { idSoftware: req.params.id },
            returning: true
        });

        if (updatedRowsCount === 0) {
            return res.status(404).json({ message: 'Software no encontrado' });
        }
        res.status(200).json(updatedSoftware[0]);


    } catch (err) {
        console.error('Error updating Software:', err);
        res.status(500).json({ message: 'Error al actualizar el software', error: err.message });
    }
};

exports.delete = async (req, res) => {
    try {
        const deletedRowCount = await Software.destroy({ where: { idSoftware: req.params.id } });
        if (!deletedRowCount) {
            return res.status(404).json({ message: 'Software no encontrado' });
        }
        res.status(200).json({ message: 'Software eliminado correctamente' });
    } catch (err) {
        console.error('Error deleting Software:', err);
        res.status(500).json({ message: 'Error al eliminar el software', error: err.message });
    }
};