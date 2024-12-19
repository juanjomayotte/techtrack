const express = require('express');
const router = express.Router();
const dispositivoController = require('../controllers/dispositivoController');
const { createValidationRules, updateValidationRules } = require('../controllers/dispositivoController'); 

// Rutas para dispositivos
router.get('/', dispositivoController.getAll); // Obtener todos los dispositivos
router.get('/:id', dispositivoController.getById); // Obtener un dispositivo por ID
router.post('/', createValidationRules, dispositivoController.create); // Crear un nuevo dispositivo
router.put('/:id', updateValidationRules, dispositivoController.update); // Actualizar un dispositivo existente
router.delete('/:id', dispositivoController.delete); // Eliminar un dispositivo

module.exports = router;
