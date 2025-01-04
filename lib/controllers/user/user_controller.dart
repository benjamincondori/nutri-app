import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/models/user.dart';
import 'package:nutrition_ai_app/services/auth/login_service.dart';

import '../../providers/user_provider.dart';
import '../../screens/screens.dart';
import '../../services/user/user_service.dart';
import '../../shared/utils/shared_pref.dart';

class UserController {
  BuildContext? context;

  final UserService _apiService = UserService();
  final LoginService _loginService = LoginService();

  Future init(BuildContext context) async {
    this.context = context;
    _apiService.init(context);
  }

  Future<void> checkAuthSession(WidgetRef ref) async {
    final token = await SharedPref().read('token');
    final userType = await SharedPref().read('user_type');
    
    bool isTokenValid = false;
    
    if (token != null) {
      isTokenValid = token != null && await _loginService.verifyToken(token);
    }
    
    if (isTokenValid) {
      // Si el token existe, redirigir según el tipo de usuario
      if (userType == 'nutritionist') {
        // Si es nutricionista, redirigir a la pantalla de nutricionista
        context?.goNamed(MainScreen1.name);
      } else {
        // Si es usuario normal, redirigir a la pantalla principal
        context?.goNamed(MainScreen.name);
      }
    } else {
      // Si no hay token, redirigir a la pantalla de login
      context?.pushReplacementNamed(LoginScreen.name);
    }
  }
  
  Future<void> getUserProfile(WidgetRef ref) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final User user = await _apiService.getProfile(token);
        print("Login::User profile: ${user.toJson()}");
        ref.read(userProvider.notifier).setUser(user);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getUserProfileNutritionist(WidgetRef ref) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final UserNutritionist user =
            await _apiService.getProfileNutritionist(token);
        print("Login::User profile: ${user.toJson()}");
        ref.read(userNutritionistProvider.notifier).setUser(user);
      } catch (e) {
        print(e);
      }
    }
  }
}
