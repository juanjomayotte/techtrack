const { DataTypes } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  const Mantenimiento = sequelize.define(
    "Mantenimiento",
    {
      idMantenimiento: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      descripcionMantenimiento: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      situacionMantenimiento: {
        type: DataTypes.ENUM("Pendiente", "En Progreso", "Finalizado"),
        allowNull: false,
      },
      prioridadMantenimiento: {
        type: DataTypes.ENUM("Baja", "Media", "Alta"),
        allowNull: false,
      },
      observacionesMantenimiento: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      softwareAsociadoMantenimientoId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      dispositivoAsociadoMantenimientoId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      mantenimientoCreadoPorId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    },
    {
      tableName: "mantenimientos",
      timestamps: true, // Para manejar createdAt y updatedAt automáticamente
    }
  );
  return Mantenimiento;
};
