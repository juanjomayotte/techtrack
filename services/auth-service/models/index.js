// index.js
const { Sequelize, DataTypes, Op } = require("sequelize");
const config = require("../config/database"); // Ajustar la ruta según sea necesario

// Crear instancia de Sequelize
const sequelize = new Sequelize(
  config.database,
  config.username,
  config.password,
  config.options
);

const Usuario = require("./usuario")(sequelize, DataTypes); // Pasamos sequelize y DataTypes
const Rol = require("./rol")(sequelize, DataTypes); // Pasamos sequelize y DataTypes

// Relación entre Usuario y Rol

Usuario.belongsTo(Rol, { foreignKey: "rolId", as: "rol" }); // Use the foreign key field name
Rol.hasMany(Usuario, { foreignKey: "rolId", as: "usuarios" }); // And in the inverse relationship too

module.exports = { Usuario, Rol, sequelize, Op }; // Exportamos sequelize, Usuario y Rol
