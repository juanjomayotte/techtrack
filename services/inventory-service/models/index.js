const { Sequelize, DataTypes } = require('sequelize');
const config = require('../config/database');

const sequelize = new Sequelize(config.database, config.username, config.password, config.options);

// Import all models *before* defining associations
const Dispositivo = require('./dispositivo')(sequelize, DataTypes);
const ModeloDispositivo = require('./modeloDispositivo')(sequelize, DataTypes);
const TipoDispositivo = require('./tipoDispositivo')(sequelize, DataTypes);
const EstadoDispositivo = require('./estadoDispositivo')(sequelize, DataTypes);
const Mantenimiento = require('./mantenimiento')(sequelize, DataTypes);
const Software = require('./software')(sequelize, DataTypes);
const Plataforma = require('./plataforma')(sequelize, DataTypes);
const TipoSoftware = require('./tipoSoftware')(sequelize, DataTypes);
const Licencia =  require('../../license-service/models/licencia')(sequelize,DataTypes);


// Relaciones
Dispositivo.belongsTo(ModeloDispositivo, { foreignKey: 'modeloDispositivoId', as: 'modelo' });
ModeloDispositivo.hasMany(Dispositivo, { foreignKey: 'modeloDispositivoId', as: 'dispositivos' });

Dispositivo.belongsTo(EstadoDispositivo, { foreignKey: 'estadoDispositivoId', as: 'estado' });
EstadoDispositivo.hasMany(Dispositivo, { foreignKey: 'estadoDispositivoId', as: 'dispositivos' });

ModeloDispositivo.belongsTo(TipoDispositivo, { foreignKey: 'tipoDispositivoId', as: 'tipo' });
TipoDispositivo.hasMany(ModeloDispositivo, { foreignKey: 'tipoDispositivoId', as: 'modelos' });

Dispositivo.belongsTo(Software, { foreignKey: 'softwareInstaladoId', as: 'softwareInstalado' });
Software.hasMany(Dispositivo, { foreignKey: 'softwareInstaladoId', as: 'dispositivosConSoftware' });

// Many-to-Many
Dispositivo.belongsToMany(Software, { through: 'DispositivoSoftware', foreignKey: 'idDispositivo' });
Software.belongsToMany(Dispositivo, { through: 'DispositivoSoftware', foreignKey: 'idSoftware' });

Software.belongsToMany(Plataforma, { through: 'SoftwarePlataforma', foreignKey: 'idSoftware' });
Plataforma.belongsToMany(Software, { through: 'SoftwarePlataforma', foreignKey: 'idPlataforma' });


// Other Associations
Mantenimiento.belongsTo(Dispositivo, { foreignKey: 'dispositivoAsociadoMantenimientoId', as: 'dispositivo' });
Dispositivo.hasMany(Mantenimiento, { foreignKey: 'dispositivoAsociadoMantenimientoId', as: 'mantenimientos' });


Mantenimiento.belongsTo(Software, { foreignKey: 'softwareAsociadoMantenimientoId', as: 'software' });
Software.hasMany(Mantenimiento, { foreignKey: 'softwareAsociadoMantenimientoId', as: 'mantenimientos' });


Software.belongsTo(TipoSoftware, { foreignKey: 'tipoSoftwareId', as: 'tipo' });
TipoSoftware.hasMany(Software, { foreignKey: 'tipoSoftwareId', as: 'softwares' });

// Asociación con Licencia
Licencia.hasMany(Software,{
      foreignKey: 'softwareId',
      as: 'licencias'
})
Software.belongsTo(Licencia, {
    foreignKey: 'idSoftware',
    as: 'licencia'
})

module.exports = {
  sequelize,
  Dispositivo,
  ModeloDispositivo,
  TipoDispositivo,
  EstadoDispositivo,
  Mantenimiento,
  Software,
  Plataforma,
  TipoSoftware
};