//auth-service\routes\rolRoutes.js

const express = require('express');
const router = express.Router();
const rolController = require('../controllers/rolController'); // Make sure this path is correct
const { check, param } = require('express-validator');



// Validations for POST and PUT

const createRolValidationRules = [
    check('nombreRol').notEmpty().withMessage('El nombre del rol es obligatorio'),
    check('descripcionRol').optional(),
    // ... other validation checks for permissions (optional, but recommended)
    // Example:
    check('permisoContratoCreacion').isBoolean().withMessage('El permiso debe ser booleano'),
    // ... and so on for other permission fields
    check('RolCreadoPor').isNumeric().withMessage('El ID de usuario debe ser numérico')
];


const updateRolValidationRules = [
    check('nombreRol').optional().notEmpty().withMessage('El nombre del rol es obligatorio'),
    check('descripcionRol').optional(),
    // ... validation checks for permissions (same as in create)
    check('RolCreadoPor').optional().isNumeric().withMessage('El ID de usuario debe ser numérico')

];


// Routes
router.get('/', rolController.getAll);
router.get('/:id', rolController.getById);
router.post('/', createRolValidationRules, rolController.create);  // Use validation middleware here
router.put('/:id', updateRolValidationRules, rolController.update);
router.delete('/:id', rolController.delete);




module.exports = router;