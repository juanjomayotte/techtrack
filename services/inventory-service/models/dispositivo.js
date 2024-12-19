const { DataTypes } = require("sequelize");
const tipoDispositivo = require("./tipoDispositivo");

module.exports = (sequelize, DataTypes) => {
  // Export a function
  const Dispositivo = sequelize.define(
    "Dispositivo",
    {
      idDispositivo: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      modeloDispositivoId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      numeroSerieDispositivo: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true, // Suponiendo que el número de serie es único
      },
      ubicacionDispositivo: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      usuarioAsignadoId: {
        type: DataTypes.INTEGER,
        allowNull: true, // Or false, depending on your requirements
      },
      dispositivoCreadoPorId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    },
    {
      timestamps: true, // Crea campos createdAt y updatedAt
      tableName: "dispositivos",
    }
  );

  return Dispositivo;
};
