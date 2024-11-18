import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/theme/my_colors.dart';

class CustomAppBarWithBack extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final IconData? rightIcon;
  final VoidCallback? onRightIconPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Color iconBackgroundColor;
  final bool showBackButton;

  const CustomAppBarWithBack({
    super.key,
    this.rightIcon,
    this.onRightIconPressed,
    required this.title,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.iconBackgroundColor,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shadowColor: Colors.grey,
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.white,
      elevation: 1,
      automaticallyImplyLeading: false,
      toolbarHeight: 70,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    size: 30,
                    CupertinoIcons.back,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          // Usamos Expanded para que el texto ocupe el espacio disponible
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Viga',
                  fontSize: 20,
                ),
              ),
            ),
          ),
          if (rightIcon != null)
            GestureDetector(
              onTap: onRightIconPressed,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: MyColors.primarySwatch[50],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    // size: 30,
                    rightIcon,
                    color: MyColors.primarySwatch[600],
                  ),
                ),
              ),
            ),

          // GestureDetector(
          //   onTap: onRightIconPressed,
          //   child: Container(
          //     width: 40,
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: MyColors.primarySwatch[50],
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Center(
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Icon(
          //             size: 10,
          //             Icons.circle,
          //             color: MyColors.primarySwatch[600],
          //           ),
          //           const SizedBox(width: 1),
          //           Icon(
          //             size: 10,
          //             Icons.circle,
          //             color: MyColors.primarySwatch[600],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
