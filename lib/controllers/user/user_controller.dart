import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/models/user.dart';

import '../../providers/user_provider.dart';
import '../../screens/screens.dart';
import '../../services/user/user_service.dart';
import '../../shared/utils/shared_pref.dart';

class UserController {
  BuildContext? context;

  final UserService _apiService = UserService();

  Future init(BuildContext context) async {
    this.context = context;
    _apiService.init(context);
  }

  Future<void> checkAuthSession(WidgetRef ref) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        context?.goNamed(MainScreen.name);
      } catch (e) {
        print(e);
        context?.pushReplacementNamed(LoginScreen.name);
      }
    } else {
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
}
