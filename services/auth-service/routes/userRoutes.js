//userRoutes.js

const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const { body, check, param } = require('express-validator');


// Ruta para registrar usuarios con validaciones
router.post('/register', [
    check('nombreUsuario').notEmpty().withMessage('El nombre de usuario es obligatorio').isLength({ min: 3, max: 50 }).withMessage('El nombre de usuario debe tener entre 3 y 50 caracteres'),
    check('correoElectronicoUsuario').isEmail().withMessage('Debes ingresar un correo electrónico válido').normalizeEmail(),
    check('passwordUsuario').isLength({ min: 6 }).withMessage('La contraseña debe tener al menos 6 caracteres').matches(/\d/).withMessage('La contraseña debe contener al menos un número').matches(/[a-z]/).withMessage('La contraseña debe contener al menos una letra minúscula').matches(/[A-Z]/).withMessage('La contraseña debe contener al menos una letra mayúscula'),
    check('confirmPassword').notEmpty().withMessage('Confirma tu contraseña').custom((value, { req }) => {
        if (value !== req.body.passwordUsuario) {
          throw new Error('Las contraseñas no coinciden');
        }
        return true;
    }),
    check('rolId').isNumeric().withMessage('Debes ingresar un rol válido (número)'),
], userController.createUser);


router.get('/', userController.getUsers);
router.get('/:id', userController.getUserById);

//Ruta PUT con validaciones
router.put('/:id', [
    param('id').isNumeric().withMessage('El ID del usuario debe ser un número'),
    check('nombreUsuario').optional().isLength({ min: 3, max: 50 }).withMessage('El nombre de usuario debe tener entre 3 y 50 caracteres'),
    check('correoElectronicoUsuario').optional().isEmail().withMessage('Debes ingresar un correo electrónico válido').normalizeEmail(),
    check('rolId').optional().isNumeric().withMessage('El rol debe ser un número'),
], userController.updateUser);

router.delete('/:id', [param('id').isNumeric().withMessage('El ID del usuario debe ser un número')], userController.deleteUser);


// Ruta para iniciar sesión con validaciones
router.post('/login', [
    check('correoElectronicoUsuario').isEmail().withMessage('Debes ingresar un correo electrónico válido').normalizeEmail(),
    check('passwordUsuario').notEmpty().withMessage('La contraseña es obligatoria'),
], userController.loginUser);

module.exports = router;