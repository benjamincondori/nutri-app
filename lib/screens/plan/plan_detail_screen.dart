import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/models/current_plan.dart';

import '../../config/theme/my_colors.dart';
import '../../controllers/meal/meal_controller.dart';
import '../../controllers/plan/plan_controller.dart';
import '../../providers/plan_provider.dart';
import '../../shared/appbar_with_back.dart';
import '../../shared/utils/format_date.dart';
import '../meal/meal_detail_screen.dart';

class PlanDetailScreen extends ConsumerStatefulWidget {
  static const String name = 'plan_detail_screen';

  final String planTitle;

  const PlanDetailScreen({super.key, required this.planTitle});

  @override
  PlanDetailScreenState createState() => PlanDetailScreenState();
}

class PlanDetailScreenState extends ConsumerState<PlanDetailScreen> {
  final PlanController _con = PlanController();
  final MealController _mealCon = MealController();

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final Map<int, bool> mealStates =
      {}; // Map para almacenar el estado del checkbox
  // late List<Meals> meals = []; // Lista de comidas

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref);
      _mealCon.init(context, refresh, ref);
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

  // void loadMealStatus() {
  //   final planDetail = ref.watch(selectedPlanProvider);
  //   meals = planDetail!.meals;

  //   // Inicializa el estado de los checkboxes a partir de meal_status
  //   for (Meals meal in meals) {
  //     mealStates[meal.mealId] = meal.mealStatus == true;
  //   }
  // }

  // void toggleMealState(int id, bool value) {
  //   setState(() {
  //     mealStates[id] = value;
  //     final meal = meals.firstWhere((meal) => meal.mealId == id);
  //     meal.mealStatus = value;
  //   });
  // }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planDetail = ref.watch(selectedPlanProvider);
    final mealsByDay = groupMealsByDay(planDetail!.meals);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Detalle del plan',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(5),
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: MyColors.primarySwatch),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: MyColors.primaryColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      widget.planTitle,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    planDetail.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Iconsax.calendar_1,
                        size: 20,
                        color: MyColors.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Creado:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formatDate(planDetail.dateGeneration),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Iconsax.tick_square,
                        size: 20,
                        color: MyColors.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Estado:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                          color: planDetail.status.toLowerCase() == 'terminado'
                              ? Colors.green[100]
                              : Colors.yellow[100],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          planDetail.status,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(
                        Iconsax.crown_1,
                        size: 20,
                        color: MyColors.primaryColor,
                      ),
                      const SizedBox(width: 5),
                      const Text(
                        "Total de calorías:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${planDetail.calories.toStringAsFixed(1)} kcal',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: mealsByDay.length,
                itemBuilder: (context, index) {
                  final day = mealsByDay.keys.elementAt(index);
                  final meals = mealsByDay[day]!;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Día $day",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...meals.map((meal) => buildMealCard(meal)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<int, List<Meals>> groupMealsByDay(List<Meals> meals) {
    final grouped = <int, List<Meals>>{};
    for (final meal in meals) {
      final day = meal.day;
      grouped.putIfAbsent(day, () => []);
      grouped[day]!.add(meal);
    }
    return grouped;
  }

  Widget buildMealCard(Meals meal) {
    // Función para obtener el ícono según el tipo de comida
    IconData getMealIcon(String type) {
      switch (type.toLowerCase()) {
        case 'desayuno':
          return Icons.breakfast_dining;
        case 'almuerzo':
          return Icons.fastfood;
        case 'cena':
          return Icons.dinner_dining;
        default:
          return Icons.fastfood; // Ícono genérico si el tipo no coincide
      }
    }

    bool isEaten = meal.mealStatus; // Estado para marcar o desmarcar
    // bool isEaten = mealStates[meal.mealId] ?? false; // Estado inicial

    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () async {
            // Seleccionar el alimento y navegar a la pantalla de detalle
            await _con.getFoodsByMeal(meal.mealId);

            if (mounted) {
              context.pushNamed(MealDetailScreen.name);
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(
              vertical: 10,
            ), // Separación entre tarjetas
            decoration: BoxDecoration(
              color: MyColors.primarySwatch[50],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.6),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: MyColors.primarySwatch),
            ),
            child: Card(
              color: Colors.white,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Ícono según el tipo de comida
                    Icon(
                      getMealIcon(meal.mealType),
                      color: MyColors.primarySwatch,
                      size: 30,
                    ),
                    const SizedBox(
                        width: 15), // Espaciado entre ícono y contenido
                    // Contenido principal de la comida
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name.toString().toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            (meal.foods).map((food) => food.name).join(", "),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    // Checkbox a la derecha
                    Checkbox(
                      value: isEaten,
                      onChanged: (bool? value) async {
                        // setState(() {
                        // isEaten = value ?? false;
                        // toggleMealState(meal.mealId, value ?? false);
                        await _mealCon.toggleMealStatus(meal.mealId);
                        // });
                      },
                      activeColor: MyColors.primarySwatch,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Widget buildMealCard(Map<String, dynamic> meal) {
  //   bool isEaten = false; // Estado para marcar o desmarcar

  //   return StatefulBuilder(
  //     builder: (context, setState) {
  //       return GestureDetector(
  //         onTap: () {
  //           print("Tocó la comida ${meal["name"]}");
  //         },
  //         child: Container(
  //           width: double.infinity,
  //           margin: const EdgeInsets.symmetric(
  //               vertical: 10), // Separación entre tarjetas
  //           decoration: BoxDecoration(
  //             color: MyColors.primarySwatch[50],
  //             borderRadius: BorderRadius.circular(15),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey.withOpacity(0.6),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //             border: Border.all(color: MyColors.primarySwatch),
  //           ),
  //           child: Card(
  //             color: Colors.white,
  //             elevation: 0,
  //             child: Padding(
  //               padding: const EdgeInsets.all(15.0),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   // Ícono en el lado izquierdo
  //                   Icon(
  //                     Icons.fastfood,
  //                     color: MyColors.primarySwatch,
  //                     size: 30,
  //                   ),
  //                   const SizedBox(
  //                       width: 15), // Espaciado entre ícono y contenido
  //                   // Contenido principal de la comida
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           meal["name"].toString().toUpperCase(),
  //                           style: const TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 8),
  //                         Text(
  //                           (meal["foods"] as List<dynamic>)
  //                               .map((food) => (food
  //                                   as Map<String, dynamic>)["name"] as String)
  //                               .join(", "),
  //                           style: const TextStyle(fontSize: 14),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                   // Checkbox a la derecha
  //                   Checkbox(
  //                     value: isEaten,
  //                     onChanged: (bool? value) {
  //                       setState(() {
  //                         isEaten = value ?? false;
  //                       });
  //                     },
  //                     activeColor: MyColors.primarySwatch,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget buildMealCard(Map<String, dynamic> meal) {
  //   return GestureDetector(
  //     onTap: () => {
  //       print("Tocó la comida ${meal["name"]}"),
  //     }, // Callback al tocar la comida completa
  //     child: Container(
  //       width: double.infinity,
  //       margin: const EdgeInsets.symmetric(
  //         vertical: 10,
  //       ), // Separación entre tarjetas
  //       decoration: BoxDecoration(
  //         color: MyColors.primarySwatch[50],
  //         borderRadius: BorderRadius.circular(15),
  //         boxShadow: [
  //           BoxShadow(
  //             color: Colors.grey.withOpacity(0.6),
  //             blurRadius: 10,
  //             offset: const Offset(0, 4),
  //           ),
  //         ],
  //         border: Border.all(color: MyColors.primarySwatch),
  //       ),
  //       child: Card(
  //         color: Colors.white,
  //         elevation: 0,
  //         child: Padding(
  //           padding: const EdgeInsets.all(15.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 meal["name"].toString().toUpperCase(),
  //                 style: const TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 (meal["foods"] as List<dynamic>)
  //                     .map((food) =>
  //                         (food as Map<String, dynamic>)["name"] as String)
  //                     .join(", "),
  //                 style: const TextStyle(fontSize: 14),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  void refresh() {
    setState(() {});
  }
}
