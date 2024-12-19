const { DataTypes } = require("sequelize");

module.exports = (sequelize, DataTypes) => {
  const Plataforma = sequelize.define(
    "Plataforma",
    {
      idPlataforma: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
        allowNull: false,
      },
      nombrePlataforma: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionPlataforma: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      plataFormaCreadoPorId: {
        type: DataTypes.INTEGER,
        allowNull: true,
      },
    },
    {
      tableName: "plataformas",
      timestamps: true, // Para manejar createdAt y updatedAt automáticamente
    }
  );
  return Plataforma;
};
