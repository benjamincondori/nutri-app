import 'package:flutter/material.dart';

import '../../config/theme/my_colors.dart';
import '../../shared/appbar_with_back.dart';

class MealDetailScreen extends StatefulWidget {
  static const String name = 'detail_meal_plan_screen';

  final String mealType; // "Desayuno", "Almuerzo", "Cena"
  final String mealName; // Nombre de la comida
  final int calories;
  final double fats;
  final double proteins;
  final double carbs;

  const MealDetailScreen({
    super.key,
    required this.mealType,
    required this.mealName,
    required this.calories,
    required this.fats,
    required this.proteins,
    required this.carbs,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final List<Map<String, String>> _mealFoods = [
    {
      'image': 'https://via.placeholder.com/50', // URL de la imagen
      'title': 'Pan Integral',
      'description': 'Una rebanada de pan integral.',
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Huevo Cocido',
      'description': 'Un huevo cocido, excelente fuente de proteínas.',
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Aguacate',
      'description': 'Una porción de aguacate, rico en grasas saludables.',
    },
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: widget.mealType,
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
            Text(
              widget.mealName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Viga',
              ),
            ),
            const SizedBox(height: 15),

            // Información nutricional
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _buildNutritionInfo('Calorías', '${widget.calories} kcal'),
            //     _buildNutritionInfo('Grasas', '${widget.fats} g'),
            //     _buildNutritionInfo('Proteínas', '${widget.proteins} g'),
            //     _buildNutritionInfo('Carbohidratos', '${widget.carbs} g'),
            //   ],
            // ),
            // Scroll horizontal para los macronutrientes
            // Container(
            //   // margin: const EdgeInsets.symmetric(vertical: 10),
            //   // padding: const EdgeInsets.all(10),
            //   height: 90, // Altura del contenedor
            //   child: ListView(
            //     padding: const EdgeInsets.all(10),
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       _nutrientCard('Calorías', '${widget.calories} kcal',
            //           'https://via.placeholder.com/50'),
            //       _nutrientCard('Grasas', '${widget.fats} g',
            //           'https://via.placeholder.com/50'),
            //       _nutrientCard('Proteínas', '${widget.proteins} g',
            //           'https://via.placeholder.com/50'),
            //       _nutrientCard('Carbohidratos', '${widget.carbs} g',
            //           'https://via.placeholder.com/50'),
            //     ],
            //   ),
            // ),

            SizedBox(
              height: 70,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _nutrientInfoCard("150 kcal", Icons.local_fire_department),
                  _nutrientInfoCard("10 g Proteínas", Icons.fitness_center),
                  _nutrientInfoCard("5 g Grasas", Icons.opacity),
                  _nutrientInfoCard("20 g Carbohidratos", Icons.grain),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // Título de la lista de alimentos
            const Text(
              'Alimentos:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Listado de alimentos
            Expanded(
              child: ListView.separated(
                itemCount: _mealFoods.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return _buildFoodItem(
                    _mealFoods[index]['image']!,
                    _mealFoods[index]['title']!,
                    _mealFoods[index]['description']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar la información nutricional
  // Widget _buildNutritionInfo(String label, String value) {
  //   return Column(
  //     children: [
  //       Text(
  //         value,
  //         style: const TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       const SizedBox(height: 5),
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 14,
  //           color: Colors.grey,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _nutrientCard(String title, String value, String imagePath) {
  //   return Container(
  //     margin: const EdgeInsets.only(right: 10),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[200], // Color de fondo
  //       borderRadius: BorderRadius.circular(10), // Bordes redondeados
  //       boxShadow: const [
  //         BoxShadow(
  //           color: Colors.black12,
  //           blurRadius: 5,
  //           offset: Offset(0, 2),
  //         ),
  //       ],
  //     ),
  //     child: Padding(
  //       padding: const EdgeInsets.all(15.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         crossAxisAlignment: CrossAxisAlignment.center,
  //         children: [
  //           Image.network(
  //             imagePath,
  //             height: 40,
  //             width: 40,
  //           ),
  //           const SizedBox(width: 10),
  //           Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 title,
  //                 style: const TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               Text(
  //                 value,
  //                 style: const TextStyle(color: Colors.black54),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget para construir cada ítem de alimento
  Widget _buildFoodItem(String imageUrl, String title, String description) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        radius: 30,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        description,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
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
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       value,
          //       style: const TextStyle(
          //         fontSize: 14,
          //         color: Colors.black54,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
