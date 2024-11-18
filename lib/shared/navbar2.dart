import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nutrition_ai_app/config/menu/menu_items.dart';
import 'package:nutrition_ai_app/config/theme/my_colors.dart';

class CustomNavbar2 extends StatefulWidget {
  final Function(int) onTabChange; // Callback para manejar el cambio de pestaña
  final int selectedIndex; // El índice de la pestaña seleccionada

  const CustomNavbar2({
    super.key,
    required this.onTabChange,
    required this.selectedIndex,
  });

  @override
  State<CustomNavbar2> createState() => _CustomNavbar2State();
}

class _CustomNavbar2State extends State<CustomNavbar2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(
      //   horizontal: 10,
      //   vertical: 10,
      // ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ), // Bordes redondeados
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: GNav(
        gap: 8,
        backgroundColor: Colors.white,
        // color: Colors.grey[800], // Color del ícono no seleccionado
        // activeColor: Colors.white, // Color del ícono seleccionado
        tabBackgroundColor:
            MyColors.primarySwatch[50]!, // Fondo del tab seleccionado
        tabBorderRadius: 20,
        padding: const EdgeInsets.all(16),
        selectedIndex: widget.selectedIndex, // El tab seleccionado
        onTabChange:
            widget.onTabChange, // Llama a la función pasada al componente
        tabs: [
          ...appMenuItems.map(
            (item) {
              IconData icon = widget.selectedIndex == appMenuItems.indexOf(item)
                  ? item.iconSelected
                  : item.icon;
              return GButton(
                icon: icon,
                text: item.title,
                textColor: MyColors.primaryColorDark,
                leading: _gradientIcon(icon, size: 30),
              );
            },
          ),
        ],
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
