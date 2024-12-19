const express = require('express');
const router = express.Router();
const plataformaController = require('../controllers/plataformaController');
const { createValidationRules, updateValidationRules } = require('../controllers/plataformaController');

// Rutas para plataformas
router.get('/', plataformaController.getAll); // Obtener todas las plataformas
router.get('/:id', plataformaController.getById); // Obtener una plataforma por ID
router.post('/', createValidationRules, plataformaController.create); // Crear una nueva plataforma
router.put('/:id', updateValidationRules, plataformaController.update); // Crear una nueva plataforma
router.delete('/:id', plataformaController.delete); // Eliminar una plataforma

module.exports = router;
