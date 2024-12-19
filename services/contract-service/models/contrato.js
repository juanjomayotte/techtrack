const { DataTypes } = require('sequelize');

module.exports = (sequelize) => {  // Solo toma sequelize como argumento
  const Contrato = sequelize.define('Contrato', {
    idContrato: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      autoIncrement: true,
      allowNull: false,
    },
    nombreContrato: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    descripcionContrato: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    tipoContratoId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      // Add references if TipoContrato is in the same service
    },
    fechaInicio: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    fechaExpiracion: {
      type: DataTypes.DATE,
      allowNull: false,
    },
    proveedor: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    terminosGenerales: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    EstadoContrato: {
      type: DataTypes.ENUM("Vigente", "Expirado", "Cancelado"),
      allowNull: false,
    },
    ContratoCreadoPor: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  }, {
    tableName: 'contratos',
    timestamps: true,
  });

  return Contrato;
};
