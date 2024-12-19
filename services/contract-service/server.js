const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { sequelize } = require('./models');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3003; // Elige el puerto para tu servicio de contrato

// Configuración de CORS (Importante: antes de las rutas)
const allowedOrigins = ['*']; // Reemplaza con el origen de tu frontend en producción. Usa ['*'] para desarrollo.
// const allowedOrigins = process.env.ALLOWED_ORIGINS ? JSON.parse(process.env.ALLOWED_ORIGINS) : ['*']; // Usa variables de entorno para mayor flexibilidad

app.use(cors({
    origin: function (origin, callback) {
        if (!origin || allowedOrigins.includes(origin) || allowedOrigins.includes('*')) {
            callback(null, true);
        } else {
            callback(new Error('No permitido por CORS'));
        }
    },
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true // Si es necesario
}));

app.use(bodyParser.json());

// Importar rutas
const contratoRoutes = require('./routes/contratoRoutes');
const tipoContratoRoutes = require('./routes/tipoContratoRoutes'); // Importa las rutas para tipoContrato

// Definir rutas
app.use('/api/contratos', contratoRoutes);  // Usa /api/contratos como la ruta base
app.use('/api/tipos-contrato', tipoContratoRoutes);  // Usa /api/tipos-contrato como la ruta base para tipoContrato

// Sincronizar y arrancar el servidor
sequelize.sync({ alter: true })
  .then(() => {
    console.log('Base de datos sincronizada (contract-service).');
    app.listen(PORT, () => console.log(`Contract service escuchando en el puerto ${PORT}`));
  })
  .catch((err) => {
    console.error('Error al sincronizar la base de datos (contract-service):', err);
  });
