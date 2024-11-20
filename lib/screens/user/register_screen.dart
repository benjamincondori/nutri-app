import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/controllers/auth/register_controller.dart';
import 'package:nutrition_ai_app/screens/screens.dart';

import '../../config/theme/my_colors.dart';

class UserRegisterScreen extends StatefulWidget {
  static const String name = 'user_register_screen';

  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final RegisterController _con = RegisterController();

  @override
  void initState() {
    super.initState();

    // Se ejecuta despues del metodo build
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity, // Ocupar todo el ancho
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageBanner(),
              _textRegister(),
              _textFieldName(),
              _textFieldSurname(),
              _textFieldEmail(),
              _textFieldPhone(),
              _textFieldPassword(),
              _buttonRegister(),
              _textHaveAccount(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageBanner() {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 375 / 318,
          child: SvgPicture.asset(
            'assets/img/image_logo_background.svg',
            fit: BoxFit.fill,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white.withOpacity(1.0), // Blanco opaco
                  Colors.white.withOpacity(0.0), // Blanco transparente
                ],
                stops: const [0.0, 0.25],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/img/image_logo.png',
                width: 130,
                height: 130,
              ),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [
                    MyColors.secondaryColor, // Color inicial del gradiente
                    MyColors.primaryColor, // Color final del gradiente
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                child: const Text(
                  'AI Nutrify',
                  style: TextStyle(
                    color: Colors
                        .white, // Este color será ignorado por el ShaderMask
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Viga',
                    fontSize: 40,
                    height: 1.2,
                  ),
                ),
              ),
              Text(
                'Nutrición diseñada solo para ti',
                style: TextStyle(
                  color: MyColors.primaryColorDark,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Viga',
                  fontSize: 15,
                  height: 1,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _textRegister() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 60, right: 60),
      child: Text(
        'Crea una Cuenta',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: MyColors.primaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'Viga',
          fontSize: 30,
          height: 1,
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          prefixIcon: Icon(
            Iconsax.sms,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        style: TextStyle(
          color: MyColors.primaryColorDark,
        ),
      ),
    );
  }

  Widget _textFieldName() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.nameController,
        decoration: InputDecoration(
          hintText: 'Nombre',
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          prefixIcon: Icon(
            Iconsax.user,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        style: TextStyle(
          color: MyColors.primaryColorDark,
        ),
      ),
    );
  }

  Widget _textFieldSurname() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.lastnameController,
        decoration: InputDecoration(
          hintText: 'Apellido',
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          prefixIcon: Icon(
            Iconsax.user,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        style: TextStyle(
          color: MyColors.primaryColorDark,
        ),
      ),
    );
  }

  Widget _textFieldPhone() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.phoneController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Telefono',
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          prefixIcon: Icon(
            Iconsax.mobile,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        style: TextStyle(
          color: MyColors.primaryColorDark,
        ),
      ),
    );
  }

  Widget _textFieldPassword() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Contraseña',
          hintStyle: TextStyle(color: MyColors.primaryColorDark),
          prefixIcon: Icon(
            Iconsax.lock_1,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        style: TextStyle(
          color: MyColors.primaryColorDark,
        ),
      ),
    );
  }

  Widget _buttonRegister() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
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
          // logica para guardar el usuario
          _con.register(context);
          // context.pushNamed(RegisterProfileScreen.name, extra: {
          //   'user_id': 1,
          // });
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
          'REGISTRARME',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Widget _textHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Ya tienes una cuenta? ',
          style: TextStyle(
            color: MyColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: () => context.pushReplacementNamed(LoginScreen.name),
          child: Text(
            'Inicia sesión',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}
