// usuario.js
const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {
    const Usuario = sequelize.define('Usuario', {
        idUsuario: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true,
        },
        nombreUsuario: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        correoElectronicoUsuario: {
            type: DataTypes.STRING,
            allowNull: false,
            unique: true,
        },
        passwordUsuario: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        rolId: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
    }, {
        tableName: 'usuarios',
        timestamps: true, // Activa createdAt y updatedAt
        createdAt: 'fechaCreacion', // Cambia el nombre si es necesario
        updatedAt: 'fechaActualizacion',
        hooks: {
            beforeCreate: (usuario) => {
                usuario.fechaCreacion = new Date();
                usuario.fechaActualizacion = new Date();
            },
            beforeUpdate: (usuario) => {
                usuario.fechaActualizacion = new Date();
            }
        }
    });

    return Usuario;
};