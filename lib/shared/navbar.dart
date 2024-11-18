import 'package:flutter/material.dart';
import 'package:nutrition_ai_app/config/menu/menu_items.dart';
import 'package:nutrition_ai_app/config/theme/my_colors.dart';

class CustomNavbar extends StatefulWidget {
  final Function(int) onTabChange; // Callback para manejar el cambio de pestaña
  final int selectedIndex; // El índice de la pestaña seleccionada

  const CustomNavbar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  State<CustomNavbar> createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(25),
        //   topRight: Radius.circular(25),
        // ), // Bordes redondeados
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Color de la sombra
            spreadRadius: 1.5, // Extensión de la sombra
            blurRadius: 15, // Difusión de la sombra
            offset: const Offset(
              0,
              -5,
            ), // Desplazamiento de la sombra en el eje x y y
          ),
        ],
      ),
      // padding: const EdgeInsets.only(top: 10),
      child: BottomNavigationBar(
        useLegacyColorScheme: false,
        type: BottomNavigationBarType.fixed,
        // elevation: 0,
        // shadowColor: Colors.black.withOpacity(0.1),
        backgroundColor: Colors.white,
        // indicatorColor: Colors.transparent,
        // surfaceTintColor: MyColors.primaryColor,
        currentIndex: widget.selectedIndex,
        // onDestinationSelected: widget.onTabChange,
        selectedItemColor: MyColors.primaryColor,
        unselectedItemColor: MyColors.primarySwatch[250],
        onTap: widget.onTabChange,
        items: [
          ...appMenuItems.map(
            (item) {
              return BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(item.icon, color: MyColors.primarySwatch[250], size: 30),
                activeIcon: Icon(item.iconSelected,
                    color: MyColors.primaryColor, size: 30),
                label: item.title,
              );
            },
          ),
        ],
        // labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        
      ),
    );
  }

  // Método para crear el ícono con gradiente usando ShaderMask
  Widget _gradientIcon(IconData icon, {double size = 24}) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [
            MyColors.secondaryColor, // Color de inicio del gradiente
            MyColors.primaryColor, // Color final del gradiente
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // Este color se reemplaza por el gradiente
      ),
    );
  }
}
