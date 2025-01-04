import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/controllers/auth/register_controller.dart';
import 'package:nutrition_ai_app/providers/physical_activity_provider.dart';

import '../../config/theme/my_colors.dart';
import '../../controllers/physical_activity/physical_activity_controller.dart';
import '../../models/physical_activity.dart';

class RegisterProfileScreen extends ConsumerStatefulWidget {
  static const String name = 'register_profile_screen';

  final int userId;

  const RegisterProfileScreen({super.key, required this.userId});

  @override
  RegisterProfileScreenState createState() => RegisterProfileScreenState();
}

class RegisterProfileScreenState extends ConsumerState<RegisterProfileScreen> {
  final RegisterController _con = RegisterController();
  final PhysicalActivityController _physicalActivityController = PhysicalActivityController();

  // Lista de opciones de género
  final List<String> _genderOptions = ['Masculino', 'Femenino', 'Otro'];

  // Lista de opciones de actividad física
  // final List<String> _physicalActivities = [
  //   'Sedentario',
  //   'Ligero',
  //   'Moderado',
  //   'Activo',
  //   'Muy activo',
  // ];

  // Lista de restricciones
  final List<String> _restrictions = [
    'Ninguna',
    'Diabetes',
    'Hipertensión',
    'Colesterol alto',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();

    // Se ejecuta despues del metodo build
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
      _physicalActivityController.init(context, refresh, ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final physicalActivities = ref.watch(physicalActivityProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity, // Ocupar todo el ancho
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageBanner(),
              _textRegister(),
              _textFieldGender(),
              _textFieldPhysicalActivity(physicalActivities),
              _textFieldBirthday(),
              _textFieldWeight(),
              _textFieldHeight(),
              _buildRestrictionSelector(),
              _buttonConfirm(),
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
        // Positioned(
        //   top: 50, // Ajusta la posición vertical
        //   left: 25, // Ajusta la posición horizontal
        //   child: GestureDetector(
        //     onTap: () {
        //       context.pop();
        //     },
        //     child: Container(
        //       padding: const EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //         gradient: LinearGradient(
        //           colors: [
        //             MyColors.primaryColor, // Color inicial del gradiente
        //             MyColors.secondaryColor, // Color final del gradiente
        //           ],
        //           begin: Alignment.topLeft,
        //           end: Alignment.bottomRight,
        //         ),
        //         boxShadow: [
        //           BoxShadow(
        //             color: MyColors.primaryColor.withOpacity(0.5),
        //             blurRadius: 10,
        //             offset: const Offset(0, 5),
        //           ),
        //         ],
        //         borderRadius: BorderRadius.circular(15),
        //       ),
        //       child: const Icon(
        //         CupertinoIcons.back,
        //         color: Colors.white,
        //         size: 30,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _textRegister() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 35, right: 35),
      child: Column(
        children: [
          Text(
            'Completemos tu Perfil',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Viga',
              fontSize: 30,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '¡Nos ayudará a saber más sobre ti!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MyColors.textColorPrimary,
              fontFamily: 'Viga',
              fontSize: 16,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldGender() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        hint: Text(
          'Género',
          style: TextStyle(
            color: MyColors.primaryColorDark,
          ),
        ),
        value: _con.selectedGender,
        focusColor: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Iconsax.profile_2user,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        items: _genderOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: MyColors.primaryColorDark,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _con.selectedGender = newValue;
          });
        },
        validator: (value) =>
            value == null ? 'Por favor selecciona un género' : null,
      ),
    );
  }
  
