//rol.js

const { DataTypes } = require("sequelize");

module.exports = (sequelize) => {
  return sequelize.define(
    "Rol",
    {
      idRol: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true,
      },
      nombreRol: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      descripcionRol: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      // Permisos para Contratos
      permisoContratoCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoContratoEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoContratoVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoContratoEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Tipos de Contratos
      permisoTipoContratoCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoContratoEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoContratoVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoContratoEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Licencias
      permisoLicenciaCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoLicenciaEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoLicenciaVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoLicenciaEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Tipos de Licencias
      permisoTipoLicenciaCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoLicenciaEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoLicenciaVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoLicenciaEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Modelos de Dispositivo
      permisoModeloDispositivoCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoModeloDispositivoEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoModeloDispositivoVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoModeloDispositivoEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Dispositivos
      permisoDispositivoCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoDispositivoEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoDispositivoVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoDispositivoEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Tipos de Dispositivos
      permisoTipoDispositivoCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoDispositivoEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoDispositivoVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoDispositivoEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Software
      permisoSoftwareCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoSoftwareEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoSoftwareVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoSoftwareEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Tipos de Software
      permisoTipoSoftwareCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoSoftwareEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoSoftwareVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoTipoSoftwareEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Mantenimiento
      permisoMantenimientoCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoMantenimientoEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoMantenimientoVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoMantenimientoEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Usuarios
      permisoUsuarioCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoUsuarioEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoUsuarioVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoUsuarioEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Roles
      permisoRolCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoRolEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoRolVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoRolEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Plataformas
      permisoPlataformaCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoPlataformaEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoPlataformaVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoPlataformaEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Estado de Dispositivos
      permisoEstadoDispositivoCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoEstadoDispositivoEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoEstadoDispositivoVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoEstadoDispositivoEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Permisos para Alertas
      permisoAlertaCreacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoAlertaEdicion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoAlertaVisualizacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },
      permisoAlertaEliminacion: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
      },

      // Relación con el usuario que crea el rol
      RolCreadoPor: {
        type: DataTypes.INTEGER,
        allowNull: true, 
        references: {
          model: "usuarios", // Asumiendo que la tabla de usuarios se llama 'usuarios'
          key: "idUsuario",
        },
      },
    },
    {
      tableName: "roles",
      timestamps: true,
    }
  );
};
