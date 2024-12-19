const { Sequelize, DataTypes } = require("sequelize");
require("dotenv").config();
const dbConfig = require("../config/database");

// Crea la instancia de Sequelize
const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  dbConfig.options
);

// Prueba la conexión (Good practice to keep)
(async () => {
  try {
    await sequelize.authenticate();
    console.log('Conexión a la base de datos establecida correctamente.');
  } catch (error) {
    console.error('No se puede conectar a la base de datos:', error);
  }
})();

// Import models *after* initializing Sequelize
const TipoContrato = require('./tipoContrato')(sequelize, DataTypes);
const Contrato = require('./contrato')(sequelize, DataTypes);



// Associations (define *after* initializing models)
Contrato.belongsTo(TipoContrato, { foreignKey: 'tipoContratoId' });
TipoContrato.hasMany(Contrato, { foreignKey: 'tipoContratoId' });

// Exportar los modelos y la instancia de sequelize
module.exports = {
  sequelize,
  TipoContrato,
  Contrato,
};
