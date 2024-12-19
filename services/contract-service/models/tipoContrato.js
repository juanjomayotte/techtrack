const { DataTypes } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  // Take sequelize and DataTypes as arguments
  const TipoContrato = sequelize.define(
    "TipoContrato",
    {
      idTipoContrato: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      nombreTipoContrato: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionTipoContrato: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      tipoContratoCreadoPor: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      timestamps: true,
      tableName: "tipo_contratos",
    }
  );
  return TipoContrato; // Return the model
};
