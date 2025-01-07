import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../shared/utils/nutrition_data_processor1.dart';

class NutritionReportSlider extends StatefulWidget {
  final List<Map<String, dynamic>> plans;

  const NutritionReportSlider({Key? key, required this.plans})
      : super(key: key);

  @override
  _NutritionReportSliderState createState() => _NutritionReportSliderState();
}

class _NutritionReportSliderState extends State<NutritionReportSlider> {
  String _timeframe = 'day';
  int _currentIndex = 0;
  final List<String> _nutrients = [
    'calories',
    'proteins',
    'carbohydrates',
    'fats'
  ];
  final List<String> _nutrientTitles = [
    'Calorías',
    'Proteínas',
    'Carbohidratos',
    'Grasas'
  ];
  final List<Color> _nutrientColors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  @override
  Widget build(BuildContext context) {
    final data = NutritionDataProcessor.processData(widget.plans, _timeframe);

    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reporte de ${_nutrientTitles[_currentIndex]}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: _timeframe,
                  items: [
                    DropdownMenuItem(
                        value: 'day', child: Text('Últimos 7 días')),
                    DropdownMenuItem(value: 'week', child: Text('Semana')),
                    DropdownMenuItem(value: 'month', child: Text('Mes')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _timeframe = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: _nutrients.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: data
                              .map((d) => d.toDouble(_nutrients[index]))
                              .reduce((a, b) => a > b ? a : b) *
                          1.2,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            return BarTooltipItem(
                              '${rod.toY.round()} ${_nutrientUnits[index]}',
                              TextStyle(color: Colors.white),
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
                              final date = data[value.toInt()].date;
                              return Text(DateFormat('E').format(date));
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
                        topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(show: false),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(data.length, (i) {
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: data[i].toDouble(_nutrients[index]),
                              color: _nutrientColors[index],
                              width: 16,
                            ),
                          ],
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _nutrients.length,
                (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  child: Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? _nutrientColors[index]
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> _nutrientUnits = ['kcal', 'g', 'g', 'g'];
}

extension on NutritionDataPoint {
  double toDouble(String nutrient) {
    switch (nutrient) {
      case 'calories':
        return calories;
      case 'proteins':
        return proteins;
      case 'carbohydrates':
        return carbohydrates;
      case 'fats':
        return fats;
      default:
        return 0;
    }
  }
}
