const express = require('express');
const router = express.Router();
const tipoContratoController = require('../controllers/tipoContratoController');
const { createValidationRules, updateValidationRules } = tipoContratoController;

// Rutas principales
router.get('/', tipoContratoController.getAll);
router.get('/:id', tipoContratoController.getById);
router.post('/', createValidationRules, tipoContratoController.create);
router.put('/:id', updateValidationRules, tipoContratoController.update);
router.delete('/:id', tipoContratoController.delete);

module.exports = router;
