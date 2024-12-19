const { DataTypes } = require("sequelize");

module.exports = (sequelize) => {
  const Licencia = sequelize.define(
    "Licencia",
    {
      idLicencia: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      nombreLicencia: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionLicencia: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      tipoLicenciaId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
          model: 'tipo_licencias', // Referencia a la tabla tipo_licencias
          key: "idTipoLicencia",
        },
      },
      fechaInicio: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      fechaExpiracion: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      estadoLicencia: {
        type: DataTypes.ENUM("Activa", "Inactiva", "Expirada"),
        allowNull: false,
        defaultValue: "Activa",
      },
      maximoUsuarios: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: 0,
      },
      softwareId: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
    },
    {
      tableName: "licencias",
      timestamps: true,
    }
  );

  Licencia.associate = (models) => {
    Licencia.belongsTo(models.TipoLicencia, {
      foreignKey: 'tipoLicenciaId',
      as: 'TipoLicencium',
    });
    Licencia.belongsTo(models.Software, {
      foreignKey: 'softwareId',  // Esta debe ser la columna 'softwareId' de la tabla 'licencias'
      as: 'software',
    });
  };

  return Licencia;
};