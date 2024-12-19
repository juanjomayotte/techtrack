const { Licencia, TipoLicencia } = require("../models");
const { Software } = require("../../inventory-service/models");
const { validationResult, check } = require("express-validator");;

const inventoryServiceUrl = "http://localhost:3002/api";

// Función reutilizable para realizar llamadas a APIs
const makeApiRequest = async (url, options = {}) => {
    try {
        // Importa fetch de forma dinámica
        const fetchModule = await import('node-fetch');
        const fetch = fetchModule.default;
        const response = await fetch(url, options);

        if (!response.ok) {
            // Intenta parsear la respuesta como JSON para obtener el mensaje de error
            let errorData = {};
            try {
                errorData = await response.json();
            } catch (jsonError) {
                // Si no es JSON, maneja el error
                const errorText = await response.text();
                console.error(
                    "Error en la solicitud al inventory-service, respuesta no es JSON:",
                    response.status,
                    response.statusText,
                    errorText
                );
                throw new Error(
                    `Error en la solicitud al inventory-service ${response.status}: ${response.statusText}`
                );
            }

            const errorMessage =
                errorData.message || "Error en la solicitud a la API";
            throw new Error(`${response.status} - ${errorMessage}`);
        }

        // Lee el body como JSON SOLO UNA VEZ
        const jsonData = await response.json();
        return jsonData;
    } catch (error) {
        console.error("Error en makeApiRequest:", error);
        throw error;
    }
};

// Reglas de validación
exports.createValidationRules = [
  check("nombreLicencia")
    .notEmpty()
    .withMessage("El nombre de la licencia es obligatorio."),
  check("tipoLicenciaId")
    .isInt()
    .withMessage("El ID del tipo de licencia debe ser un número entero."),
    check("softwareId")
    .isInt()
    .withMessage("El ID del software debe ser un número entero."),
    check("fechaInicio")
    .notEmpty()
    .withMessage("La fecha de inicio es obligatoria."),
  check("fechaExpiracion")
    .notEmpty()
    .withMessage("La fecha de expiración es obligatoria."),
  check("estadoLicencia")
      .notEmpty()
      .withMessage("El estado de la licencia es obligatorio"),
    check("maximoUsuarios")
        .optional()
      .isInt({min:0})
      .withMessage("El máximo de usuarios debe ser un número entero positivo")
];

exports.updateValidationRules = [
  check("nombreLicencia")
    .optional()
    .notEmpty()
    .withMessage("El nombre de la licencia no puede estar vacío."),
  check("tipoLicenciaId")
    .optional()
    .isInt()
    .withMessage("El ID del tipo de licencia debe ser un número entero."),
    check("softwareId")
    .optional()
    .isInt()
     .withMessage("El ID del software debe ser un número entero."),
    check("fechaInicio")
      .optional()
      .notEmpty()
      .withMessage("La fecha de inicio es obligatoria."),
    check("fechaExpiracion")
      .optional()
       .notEmpty()
      .withMessage("La fecha de expiración es obligatoria."),
    check("estadoLicencia")
      .optional()
      .notEmpty()
        .withMessage("El estado de la licencia es obligatorio"),
      check("maximoUsuarios")
       .optional()
         .isInt({min:0})
        .withMessage("El máximo de usuarios debe ser un número entero positivo")
];

exports.getAll = async (req, res) => {
    try {
        const licencias = await Licencia.findAll({
            include: [
                {
                    model: TipoLicencia,
                    as: 'TipoLicencium'
                },
                 {
                   model: Software,
                   as: 'software',
                     attributes: ['idSoftware','nombreSoftware', 'tipoSoftwareId', 'versionSoftware', 'requiereActualizacion','estaEnListaNegra', 'licenciaVinculadaSoftwareId', 'contratoVinculadoSoftwareId', 'softwareCreadoPorId','createdAt', 'updatedAt']
                 }
            ]
        });
        res.status(200).json(licencias);

    } catch (error) {
        console.error('Error al obtener licencias:', error);
        res.status(500).json({ error: 'Error al obtener licencias' });
    }
};

