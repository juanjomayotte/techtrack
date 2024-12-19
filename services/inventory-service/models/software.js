const { DataTypes } = require("sequelize");

module.exports = (sequelize) => {
  const Software = sequelize.define(
    "Software",
    {
      idSoftware: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      nombreSoftware: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      tipoSoftwareId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      versionSoftware: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      requiereActualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      estaEnListaNegra: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      licenciaVinculadaSoftwareId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      contratoVinculadoSoftwareId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
      softwareCreadoPorId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
    },
    {
      tableName: "software",
      timestamps: true, // Para manejar createdAt y updatedAt automáticamente
    }
  );

  Software.associate = (models) => {
    Software.hasMany(models.Licencia, {
      foreignKey: 'softwareId', // Relación con el modelo Licencia
      as: 'licencias',          // Alias para la relación
      // Add the following if the Licencia model has the `softwareId` column.
      // targetKey: 'idSoftware',
    });

    Software.hasMany(models.Dispositivo, {
      foreignKey: 'softwareInstaladoId',
      as: 'dispositivosConSoftware',
    });
  };

  return Software;
};