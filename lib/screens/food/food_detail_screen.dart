import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/my_colors.dart';
import '../../models/food.dart';

class FoodDetailScreen extends StatelessWidget {
  static const String name = 'food_detail_screen';

  final Food food;

  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildImage(context), // Imagen en la parte superior
          _buildFoodInfo(context), // Información sobre el alimento
          _buttomBack(context), // Botón de regreso
        ],
      ),
    );
  }

  // Imagen en la parte superior
  Widget _buildImage(BuildContext context) {
    return Positioned.fill(
      top: 0,
      bottom: MediaQuery.of(context).size.height * 0.4,
      child: Image.network(
        food.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  // Información sobre el alimento
  Widget _buildFoodInfo(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5, // Tamaño inicial (50% de la pantalla)
      minChildSize: 0.5, // Tamaño mínimo (50% de la pantalla)
      maxChildSize: 0.75, // Tamaño máximo (75% de la pantalla)
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Viga',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        food.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _nutrientInfoCard("Calorías", "${food.calories} kcal",
                                Icons.local_fire_department),
                            _nutrientInfoCard("Proteínas", "${food.proteins} g",
                                Icons.fitness_center),
                            _nutrientInfoCard(
                                "Grasas", "${food.fats} g", Icons.opacity),
                            _nutrientInfoCard("Carbohidratos",
                                "${food.carbohydrates} g", Icons.grain),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Añadir más información o elementos según sea necesario
                      const Text(
                        "Beneficios:",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Viga',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        food.benefits,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Categoria:",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Viga',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        food.category,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget de la tarjeta de información nutricional
  Widget _nutrientInfoCard(String label, String value, IconData icon) {
    return Container(
      constraints: const BoxConstraints(
        minWidth: 100,
      ),
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buttomBack(BuildContext context) {
    return Positioned(
      top: 40, // Ajusta la posición vertical
      left: 25, // Ajusta la posición horizontal
      child: GestureDetector(
        onTap: () {
          context.pop();
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MyColors.primaryColor, // Color inicial del gradiente
                MyColors.secondaryColor, // Color final del gradiente
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.primaryColor.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
