import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/controllers/user/user_controller.dart';

import '../../config/theme/my_colors.dart';
import '../../controllers/meal/meal_controller.dart';
import '../../providers/user_provider.dart';
import '../../shared/appbar_with_back.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  static const String name = 'edit_profile_screen';

  // final Meal? mealToEdit;

  const EditProfileScreen({super.key});

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final MealController _con = MealController();
  final UserController _userCon = UserController();

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  // Lista de opciones de género
  final List<String> _genderOptions = ['Masculino', 'Femenino', 'Otro'];

  // Lista de restricciones
  // final List<String> _restrictions = [
  //   'Ninguna',
  //   'Diabetes',
  //   'Hipertensión',
  //   'Colesterol alto',
  //   'Otro',
  // ];

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref);
      _userCon.init(context, refresh);
    });

    final user = ref.read(userProvider);
    _userCon.nameController.text = user?.name ?? '';
    _userCon.lastNameController.text = user?.lastname ?? '';
    _userCon.weightController.text =
        user?.healthProfile.weight.toString() ?? '';
    _userCon.heightController.text =
        user?.healthProfile.height.toString() ?? '';
    _userCon.emailController.text = user?.email ?? '';
    _userCon.telephoneController.text = user?.telephone ?? '';

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
        title: 'Editar Perfil',
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
              'Nombre',
              controller: _userCon.nameController,
              TextInputType.text,
            ),
            const SizedBox(height: 15),

            // Campo apellido
            _textField(
              'Apellido',
              controller: _userCon.lastNameController,
              TextInputType.text,
            ),
            const SizedBox(height: 15),

            _textField(
              'Email',
              controller: _userCon.emailController,
              TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),

            // Campo de teléfono
            _textField(
              'Teléfono',
              controller: _userCon.telephoneController,
              TextInputType.phone,
            ),
            const SizedBox(height: 15),

            // Campo de peso
            _textField(
              'Peso (kg)',
              controller: _userCon.weightController,
              TextInputType.number,
            ),
            const SizedBox(height: 15),

            // Campo de altura
            _textField(
              'Altura (cm)',
              controller: _userCon.heightController,
              TextInputType.number,
            ),

            const SizedBox(height: 20),

            // Botón para agregar comida
            _buttonUpdate(),
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

  Widget _buttonUpdate() {
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
          _userCon.updateProfile(ref);
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

  Widget _buildGenderSelector() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: MyColors.textColorPrimary,
        ),
        floatingLabelStyle: TextStyle(
          color: MyColors.primarySwatch[600],
        ),
        labelText: 'Género',
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
      borderRadius: BorderRadius.circular(10),
      dropdownColor: MyColors.primarySwatch[10],
      value: _userCon.selectedGender,
      items: _genderOptions.map((gender) {
        return DropdownMenuItem(
          value: gender.toLowerCase(),
          child: Text(
            gender,
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _userCon.selectedGender = newValue!;
        });
      },
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: MyColors.primaryColor,
      ),
      style: TextStyle(
        color: MyColors.primaryColorDark,
        fontSize: 16,
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
