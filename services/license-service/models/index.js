// license-service/index.js
const { Sequelize, DataTypes } = require("sequelize");
require("dotenv").config();
const dbConfig = require("../config/database");

const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  dbConfig.options
);

(async () => {
  try {
    await sequelize.authenticate();
    console.log('Conexión a la base de datos establecida correctamente.');
  } catch (error) {
    console.error('No se puede conectar a la base de datos:', error);
  }
})();

// Importar los modelos
const TipoLicencia = require('./tipoLicencia')(sequelize, DataTypes);
const Licencia = require('./licencia')(sequelize, DataTypes);

// Importar Software desde inventory-service
const Software = require('../../inventory-service/models/software')(sequelize, DataTypes); // Ajusta la ruta

// Asociaciones
TipoLicencia.associate = (models) => {
    TipoLicencia.hasMany(models.Licencia, {
        foreignKey: 'tipoLicenciaId',
        as: 'licencias'
    });
};

Licencia.associate( {TipoLicencia, Software} ); // Pasa Software para asociar
TipoLicencia.associate( {Licencia} );

module.exports = {
  sequelize,
  TipoLicencia,
  Licencia,
  Software, // Exporta también Software
};
