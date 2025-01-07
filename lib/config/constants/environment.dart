import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String urlApi = dotenv.env['URL_API'] ?? '';
  static String stripePublishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  static String stripeSecretKey = dotenv.env['STRIPE_SECRET'] ?? '';
}
