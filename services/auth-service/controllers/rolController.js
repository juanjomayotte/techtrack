const { Rol } = require('../models');
const { validationResult } = require('express-validator');


// Create a new Rol
exports.create = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    try {
        const newRol = await Rol.create(req.body);
        res.status(201).json(newRol); // 201 Created
    } catch (err) {
        console.error('Error creating Rol:', err);
        res.status(500).json({ message: 'Error creating role', error: err.message }); // Provide a more helpful error message
    }
};


// Get all roles
exports.getAll = async (req, res) => {
    try {
        const roles = await Rol.findAll();
        res.json(roles);
    } catch (error) {
        console.error('Error getting roles:', error);
        res.status(500).json({ message: 'Error getting roles', error: error.message });
    }
};

// Get Rol by ID
exports.getById = async (req, res) => {
    try {
        const rol = await Rol.findByPk(req.params.id);
        if (!rol) {
            return res.status(404).json({ message: 'Rol not found' });
        }
        res.json(rol);
    } catch (error) {
        console.error('Error getting rol by ID:', error);
        res.status(500).json({ message: 'Error getting role', error: error.message }); // Better error message
    }
};


// Update an existing Rol
exports.update = async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() }); // Send validation errors
    }
    try {
        const [updatedRowsCount, updatedRol] = await Rol.update(req.body, {
            where: { idRol: req.params.id },
            returning: true,
        });
        if (updatedRowsCount === 0) {
            return res.status(404).json({ message: 'Rol not found' }); // Correct status code (it should be a 404 Not Found if not updated)
        }
        res.json(updatedRol[0]); // Send the updated Rol

    } catch (err) {
        console.error('Error updating Rol:', err);
        res.status(500).json({ message: 'Error updating role', error: err.message }); // Better error message
    }

};

// Delete a Rol
exports.delete = async (req, res) => {

    try {
        const deletedRowCount = await Rol.destroy({ where: { idRol: req.params.id } });
        if (!deletedRowCount) {
            return res.status(404).json({ message: 'Rol not found' });
        }
        // Correct response for successful delete. Status 204 or 200 and json message
        res.status(200).json({ message: 'Rol deleted successfully' }); // Or status 204 No Content if you don't want to send a JSON response

    } catch (error) {
        console.error('Error deleting rol:', error);
        res.status(500).json({ message: 'Error deleting role', error: error.message }); // Clearer message
    }
};