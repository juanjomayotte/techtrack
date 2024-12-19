const express = require('express');
const router = express.Router();
const tipoDispositivoController = require('../controllers/tipoDispositivoController');
const { createValidationRules, updateValidationRules } = require('../controllers/tipoDispositivoController');

// Rutas para tipos de dispositivos
router.get('/', tipoDispositivoController.getAll); // Obtener todos los tipos de dispositivos
router.get('/:id', tipoDispositivoController.getById); 
router.post('/', createValidationRules, tipoDispositivoController.create); // Crear un nuevo tipo de dispositivo
router.put('/:id', updateValidationRules, tipoDispositivoController.update); 
router.delete('/:id', tipoDispositivoController.delete);


module.exports = router;
