const express = require('express');
const router = express.Router();
const tipoSoftwareController = require('../controllers/tipoSoftwareController');
const { createValidationRules, updateValidationRules } = require('../controllers/tipoSoftwareController');

// Rutas para tipos de software
router.get('/', tipoSoftwareController.getAll); // Obtener todos los tipos de software
router.get('/:id', tipoSoftwareController.getById); // Obtener un tipo de software por ID
router.post('/', createValidationRules, tipoSoftwareController.create); // Crear un nuevo tipo de software
router.put('/:id', updateValidationRules, tipoSoftwareController.update); // Actualizar un tipo de software existente
router.delete('/:id', tipoSoftwareController.delete); // Eliminar un tipo de software

module.exports = router;
