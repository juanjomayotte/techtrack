
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const ModeloDispositivo = sequelize.define('ModeloDispositivo', {
    idModeloDispositivo: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false
    },
    nombreModeloDispositivo: {
      type: DataTypes.STRING,
      allowNull: false
    },
    marca: {
      type: DataTypes.STRING,
      allowNull: false
    },
    descripcionModeloDispositivo: {
      type: DataTypes.STRING,
      allowNull: true
    },
    cantidadEnInventario: {
      type: DataTypes.INTEGER,
      defaultValue: 0,
      allowNull: false
    },
    modeloDispositivoCreadoPorId: {
      type: DataTypes.INTEGER,
      allowNull: true,
    },
  }, {
    tableName: 'modelosdispositivos',
    timestamps: true, // Para manejar createdAt y updatedAt automáticamente
  });
  return ModeloDispositivo;
}

