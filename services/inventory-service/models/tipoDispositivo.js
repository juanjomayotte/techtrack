const { DataTypes } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  const TipoDispositivo = sequelize.define(
    "TipoDispositivo",
    {
      idTipoDispositivo: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      nombreTipoDispositivo: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionTipoDispositivo: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      tipoDispositivoCreadoPorId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    },
    {
      tableName: "tiposdispositivos",
      timestamps: true, // Para manejar createdAt y updatedAt automáticamente
    }
  );
  return TipoDispositivo;
};
