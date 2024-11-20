import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/services/auth/login_service.dart';
import 'package:nutrition_ai_app/shared/utils/my_toastbar.dart';

import '../../screens/main_screen.dart';
import '../../shared/utils/shared_pref.dart';

class LoginController {
  BuildContext? context;
  WidgetRef? ref;

  final LoginService _apiService = LoginService();
  final SharedPref _sharedPref = SharedPref();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future init(BuildContext context, WidgetRef ref) async {
    this.context = context;
    this.ref = ref;
    _apiService.init(context);
  }

  Future<void> login(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      MyToastBar.showInfo(context, 'Debe ingresar todos los datos');
      return;
    }

    try {
      Map<String, dynamic> response = await _apiService.login(email, password);

      if (context.mounted) {
        MyToastBar.showSuccess(context, 'Inicio de sesión exitoso');

        _sharedPref.save('token', response['token']);
        context.goNamed(MainScreen.name);
      }
    } catch (e) {
      if (context.mounted) {
        MyToastBar.showError(context, e.toString());
      }
    }
  }
}
