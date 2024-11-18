import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme/my_colors.dart';
import '../../shared/appbar_with_back.dart';

class CreateMealPlanScreen extends StatefulWidget {
  static const String name = 'create_meal_plan_screen';

  const CreateMealPlanScreen({super.key});

  @override
  State<CreateMealPlanScreen> createState() => _CreateMealPlanScreenState();
}

class _CreateMealPlanScreenState extends State<CreateMealPlanScreen> {
  String _selectedGoal = '';
  bool _showCustomGoalField = false;
  final TextEditingController _customGoalController = TextEditingController();
  int _selectedDays = 3; // Inicialmente seleccionamos 3 días

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white; 
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

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

  void _onGoalChanged(String? value) {
    setState(() {
      _selectedGoal = value ?? '';
      _showCustomGoalField = _selectedGoal == 'Otro';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Crear Plan de Alimentación',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGoalSelector(),
            const SizedBox(height: 30),
            _buildDaySelector(),
            const SizedBox(height: 30),
            _buttonGeneratePlan(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona tu objetivo:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Viga',
          ),
        ),
        const SizedBox(height: 10),
        ...[
          'Perder peso',
          'Ganar masa muscular',
          'Mantener peso',
          'Otro',
        ].map((String value) {
          return RadioListTile<String>(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            dense: true,
            fillColor: WidgetStateProperty.all(MyColors.primarySwatch[600]),
            overlayColor: WidgetStateProperty.all(MyColors.primarySwatch[100]),
            hoverColor: MyColors.primarySwatch[100],
            title: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: MyColors.textColorPrimary,
              ),
            ),
            value: value,
            groupValue: _selectedGoal,
            onChanged: _onGoalChanged,
          );
        }),
        if (_showCustomGoalField) ...[
          const SizedBox(height: 10),
          TextField(
            controller: _customGoalController,
            minLines: 2,
            maxLines: 5,
            style: TextStyle(
              color: MyColors.textColorPrimary,
            ),
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelStyle: TextStyle(
                color: MyColors.textColorPrimary,
              ),
              floatingLabelStyle: TextStyle(
                color: MyColors.primarySwatch[600],
              ),
              labelText: 'Escribe tu objetivo',
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
          ),
        ]
      ],
    );
  }

  Widget _buildDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Selecciona la cantidad de días:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Viga',
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            // color: MyColors.primarySwatch[10],
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: MyColors.primarySwatch[400]!,
            ),
          ),
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              enabledBorder: InputBorder.none,
              border: InputBorder.none,
            ),
            borderRadius: BorderRadius.circular(10),
            dropdownColor: MyColors.primarySwatch[10],
            value: _selectedDays,
            items: List.generate(7, (index) {
              return DropdownMenuItem<int>(
                value: index + 1,
                child: Text(
                  '${index + 1} días',
                  style: TextStyle(
                    color: MyColors.primaryColorDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
            onChanged: (int? newValue) {
              setState(() {
                _selectedDays = newValue!;
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
          ),
        ),
      ],
    );
  }

  Widget _buttonGeneratePlan() {
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
          // context.goNamed(HomeScreen.name);
          context.pop();
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
          'GENERAR PLAN',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
