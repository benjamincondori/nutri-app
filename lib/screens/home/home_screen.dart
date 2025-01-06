import 'package:dotted_border/dotted_border.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/controllers/meal/meal_controller.dart';
import 'package:nutrition_ai_app/controllers/plan/plan_controller.dart';
import 'package:nutrition_ai_app/screens/home/slider.dart';

import '../../config/theme/my_colors.dart';
import '../../models/current_plan.dart';
import '../../providers/plan_provider.dart';
import '../../providers/user_provider.dart';
import '../../shared/appbar.dart';
import '../screens.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const String name = 'home_screen';

  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  final PlanController _con = PlanController();
  final MealController _mealCon = MealController();
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white; // Color inicial del AppBar
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;
  DateTime date = DateTime.now();

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

  @override
  void dispose() {
    _scrollController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentPlan = ref.watch(currentPlanProvider);
    final user = ref.watch(userProvider);
    final mealsForToday = ref.watch(currentMealsPlanProvider);

    print("Meals for today: $mealsForToday");

    // Si currentPlan es nulo, mostramos un mensaje o algo similar.
    if (mealsForToday.isEmpty && currentPlan == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          userName: '${user?.name} ${user?.lastname}',
          profileImageUrl: user?.urlImage ??
              'https://img.lovepik.com/png/20231128/3d-illustration-avatar-profile-man-collection-guy-cheerful_716220_wh860.png',
          backgroundColor: _appBarColor,
          textColor: _textColor,
          iconColor: _iconColor,
          iconBackgroundColor: _iconBackgroundColor,
        ),
        body: Container(
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateTimeline(ref),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: DottedBorder(
                  radius: const Radius.circular(15),
                  borderType: BorderType.RRect,
                  color: Colors.grey,
                  strokeWidth: 1.5,
                  dashPattern: const [7, 5],
                  child: const Center(
                    child: Text(
                      'No tiene planes en este momento',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.pushNamed(CreateMealPlanScreen.name);
          },
          label: const Row(
            children: [
              Icon(Iconsax.box_add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Crear Plan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Viga',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: MyColors.primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          userName: '${user?.name} ${user?.lastname}',
          profileImageUrl: user?.urlImage ??
              'https://img.lovepik.com/png/20231128/3d-illustration-avatar-profile-man-collection-guy-cheerful_716220_wh860.png',
          backgroundColor: _appBarColor,
          textColor: _textColor,
          iconColor: _iconColor,
          iconBackgroundColor: _iconBackgroundColor,
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 10,
            bottom: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateTimeline(ref),
              const SizedBox(height: 20),
              if (mealsForToday.isEmpty) ...[
                SizedBox(
                  height: 250,
                  child: DottedBorder(
                    radius: const Radius.circular(15),
                    borderType: BorderType.RRect,
                    color: Colors.grey,
                    strokeWidth: 1.5,
                    dashPattern: const [7, 5],
                    child: const Center(
                      child: Text(
                        'No tiene planes en este momento',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 10),

                // Slider de macronutrientes
                MacronutrientSliderWidget(
                  consumedCalories: mealsForToday
                      .where((meal) => meal.mealStatus == true)
                      .map((meal) => meal.totalCalories)
                      .fold(
                          0,
                          (previousValue, calories) =>
                              previousValue + calories),
                  targetCalories: mealsForToday
                      .map((meal) => meal.totalCalories)
                      .reduce((a, b) => a + b),
                  consumedProtein: mealsForToday
                      .where((meal) => meal.mealStatus == true)
                      .map((meal) => meal.totalProteins)
                      .fold(
                          0,
                          (previousValue, proteins) =>
                              previousValue + proteins),
                  targetProtein: mealsForToday
                      .map((meal) => meal.totalProteins)
                      .reduce((a, b) => a + b),
                  consumedCarbs: mealsForToday
                      .where((meal) => meal.mealStatus == true)
                      .map((meal) => meal.totalCarbohydrates)
                      .fold(0, (previousValue, carbs) => previousValue + carbs),
                  targetCarbs: mealsForToday
                      .map((meal) => meal.totalCarbohydrates)
                      .reduce((a, b) => a + b),
                  consumedFat: mealsForToday
                      .where((meal) => meal.mealStatus == true)
                      .map((meal) => meal.totalFats)
                      .fold(0, (previousValue, fats) => previousValue + fats),
                  targetFat: mealsForToday
                      .map((meal) => meal.totalFats)
                      .reduce((a, b) => a + b),
                ),
                const SizedBox(height: 30),

                // Plan del día
                const Text(
                  "Plan de Hoy",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Viga',
                  ),
                ),
                ...mealsForToday.map((meal) => buildMealCard(meal)),

                const SizedBox(height: 30),
              ]
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.pushNamed(CreateMealPlanScreen.name);
          },
          label: const Row(
            children: [
              Icon(Iconsax.box_add, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Crear Plan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Viga',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: MyColors.primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    }
  }

  Widget _buildCaloriesProgressChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Calorías Consumidas",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Viga',
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                  color: Colors.green,
                  value: 75, // Progreso
                  title: '75%',
                  radius: 60,
                  titleStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                PieChartSectionData(
                  color: Colors.grey[300]!,
                  value: 25, // Lo que falta
                  title: '',
                  radius: 60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
                          const SizedBox(height: 3),
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
                        await _mealCon.toggleMealStatus(meal.mealId,
                            date: date);
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

  Widget _dateTimeline(WidgetRef ref) {
    return EasyDateTimeLine(
      initialDate: DateTime.now(),
      activeColor: MyColors.primaryColor,
      onDateChange: (selectedDate) {
        date = selectedDate;
        loadDataMeals(date, ref);
      },
      locale: 'es_ES',
      headerProps: const EasyHeaderProps(
        dateFormatter: DateFormatter.fullDateDMonthAsStrY(),
        selectedDateStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        monthStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
        monthPickerType: MonthPickerType.switcher,
      ),
      dayProps: const EasyDayProps(
        activeDayStyle: DayStyle(
          dayNumStyle: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
          dayStrStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
          monthStrStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
