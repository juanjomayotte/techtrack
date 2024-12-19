// server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { sequelize } = require('./models');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3004; // Puerto para el servicio de licencias

// Configuración de CORS
const allowedOrigins = process.env.ALLOWED_ORIGINS ? JSON.parse(process.env.ALLOWED_ORIGINS) : ['*'];

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
}));

app.use(bodyParser.json());

// Importar rutas
const licenciaRoutes = require('./routes/licenciaRoutes');
const tipoLicenciaRoutes = require('./routes/tipoLicenciaRoutes');

// Definir rutas
app.use('/api/licencias', licenciaRoutes);
app.use('/api/tipos-licencia', tipoLicenciaRoutes);


// Sincronizar y arrancar el servidor
sequelize.sync({ alter: true }) // alter:true para sincronizar cambios en los modelos
  .then(() => {
    console.log('Base de datos sincronizada (license-service).');
    app.listen(PORT, () => console.log(`License service escuchando en el puerto ${PORT}`));
  })
  .catch((err) => {
    console.error('Error al sincronizar la base de datos (license-service):', err);
  });