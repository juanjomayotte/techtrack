// routes/tipoLicenciaRoutes.js
const express = require('express');
const router = express.Router();
const tipoLicenciaController = require('../controllers/tipoLicenciaController');
const { createValidationRules, updateValidationRules } = tipoLicenciaController; // Importa las reglas del controlador


router.get('/', tipoLicenciaController.getAll);
router.get('/:id', tipoLicenciaController.getById);
router.post('/', createValidationRules, tipoLicenciaController.create); // Usa las reglas de validación del controlador
router.put('/:id', updateValidationRules, tipoLicenciaController.update); // Usa las reglas de validación del controlador
router.delete('/:id', tipoLicenciaController.delete);

module.exports = router;