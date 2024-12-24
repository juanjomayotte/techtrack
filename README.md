# TechTrack - Business Asset Management Application

TechTrack is a cross-platform application designed to provide comprehensive management of business assets, including software, hardware, licenses, and contracts. The application integrates a backend built with modern microservices architecture, utilizing frameworks such as Node.js, Express, and Sequelize, paired with an SQL database to ensure scalability and robustness.
Made by Juan José Mayotte.

## Key Features
- **Backend Microservices**: A scalable and maintainable backend designed with Node.js, Express, and Sequelize, supporting the management of software, hardware, licenses, and contracts.
- **Frontend (Flutter)**: A minimalist, responsive interface developed using Flutter, optimized for mobile and tablet use, with an emphasis on user experience and ease of navigation.
- **Role & Permission Management**: A flexible and customizable system to manage user roles and permissions, meeting the specific needs of any organization.
- **Data Security & Compliance**: TechTrack is designed to ensure regulatory compliance and data security in enterprise environments.

## Technologies Used
- **Backend**: Node.js, Express, Sequelize, MySQL
- **Frontend**: Flutter
- **Microservices Architecture**: Scalable design for easy integration and maintenance
- **Authentication & Authorization**: JSON Web Tokens (JWT), bcryptjs, and role-based access control

## Features
- **Asset Management**: Track and manage both software and hardware assets across your organization.
- **License & Contract Management**: Easily manage software licenses and related contracts.
- **Role-Based Access Control**: Customize permissions and roles for users to ensure secure access to the system.
- **Responsive UI**: A minimalist, user-friendly interface that adapts seamlessly to different screen sizes (optimized for mobile devices and tablets).

## Installation

To get started with TechTrack, follow these steps to install and run the application locally:

### Backend Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/juanjomayotte/techtrack.git
   ```
2. Navigate to the backend directory:
   ```bash
   cd techtrack/services
   ```
3. Install dependencies:
   ```bash
   npm install
   ```
4. Create a `.env` file with the necessary configuration (see `.env.example`).
5. Run the backend services:
   ```bash
   npm start
   ```

### Frontend Setup
1. Navigate to the frontend directory:
   ```bash
   cd app_gestion_activos
   ```
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the Flutter app:
   ```bash
   flutter run
   ```

## Demo

You can view the complete code and demo of TechTrack in the [GitHub repository](https://github.com/juanjomayotte/techtrack).

## Roadmap

- **User Interface Improvements**: Enhance design for better usability.
- **Integration with External APIs**: Expand the app's functionality to connect with third-party systems.
- **Performance Optimization**: Improve backend performance with caching and load balancing.
- **Advanced Analytics**: Implement reporting and data analysis features for better decision-making.

## Contributing

We welcome contributions to TechTrack! If you have suggestions, bug fixes, or new features, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Keywords
asset management, enterprise devices, enterprise software, contracts, licenses.
