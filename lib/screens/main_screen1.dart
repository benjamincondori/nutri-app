import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/config/menu/menu_items.dart';
import 'package:nutrition_ai_app/controllers/user/user_controller.dart';
import 'package:nutrition_ai_app/screens/screens.dart';
import 'package:nutrition_ai_app/shared/navbar2.dart';

class MainScreen1 extends ConsumerStatefulWidget {
  static const String name = 'main_screen_1';

  const MainScreen1({super.key});

  @override
  MainScreen1State createState() => MainScreen1State();
}

class MainScreen1State extends ConsumerState<MainScreen1> {
  final UserController _con = UserController();
  int _selectedIndex = 0; // Mantiene el índice del tab seleccionado

  // Cambiar la pestaña seleccionada
  void _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Lista de las vistas correspondientes a cada tab
  final List<Widget> _screens = [
    const HomeScreen1(),
    const LoginScreen(),
    const MealListScreen(),
    const FoodListScreen(),
  ];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    _con.getUserProfileNutritionist(ref);
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
          menuItems: appMenuItems1,
        ),
      ),
    );
  }
}
