-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-12-2024 a las 12:23:06
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gestion_activos`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `contratos`
--

CREATE TABLE `contratos` (
  `idContrato` int(11) NOT NULL,
  `nombreContrato` varchar(255) NOT NULL,
  `descripcionContrato` varchar(255) DEFAULT NULL,
  `tipoContratoId` int(11) NOT NULL,
  `fechaInicio` datetime NOT NULL,
  `fechaExpiracion` datetime NOT NULL,
  `proveedor` varchar(255) NOT NULL,
  `terminosGenerales` text DEFAULT NULL,
  `EstadoContrato` enum('Vigente','Expirado','Cancelado') NOT NULL,
  `ContratoCreadoPor` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `contratos`
--

INSERT INTO `contratos` (`idContrato`, `nombreContrato`, `descripcionContrato`, `tipoContratoId`, `fechaInicio`, `fechaExpiracion`, `proveedor`, `terminosGenerales`, `EstadoContrato`, `ContratoCreadoPor`, `createdAt`, `updatedAt`) VALUES
(7, ' Mantenimiento Preventivo de Equipos Informáticos', 'ontrato para realizar mantenimiento preventivo trimestral a todos los dispositivos informáticos de la empresa, con revisiones físicas y de software.', 1, '2023-05-01 00:00:00', '2025-05-01 00:00:00', 'TechSolutions S.A.', 'El proveedor se compromete a realizar inspecciones cada tres meses, actualizar el software de los dispositivos y ofrecer soporte para prevenir fallos. El contrato incluye un número limitado de visitas adicionales sin costo.', 'Vigente', 1, '2024-12-19 00:23:38', '2024-12-19 00:23:38'),
(8, 'Mantenimiento Preventivo de Servidores', 'Acuerdo para el mantenimiento preventivo de los servidores de la empresa, garantizando que los sistemas operativos y el hardware estén siempre actualizados.', 1, '2022-11-15 00:00:00', '2024-11-15 00:00:00', 'NetCare Services', 'Incluye dos visitas anuales para auditoría y mantenimiento de servidores, así como actualizaciones de seguridad del software. La empresa cliente debe notificar cualquier fallo para recibir soporte adicional.', 'Expirado', 1, '2024-12-19 00:24:36', '2024-12-19 00:24:36'),
(9, 'Mantenimiento Correctivo de Equipos de Red', 'Contrato para la reparación y solución de problemas de dispositivos de red en caso de fallos no programados.', 4, '2023-06-01 00:00:00', '2025-06-01 00:00:00', 'NetworkFix Inc.', 'El proveedor debe responder dentro de las 48 horas siguientes al reporte de un fallo y garantizar la reparación de los dispositivos en un plazo máximo de 5 días hábiles.', 'Vigente', 1, '2024-12-19 00:25:59', '2024-12-19 00:25:59'),
(10, 'Soporte Correctivo de Software Empresarial', 'Contrato que cubre la reparación de fallos en el software de gestión empresarial de la empresa, con asistencia inmediata ante cualquier incidencia grave.', 4, '2023-08-20 00:00:00', '2025-08-20 00:00:00', 'SoftRepair Ltd.', 'Incluye soporte técnico remoto y visitas presenciales si es necesario. El contrato cubre fallos de software que interrumpan las operaciones comerciales.', 'Vigente', 1, '2024-12-19 00:27:01', '2024-12-19 00:27:01'),
(11, 'Licencia de Uso de Microsoft Office 365', 'icencia anual para el uso de la suite de productividad Microsoft Office 365 para todos los empleados de la empresa.', 5, '2023-01-01 00:00:00', '2026-01-01 00:00:00', 'Microsoft Corp.', 'La licencia cubre el uso de Office 365 en hasta 500 dispositivos y la actualización automática de nuevas versiones de software. La empresa tiene derecho a instalar las aplicaciones en sus dispositivos corporativos y usar las herramientas colaborativas.', 'Vigente', 1, '2024-12-19 00:29:38', '2024-12-19 00:29:38'),
(12, 'Licencia de Software de Gestión ERP', 'Licencia de software para un sistema ERP utilizado por el departamento de finanzas y operaciones de la empresa.', 5, '2022-12-01 00:00:00', '2024-12-01 00:00:00', 'SAP SE', 'La licencia cubre la implementación del sistema ERP y el acceso a nuevas actualizaciones. El contrato es válido para 50 usuarios simultáneos y la empresa puede solicitar soporte técnico en caso de fallos.', 'Expirado', 1, '2024-12-19 00:30:57', '2024-12-19 00:30:57'),
(13, 'Soporte Técnico 24/7 para Infraestructura TI', 'Contrato de soporte continuo para resolver problemas técnicos en la infraestructura de TI de la empresa, disponible las 24 horas, los 7 días de la semana.', 1, '2023-03-01 00:00:00', '2024-03-01 00:00:00', 'ITSupport Pro', ' El proveedor debe garantizar asistencia inmediata a través de chat, teléfono o acceso remoto, y realizar intervenciones en el sitio cuando sea necesario. El contrato cubre problemas técnicos no relacionados con fallos de hardware.', 'Expirado', 1, '2024-12-19 00:32:03', '2024-12-19 00:32:03'),
(14, 'Soporte Técnico de Software CRM', ' Acuerdo para el soporte y mantenimiento del sistema de software CRM utilizado para gestionar las relaciones con clientes.', 6, '2022-09-15 00:00:00', '2025-09-15 00:00:00', 'SupportCo', 'Incluye soporte técnico remoto, actualizaciones de software y asistencia para la integración de nuevas funciones dentro del CRM. También cubre la corrección de errores y optimización de rendimiento.', 'Vigente', 1, '2024-12-19 00:33:12', '2024-12-19 00:33:12'),
(15, 'Actualización Anual de Software de Gestión', 'Contrato que cubre las actualizaciones anuales de los sistemas de software de gestión utilizados por la empresa, con la inclusión de nuevas características y mejoras.', 1, '2023-07-01 00:00:00', '2024-07-01 00:00:00', 'BusinessSoft', 'El proveedor actualizará todos los módulos del software una vez al año, asegurando la compatibilidad con los nuevos dispositivos y tecnologías. Las actualizaciones no incluyen nuevas funcionalidades que no estén especificadas en el contrato.', 'Vigente', 1, '2024-12-19 00:34:16', '2024-12-19 00:34:16'),
(16, 'Actualización de Seguridad de Software de Red', 'Contrato para recibir actualizaciones de seguridad regulares para el software de gestión de redes de la empresa, con un enfoque en proteger contra vulnerabilidades.', 1, '2023-02-01 00:00:00', '2025-02-01 00:00:00', 'SecureTech', 'El proveedor aplicará parches de seguridad críticos mensualmente, realizar auditorías de vulnerabilidades y ofrecer parches emergentes si se descubren amenazas nuevas.', 'Vigente', 1, '2024-12-19 00:35:10', '2024-12-19 00:35:10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dispositivos`
--

