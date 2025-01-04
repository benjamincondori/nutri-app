import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/config/theme/my_colors.dart';
import 'package:nutrition_ai_app/controllers/food/food_controller.dart';
import 'package:nutrition_ai_app/shared/appbar_with_back.dart';

import '../../models/food.dart';

class FoodCreateScreen extends ConsumerStatefulWidget {
  static const String name = 'food_create_screen';

  final Food? foodToEdit;

  const FoodCreateScreen({super.key, this.foodToEdit});

  @override
  FoodCreateScreenState createState() => FoodCreateScreenState();
}

class FoodCreateScreenState extends ConsumerState<FoodCreateScreen> {
  final FoodController _con = FoodController();

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final List<String> _categories = [
    "Frutas",
    "Frutos Secos",
    "Carnes",
    "Pescados",
    'Huevos',
    "Verduras/Hortalizas",
    "Legumbres",
    "Cereales y derivados",
    "Lacteos",
    "Grasas",
    "Quesos",
    "Otros",
  ];

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref);
    });

    // Si hay un alimento para editar, inicializa los campos
    if (widget.foodToEdit != null) {
      _con.nameController.text = widget.foodToEdit!.name;
      _con.descriptionController.text = widget.foodToEdit!.description;
      _con.proteinsController.text = widget.foodToEdit!.proteins.toString();
      _con.fatsController.text = widget.foodToEdit!.fats.toString();
      _con.carbsController.text = widget.foodToEdit!.carbohydrates.toString();
      _con.caloriesController.text = widget.foodToEdit!.calories.toString();
      _con.benefitsController.text = widget.foodToEdit!.benefits;
      _con.selectedCategory = widget.foodToEdit!.category;
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
        title: widget.foodToEdit == null
            ? 'Agregar Alimento'
            : 'Actualizar Alimento',
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
            // Campo Nombre
            _textField(
              'Nombre del alimento',
              _con.nameController,
              TextInputType.text,
            ),

            const SizedBox(height: 15),

            // Campo Descripción
            _textField(
              'Descripción',
              _con.descriptionController,
              TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
            ),

            const SizedBox(height: 15),

            // Campo Proteínas
            _textField(
              'Proteínas (g)',
              _con.proteinsController,
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            // Campo Grasas
            _textField(
              'Grasas (g)',
              _con.fatsController,
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            // Campo Carbohidratos
            _textField(
              'Carbohidratos (g)',
              _con.carbsController,
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            // Campo Calorías
            _textField(
              'Calorías (Kcal)',
              _con.caloriesController,
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            // Campo Beneficios
            _textField(
              'Beneficios',
              _con.benefitsController,
              TextInputType.multiline,
              minLines: 2,
              maxLines: 5,
            ),
            const SizedBox(height: 15),

            // Dropdown para la categoría
            _buildCategorySelector(),
            const SizedBox(height: 20),

            // Campo Imagen
            _imageUploader(),
            const SizedBox(height: 20),

            // Botón para agregar el alimento
            _buttonAddFood(),

            const SizedBox(height: 10),
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

  Widget _buttonAddFood() {
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
          if (widget.foodToEdit == null) {
            _con.addFood(); // Crear alimento
          } else {
            _con.updateFood(widget.foodToEdit!.id!); // Actualizar alimento
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
          widget.foodToEdit == null
              ? 'AGREGAR ALIMENTO'
              : 'ACTUALIZAR ALIMENTO',
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
        labelText: 'Categoría',
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
          child: Text(category[0].toUpperCase() + category.substring(1)),
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

  Widget _imageUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imagen del alimento',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: MyColors.primaryColorDark,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: _con.pickImage,
          child: Container(
            height: 250,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: MyColors.primarySwatch[600]!),
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[100],
            ),
            child: _con.selectedImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _con.selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : widget.foodToEdit != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.foodToEdit!.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  : Center(
                      child: Text(
                        'Toca para seleccionar una imagen',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
