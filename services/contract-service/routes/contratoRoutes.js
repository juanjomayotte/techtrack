const express = require('express');
const router = express.Router();
const contratoController = require('../controllers/contratoController');
const { createValidationRules, updateValidationRules } = require('../controllers/contratoController');

// Rutas principales
router.get('/', contratoController.getAll);
router.get('/:id', contratoController.getById);
router.post('/', createValidationRules, contratoController.create);
router.put('/:id', updateValidationRules, contratoController.update);
router.delete('/:id', contratoController.delete);

// Rutas para las relaciones de muchos a muchos
// // Dispositivo
// router.post('/:contratoId/dispositivos', contratoController.vincularDispositivo);
// router.delete('/:contratoId/dispositivos', contratoController.desvincularDispositivo);

// // Software
// router.post('/:contratoId/software', contratoController.vincularSoftware);
// router.delete('/:contratoId/software', contratoController.desvincularSoftware);

// // Licencias
// router.post('/:contratoId/licencias', contratoController.vincularLicencia);
// router.delete('/:contratoId/licencias', contratoController.desvincularLicencia);

// // Usuarios
// router.post('/:contratoId/usuarios', contratoController.vincularUsuario);
// router.delete('/:contratoId/usuarios', contratoController.desvincularUsuario);

// // Mantenimientos
// router.post('/:contratoId/mantenimientos', contratoController.vincularMantenimiento);
// router.delete('/:contratoId/mantenimientos', contratoController.desvincularMantenimiento);

// Otras operaciones
// router.put('/:id/renovar', contratoController.renovarContrato);
// router.get('/:id/verificar-vencimiento', contratoController.verificarVencimiento);
// router.put('/:id/modificar-terminos', contratoController.modificarTerminos);

module.exports = router;
