import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nutrition_ai_app/models/user_request.dart';
import 'package:nutrition_ai_app/services/auth/register_service.dart';

import '../../models/health_profile.dart';
import '../../screens/login/login_screen.dart';
import '../../screens/user/register_profile_screen.dart';
import '../../shared/utils/my_snackbar.dart';
import '../../shared/utils/my_toastbar.dart';

class RegisterController {
  BuildContext? context;

  final RegisterService _apiService = RegisterService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController customRestrictionController =
      TextEditingController();

  String? selectedGender;
  DateTime? selectedDate;
  String? selectedActivity;
  String? selectedRestriction;
  bool showCustomRestrictionField = false;

  Function? refresh;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _apiService.init(context);
  }

  Future<void> register(BuildContext context) async {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String lastname = lastnameController.text.trim();
    String telephone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty ||
        name.isEmpty ||
        lastname.isEmpty ||
        telephone.isEmpty ||
        password.isEmpty) {
      MyToastBar.showInfo(context, 'Debe ingresar todos los datos');
      return;
    }

    if (password.length < 6) {
      MyToastBar.showInfo(
          context, 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    try {
      final user = UserRequest(
        email: email,
        name: name,
        lastname: lastname,
        password: password,
        telephone: telephone,
      );

      final result = await _apiService.registerUser(user);
      print("CONTROLLER::Data register: $result");

      if (context.mounted) {
        // MySnackbar.show(context, result["message"]);
        MyToastBar.showSuccess(context, 'Usuario registrado correctamente');
        
        // Navegar a la pantalla de registro de perfil
        context.pushReplacementNamed(RegisterProfileScreen.name, extra: {
          'user_id': result['user_id'],
        });
      }
    } catch (e) {
      if (context.mounted) {
        MyToastBar.showError(context, e.toString());
      }
    }
  }

  Future<void> registerProfile(BuildContext context, int userId) async {
    
    String weight = weightController.text.trim();
    String height = heightController.text.trim();
    String gender = selectedGender ?? '';
    String activity = selectedActivity ?? '';
    String birthday = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : '';
    String restriction = showCustomRestrictionField
        ? customRestrictionController.text.trim()
        : selectedRestriction ?? '';
        
    if (weight.isEmpty ||
        height.isEmpty ||
        gender.isEmpty ||
        activity.isEmpty ||
        birthday.isEmpty ||
        restriction.isEmpty) {
      MyToastBar.showInfo(context, 'Debe ingresar todos los datos');
      return;
    }
    
    try {
      final profile = HealthProfile(
        age: DateTime.now().year - selectedDate!.year,
        healthRestrictions: restriction,
        height: double.parse(height),
        physicalActivityId: int.parse(activity),
        weight: double.parse(weight),
        userId: userId,
        birthday: DateTime.parse(birthday),
        gender: gender,
      );


      final result = await _apiService.registerHealthProfile(profile);
      print("CONTROLLER::Data register: $result");

      if (context.mounted) {
        // MySnackbar.show(context, result["message"]);
        MyToastBar.showSuccess(context, 'Perfil registrado correctamente');
        // Navegar a la pantalla de login
        context.goNamed(LoginScreen.name);
      }
    } catch (e) {
      if (context.mounted) {
        MySnackbar.show(context, e.toString());
      }
    }
    
  }
}
