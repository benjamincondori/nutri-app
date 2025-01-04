import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/config/theme/my_colors.dart';

import '../../providers/user_provider.dart';
import '../../shared/appbar_with_back.dart';
import '../../shared/card_with_links.dart';
import '../../shared/utils/shared_pref.dart';

class ProfileScreen1 extends ConsumerStatefulWidget {
  static const String name = 'profile_screen_1';

  const ProfileScreen1({super.key});

  @override
  ProfileScreen1State createState() => ProfileScreen1State();
}

class ProfileScreen1State extends ConsumerState<ProfileScreen1> {
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white; // Color inicial del AppBar
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  bool _isSwitched = false;

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

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNutritionistProvider);

    String userName =
        user != null ? '${user.name} ${user.lastname}' : 'Usuario';
    String profileImageUrl = user != null
        ? user.urlImage
        : "https://img.lovepik.com/png/20231128/3d-illustration-avatar-profile-man-collection-guy-cheerful_716220_wh860.png";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Mi Perfil',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileImage(profileImageUrl),
            const SizedBox(height: 8),
            _profileName(userName),
            // _profileInfoHealth(height, weight, age),
            const SizedBox(height: 15),
            _profileAccount(),
            const SizedBox(height: 30),
            _cardNotification(),
            const SizedBox(height: 30),
            _profileOthers(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _profileImage(String profileImageUrl) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 30),
      child: Stack(
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(profileImageUrl),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () {
                  _showImagePickerOptions(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileName(String name) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Text(
        name,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Viga',
          height: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _profileInfoHealth(double height, double weight, int age) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _cardInfoHealth('Altura', '$height cm'),
          _cardInfoHealth('Peso', '$weight kg'),
          _cardInfoHealth('Edad', '$age años'),
        ],
      ),
    );
  }

  Widget _cardInfoHealth(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(17),
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
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontFamily: 'Viga',
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: MyColors.primaryColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardNotification() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
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
              const Padding(
                padding: EdgeInsets.only(left: 12, right: 12, top: 10),
                child: Text(
                  'Notificaciones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Viga',
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Lista de opciones
              ListTile(
                dense: true,
                contentPadding: const EdgeInsets.only(left: 12, right: 8),
                leading: Icon(
                  Iconsax.notification,
                  size: 25,
                  color: MyColors.primaryColor,
                ),
                trailing: Switch(
                  value: _isSwitched,
                  onChanged: (value) {
                    setState(() {
                      _isSwitched = value;
                    });
                  },
                  activeColor: Colors.white,
                  activeTrackColor: MyColors.primarySwatch,
                  inactiveTrackColor: MyColors.primarySwatch[50],
                  trackOutlineColor:
                      WidgetStateProperty.all(MyColors.primarySwatch),
                  trackOutlineWidth: WidgetStateProperty.all(1),
                  inactiveThumbColor: MyColors.primarySwatch[300],
                ),
                title: Text(
                  'Activar Notificaciones',
                  style: TextStyle(
                    fontSize: 16,
                    color: MyColors.textColorPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileAccount() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: CustomCardWithLinks(
        title: 'Mi Cuenta',
        options: [
          OptionItem(
            icon: Iconsax.profile_circle,
            title: 'Editar Perfil',
            link: '/edit-profile',
          ),
          OptionItem(
            icon: Iconsax.chart_square,
            title: 'Mis progresos',
            link: '/statistics',
          ),
          OptionItem(
            icon: Iconsax.lock_1,
            title: 'Cambiar Contraseña',
            link: '/change-password',
          ),
          OptionItem(
            icon: Iconsax.cards,
            title: 'Métodos de Pago',
            link: '/payment-methods',
          ),
        ],
      ),
    );
  }

  Widget _profileOthers() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: CustomCardWithLinks(
        title: 'Otros',
        options: [
          OptionItem(
            icon: Iconsax.info_circle,
            title: 'Acerca de',
            link: '/about',
          ),
          OptionItem(
            icon: Iconsax.star,
            title: 'Calificar la App',
            link: '/rate-app',
          ),
          OptionItem(
            icon: Iconsax.sms,
            title: 'Contáctanos',
            link: '/contact-us',
          ),
          OptionItem(
            icon: Iconsax.shield_tick,
            title: 'Políticas de Privacidad',
            link: '/privacy-policy',
          ),
          OptionItem(
            icon: Iconsax.setting_2,
            title: 'Configuración',
            link: '/settings',
          ),
          OptionItem(
            icon: Icons.logout,
            title: 'Cerrar Sesión',
            onTap: () async {
              // Ejecuta el método de cierre de sesión
              SharedPref().logout(context);
            },
          ),
        ],
      ),
    );
  }

  // Función para mostrar las opciones de actualización de imagen
  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Cámara"),
                onTap: () {
                  // Aquí va la lógica para tomar una foto con la cámara
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Galería"),
                onTap: () {
                  // Aquí va la lógica para elegir una imagen de la galería
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
