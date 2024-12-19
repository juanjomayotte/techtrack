// auth-service/server.js
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const { Usuario, Rol, sequelize } = require('./models');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;


// CORS configuration (Before routes and other middleware)
const allowedOrigins = ['*']; // Replace with your frontend URL.  Use * for development.



app.use(cors({
    origin: function (origin, callback) {  // Custom origin validation function
        if (!origin || allowedOrigins.includes(origin) || allowedOrigins.includes('*')) {
            callback(null, true); // Allow the request
        } else {
            callback(new Error('Not allowed by CORS'));
        }
    },
    methods: ['GET', 'POST', 'PUT', 'DELETE'], // Allow only necessary HTTP methods
    allowedHeaders: ['Content-Type', 'Authorization'], // Allow only necessary headers
    credentials: true  // If your frontend sends cookies or HTTP authentication
}));

app.use(bodyParser.json());


// Manejador para la ruta raiz
app.get('/', (req, res) => {
    res.send('Auth service funcionando!');
});


// Routes
const userRoutes = require('./routes/userRoutes');  // Assuming your user routes are here
const rolRoutes = require('./routes/rolRoutes');
app.use('/api/users', userRoutes); // Example with /api prefix
app.use('/api/roles', rolRoutes); 



// Conexión con la base de datos y sincronización
// Modify how you sync, using a then catch block to handle errors:
sequelize.sync({ alter: true })
  .then(() => {
    console.log('Modelos sincronizados con la base de datos (auth-service).');
    app.listen(PORT, () => console.log(`Auth service escuchando en puerto ${PORT}`)); // Start the server *after* successful sync.
  })
  .catch((err) => {
    console.error('Error al sincronizar la base de datos (auth-service):', err);
  });