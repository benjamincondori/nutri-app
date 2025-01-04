import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/models/meal.dart';

import '../../config/theme/my_colors.dart';
import '../../controllers/meal/meal_controller.dart';
import '../../shared/appbar_with_back.dart';

class MealCreateScreen extends ConsumerStatefulWidget {
  static const String name = 'meal_create_screen';

  final Meal? mealToEdit;

  const MealCreateScreen({super.key, this.mealToEdit});

  @override
  MealCreateScreenState createState() => MealCreateScreenState();
}

class MealCreateScreenState extends ConsumerState<MealCreateScreen> {
  final MealController _con = MealController();

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final List<String> _categories = [
    'Desayuno',
    'Almuerzo',
    // 'Merienda',
    'Cena',
    // 'Snack',
  ];

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref);
    });

    // Si hay una comida para editar, inicializa los campos
    if (widget.mealToEdit != null) {
      _con.nameController.text = widget.mealToEdit!.name;
      _con.selectedCategory = widget.mealToEdit!.mealType;
    }

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
        title: widget.mealToEdit == null ? 'Crear Comida' : 'Actualizar Comida',
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
              _con.nameController,
              TextInputType.text,
              hintText: 'Ej: Desayuno',
            ),
            const SizedBox(height: 15),

            // Campo de categoría
            _buildCategorySelector(),
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
    TextEditingController controller,
    TextInputType keyboardType, {
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
          if (widget.mealToEdit == null) {
            _con.addMeal(); // Crear comida
          } else {
            _con.updateMeal(widget.mealToEdit!); // Actualizar comida
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
        child: Text(
          widget.mealToEdit == null ? 'AGREGAR COMIDA' : 'ACTUALIZAR COMIDA',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: MyColors.textColorPrimary,
        ),
        floatingLabelStyle: TextStyle(
          color: MyColors.primarySwatch[600],
        ),
        labelText: 'Tipo de Comida',
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
      value: _con.selectedCategory,
      items: _categories.map((category) {
        return DropdownMenuItem(
          value: category.toLowerCase(),
          child: Text(
            category[0].toUpperCase() + category.substring(1),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _con.selectedCategory = newValue!;
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
