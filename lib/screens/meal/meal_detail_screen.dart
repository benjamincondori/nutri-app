import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/controllers/meal/meal_food_controller.dart';

import '../../config/theme/my_colors.dart';
import '../../models/food.dart';
import '../../providers/food_provider.dart';
import '../../providers/meal_provider.dart';
import '../../shared/appbar_with_back.dart';
import '../screens.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  static const String name = 'meal_detail_screen';

  const MealDetailScreen({super.key});

  @override
  MealDetailScreenState createState() => MealDetailScreenState();
}

class MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  final MealFoodController _con = MealFoodController();

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

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
    final mealDetail = ref.watch(selectedMealProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: mealDetail!.meal.mealType[0].toUpperCase() +
            mealDetail.meal.mealType.substring(1),
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre de la comida
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    mealDetail.meal.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Viga',
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    color: Colors.white,
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción del botón de editar comida
                      context.pushNamed(
                        MealCreateScreen.name,
                        extra: {
                          'meal': mealDetail.meal,
                        },
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // Información nutricional
              SizedBox(
                height: 70,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _nutrientInfoCard(
                      "${mealDetail.meal.totalCalories.toStringAsFixed(1)} kcal",
                      Icons.local_fire_department,
                    ),
                    _nutrientInfoCard(
                      "${mealDetail.meal.totalProteins.toStringAsFixed(1)} g Proteínas",
                      Icons.fitness_center,
                    ),
                    _nutrientInfoCard(
                      "${mealDetail.meal.totalFats.toStringAsFixed(1)} g Grasas",
                      Icons.opacity,
                    ),
                    _nutrientInfoCard(
                      "${mealDetail.meal.totalCarbohydrates.toStringAsFixed(1)} g Carbohidratos",
                      Icons.grain,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // Título de la lista de alimentos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Alimentos:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(MyColors.primaryColor),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    color: Colors.white,
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Acción del botón para agregar alimentos
                      _showAddFoodForm(context);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Listado de alimentos
              Expanded(
                child: mealDetail.foods.isEmpty
                    ? DottedBorder(
                        radius: const Radius.circular(15),
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        strokeWidth: 1.5,
                        dashPattern: const [7, 5],
                        child: const Center(
                          child: Text(
                            'No hay alimentos registrados',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: mealDetail.foods.length,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          return _buildFoodItem(mealDetail.foods[index]);
                        },
                      ),
              ),
            ],
          )),
    );
  }

  // Widget para mostrar la información nutricional
  Widget _nutrientInfoCard(String label, IconData icon) {
    return Container(
      // constraints: const BoxConstraints(
      //   minWidth: 100,
      // ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: MyColors.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: MyColors.primaryColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Widget para construir cada ítem de alimento
  Widget _buildFoodItem(Food food) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(food.imageUrl!),
        radius: 30,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            food.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Mostrar diálogo de confirmación para eliminar el alimento
              _showDeleteConfirmationDialog(food);
            },
          ),
        ],
      ),
      subtitle: Text(
        food.description,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      onTap: () {
        // Seleccionar el alimento y navegar a la pantalla de detalle
        ref.read(selectedFoodProvider.notifier).state = food;
        context.pushNamed(
          FoodDetailScreen.name,
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Food food) {
    final mealDetail = ref.watch(selectedMealProvider);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar ${food.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop(); // Cerrar el diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _con.removeFoodFromMeal(mealDetail!.meal.id!, food.id!);
                // _deleteFood(food); // Eliminar el alimento
                context.pop(); // Cerrar el diálogo
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // Mostrar formulario para agregar alimentos
  void _showAddFoodForm(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Agregar Alimento',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildFoodSelector(),
              const SizedBox(height: 20),
              _textField(
                'Cantidad',
                _con.quantityController,
                TextInputType.number,
              ),
              const SizedBox(height: 20),
              _textField(
                'Tipo de cantidad',
                _con.typeQuantityController,
                TextInputType.text,
              ),
              const SizedBox(height: 20),
              _buttonAddFood(),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
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
          final mealDetail = ref.watch(selectedMealProvider);
          _con.addFoodToMeal(mealDetail!.meal.id!);
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
          'AGREGAR ALIMENTO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
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

  Widget _buildFoodSelector() {
    final foods = ref.watch(foodProvider);

    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelStyle: TextStyle(
          color: MyColors.textColorPrimary,
        ),
        floatingLabelStyle: TextStyle(
          color: MyColors.primarySwatch[600],
        ),
        labelText: 'Alimento',
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
      value: _con.selectedFood,
      items: foods.map((food) {
        return DropdownMenuItem(
          value: food.id,
          child: Text(
            food.name,
          ),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          _con.selectedFood = newValue!;
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