// Obtener una licencia por ID
exports.getById = async (req, res) => {
  try {
      const licencia = await Licencia.findByPk(req.params.id, {
          include: [
              {
                  model: TipoLicencia,
                  as: 'TipoLicencium'
              },
              {
                  model: Software,
                  as: 'software',
                     attributes: ['idSoftware','nombreSoftware', 'tipoSoftwareId', 'versionSoftware', 'requiereActualizacion','estaEnListaNegra', 'licenciaVinculadaSoftwareId', 'contratoVinculadoSoftwareId', 'softwareCreadoPorId','createdAt', 'updatedAt']
                }
          ]
      });
    if (!licencia) {
      return res.status(404).json({ message: "Licencia no encontrada" });
    }

    res.json(licencia);
  } catch (error) {
    console.error("Error al obtener licencia:", error);
    res
      .status(500)
      .json({ message: "Error al obtener licencia", error: error.message });
  }
};

// Crear una licencia
exports.create = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  try {
    const newLicencia = await Licencia.create(req.body);
      const licencia = await Licencia.findByPk(newLicencia.idLicencia, {
            include: [
                {
                    model: TipoLicencia,
                    as: 'TipoLicencium'
                },
                 {
                   model: Software,
                   as: 'software',
                     attributes: ['idSoftware','nombreSoftware', 'tipoSoftwareId', 'versionSoftware', 'requiereActualizacion','estaEnListaNegra', 'licenciaVinculadaSoftwareId', 'contratoVinculadoSoftwareId', 'softwareCreadoPorId','createdAt', 'updatedAt']
                }
            ]
        });
    res.status(201).json({ message: "Licencia creada correctamente", licencia });
  } catch (error) {
    console.error("Error al crear licencia:", error);
    res
      .status(500)
      .json({ message: "Error al crear licencia", error: error.message });
  }
};

// Actualizar una licencia
exports.update = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }
  
  try {
    const licencia = await Licencia.findByPk(req.params.id);
    if (!licencia) {
      return res.status(404).json({ message: "Licencia no encontrada" });
    }

    // Asegúrate de que 'maximoUsuarios' no sea nulo
    if (req.body.maximoUsuarios === null || req.body.maximoUsuarios === undefined) {
      req.body.maximoUsuarios = 0; // Valor predeterminado si no se proporciona
    }

    await licencia.update(req.body);
     const licenciaActualizada = await Licencia.findByPk(req.params.id, {
            include: [
                {
                    model: TipoLicencia,
                    as: 'TipoLicencium'
                },
                {
                    model: Software,
                    as: 'software',
                    attributes: ['idSoftware','nombreSoftware', 'tipoSoftwareId', 'versionSoftware', 'requiereActualizacion','estaEnListaNegra', 'licenciaVinculadaSoftwareId', 'contratoVinculadoSoftwareId', 'softwareCreadoPorId','createdAt', 'updatedAt']
                  }
            ]
        });
    res.json({ message: "Licencia actualizada correctamente", licencia: licenciaActualizada });
  } catch (error) {
    console.error("Error al actualizar licencia:", error);
    res.status(500).json({ message: "Error al actualizar licencia", error: error.message });
  }
};

// Eliminar una licencia
exports.delete = async (req, res) => {
  try {
    const licencia = await Licencia.findByPk(req.params.id);
    if (!licencia) {
      return res.status(404).json({ message: "Licencia no encontrada" });
    }
    await licencia.destroy();
    res.json({ message: "Licencia eliminada correctamente" });
  } catch (error) {
    console.error("Error al eliminar licencia:", error);
    res
      .status(500)
      .json({ message: "Error al eliminar licencia", error: error.message });
  }
};