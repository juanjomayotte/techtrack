const express = require('express');
const router = express.Router();
const softwareController = require('../controllers/softwareController');
const { createValidationRules, updateValidationRules } = require('../controllers/softwareController');

// Rutas para software
router.get('/', softwareController.getAll); // Obtener todos los softwares
router.get('/:id', softwareController.getById); // Obtener un software por ID
router.post('/', createValidationRules, softwareController.create); // Crear un nuevo software
router.put('/:id', updateValidationRules, softwareController.update); // Actualizar un software existente
router.delete('/:id', softwareController.delete); // Eliminar un software

module.exports = router;
