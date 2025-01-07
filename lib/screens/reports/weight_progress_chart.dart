// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:intl/intl.dart';

// class WeightEntry {
//   final DateTime date;
//   final double weight;

//   WeightEntry({required this.date, required this.weight});
// }

// class WeightProgressChart extends StatelessWidget {
//   final List<WeightEntry> weightEntries;

//   const WeightProgressChart({Key? key, required this.weightEntries})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Ordenar las entradas por fecha
//     final sortedEntries = List<WeightEntry>.from(weightEntries)
//       ..sort((a, b) => a.date.compareTo(b.date));

//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Progreso de Peso',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//             const SizedBox(height: 16),
//             AspectRatio(
//               aspectRatio: 1.7,
//               child: LineChart(
//                 LineChartData(
//                   gridData: FlGridData(show: false),
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           final index = value.toInt();
//                           if (index >= 0 && index < sortedEntries.length) {
//                             return Padding(
//                               padding: const EdgeInsets.only(top: 8.0),
//                               child: Text(
//                                 DateFormat('dd/MM')
//                                     .format(sortedEntries[index].date),
//                                 style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             );
//                           }
//                           return Text('');
//                         },
//                         reservedSize: 32,
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           return Text(
//                             '${value.toStringAsFixed(1)}',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 12,
//                             ),
//                           );
//                         },
//                         reservedSize: 40,
//                       ),
//                     ),
//                     topTitles:
//                         AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                     rightTitles:
//                         AxisTitles(sideTitles: SideTitles(showTitles: false)),
//                   ),
//                   borderData: FlBorderData(
//                     show: true,
//                     border:
//                         Border.all(color: const Color(0xff37434d), width: 1),
//                   ),
//                   minX: 0,
//                   maxX: sortedEntries.length - 1.0,
//                   minY: sortedEntries
//                           .map((e) => e.weight)
//                           .reduce((a, b) => a < b ? a : b) -
//                       1,
//                   maxY: sortedEntries
//                           .map((e) => e.weight)
//                           .reduce((a, b) => a > b ? a : b) +
//                       1,
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: sortedEntries.asMap().entries.map((entry) {
//                         return FlSpot(entry.key.toDouble(), entry.value.weight);
//                       }).toList(),
//                       isCurved: true,
//                       color: Colors.blue,
//                       barWidth: 3,
//                       isStrokeCapRound: true,
//                       dotData: FlDotData(show: true),
//                       belowBarData: BarAreaData(
//                         show: true,
//                         color: Colors.blue.withOpacity(0.3),
//                       ),
//                     ),
//                   ],
//                   lineTouchData: LineTouchData(
//                     touchTooltipData: LineTouchTooltipData(
//                       // tooltipBgColor: Colors.blueAccent,
//                       getTooltipItems: (touchedSpots) {
//                         return touchedSpots.map((LineBarSpot touchedSpot) {
//                           final date =
//                               sortedEntries[touchedSpot.x.toInt()].date;
//                           final weight = touchedSpot.y;
//                           return LineTooltipItem(
//                             '${DateFormat('dd/MM/yyyy').format(date)}\n$weight kg',
//                             const TextStyle(color: Colors.white),
//                           );
//                         }).toList();
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ProgresoPesoReporte extends StatelessWidget {
  final List<Map<String, dynamic>>
      progresoPeso; // Lista de mapas con 'fecha' y 'peso'

  const ProgresoPesoReporte({
    Key? key,
    required this.progresoPeso, // Lista de datos con fecha y peso
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convertir las fechas y pesos a los formatos que usaremos
    final fechas = progresoPeso
        .map((data) => DateTime.parse(data['fecha'] as String))
        .toList();
    final pesos = progresoPeso.map((data) => data['peso'] as double).toList();

    double maxPeso =
        pesos.isNotEmpty ? pesos.reduce((a, b) => a > b ? a : b) : 0;
    // double maxY = (maxPeso +
    //     20 -
    //     (maxPeso % 20)); // Redondear hacia el siguiente múltiplo de 20

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progreso de Peso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval:
                        5, // Intervalo de las líneas horizontales
                    verticalInterval: 1, // Intervalo de las líneas verticales
                    getDrawingHorizontalLine: (value) {
                      return const FlLine(
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashArray: [4, 4], // Líneas punteadas horizontales
                      );
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          // Muestra las fechas en el eje X
                          final index = value.toInt();
                          print("index: $index");
                          print("longitud: ${fechas.length}");
                          if (index >= 0 && index < fechas.length) {
                            final fecha = fechas[index];
                            print("Fecha: $fecha");
                            return Text(
                              DateFormat('dd/MM')
                                  .format(fecha), // Muestra en formato día/mes
                              style: const TextStyle(fontSize: 12),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toStringAsFixed(1)} kg');
                        },
                      ),
                    ),
                    topTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles:
                        AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(fechas.length, (index) {
                        return FlSpot(index.toDouble(), pesos[index]);
                      }),
                      isCurved: true, // Hacer la línea curvada
                      // colors: [Colors.blue],
                      barWidth: 3,
                      belowBarData: BarAreaData(
                          show: false), // No mostrar el área debajo de la línea
                    ),
                  ],
                  // Establecer maxY dinámicamente y el intervalo
                  maxY: maxPeso,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
