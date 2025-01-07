import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class DailyCaloriesReport extends StatelessWidget {
  final List<double>
      dailyCalories; // Las calorías de los últimos días (debe incluir al menos 5 días).
  final double targetCalories;
  final List<String> days;

  const DailyCaloriesReport({
    Key? key,
    required this.dailyCalories,
    required this.targetCalories,
    required this.days,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tomar solo los últimos 5 días.
    final recentCalories = dailyCalories.length >= 5
        ? dailyCalories.sublist(dailyCalories.length - 5)
        : dailyCalories;
    
    final recentDays = days.length >= 5
        ? days.sublist(days.length - 5)
        : days;


    // Calcular el valor máximo dinámico para el eje Y.
    final maxCalories = recentCalories.reduce((a, b) => a > b ? a : b);
    final maxY = (maxCalories * 1).ceilToDouble();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reporte de Calorías Diarias',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxY,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.round()} kcal',
                          const TextStyle(color: Colors.white),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Calcula las fechas para los últimos 5 días.
                          // final date = DateTime.now()
                          //     .subtract(Duration(days: 4 - value.toInt()));
                          // String day = DateFormat('EEE', 'es_ES').format(date);
                          // day = day[0].toUpperCase() + day.substring(1);
                          // return Text(
                          //   day,
                          //   style: const TextStyle(fontSize: 12),
                          // );
                             if (value.toInt() >= 0 &&
                              value.toInt() < recentDays.length) {
                            return Text(
                              recentDays[value.toInt()],
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}');
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  // gridData: FlGridData(show: true),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval:
                        maxY / 5, // Intervalo de las líneas horizontales
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey, // Color de la línea
                        strokeWidth: 1, // Grosor de la línea
                        dashArray: [4, 4], // Patrón de líneas punteadas
                      );
                    },
                    verticalInterval: 1,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(recentCalories.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: recentCalories[index],
                          color: recentCalories[index] > targetCalories
                              ? Colors.red
                              : Colors.blue,
                          width: 16,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                const Text('Dentro del objetivo'),
                const SizedBox(width: 16),
                Container(
                  width: 16,
                  height: 16,
                  color: Colors.red,
                ),
                const SizedBox(width: 8),
                const Text('Excede el objetivo'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
