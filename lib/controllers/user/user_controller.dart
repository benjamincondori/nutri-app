import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai_app/models/user.dart';
import 'package:nutrition_ai_app/services/auth/login_service.dart';
import 'package:nutrition_ai_app/shared/utils/my_toastbar.dart';

import '../../models/totals.dart';
import '../../providers/totals_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/users_provider.dart';
import '../../screens/screens.dart';
import '../../services/user/user_service.dart';
import '../../shared/utils/shared_pref.dart';

class UserController {
  BuildContext? context;
  late Function refresh;

  final UserService _apiService = UserService();
  final LoginService _loginService = LoginService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telephoneController = TextEditingController();
  // final TextEditingController activityController = TextEditingController();
  // final TextEditingController restrictionsController = TextEditingController();

  String? selectedGender;
  PickedFile? pickedFile;
  File? imageFile;

  Future init(BuildContext context, Function refresh, {WidgetRef? ref}) async {
    this.context = context;
    this.refresh = refresh;
    _apiService.init(context);

    if (ref != null) {
      await getTotals(ref);
      await getUsers(ref);
    }
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

  Future<void> updateProfile(WidgetRef ref) async {
    String name = nameController.text.trim();
    String lastName = lastNameController.text.trim();
    String weight = weightController.text.trim();
    String height = heightController.text.trim();
    String email = emailController.text.trim();
    String telephone = telephoneController.text.trim();

    if (name.isEmpty ||
        lastName.isEmpty ||
        weight.isEmpty ||
        height.isEmpty ||
        email.isEmpty ||
        telephone.isEmpty) {
      MyToastBar.showInfo(context!, 'Todos los campos son requeridos');
      return;
    }

    final data = {
      'name': name,
      'lastname': lastName,
      'weight': weight,
      'height': height,
      'email': email,
      'telephone': telephone,
    };

    final token = await SharedPref().read('token');

    try {
      final response = await _apiService.updateProfile(token, data: data);
      print("UserController::updateProfile::response: $response");
      MyToastBar.showSuccess(context!, 'Perfil actualizado correctamente');
      await getUserProfile(ref);
      context!.pop();
    } catch (e) {
      print(e);
      MyToastBar.showError(context!, e.toString());
    }
  }

  Future selectImage(ImageSource imageSource, WidgetRef ref) async {
    final pickedFile = await ImagePicker().pickImage(
      source: imageSource,
    );

    if (pickedFile != null) {
      context!.pop();
      imageFile = File(pickedFile.path);

      showImagePreviewDialog(ref);
    }
  }

  Future updateProfileImage(WidgetRef ref) async {
    final token = await SharedPref().read('token');

    if (imageFile == null) {
      MyToastBar.showInfo(context!, 'Debe seleccionar una imagen');
      return;
    }

    try {
      final response = await _apiService.updateProfile(token, image: imageFile);
      print("UserController::updateProfileImage::response: $response");
      MyToastBar.showSuccess(
          context!, 'Imagen de perfil actualizada correctamente');
      await getUserProfile(ref);
      context!.pop();
    } catch (e) {
      print(e);
      MyToastBar.showError(context!, e.toString());
    }
  }

  Future<void> getTotals(WidgetRef ref) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final Totals totals = await _apiService.getTotals(token);
        print("UserController::getTotals::totals: $totals");
        ref.read(totalsProvider.notifier).state = totals;
      } catch (e) {
        print(e);
      }
    }
  }

  // obtener todos los usuarios
  Future<void> getUsers(WidgetRef ref) async {
    final token = await SharedPref().read('token');

    if (token != null) {
      try {
        final List<User> users = await _apiService.getUsers(token);
        print("UserController::getUsers::users: $users");
        ref.read(usersProvider.notifier).setUsers(users);
      } catch (e) {
        print(e);
      }
    }
  }

  void showImagePreviewDialog(WidgetRef ref) {
    showDialog(
      context: context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Imagen seleccionada",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  ), // Borde negro
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    imageFile!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await updateProfileImage(ref);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      "Guardar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      imageFile = null;
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
