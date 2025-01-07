import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:nutrition_ai_app/config/constants/environment.dart';
import 'package:nutrition_ai_app/config/router/app_router.dart';
import 'package:nutrition_ai_app/config/theme/app_theme.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  await _setup();

  runApp(const ProviderScope(child: MainApp()));
}

// juan.perez@example.com
// securepassword123

// marcos@gmail.com
// 123456

Future<void> _setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = Environment.stripePublishableKey;
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // English
      ],
      locale: const Locale('es', 'ES'),
    );
  }
}
