// inventory-service/server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { sequelize } = require('./models');
require('dotenv').config();


const app = express();
const PORT = process.env.PORT || 3002;


// CORS Configuration (Important: Before routes)
// Whitelist allowed origins. Use specific origins in production
const allowedOrigins = ['*']; // Replace with your frontend URL. Use * for development
// const allowedOrigins = process.env.ALLOWED_ORIGINS ? JSON.parse(process.env.ALLOWED_ORIGINS) : ['http://localhost:your-frontend-port']; // If using environment variables

app.use(cors({
    origin: function (origin, callback) { // Custom origin validation
        if (!origin || allowedOrigins.includes(origin) || allowedOrigins.includes('*')) {
            callback(null, true);
        } else {
            callback(new Error('Not allowed by CORS'));
        }
    },
    methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allow only necessary methods
    allowedHeaders: ['Content-Type', 'Authorization'],  // Allow only necessary headers.  Include any custom headers your frontend sends
    credentials: true // If you're using cookies or HTTP authentication
}));

app.use(bodyParser.json());



// Import routes
const dispositivoRoutes = require('./routes/dispositivoRoutes');
const estadoDispositivoRoutes = require('./routes/estadoDispositivoRoutes');
const modeloDispositivoRoutes = require('./routes/modeloDispositivoRoutes');
const mantenimientoRoutes = require('./routes/mantenimientoRoutes');
const tipoDispositivoRoutes = require('./routes/tipoDispositivoRoutes');
const softwareRoutes = require('./routes/softwareRoutes');
const plataformaRoutes = require('./routes/plataformaRoutes');
const tipoSoftwareRoutes = require('./routes/tipoSoftwareRoutes');


// Use your routes
app.use('/api/dispositivos', dispositivoRoutes);
app.use('/api/estadosdispositivos', estadoDispositivoRoutes);
app.use('/api/modelosdispositivos', modeloDispositivoRoutes);
app.use('/api/mantenimientos', mantenimientoRoutes);
app.use('/api/tiposdispositivos', tipoDispositivoRoutes);
app.use('/api/software', softwareRoutes);
app.use('/api/plataformas', plataformaRoutes);
app.use('/api/tipossoftware', tipoSoftwareRoutes);




// Synchronize and start server
sequelize.sync({ alter: true }) // Use { alter: true } in development.  {force: true} will drop existing tables.
    .then(() => {
        console.log('Base de datos sincronizada (inventory-service).');
        app.listen(PORT, () => console.log(`Inventario service escuchando en el puerto ${PORT}`));
    })
    .catch((err) => {
        console.error('Error en inventory-service:', err);
    });