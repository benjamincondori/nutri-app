import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nutrition_ai_app/config/theme/my_colors.dart';
import 'package:nutrition_ai_app/controllers/user/user_controller.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const String name = 'splash_screen';

  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  final UserController _con = UserController();
  double _opacity = 0.0; // Controla la opacidad para la animación

  @override
  void initState() {
    super.initState();
    _startAnimation(); // Inicia la animación
    _startSplashScreenTimer(); // Navega después de la animación
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }
  

  // Controla la navegación después del splash
  void _startSplashScreenTimer() async {
    await Future.delayed(
      const Duration(seconds: 4),
      () {
        setState(() {
          _opacity = 0.0; // Inicia el fade out (desvanecer)
        });
      },
    );

    await Future.delayed(
      const Duration(
        milliseconds: 400,
      ),
      () {
        _con.checkAuthSession(ref);
      },
    );
    
    _con.checkAuthSession(ref);
  }

  // Inicia la animación del fade in
  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _opacity = 1.0; // Cambia la opacidad de 0 a 1
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(seconds: 2), // Duración del fade in
            child: _imageBanner(), // Reutiliza tu widget de splash
          ),
        ));
  }

  Widget _imageBanner() {
    return Stack(
      children: [
        // Fondo del Splash
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          child: AspectRatio(
            aspectRatio: 375 / 318,
            child: SvgPicture.asset(
              'assets/img/image_logo_background.svg',
              fit: BoxFit.fill,
            ),
          ),
        ),

        // Gradiente sobre el fondo
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AspectRatio(
            aspectRatio: 375 / 318, // Misma proporción que el fondo
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white.withOpacity(1.0), // Blanco opaco
                    Colors.white.withOpacity(0.0), // Blanco transparente
                  ],
                  stops: const [0.0, 0.4],
                ),
              ),
            ),
          ),
        ),

        // Logo y texto centrados
        Center(
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
  
  void refresh() {
    setState(() {});
  }
}