  Widget _textFieldPhysicalActivity(List<PhysicalActivity> physicalActivities) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: DropdownButtonFormField<String>(
        hint: Text(
          'Nivel de Actividad física',
          style: TextStyle(
            color: MyColors.primaryColorDark,
          ),
        ),
        value: _con.selectedActivity,
        focusColor: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Iconsax.timer_1,
            color: MyColors.primarySwatch,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
        ),
        items: physicalActivities.map((PhysicalActivity activity) {
          return DropdownMenuItem<String>(
            value: activity.id.toString(),
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                activity.name,
                style: TextStyle(
                  color: MyColors.primaryColorDark,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _con.selectedActivity = newValue;
          });
        },
        validator: (value) =>
            value == null ? 'Por favor selecciona un actividad' : null,
      ),
    );
  }

  Widget _buildRestrictionSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona tu restricción:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: MyColors.primaryColorDark,
              // fontFamily: 'Viga',
            ),
          ),
          const SizedBox(height: 10),
          ..._restrictions.map((String value) {
            return RadioListTile<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              dense: true,
              fillColor: WidgetStateProperty.all(MyColors.primarySwatch[600]),
              overlayColor:
                  WidgetStateProperty.all(MyColors.primarySwatch[100]),
              hoverColor: MyColors.primarySwatch[100],
              title: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.textColorPrimary,
                ),
              ),
              value: value,
              groupValue: _con.selectedRestriction,
              onChanged: (value) {
                setState(() {
                  _con.selectedRestriction = value ?? '';
                  _con.showCustomRestrictionField = _con.selectedRestriction == 'Otro';
                });
              },
            );
          }),
          if (_con.showCustomRestrictionField) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _con.customRestrictionController,
              minLines: 2,
              maxLines: 5,
              style: TextStyle(
                color: MyColors.textColorPrimary,
              ),
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelStyle: TextStyle(
                  color: MyColors.textColorPrimary,
                ),
                floatingLabelStyle: TextStyle(
                  color: MyColors.primarySwatch[600],
                ),
                labelText: 'Escribe tu restricción',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: MyColors.primarySwatch[600]!,
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: MyColors.primarySwatch[600]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(
                    color: MyColors.primarySwatch[600]!,
                  ),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }


  Widget _textFieldBirthday() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
        decoration: BoxDecoration(
          color: MyColors.primarySwatch[50],
          borderRadius: BorderRadius.circular(15),
        ),
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: _con.selectedDate == null
                  ? 'Fecha de nacimiento'
                  : '${_con.selectedDate!.day}/${_con.selectedDate!.month}/${_con.selectedDate!.year}',
              hintStyle: TextStyle(color: MyColors.primaryColorDark),
              prefixIcon: Icon(
                Iconsax.calendar_1,
                color: MyColors.primarySwatch,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
            ),
            style: TextStyle(
              color: MyColors.primaryColorDark,
            ),
            validator: (value) =>
                _con.selectedDate == null ? 'Por favor selecciona una fecha' : null,
          ),
        ),
      ),
    );
  }

  Widget _textFieldWeight() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: MyColors.primarySwatch[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                controller: _con.weightController,
                decoration: InputDecoration(
                  hintText: 'Peso',
                  hintStyle: TextStyle(color: MyColors.primaryColorDark),
                  prefixIcon: Icon(
                    Iconsax.weight,
                    color: MyColors.primarySwatch,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: MyColors.primaryColorDark,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu peso';
                  }
                  final double? weight = double.tryParse(value);
                  if (weight == null || weight <= 0) {
                    return 'Ingresa un peso válido';
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.secondaryColor,
                  MyColors.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'kg',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Viga',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldHeight() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: MyColors.primarySwatch[50],
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                controller: _con.heightController,
                decoration: InputDecoration(
                  hintText: 'Altura',
                  hintStyle: TextStyle(color: MyColors.primaryColorDark),
                  prefixIcon: Icon(
                    Iconsax.arrow_3,
                    color: MyColors.primarySwatch,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: MyColors.primaryColorDark),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu altura';
                  }
                  final double? height = double.tryParse(value);
                  if (height == null || height <= 0) {
                    return 'Ingresa una altura válida';
                  }
                  return null;
                },
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  MyColors.secondaryColor,
                  MyColors.primaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'cm',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Viga',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buttonConfirm() {
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
          _con.registerProfile(context, widget.userId);
          // context.goNamed(LoginScreen.name);
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
          'CONFIRMAR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  // Función para seleccionar la fecha de cumpleaños
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'), // Mostrar el calendario en español
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: MyColors
                  .primarySwatch[600]!, // Color de encabezado (mes y año)
              onPrimary: Colors.white, // Color del texto en el encabezado
              surface: MyColors.primarySwatch[10]!, // Fondo del cuadro
              onSurface: Colors.black, // Color de los números de días
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _con.selectedDate) {
      setState(() {
        _con.selectedDate = picked;
      });
    }
  }

  void refresh() {
    setState(() {});
  }
}
