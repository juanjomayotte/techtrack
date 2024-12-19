const { DataTypes } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  const EstadoDispositivo = sequelize.define(
    "EstadoDispositivo",
    {
      idEstadoDispositivo: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      nombreEstadoDispositivo: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionEstadoDispositivo: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      estadoDispositivoCreadoPorId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    },
    {
      tableName: "estadosdispositivos",
      timestamps: true, // Para manejar createdAt y updatedAt automáticamente
    }
  );
  return EstadoDispositivo;
};
