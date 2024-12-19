const express = require('express');
const router = express.Router();
const modeloDispositivoController = require('../controllers/modeloDispositivoController');
const { createValidationRules, updateValidationRules } = require('../controllers/modeloDispositivoController');

// Rutas para modelos de dispositivos
router.get('/', modeloDispositivoController.getAll); // Obtener todos los modelos
router.get('/:id', modeloDispositivoController.getById); // Obtener un modelo por ID
router.post('/', createValidationRules, modeloDispositivoController.create); // Crear un nuevo modelo
router.put('/:id',updateValidationRules, modeloDispositivoController.update); // Actualizar un modelo existente
router.delete('/:id', modeloDispositivoController.delete); // Eliminar un modelo

module.exports = router;
