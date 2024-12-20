import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;
  final IconData iconSelected;

  const MenuItem({
    required this.title,
    required this.subTitle,
    required this.link,
    required this.icon,
    required this.iconSelected,
  });
}

const appMenuItems = <MenuItem>[
  MenuItem(
    title: 'Inicio',
    subTitle: 'Pantalla de inicio',
    link: '/',
    icon: Iconsax.home,
    iconSelected: Iconsax.home_15,
  ),
  MenuItem(
    title: 'Mis Planes',
    subTitle: 'Planes de alimentación',
    link: '/buttons',
    icon: Iconsax.menu_board,
    iconSelected: Iconsax.menu_board5,
  ),
  // MenuItem(
  //   title: 'Recetas',
  //   subTitle: 'Recetas de cocina',
  //   link: '/cards',
  //   icon: Icons.restaurant,
  // ),
  MenuItem(
    title: 'Ayuda',
    subTitle: 'Centro de ayuda',
    link: '/theme-changer',
    icon: Iconsax.lamp_charge,
    iconSelected: Iconsax.lamp_charge5,
  ),
  MenuItem(
    title: 'Mi Perfil', 
    subTitle: 'Perfil de usuario', 
    link: '/theme-changer', 
    icon: Iconsax.tag_user,
    iconSelected: Iconsax.tag_user5
  ),
  
];
