import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../config/theme/my_colors.dart';
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
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white; // Color inicial del AppBar
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final List<MealPlanItem> _mealPlan = [
    const MealPlanItem(
      title: 'Desayuno',
      subtitle: 'Avena con frutas y nueces',
      icon: Icons.breakfast_dining,
      color: Colors.green,
    ),
    const MealPlanItem(
      title: 'Almuerzo',
      subtitle: 'Ensalada de pollo y quinoa',
      icon: Icons.lunch_dining,
      color: Colors.green,
    ),
    const MealPlanItem(
      title: 'Cena',
      subtitle: 'Salmón con espárragos',
      icon: Icons.dinner_dining,
      color: Colors.green,
    ),
  ];

  @override
  void initState() {
    super.initState();
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
    final user = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        userName: '${user?.name} ${user?.lastname}',
        profileImageUrl: user?.urlImage ?? 'https://img.lovepik.com/png/20231128/3d-illustration-avatar-profile-man-collection-guy-cheerful_716220_wh860.png',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),

            // Gráfico de progreso de calorías
            _buildCaloriesProgressChart(),

            const SizedBox(height: 30),

            // Gráfico de progreso de agua
            // _buildWaterProgressChart(),

            // Plan del día
            _buildMealPlan(),

            // const SizedBox(height: 30),

            // Sugerencias de recetas
            // _buildRecipeSuggestions(),

            const SizedBox(height: 30),
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

  // Widget _buildWaterProgressChart() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         "Agua Bebida",
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       SizedBox(
  //         height: 200,
  //         child: BarChart(
  //           BarChartData(
  //             barGroups: [
  //               BarChartGroupData(x: 0, barRods: [
  //                 BarChartRodData(
  //                   toY: 8, // Progreso en litros
  //                   color: Colors.blue,
  //                   width: 20,
  //                 ),
  //               ]),
  //               BarChartGroupData(x: 1, barRods: [
  //                 BarChartRodData(
  //                   toY: 12, // Objetivo en litros
  //                   color: Colors.grey[300]!,
  //                   width: 20,
  //                 ),
  //               ]),
  //             ],
  //             titlesData: FlTitlesData(show: false),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMealPlan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Plan de Hoy",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Viga',
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mealPlan.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: 15), // Espacio entre elementos
          itemBuilder: (context, index) {
            final item = _mealPlan[index];
            Map<String, dynamic> mealDetails;

            // Aquí puedes cambiar los valores de acuerdo a cada item
            if (item.title == "Desayuno") {
              mealDetails = {
                'mealType': "Desayuno",
                'mealName': "Tostadas con Aguacate",
                'calories': 300,
                'fats': 15.0,
                'proteins': 10.0,
                'carbs': 35.0,
              };
            } else if (item.title == "Almuerzo") {
              mealDetails = {
                'mealType': "Almuerzo",
                'mealName': "Ensalada César",
                'calories': 450,
                'fats': 20.0,
                'proteins': 30.0,
                'carbs': 40.0,
              };
            } else if (item.title == "Cena") {
              mealDetails = {
                'mealType': "Cena",
                'mealName': "Salmón a la Plancha",
                'calories': 500,
                'fats': 25.0,
                'proteins': 35.0,
                'carbs': 20.0,
              };
            } else {
              mealDetails = {
                'mealType': "Snack",
                'mealName': "Yogur con Frutas",
                'calories': 150,
                'fats': 5.0,
                'proteins': 8.0,
                'carbs': 20.0,
              };
            }

            return _itemMealPlan(
              item.title,
              item.subtitle,
              item.icon,
              item.color,
              mealDetails: mealDetails,
            );
          },
        ),
      ],
    );
  }

  Widget _itemMealPlan(
      String title, String subtitle, IconData icon, Color color,
      {required Map<String, dynamic> mealDetails}) {
    return Container(
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            context.pushNamed(
              MealDetailScreen.name,
              extra: mealDetails,
            );
          },
          splashColor: MyColors.primarySwatch[10],
          highlightColor: MyColors.primarySwatch[50],
          focusColor: MyColors.primarySwatch[50],
          hoverColor: MyColors.primarySwatch[50],
          child: ListTile(
            leading: Icon(
              icon,
              color: MyColors.primaryColor,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(subtitle),
            trailing: Icon(Icons.check_circle, color: color),
          ),
        ),
      ),
    );
  }

  // Widget _buildRecipeSuggestions() {
  //   return Column(
  //     children: [
  //       const Text(
  //         "Sugerencias de Recetas:",
  //         style: TextStyle(
  //           fontSize: 20,
  //           fontWeight: FontWeight.bold,
  //           fontFamily: 'Viga',
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Card(
  //         elevation: 4,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: ListTile(
  //           leading: const Icon(Icons.restaurant),
  //           title: const Text('Ensalada Mediterránea'),
  //           onTap: () {
  //             // Acción para ver receta
  //           },
  //         ),
  //       ),
  //       const SizedBox(height: 10),
  //       Card(
  //         elevation: 4,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         child: ListTile(
  //           leading: const Icon(Icons.restaurant),
  //           title: const Text('Batido de Proteínas'),
  //           onTap: () {
  //             // Acción para ver receta
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class MealPlanItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const MealPlanItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}
