const { DataTypes } = require("sequelize");
const sequelize = require("../config/database"); // Asegúrate de importar la configuración de Sequelize

module.exports = (sequelize, DataTypes) => {
  const TipoSoftware = sequelize.define(
    "TipoSoftware",
    {
      idTipoSoftware: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      nombreTipoSoftware: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionTipoSoftware: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      tipoSoftwareCreadoPorId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    },
    {
      tableName: "tipossoftware",
      timestamps: true, // Para manejar createdAt y updatedAt automáticamente
    }
  );
  return TipoSoftware;
};
