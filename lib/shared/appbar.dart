import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../config/theme/my_colors.dart';
import '../providers/user_provider.dart';
import '../screens/screens.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String userName;
  final String profileImageUrl;

  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color iconBackgroundColor;

  const CustomAppBar({
    super.key,
    required this.userName,
    required this.profileImageUrl,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNutritionist = ref.watch(userNutritionistProvider);

    return AppBar(
      shadowColor: Colors.grey,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 80,
      title: Row(
        children: [
          // Imagen de perfil
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: MyColors.primarySwatch[50],
              image: DecorationImage(
                image: NetworkImage(profileImageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Texto de bienvenida y nombre del usuario
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hola, bienvenido",
                style: TextStyle(
                  fontSize: 14,
                  // color: Color(0xFF7B7777),
                  color: textColor,
                ),
              ),
              Text(
                userName,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  // fontFamily: 'Viga',
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Botón de notificaciones
        userNutritionist != null
            ? _buttonAction(context, Iconsax.setting_2, () {
                context.pushNamed(ProfileScreen1.name);
              }, false)
            : _buttonAction(context, Iconsax.notification, () {
                context.pushNamed(NotificationsScreen.name);
              }, true),

        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buttonAction(BuildContext context, IconData icon, Function() onTap,
      bool hasNotification) {
    return Stack(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            // color: MyColors.primarySwatch[50],
            color: iconBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            highlightColor: Colors.transparent,
            iconSize: 28,
            icon: Icon(
              icon,
              // color: MyColors.primarySwatch[700],
              color: iconColor,
            ),
            // onPressed: () {
            //   context.pushNamed(ProfileScreen1.name);
            // },
            onPressed: onTap,
          ),
        ),
        // Indicador de notificación
        if (hasNotification)
          Positioned(
            right: 9,
            top: 10,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 234, 57, 44), // Color del indicador
                shape: BoxShape.circle, // Punto redondo
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
