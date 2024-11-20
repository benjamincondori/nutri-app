import 'package:flutter/material.dart';

import '../config/theme/my_colors.dart';

class CustomCardWithLinks extends StatelessWidget {
  final String title;
  final List<OptionItem> options;

  const CustomCardWithLinks({
    super.key,
    required this.title,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal del card
            Padding(
              padding: const EdgeInsets.only(left: 12, right: 12, top: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Viga',
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Lista de opciones
            Column(
              children: options.map((option) {
                return InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    if (option.onTap != null) {
                      option.onTap!(); 
                    } else if (option.link != null) {
                      // Navega a la ruta definida
                      // context.pushNamed(option.link!);
                    }
                  },
                  splashColor: MyColors.primarySwatch[50],
                  highlightColor: MyColors.primarySwatch[50],
                  focusColor: MyColors.primarySwatch[50],
                  hoverColor: MyColors.primarySwatch[50],
                  child: ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 12, right: 8),
                    leading: Icon(
                      option.icon,
                      size: 25,
                      color: MyColors.primaryColor,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: MyColors.primaryColor,
                    ),
                    title: Text(
                      option.title,
                      style: TextStyle(
                        fontSize: 16,
                        color: MyColors.textColorPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// Clase para representar cada opción con ícono, título y link
class OptionItem {
  final IconData icon;
  final String title;
  final String? link;
  final VoidCallback? onTap;

  OptionItem({
    required this.icon,
    required this.title,
    this.link,
    this.onTap,
  });
}
