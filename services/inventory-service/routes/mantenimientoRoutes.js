const express = require('express');
const router = express.Router();
const mantenimientoController = require('../controllers/mantenimientoController');
const { createValidationRules, updateValidationRules } = require('../controllers/mantenimientoController');

// Rutas para mantenimientos
router.get('/', mantenimientoController.getAll); // Obtener todos los mantenimientos
router.get('/:id', mantenimientoController.getById);
router.post('/', createValidationRules, mantenimientoController.create); // Crear un nuevo mantenimiento
router.put('/:id',updateValidationRules, mantenimientoController.update); // Actualizar un mantenimiento existente
router.delete('/:id', mantenimientoController.delete); 

module.exports = router;
