import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/shared/utils/my_toastbar.dart';

import '../../config/theme/my_colors.dart';
import '../../controllers/meal/meal_controller.dart';
import '../../shared/appbar_with_back.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  static const String name = 'change_password_screen';

  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final MealController _con = MealController();

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final TextEditingController _currentPassword = TextEditingController();
  final TextEditingController _newPassword = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref);
    });

    _scrollController.addListener(() {
      // Cambiar el color del AppBar cuando se haga scroll
      setState(() {
        if (_scrollController.position.pixels > 1) {
          _appBarColor = MyColors.primarySwatch; // Color al hacer scroll
          _textColor = Colors.white;
          _iconColor = MyColors.primaryColor;
          _iconBackgroundColor = Colors.white;
        } else {
          _appBarColor = Colors.white; // Color inicial
          _textColor = Colors.black;
          _iconColor = MyColors.primaryColor;
          _iconBackgroundColor = MyColors.primarySwatch[50]!;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Cambiar Contraseña',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de nombre
            _textField(
              'Contraseña Actual',
              controller: _currentPassword,
              TextInputType.text,
              isPassword: true,
            ),
            const SizedBox(height: 15),

            // Campo apellido
            _textField(
              'Nueva Contraseña',
              controller: _newPassword,
              TextInputType.text,
              isPassword: true,
            ),
            const SizedBox(height: 15),

            // Campo de peso
            _textField(
              'Confirmar Contraseña',
              controller: _confirmPassword,
              TextInputType.text,
              isPassword: true,
            ),

            const SizedBox(height: 20),

            // Botón para agregar comida
            _buttonAddMeal(),
          ],
        ),
      ),
    );
  }

  Widget _textField(
    String label,
    TextInputType keyboardType, {
    TextEditingController? controller,
    int? minLines,
    int? maxLines,
    bool isPassword = false,
    String? hintText,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword, // Para campos de contraseña
      minLines: minLines ?? 1, // Si no se pasa minLines, usa 1
      maxLines: maxLines ?? 1, // Si no se pasa maxLines, usa 1
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelStyle: TextStyle(
          color: MyColors.textColorPrimary,
        ),
        floatingLabelStyle: TextStyle(
          color: MyColors.primarySwatch[600],
        ),
        labelText: label, // Usamos el label dinámico que pasa como parámetro
        hintText: hintText, // Para sugerencias
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: MyColors.primarySwatch[600]!,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: MyColors.primarySwatch[600]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: MyColors.primarySwatch[600]!,
          ),
        ),
      ),
    );
  }

  Widget _buttonAddMeal() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            MyColors.secondaryColor,
            MyColors.primaryColor,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: MyColors.primaryColor.withOpacity(0.5), // Sombra suave azul
            blurRadius: 10,
            offset: const Offset(0, 5), // Posición de la sombra
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          if (_currentPassword.text.isEmpty ||
              _newPassword.text.isEmpty ||
              _confirmPassword.text.isEmpty) {
            MyToastBar.showInfo(
              context,
              'Por favor, rellene todos los campos',
            );
            return;
          }

          if (_newPassword.text != _confirmPassword.text) {
            MyToastBar.showInfo(
              context,
              'Las contraseñas no coinciden',
            );
            return;
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: const Text(
          'Guardar Cambios',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
