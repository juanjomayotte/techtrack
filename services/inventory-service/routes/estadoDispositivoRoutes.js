const express = require('express');
const router = express.Router();
const estadoDispositivoController = require('../controllers/estadoDispositivoController');
const { createValidationRules, updateValidationRules }  = require('../controllers/estadoDispositivoController');

// Rutas para estados de dispositivos
router.get('/', estadoDispositivoController.getAll);
router.get('/:id', estadoDispositivoController.getById); // Route for getting by ID
router.post('/', createValidationRules, estadoDispositivoController.create); 
router.put('/:id', updateValidationRules, estadoDispositivoController.update); // Route for updating
router.delete('/:id', estadoDispositivoController.delete); // Route for deleting



module.exports = router;