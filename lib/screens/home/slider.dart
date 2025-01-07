import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/config/theme/my_colors.dart';

class MacronutrientSliderWidget extends ConsumerStatefulWidget {
  final double consumedCalories;
  final double targetCalories;
  final double consumedProtein;
  final double targetProtein;
  final double consumedCarbs;
  final double targetCarbs;
  final double consumedFat;
  final double targetFat;

  const MacronutrientSliderWidget({
    super.key,
    required this.consumedCalories,
    required this.targetCalories,
    required this.consumedProtein,
    required this.targetProtein,
    required this.consumedCarbs,
    required this.targetCarbs,
    required this.consumedFat,
    required this.targetFat,
  });

  @override
  MacronutrientSliderWidgetState createState() =>
      MacronutrientSliderWidgetState();
}

class MacronutrientSliderWidgetState
    extends ConsumerState<MacronutrientSliderWidget> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildMacroCard({
    required String title,
    required double consumed,
    required double target,
    required Color color,
    required String unit,
  }) {
    final double percentage = target > 0 ? (consumed / target) : 0;
    final double remaining = target - consumed;

    return Container(
      margin: const EdgeInsets.only(left: 7, right: 7, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Círculo de progreso
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: percentage,
                        backgroundColor: Colors.grey[200],
                        strokeWidth: 10,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          percentage > 1 ? Colors.red : color,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: 100,
                          child: Text(
                            '$title ingeridas',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600]!,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${consumed.toInt()} $unit',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '(${(percentage * 100).toInt()}%)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Información de objetivo y saldo
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Objetivo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${target.toInt()} $unit',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Saldo',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${remaining >= 0 ? '+' : ''}${remaining.toInt()} $unit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: remaining >= 0 ? color : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250, // Ajusta esta altura según tus necesidades
          child: PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              // Calorías
              _buildMacroCard(
                title: 'Calorías',
                consumed: widget.consumedCalories,
                target: widget.targetCalories,
                color: MyColors.primaryColor,
                unit: 'kcal',
              ),
              // Proteínas
              _buildMacroCard(
                title: 'Proteínas',
                consumed: widget.consumedProtein,
                target: widget.targetProtein,
                color: Colors.blue,
                unit: 'g',
              ),
              // Carbohidratos
              _buildMacroCard(
                title: 'Carbohidratos',
                consumed: widget.consumedCarbs,
                target: widget.targetCarbs,
                color: Colors.orange,
                unit: 'g',
              ),
              // Grasas
              _buildMacroCard(
                title: 'Grasas',
                consumed: widget.consumedFat,
                target: widget.targetFat,
                color: Colors.purple,
                unit: 'g',
              ),
            ],
          ),
        ),
        // Indicadores de página
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            4,
            (index) => Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index ? Colors.blue : Colors.grey[300],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