CREATE TABLE `dispositivos` (
  `idDispositivo` int(11) NOT NULL,
  `modeloDispositivoId` int(11) DEFAULT NULL,
  `numeroSerieDispositivo` varchar(255) NOT NULL,
  `ubicacionDispositivo` varchar(255) DEFAULT NULL,
  `usuarioAsignadoId` int(11) DEFAULT NULL,
  `dispositivoCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `estadoDispositivoId` int(11) DEFAULT NULL,
  `softwareInstaladoId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `dispositivos`
--

INSERT INTO `dispositivos` (`idDispositivo`, `modeloDispositivoId`, `numeroSerieDispositivo`, `ubicacionDispositivo`, `usuarioAsignadoId`, `dispositivoCreadoPorId`, `createdAt`, `updatedAt`, `estadoDispositivoId`, `softwareInstaladoId`) VALUES
(2, 1, 'SN-XYZ123', 'Oficina A', 1, 1, '2024-12-07 20:57:26', '2024-12-18 23:21:05', 1, 2),
(13, 2, 'F8GH3L9K10', 'Oficina Principal - Escritorio 12', NULL, 1, '2024-12-15 15:22:24', '2024-12-19 21:48:50', 4, NULL),
(14, 4, 'G7RT2N5M88', 'Sucursal Centro - Sala de Juntas', 13, 1, '2024-12-15 15:23:31', '2024-12-18 23:21:39', 4, NULL),
(15, 3, 'J5PL1K7X22', 'Oficina Principal - Sala de Diseño', NULL, 1, '2024-12-15 15:24:26', '2024-12-18 23:21:53', 5, NULL),
(16, 5, 'K9RT4Y3L67', 'Oficina Norte - Escritorio 5', NULL, 1, '2024-12-15 15:26:14', '2024-12-15 15:26:14', 1, NULL),
(17, 6, 'D2XF7L3M19', 'Oficina Principal - Puesto TI 01', NULL, 1, '2024-12-15 15:27:08', '2024-12-19 00:13:44', 10, NULL),
(18, 7, 'H8MK3J1T56', 'Oficina Sur - Laboratorio Técnico', NULL, 1, '2024-12-15 15:28:48', '2024-12-18 23:22:21', 10, 4),
(19, 8, 'L9WQ8R4N77', 'Oficina Principal - Gerencia General', NULL, 1, '2024-12-15 15:29:51', '2024-12-19 00:13:33', 10, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `dispositivosoftware`
--

CREATE TABLE `dispositivosoftware` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `idDispositivo` int(11) NOT NULL,
  `idSoftware` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estadosdispositivos`
--

CREATE TABLE `estadosdispositivos` (
  `idEstadoDispositivo` int(11) NOT NULL,
  `nombreEstadoDispositivo` varchar(255) NOT NULL,
  `descripcionEstadoDispositivo` varchar(255) DEFAULT NULL,
  `estadoDispositivoCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estadosdispositivos`
--

INSERT INTO `estadosdispositivos` (`idEstadoDispositivo`, `nombreEstadoDispositivo`, `descripcionEstadoDispositivo`, `estadoDispositivoCreadoPorId`, `createdAt`, `updatedAt`) VALUES
(1, 'En uso', 'Estado operativo', 1, '2024-12-07 20:45:04', '2024-12-07 20:45:04'),
(3, 'En mantenimiento', 'El dispositivo está siendo revisado o reparado, no está disponible para su uso', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(4, 'Disponible', 'El dispositivo está listo y operativo, pero no está asignado a ningún usuario o tarea específica', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(5, 'Fuera de servicio', 'El dispositivo no puede utilizarse debido a un daño o fallo crítico', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(6, 'En revisión', 'El dispositivo está siendo evaluado para identificar posibles fallos o necesidades de mantenimiento', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(8, 'En desuso', 'El dispositivo no está en uso, pero no ha sido dado de baja. Puede estar almacenado o en espera de ser reasignado', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(10, 'Pendiente de reparación', 'El dispositivo está en espera para iniciar el proceso de reparación', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00'),
(11, 'Extraviado', 'El dispositivo no está localizado y no se encuentra disponible para su uso', 1, '0000-00-00 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `licencias`
--

CREATE TABLE `licencias` (
  `idLicencia` int(11) NOT NULL,
  `nombreLicencia` varchar(255) NOT NULL,
  `descripcionLicencia` varchar(255) DEFAULT NULL,
  `tipoLicenciaId` int(11) NOT NULL,
  `fechaInicio` datetime NOT NULL,
  `fechaExpiracion` datetime NOT NULL,
  `estadoLicencia` enum('Activa','Inactiva','Expirada') NOT NULL DEFAULT 'Activa',
  `maximoUsuarios` int(11) NOT NULL DEFAULT 0,
  `softwareId` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `licencias`
--

INSERT INTO `licencias` (`idLicencia`, `nombreLicencia`, `descripcionLicencia`, `tipoLicenciaId`, `fechaInicio`, `fechaExpiracion`, `estadoLicencia`, `maximoUsuarios`, `softwareId`, `createdAt`, `updatedAt`) VALUES
(1, 'Licencia Premium', 'Licencia premium con todas las funcionalidades vieji', 1, '2024-12-18 00:00:00', '2025-12-19 00:00:00', 'Activa', 10, 2, '2024-12-08 19:40:11', '2024-12-19 02:45:12'),
(5, 'Microsoft Office Professional', 'icencia comercial para la suite de productividad de Microsoft Office. Incluye Word, Excel, PowerPoint, y más.', 1, '2023-01-15 00:00:00', '2026-01-15 00:00:00', 'Activa', 50, 4, '2024-12-19 02:58:18', '2024-12-19 02:58:18'),
(6, 'Adobe Photoshop Pro', 'Licencia comercial para la herramienta de edición de imágenes Photoshop.', 1, '2022-07-01 00:00:00', '2024-07-01 00:00:00', 'Expirada', 1, 5, '2024-12-19 02:59:30', '2024-12-19 02:59:30'),
(7, 'JetBrains PyCharm Professional', 'icencia para un solo desarrollador del entorno de desarrollo integrado (IDE) para Python.', 9, '2023-05-01 00:00:00', '2024-05-01 00:00:00', 'Activa', 1, 12, '2024-12-19 03:03:33', '2024-12-19 03:03:33'),
(8, 'Linux Ubuntu', 'Sistema operativo de código abierto basado en Linux, disponible para distribución y uso sin restricciones comerciales.', 13, '2004-10-20 00:00:00', '3004-10-20 00:00:00', 'Activa', 0, 3, '2024-12-19 03:04:42', '2024-12-19 03:04:42'),
(9, 'Apache HTTP Server', 'Software de servidor web de código abierto utilizado para alojar sitios web y aplicaciones.', 13, '1999-05-08 00:00:00', '2999-05-08 00:00:00', 'Activa', 0, 11, '2024-12-19 03:05:45', '2024-12-19 03:05:45'),
(10, 'Netflix Premium', 'Licencia de suscripción mensual para el servicio de streaming de videos con múltiples pantallas simultáneas.', 14, '2023-12-01 00:00:00', '2024-01-01 00:00:00', 'Activa', 4, 6, '2024-12-19 03:06:40', '2024-12-19 03:06:40'),
(11, 'Spotify Family', 'Licencia de suscripción para escuchar música en hasta 6 cuentas individuales.', 14, '2023-11-01 00:00:00', '2023-12-01 00:00:00', 'Expirada', 6, 9, '2024-12-19 03:07:33', '2024-12-19 03:07:33');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mantenimientos`
--

CREATE TABLE `mantenimientos` (
  `idMantenimiento` int(11) NOT NULL,
  `descripcionMantenimiento` varchar(255) DEFAULT NULL,
  `situacionMantenimiento` enum('Pendiente','En Progreso','Finalizado') NOT NULL,
  `prioridadMantenimiento` enum('Baja','Media','Alta') NOT NULL,
  `observacionesMantenimiento` varchar(255) DEFAULT NULL,
  `softwareAsociadoMantenimientoId` int(11) DEFAULT NULL,
  `dispositivoAsociadoMantenimientoId` int(11) DEFAULT NULL,
  `mantenimientoCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `mantenimientos`
--

INSERT INTO `mantenimientos` (`idMantenimiento`, `descripcionMantenimiento`, `situacionMantenimiento`, `prioridadMantenimiento`, `observacionesMantenimiento`, `softwareAsociadoMantenimientoId`, `dispositivoAsociadoMantenimientoId`, `mantenimientoCreadoPorId`, `createdAt`, `updatedAt`) VALUES
(21, '', 'Finalizado', 'Baja', '', 2, NULL, 1, '2024-12-16 20:25:24', '2024-12-16 20:25:46'),
(22, '', 'Finalizado', 'Baja', '', NULL, 2, 1, '2024-12-16 20:35:02', '2024-12-16 20:35:35'),
(23, '', 'Finalizado', 'Baja', '', 2, NULL, 1, '2024-12-16 20:35:18', '2024-12-16 20:36:15'),
(24, '', 'Finalizado', 'Baja', '', 2, NULL, 1, '2024-12-16 20:39:22', '2024-12-16 20:39:41'),
(25, '', 'Finalizado', 'Baja', '', 2, NULL, 1, '2024-12-16 20:41:11', '2024-12-16 20:41:27'),
(26, '', 'Finalizado', 'Baja', '', NULL, 13, 1, '2024-12-19 21:48:26', '2024-12-19 21:48:50');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modelosdispositivos`
--

CREATE TABLE `modelosdispositivos` (
  `idModeloDispositivo` int(11) NOT NULL,
  `nombreModeloDispositivo` varchar(255) NOT NULL,
  `marca` varchar(255) NOT NULL,
  `descripcionModeloDispositivo` varchar(255) DEFAULT NULL,
  `cantidadEnInventario` int(11) NOT NULL DEFAULT 0,
  `modeloDispositivoCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `tipoDispositivoId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `modelosdispositivos`
--

INSERT INTO `modelosdispositivos` (`idModeloDispositivo`, `nombreModeloDispositivo`, `marca`, `descripcionModeloDispositivo`, `cantidadEnInventario`, `modeloDispositivoCreadoPorId`, `createdAt`, `updatedAt`, `tipoDispositivoId`) VALUES
(1, 'ThinkPad X1 Carbon', 'Lenovo', 'Laptop de gama alta', 1, 1, '2024-12-07 20:45:43', '2024-12-19 21:41:20', 1),
(2, 'iPhone 15 Pro', 'Apple', 'Smartphone de alta gama con pantalla Super Retina XDR, procesador A17 Pro, y sistema de cámaras avanzado. Diseñado para un rendimiento excepcional en fotografía, juegos, y productividad.', 1, 1, '2024-12-15 14:08:36', '2024-12-15 15:22:24', 5),
(3, 'iPad Pro 12.9', 'Apple', 'Tableta premium con pantalla Liquid Retina XDR, chip M2, y compatibilidad con Apple Pencil. Ideal para diseño gráfico, edición de video y productividad avanzada.', 1, 1, '2024-12-15 15:15:05', '2024-12-15 15:24:27', 3),
(4, 'Galaxy S23 Ultra', 'Samsung', 'Smartphone con pantalla AMOLED de 6.8\", S Pen integrado, y cámaras de hasta 200 MP. Perfecto para usuarios exigentes en diseño y productividad.', 1, 1, '2024-12-15 15:15:51', '2024-12-15 15:23:31', 5),
(5, 'Galaxy Tab S9', 'Samsung', 'Tableta con pantalla AMOLED, procesador Snapdragon 8 Gen 2, y diseño ultraligero. Ofrece un equilibrio perfecto entre entretenimiento y productividad.', 1, 1, '2024-12-15 15:16:49', '2024-12-15 15:26:14', 3),
(6, 'iMac 24', 'Apple', 'Computadora de escritorio todo en uno con pantalla Retina 4.5K, chip M1, y diseño compacto. Ideal para tareas creativas y de oficina.', 1, 1, '2024-12-15 15:17:41', '2024-12-15 15:27:08', 4),
(7, 'Dell OptiPlex 7000', 'Dell', 'Computadora de escritorio modular con procesadores Intel Core de última generación, múltiples configuraciones y opciones de expansión. Diseñada para empresas y usuarios profesionales.', 1, 1, '2024-12-15 15:18:16', '2024-12-15 15:28:48', 4),
(8, 'MacBook Pro 16\"', 'Apple', 'Laptop de alto rendimiento con pantalla Liquid Retina XDR, chip M3 Pro/Max, y batería de larga duración. Ideal para profesionales creativos y tareas intensivas.', 3, 1, '2024-12-15 15:19:00', '2024-12-15 15:29:52', 1),
(9, 'Lenovo ThinkPad X1 Carbon', 'Lenovo', 'Laptop ultraligera con procesador Intel Core i7, batería de larga duración, y diseño robusto. Diseñada para usuarios de negocios y movilidad extrema.', 2, 1, '2024-12-15 15:19:35', '2024-12-15 15:19:35', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `plataformas`
--

CREATE TABLE `plataformas` (
  `idPlataforma` int(11) NOT NULL,
  `nombrePlataforma` varchar(255) NOT NULL,
  `descripcionPlataforma` varchar(255) DEFAULT NULL,
  `plataFormaCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idRol` int(11) NOT NULL,
  `nombreRol` varchar(255) NOT NULL,
  `descripcionRol` varchar(255) DEFAULT NULL,
  `permisoContratoCreacion` tinyint(1) DEFAULT 0,
  `permisoContratoEdicion` tinyint(1) DEFAULT 0,
  `permisoContratoVisualizacion` tinyint(1) DEFAULT 0,
  `permisoContratoEliminacion` tinyint(1) DEFAULT 0,
  `permisoTipoContratoCreacion` tinyint(1) DEFAULT 0,
  `permisoTipoContratoEdicion` tinyint(1) DEFAULT 0,
  `permisoTipoContratoVisualizacion` tinyint(1) DEFAULT 0,
  `permisoTipoContratoEliminacion` tinyint(1) DEFAULT 0,
  `permisoLicenciaCreacion` tinyint(1) DEFAULT 0,
  `permisoLicenciaEdicion` tinyint(1) DEFAULT 0,
  `permisoLicenciaVisualizacion` tinyint(1) DEFAULT 0,
  `permisoLicenciaEliminacion` tinyint(1) DEFAULT 0,
  `permisoTipoLicenciaCreacion` tinyint(1) DEFAULT 0,
  `permisoTipoLicenciaEdicion` tinyint(1) DEFAULT 0,
  `permisoTipoLicenciaVisualizacion` tinyint(1) DEFAULT 0,
  `permisoTipoLicenciaEliminacion` tinyint(1) DEFAULT 0,
  `permisoModeloDispositivoCreacion` tinyint(1) DEFAULT 0,
  `permisoModeloDispositivoEdicion` tinyint(1) DEFAULT 0,
  `permisoModeloDispositivoVisualizacion` tinyint(1) DEFAULT 0,
  `permisoModeloDispositivoEliminacion` tinyint(1) DEFAULT 0,
  `permisoDispositivoCreacion` tinyint(1) DEFAULT 0,
  `permisoDispositivoEdicion` tinyint(1) DEFAULT 0,
  `permisoDispositivoVisualizacion` tinyint(1) DEFAULT 0,
  `permisoDispositivoEliminacion` tinyint(1) DEFAULT 0,
  `permisoTipoDispositivoCreacion` tinyint(1) DEFAULT 0,
  `permisoTipoDispositivoEdicion` tinyint(1) DEFAULT 0,
  `permisoTipoDispositivoVisualizacion` tinyint(1) DEFAULT 0,
  `permisoTipoDispositivoEliminacion` tinyint(1) DEFAULT 0,
  `permisoSoftwareCreacion` tinyint(1) DEFAULT 0,
  `permisoSoftwareEdicion` tinyint(1) DEFAULT 0,
  `permisoSoftwareVisualizacion` tinyint(1) DEFAULT 0,
  `permisoSoftwareEliminacion` tinyint(1) DEFAULT 0,
  `permisoTipoSoftwareCreacion` tinyint(1) DEFAULT 0,
  `permisoTipoSoftwareEdicion` tinyint(1) DEFAULT 0,
  `permisoTipoSoftwareVisualizacion` tinyint(1) DEFAULT 0,
  `permisoTipoSoftwareEliminacion` tinyint(1) DEFAULT 0,
  `permisoMantenimientoCreacion` tinyint(1) DEFAULT 0,
  `permisoMantenimientoEdicion` tinyint(1) DEFAULT 0,
  `permisoMantenimientoVisualizacion` tinyint(1) DEFAULT 0,
  `permisoMantenimientoEliminacion` tinyint(1) DEFAULT 0,
  `permisoUsuarioCreacion` tinyint(1) DEFAULT 0,
  `permisoUsuarioEdicion` tinyint(1) DEFAULT 0,
  `permisoUsuarioVisualizacion` tinyint(1) DEFAULT 0,
  `permisoUsuarioEliminacion` tinyint(1) DEFAULT 0,
  `permisoRolCreacion` tinyint(1) DEFAULT 0,
  `permisoRolEdicion` tinyint(1) DEFAULT 0,
  `permisoRolVisualizacion` tinyint(1) DEFAULT 0,
  `permisoRolEliminacion` tinyint(1) DEFAULT 0,
  `permisoPlataformaCreacion` tinyint(1) DEFAULT 0,
  `permisoPlataformaEdicion` tinyint(1) DEFAULT 0,
  `permisoPlataformaVisualizacion` tinyint(1) DEFAULT 0,
  `permisoPlataformaEliminacion` tinyint(1) DEFAULT 0,
  `permisoEstadoDispositivoCreacion` tinyint(1) DEFAULT 0,
  `permisoEstadoDispositivoEdicion` tinyint(1) DEFAULT 0,
  `permisoEstadoDispositivoVisualizacion` tinyint(1) DEFAULT 0,
  `permisoEstadoDispositivoEliminacion` tinyint(1) DEFAULT 0,
  `permisoAlertaCreacion` tinyint(1) DEFAULT 0,
  `permisoAlertaEdicion` tinyint(1) DEFAULT 0,
  `permisoAlertaVisualizacion` tinyint(1) DEFAULT 0,
  `permisoAlertaEliminacion` tinyint(1) DEFAULT 0,
  `RolCreadoPor` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idRol`, `nombreRol`, `descripcionRol`, `permisoContratoCreacion`, `permisoContratoEdicion`, `permisoContratoVisualizacion`, `permisoContratoEliminacion`, `permisoTipoContratoCreacion`, `permisoTipoContratoEdicion`, `permisoTipoContratoVisualizacion`, `permisoTipoContratoEliminacion`, `permisoLicenciaCreacion`, `permisoLicenciaEdicion`, `permisoLicenciaVisualizacion`, `permisoLicenciaEliminacion`, `permisoTipoLicenciaCreacion`, `permisoTipoLicenciaEdicion`, `permisoTipoLicenciaVisualizacion`, `permisoTipoLicenciaEliminacion`, `permisoModeloDispositivoCreacion`, `permisoModeloDispositivoEdicion`, `permisoModeloDispositivoVisualizacion`, `permisoModeloDispositivoEliminacion`, `permisoDispositivoCreacion`, `permisoDispositivoEdicion`, `permisoDispositivoVisualizacion`, `permisoDispositivoEliminacion`, `permisoTipoDispositivoCreacion`, `permisoTipoDispositivoEdicion`, `permisoTipoDispositivoVisualizacion`, `permisoTipoDispositivoEliminacion`, `permisoSoftwareCreacion`, `permisoSoftwareEdicion`, `permisoSoftwareVisualizacion`, `permisoSoftwareEliminacion`, `permisoTipoSoftwareCreacion`, `permisoTipoSoftwareEdicion`, `permisoTipoSoftwareVisualizacion`, `permisoTipoSoftwareEliminacion`, `permisoMantenimientoCreacion`, `permisoMantenimientoEdicion`, `permisoMantenimientoVisualizacion`, `permisoMantenimientoEliminacion`, `permisoUsuarioCreacion`, `permisoUsuarioEdicion`, `permisoUsuarioVisualizacion`, `permisoUsuarioEliminacion`, `permisoRolCreacion`, `permisoRolEdicion`, `permisoRolVisualizacion`, `permisoRolEliminacion`, `permisoPlataformaCreacion`, `permisoPlataformaEdicion`, `permisoPlataformaVisualizacion`, `permisoPlataformaEliminacion`, `permisoEstadoDispositivoCreacion`, `permisoEstadoDispositivoEdicion`, `permisoEstadoDispositivoVisualizacion`, `permisoEstadoDispositivoEliminacion`, `permisoAlertaCreacion`, `permisoAlertaEdicion`, `permisoAlertaVisualizacion`, `permisoAlertaEliminacion`, `RolCreadoPor`, `createdAt`, `updatedAt`) VALUES
(1, 'Administrador', 'Tiene todos los permisos', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, NULL, '2024-12-07 21:19:13', '2024-12-07 21:19:13'),
(8, 'Visualizer', 'Visualiza todo', 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, '2024-12-14 14:26:12', '2024-12-14 14:59:42'),
(9, 'Encargado de Mantenimiento', 'Gestiona el mantenimiento de dispositivos y software.', 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, '2024-12-14 14:38:20', '2024-12-14 14:46:40'),
(10, 'Contract Manager', 'Gestiona contratos, puede visualizar el resto.', 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, '2024-12-19 19:37:37', '2024-12-19 19:38:09');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `software`
--

CREATE TABLE `software` (
  `idSoftware` int(11) NOT NULL,
  `nombreSoftware` varchar(255) NOT NULL,
  `tipoSoftwareId` int(11) DEFAULT NULL,
  `versionSoftware` varchar(255) NOT NULL,
  `requiereActualizacion` tinyint(1) DEFAULT 0,
  `estaEnListaNegra` tinyint(1) DEFAULT 0,
  `licenciaVinculadaSoftwareId` int(11) DEFAULT NULL,
  `contratoVinculadoSoftwareId` int(11) DEFAULT NULL,
  `softwareCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `softwareId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `software`
--

INSERT INTO `software` (`idSoftware`, `nombreSoftware`, `tipoSoftwareId`, `versionSoftware`, `requiereActualizacion`, `estaEnListaNegra`, `licenciaVinculadaSoftwareId`, `contratoVinculadoSoftwareId`, `softwareCreadoPorId`, `createdAt`, `updatedAt`, `softwareId`) VALUES
(2, 'Windows 11 Pro', 1, 'Versión 22H2', 1, 0, NULL, NULL, 1, '2024-12-15 17:21:57', '2024-12-18 23:36:13', NULL),
(3, 'Ubuntu', 1, 'Versión 22.04 LTS (Jammy Jellyfish)', 0, 0, NULL, NULL, 1, '2024-12-15 17:22:41', '2024-12-16 20:14:01', NULL),
(4, 'Microsoft Word', 2, 'Versión 2021 (Microsoft Office LTSC)', 0, 1, NULL, NULL, 1, '2024-12-15 17:23:45', '2024-12-19 00:11:57', NULL),
(5, 'Adobe Photoshop', 2, 'Versión 25.0.1 (Creative Cloud 2024)', 0, 0, NULL, NULL, 1, '2024-12-15 17:24:17', '2024-12-15 17:24:17', NULL),
(6, 'MySQL', 3, 'Versión 8.0.34', 1, 1, NULL, NULL, 1, '2024-12-15 17:24:50', '2024-12-19 00:12:11', NULL),
(7, 'MongoDB', 3, 'Versión 6.0.5', 0, 0, NULL, NULL, 1, '2024-12-15 17:25:24', '2024-12-15 17:25:24', NULL),
(8, 'Norton 360', 4, 'Versión 23.9.4.5', 0, 1, NULL, NULL, 1, '2024-12-15 17:26:19', '2024-12-19 00:12:19', NULL),
(9, 'Bitdefender Total Security', 4, 'Versión 27.0.1.33', 0, 0, NULL, NULL, 1, '2024-12-15 17:27:01', '2024-12-15 17:27:01', NULL),
(10, 'VMware Workstation Pro', 5, 'Versión 17.0.2', 1, 0, NULL, NULL, 1, '2024-12-15 17:27:51', '2024-12-19 00:12:30', NULL),
(11, 'Docker', 5, 'Versión 24.0.6', 0, 0, NULL, NULL, 1, '2024-12-15 17:28:30', '2024-12-16 19:57:49', NULL),
(12, 'JetBrains PyCharm Professional', 2, '5.5', 0, 0, NULL, NULL, 1, '2024-12-19 03:02:02', '2024-12-19 03:02:02', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `softwareplataforma`
--

CREATE TABLE `softwareplataforma` (
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL,
  `idSoftware` int(11) NOT NULL,
  `idPlataforma` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tiposdispositivos`
--

CREATE TABLE `tiposdispositivos` (
  `idTipoDispositivo` int(11) NOT NULL,
  `nombreTipoDispositivo` varchar(255) NOT NULL,
  `descripcionTipoDispositivo` varchar(255) DEFAULT NULL,
  `tipoDispositivoCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tiposdispositivos`
--

INSERT INTO `tiposdispositivos` (`idTipoDispositivo`, `nombreTipoDispositivo`, `descripcionTipoDispositivo`, `tipoDispositivoCreadoPorId`, `createdAt`, `updatedAt`) VALUES
(1, 'Laptop', 'Computadora portátil. Equipo informático portátil con diseño compacto y funcionalidad completa. Combina potencia y movilidad, ideal para tareas laborales, académicas o de entretenimiento en cualquier lugar. ', 1, '2024-12-07 20:44:21', '2024-12-15 13:14:21'),
(3, 'Tablet', 'Tableta. Dispositivo portátil de pantalla táctil más grande que un móvil, pero más pequeño que una laptop. Perfecto para leer, ver contenido multimedia, y realizar tareas ligeras de oficina o diseño.', 1, '2024-12-15 12:59:40', '2024-12-15 13:11:20'),
(4, 'PC de Escritorio', 'Computadora de Escritorio. Sistema informático de alto rendimiento diseñado para uso fijo. Ofrece gran capacidad de procesamiento, almacenamiento y personalización.', 1, '2024-12-15 13:12:14', '2024-12-15 13:13:55'),
(5, 'Móvil', 'Dispositivo Móvil. Dispositivo compacto diseñado para ser portátil, con funcionalidades avanzadas como conectividad móvil, cámara, y acceso a aplicaciones. Ideal para comunicación, entretenimiento, y trabajo básico en movimiento. ', 1, '2024-12-15 13:15:11', '2024-12-15 13:15:11');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipossoftware`
--

CREATE TABLE `tipossoftware` (
  `idTipoSoftware` int(11) NOT NULL,
  `nombreTipoSoftware` varchar(255) NOT NULL,
  `descripcionTipoSoftware` varchar(255) DEFAULT NULL,
  `tipoSoftwareCreadoPorId` int(11) DEFAULT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipossoftware`
--

INSERT INTO `tipossoftware` (`idTipoSoftware`, `nombreTipoSoftware`, `descripcionTipoSoftware`, `tipoSoftwareCreadoPorId`, `createdAt`, `updatedAt`) VALUES
(1, 'Sistema Operativo', 'Software base que actúa como intermediario entre el hardware y las aplicaciones, gestionando los recursos del sistema como memoria, procesadores y dispositivos periféricos. Es esencial para el funcionamiento del equipo y proporciona una interfaz', 1, '2024-12-07 20:54:14', '2024-12-15 17:09:39'),
(2, 'Software de Aplicación', 'Programas diseñados para realizar tareas específicas para los usuarios, como procesamiento de texto, hojas de cálculo, diseño gráfico o gestión de proyectos. Este software depende del sistema operativo para ejecutarse.', 1, '2024-12-15 17:02:28', '2024-12-15 17:02:28'),
(3, 'Software de Gestión de Base de Datos', 'Software especializado para crear, gestionar y mantener bases de datos. Permite almacenar, organizar y consultar grandes volúmenes de datos de manera eficiente y segura, siendo clave en aplicaciones empresariales.', 1, '2024-12-15 17:03:05', '2024-12-15 17:03:05'),
(4, 'Software de Seguridad', 'Programas diseñados para proteger sistemas y datos contra amenazas como malware, accesos no autorizados y vulnerabilidades. Incluye antivirus, firewalls y herramientas de cifrado.', 1, '2024-12-15 17:03:27', '2024-12-15 17:10:28'),
(5, 'Software de Virtualización', 'Herramientas que permiten crear y ejecutar máquinas virtuales, separando el hardware físico del software. Es utilizado en entornos de prueba, servidores y computación en la nube para optimizar recursos.', 1, '2024-12-15 17:03:50', '2024-12-15 17:34:52');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_contratos`
--

CREATE TABLE `tipo_contratos` (
  `idTipoContrato` int(11) NOT NULL,
  `nombreTipoContrato` varchar(255) NOT NULL,
  `descripcionTipoContrato` varchar(255) NOT NULL,
  `tipoContratoCreadoPor` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_contratos`
--

INSERT INTO `tipo_contratos` (`idTipoContrato`, `nombreTipoContrato`, `descripcionTipoContrato`, `tipoContratoCreadoPor`, `createdAt`, `updatedAt`) VALUES
(1, 'Contrato de Mantenimiento Preventivo', 'Contrato que cubre la ejecución de tareas programadas para prevenir fallos en los equipos y sistemas de software. Incluye revisiones periódicas, actualizaciones de software y verificaciones de hardware para mantener los dispositivos en condiciones óptimas', 1, '2024-12-08 18:54:56', '2024-12-19 00:17:53'),
(4, 'Contrato de Mantenimiento Correctivo', 'ontrato que cubre la reparación y resolución de fallos imprevistos en equipos de hardware o software. Este contrato entra en vigor cuando un dispositivo o sistema presenta problemas que requieren intervención urgente para su reparación o restauración a su', 1, '2024-12-19 00:18:16', '2024-12-19 00:18:16'),
(5, 'Contrato de Licencia de Software', 'Contrato que establece los términos y condiciones bajo los cuales una empresa puede utilizar un software específico. Incluye detalles sobre la duración de la licencia, el número de usuarios permitidos, la distribución y las restricciones del uso del softw', 1, '2024-12-19 00:18:45', '2024-12-19 00:18:45'),
(6, 'Contrato de Soporte Técnico', 'Contrato que proporciona asistencia continua y resolución de problemas en tiempo real para software y dispositivos. Abarca servicios como el soporte remoto, la atención telefónica, y la resolución de incidencias a nivel de sistema, incluyendo parches y ac', 1, '2024-12-19 00:19:08', '2024-12-19 00:19:08'),
(7, 'Contrato de Actualización de Software', 'Contrato que garantiza las actualizaciones regulares de software, asegurando que los dispositivos y sistemas estén siempre al día con las últimas versiones y mejoras. Esto incluye tanto actualizaciones de seguridad como nuevas funcionalidades.', 1, '2024-12-19 00:19:30', '2024-12-19 00:19:30');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tipo_licencias`
--

CREATE TABLE `tipo_licencias` (
  `idTipoLicencia` int(11) NOT NULL,
  `nombreTipoLicencia` varchar(255) NOT NULL,
  `descripcionTipoLicencia` varchar(255) NOT NULL,
  `tipoLicenciaCreadaPor` int(11) NOT NULL,
  `createdAt` datetime NOT NULL,
  `updatedAt` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `tipo_licencias`
--

INSERT INTO `tipo_licencias` (`idTipoLicencia`, `nombreTipoLicencia`, `descripcionTipoLicencia`, `tipoLicenciaCreadaPor`, `createdAt`, `updatedAt`) VALUES
(1, 'Licencia Comercial', 'Licencia que permite el uso del software con fines comerciales, es decir, para generar ingresos o utilizar el software en actividades empresariales. Esta licencia generalmente incluye el derecho a distribuir, modificar o adaptar el software para su uso en', 1, '2024-12-11 20:34:22', '2024-12-19 01:21:51'),
(9, 'Licencia de Usuario Único', 'Licencia que permite a una sola persona utilizar el software en un solo dispositivo. Esta licencia es ideal para usuarios individuales o pequeñas empresas que no requieren múltiples instalaciones o usuarios concurrentes.', 1, '2024-12-19 01:22:11', '2024-12-19 01:22:11'),
(13, 'Licencia de Código Abierto', ' Licencia que permite al usuario no solo usar el software, sino también modificarlo, distribuirlo y compartirlo libremente bajo los términos definidos por el proveedor. El código fuente está disponible para ser modificado por cualquier persona.', 1, '2024-12-19 01:34:22', '2024-12-19 01:34:22'),
(14, 'Licencia por Suscripción', 'Licencia que otorga el uso del software durante un periodo determinado, generalmente anual o mensual. La renovación de la licencia depende del pago periódico y suele incluir actualizaciones y soporte técnico durante la duración de la suscripción.', 1, '2024-12-19 01:37:13', '2024-12-19 01:37:13'),
(15, 'Licencia OEM (Original Equipment Manufacturer)', 'Licencia otorgada a fabricantes de hardware o distribuidores para preinstalar el software en sus productos. Esta licencia generalmente es más barata que una licencia de usuario individual y está restringida al uso con el hardware específico con el que fue', 1, '2024-12-19 01:42:00', '2024-12-19 01:42:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idUsuario` int(11) NOT NULL,
  `nombreUsuario` varchar(255) NOT NULL,
  `correoElectronicoUsuario` varchar(255) NOT NULL,
  `passwordUsuario` varchar(255) NOT NULL,
  `rolId` int(11) DEFAULT NULL,
  `fechaCreacion` datetime NOT NULL,
  `fechaActualizacion` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idUsuario`, `nombreUsuario`, `correoElectronicoUsuario`, `passwordUsuario`, `rolId`, `fechaCreacion`, `fechaActualizacion`) VALUES
(1, 'Test User', 'test@example.com', '$2a$10$OEGz5C2S1QlzlaViFFOYROYj7WGqg840J5sEWbxlBuUhkLxpxKvcG', 1, '2024-12-07 20:29:20', '2024-12-19 22:35:38'),
(13, 'pedro', 'pedro@mail.com', '$2a$10$H6itPkfKEaypusSRgKiqSOrT5SJpdYjEZZUfunp4Di56xurNjMOYu', 8, '2024-12-13 17:45:18', '2024-12-14 14:58:44'),
(14, 'Mary', 'maria@mail.com', '$2a$10$P49wWXL01qGPE8sHHkyP1OZ4IFzcH9T35mI.NLyMGeakWp6ObtO0i', 10, '2024-12-19 19:38:40', '2024-12-19 22:30:45');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD PRIMARY KEY (`idContrato`),
  ADD KEY `tipoContratoId` (`tipoContratoId`);

--
-- Indices de la tabla `dispositivos`
--
ALTER TABLE `dispositivos`
  ADD PRIMARY KEY (`idDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_2` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_3` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_4` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_5` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_6` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_7` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_8` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_9` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_10` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_11` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_12` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_13` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_14` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_15` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_16` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_17` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_18` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_19` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_20` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_21` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_22` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_23` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_24` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_25` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_26` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_27` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_28` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_29` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_30` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_31` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_32` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_33` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_34` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_35` (`numeroSerieDispositivo`),
  ADD UNIQUE KEY `numeroSerieDispositivo_36` (`numeroSerieDispositivo`),
  ADD KEY `modeloDispositivoId` (`modeloDispositivoId`),
  ADD KEY `estadoDispositivoId` (`estadoDispositivoId`),
  ADD KEY `softwareInstaladoId` (`softwareInstaladoId`);

--
-- Indices de la tabla `dispositivosoftware`
--
ALTER TABLE `dispositivosoftware`
  ADD PRIMARY KEY (`idDispositivo`,`idSoftware`),
  ADD KEY `idSoftware` (`idSoftware`);

--
-- Indices de la tabla `estadosdispositivos`
--
ALTER TABLE `estadosdispositivos`
  ADD PRIMARY KEY (`idEstadoDispositivo`);

--
-- Indices de la tabla `licencias`
--
ALTER TABLE `licencias`
  ADD PRIMARY KEY (`idLicencia`),
  ADD KEY `softwareId` (`softwareId`),
  ADD KEY `tipoLicenciaId` (`tipoLicenciaId`);

--
-- Indices de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD PRIMARY KEY (`idMantenimiento`),
  ADD KEY `softwareAsociadoMantenimientoId` (`softwareAsociadoMantenimientoId`),
  ADD KEY `dispositivoAsociadoMantenimientoId` (`dispositivoAsociadoMantenimientoId`);

--
-- Indices de la tabla `modelosdispositivos`
--
ALTER TABLE `modelosdispositivos`
  ADD PRIMARY KEY (`idModeloDispositivo`),
  ADD KEY `tipoDispositivoId` (`tipoDispositivoId`);

--
-- Indices de la tabla `plataformas`
--
ALTER TABLE `plataformas`
  ADD PRIMARY KEY (`idPlataforma`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRol`),
  ADD KEY `RolCreadoPor` (`RolCreadoPor`);

--
-- Indices de la tabla `software`
--
ALTER TABLE `software`
  ADD PRIMARY KEY (`idSoftware`),
  ADD KEY `software_softwareId_foreign_idx` (`softwareId`),
  ADD KEY `tipoSoftwareId` (`tipoSoftwareId`);

--
-- Indices de la tabla `softwareplataforma`
--
ALTER TABLE `softwareplataforma`
  ADD PRIMARY KEY (`idSoftware`,`idPlataforma`),
  ADD KEY `idPlataforma` (`idPlataforma`);

--
-- Indices de la tabla `tiposdispositivos`
--
ALTER TABLE `tiposdispositivos`
  ADD PRIMARY KEY (`idTipoDispositivo`);

--
-- Indices de la tabla `tipossoftware`
--
ALTER TABLE `tipossoftware`
  ADD PRIMARY KEY (`idTipoSoftware`);

--
-- Indices de la tabla `tipo_contratos`
--
ALTER TABLE `tipo_contratos`
  ADD PRIMARY KEY (`idTipoContrato`);

--
-- Indices de la tabla `tipo_licencias`
--
ALTER TABLE `tipo_licencias`
  ADD PRIMARY KEY (`idTipoLicencia`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_2` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_3` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_4` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_5` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_6` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_7` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_8` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_9` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_10` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_11` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_12` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_13` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_14` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_15` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_16` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_17` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_18` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_19` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_20` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_21` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_22` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_23` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_24` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_25` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_26` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_27` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_28` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_29` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_30` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_31` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_32` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_33` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_34` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_35` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_36` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_37` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_38` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_39` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_40` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_41` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_42` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_43` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_44` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_45` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_46` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_47` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_48` (`correoElectronicoUsuario`),
  ADD UNIQUE KEY `correoElectronicoUsuario_49` (`correoElectronicoUsuario`),
  ADD KEY `rolId` (`rolId`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `contratos`
--
ALTER TABLE `contratos`
  MODIFY `idContrato` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT de la tabla `dispositivos`
--
ALTER TABLE `dispositivos`
  MODIFY `idDispositivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT de la tabla `estadosdispositivos`
--
ALTER TABLE `estadosdispositivos`
  MODIFY `idEstadoDispositivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `licencias`
--
ALTER TABLE `licencias`
  MODIFY `idLicencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  MODIFY `idMantenimiento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `modelosdispositivos`
--
ALTER TABLE `modelosdispositivos`
  MODIFY `idModeloDispositivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `plataformas`
--
ALTER TABLE `plataformas`
  MODIFY `idPlataforma` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idRol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `software`
--
ALTER TABLE `software`
  MODIFY `idSoftware` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de la tabla `tiposdispositivos`
--
ALTER TABLE `tiposdispositivos`
  MODIFY `idTipoDispositivo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `tipossoftware`
--
ALTER TABLE `tipossoftware`
  MODIFY `idTipoSoftware` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `tipo_contratos`
--
ALTER TABLE `tipo_contratos`
  MODIFY `idTipoContrato` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de la tabla `tipo_licencias`
--
ALTER TABLE `tipo_licencias`
  MODIFY `idTipoLicencia` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `contratos`
--
ALTER TABLE `contratos`
  ADD CONSTRAINT `contratos_ibfk_1` FOREIGN KEY (`tipoContratoId`) REFERENCES `tipo_contratos` (`idTipoContrato`) ON DELETE NO ACTION ON UPDATE CASCADE;

--
-- Filtros para la tabla `dispositivos`
--
ALTER TABLE `dispositivos`
  ADD CONSTRAINT `dispositivos_ibfk_106` FOREIGN KEY (`modeloDispositivoId`) REFERENCES `modelosdispositivos` (`idModeloDispositivo`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `dispositivos_ibfk_107` FOREIGN KEY (`estadoDispositivoId`) REFERENCES `estadosdispositivos` (`idEstadoDispositivo`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `dispositivos_ibfk_108` FOREIGN KEY (`softwareInstaladoId`) REFERENCES `software` (`idSoftware`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `dispositivosoftware`
--
ALTER TABLE `dispositivosoftware`
  ADD CONSTRAINT `dispositivosoftware_ibfk_1` FOREIGN KEY (`idDispositivo`) REFERENCES `dispositivos` (`idDispositivo`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `dispositivosoftware_ibfk_2` FOREIGN KEY (`idSoftware`) REFERENCES `software` (`idSoftware`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `licencias`
--
ALTER TABLE `licencias`
  ADD CONSTRAINT `licencias_ibfk_22` FOREIGN KEY (`softwareId`) REFERENCES `software` (`idSoftware`) ON DELETE NO ACTION ON UPDATE CASCADE,
  ADD CONSTRAINT `licencias_ibfk_23` FOREIGN KEY (`tipoLicenciaId`) REFERENCES `tipo_licencias` (`idTipoLicencia`);

--
-- Filtros para la tabla `mantenimientos`
--
ALTER TABLE `mantenimientos`
  ADD CONSTRAINT `mantenimientos_ibfk_71` FOREIGN KEY (`softwareAsociadoMantenimientoId`) REFERENCES `software` (`idSoftware`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `mantenimientos_ibfk_72` FOREIGN KEY (`dispositivoAsociadoMantenimientoId`) REFERENCES `dispositivos` (`idDispositivo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `modelosdispositivos`
--
ALTER TABLE `modelosdispositivos`
  ADD CONSTRAINT `modelosdispositivos_ibfk_1` FOREIGN KEY (`tipoDispositivoId`) REFERENCES `tiposdispositivos` (`idTipoDispositivo`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `roles`
--
ALTER TABLE `roles`
  ADD CONSTRAINT `roles_ibfk_1` FOREIGN KEY (`RolCreadoPor`) REFERENCES `usuarios` (`idUsuario`);

--
-- Filtros para la tabla `software`
--
ALTER TABLE `software`
  ADD CONSTRAINT `software_ibfk_1` FOREIGN KEY (`tipoSoftwareId`) REFERENCES `tipossoftware` (`idTipoSoftware`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `software_softwareId_foreign_idx` FOREIGN KEY (`softwareId`) REFERENCES `licencias` (`idLicencia`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Filtros para la tabla `softwareplataforma`
--
ALTER TABLE `softwareplataforma`
  ADD CONSTRAINT `softwareplataforma_ibfk_1` FOREIGN KEY (`idSoftware`) REFERENCES `software` (`idSoftware`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `softwareplataforma_ibfk_2` FOREIGN KEY (`idPlataforma`) REFERENCES `plataformas` (`idPlataforma`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`rolId`) REFERENCES `roles` (`idRol`) ON DELETE NO ACTION ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
