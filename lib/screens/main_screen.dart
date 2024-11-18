import 'package:flutter/material.dart';
import 'package:nutrition_ai_app/screens/screens.dart';
import 'package:nutrition_ai_app/shared/navbar2.dart';

class MainScreen extends StatefulWidget {
  static const String name = 'main_screen';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Mantiene el índice del tab seleccionado

  // Cambiar la pestaña seleccionada
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lista de las vistas correspondientes a cada tab
  final List<Widget> _screens = [
    const HomeScreen(),
    const LoginScreen(),
    const FoodListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomNavbar2(
          onTabChange: _onTabChange, // Pasar la función de cambio de tab
          selectedIndex: _selectedIndex, // El índice de la pestaña seleccionada
        ),
      ),
    );
  }
}
