// models/tipoLicencia.js
const { DataTypes } = require("sequelize");

module.exports = (sequelize) => {
  const TipoLicencia = sequelize.define(
    "TipoLicencia",
    {
      idTipoLicencia: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
      },
      nombreTipoLicencia: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionTipoLicencia: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      tipoLicenciaCreadaPor: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      timestamps: true,
      tableName: "tipo_licencias",
    }
  );
  
   return TipoLicencia;
};