// routes/licenciaRoutes.js
const express = require('express');
const router = express.Router();
const licenciaController = require('../controllers/licenciaController');
const { createValidationRules, updateValidationRules } = require('../controllers/licenciaController');

// Rutas principales
router.get('/', licenciaController.getAll);
router.get('/:id', licenciaController.getById);
router.post('/', createValidationRules, licenciaController.create);
router.put('/:id', updateValidationRules, licenciaController.update);
router.delete('/:id', licenciaController.delete);




module.exports = router;