import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String authBaseUrl = dotenv.env['AUTH_BASE_URL'] ?? '';
  static final String inventoryBaseUrl = dotenv.env['INVENTORY_BASE_URL'] ?? '';
  static final String contractBaseUrl = dotenv.env['CONTRACT_BASE_URL'] ?? '';
  static final String licenseBaseUrl = dotenv.env['LICENSE_BASE_URL'] ?? '';
}
