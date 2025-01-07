import 'package:flutter/material.dart';
import 'package:nutrition_ai_app/screens/reports/daily_calories_report.dart';
import 'package:nutrition_ai_app/screens/reports/nutrition_report_slider.dart';
import 'package:nutrition_ai_app/screens/reports/weight_progress_chart.dart';
import 'package:nutrition_ai_app/services/plan/plan_service.dart';

import '../../config/theme/my_colors.dart';
import '../../shared/appbar_with_back.dart';
import '../home/slider.dart';

class ReportsScreen extends StatefulWidget {
  static const String name = 'reports_screen';

  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  List<Map<String, dynamic>> _plans = [];
  final PlanService _nutritionService = PlanService();

  List<double> dailyCalories1 = []; 
  bool isLoading = true; // Indicador de carga.

  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  @override
  void initState() {
    super.initState();

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   _con.init(context, refresh, ref);
    // });

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

    _fetchPlans();
    _fetchDailyCalories();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  Future<void> _fetchPlans() async {
    // Simula la obtención de datos de tu backend
    // En una aplicación real, aquí harías una llamada a tu API
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      _plans = [
        {
          "calories": 6919.31665,
          "date_generation": "2025-01-05T15:49:18",
          "meals": [
            {
              "date": "2025-01-05T15:49:18",
              "day": 1,
              "foods": [
                {
                  "benefits":
                      "Rico en carbohidratos y fibra, ayuda en la digestión y el control del colesterol.",
                  "calories": 363.0,
                  "carbohydrates": 73.0,
                  "category": "cereales y derivados",
                  "description":
                      "Grano de cereal que se utiliza para hacer harina y tortillas.",
                  "fats": 3.8,
                  "food_id": 130,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642593/ss66xdwibqqpsziraaxi.jpg",
                  "name": "Maíz",
                  "proteins": 9.2,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Propiedades antiinflamatorias y mejora el sueño.",
                  "calories": 48.0,
                  "carbohydrates": 11.7,
                  "category": "frutas",
                  "description":
                      "Fruta dulce con alto contenido de antioxidantes.",
                  "fats": 0.1,
                  "food_id": 56,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732637885/os6olqc4f31zbl0h5hnv.jpg",
                  "name": "Cereza",
                  "proteins": 0.8,
                  "quantity": 100.0,
                  "type_quantity": "unidad"
                },
                {
                  "benefits":
                      "Reduce la inflamación y mejora la salud cardiovascular.",
                  "calories": 62.0,
                  "carbohydrates": 15.9,
                  "category": "frutas",
                  "description": "Fruta exótica rica en antioxidantes.",
                  "fats": 0.1,
                  "food_id": 60,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732637729/yvswb2oaxnrp0go5dhpb.jpg",
                  "name": "Granada",
                  "proteins": 0.5,
                  "quantity": 100.0,
                  "type_quantity": "unidad"
                },
                {
                  "benefits":
                      "Fuente de potasio, ayuda a la función muscular y nerviosa.",
                  "calories": 85.0,
                  "carbohydrates": 19.5,
                  "category": "frutas",
                  "description": "Fruta dulce y rica en potasio.",
                  "fats": 0.3,
                  "food_id": 74,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732637652/ipzac2pbpcdak8jdgfq6.jpg",
                  "name": "Plátano",
                  "proteins": 1.2,
                  "quantity": 100.0,
                  "type_quantity": "unidad"
                },
                {
                  "benefits": "Rico en calcio, mejora la salud dental y ósea.",
                  "calories": 306.0,
                  "carbohydrates": 22.0,
                  "category": "quesos",
                  "description":
                      "Queso semiduro, con un sabor suave y ligeramente dulce.",
                  "fats": 22.0,
                  "food_id": 155,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732643111/vyoigk3sjpkr9gp8nnmg.jpg",
                  "name": "Edam",
                  "proteins": 26.0,
                  "quantity": 76.62,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 40,
              "meal_status": false,
              "meal_type": "desayuno",
              "name": "desayuno",
              "total_calories": 792.4572000000001,
              "total_carbohydrates": 142.10000000000002,
              "total_fats": 26.3,
              "total_proteins": 37.7
            },
            {
              "date": "2025-01-05T15:49:18",
              "day": 1,
              "foods": [
                {
                  "benefits":
                      "Rico en proteínas vegetales, bajo en grasas, ayuda a mantener la salud muscular y digestiva.",
                  "calories": 304.0,
                  "carbohydrates": 53.6,
                  "category": "legumbres",
                  "description":
                      "Semillas de guisante secas, muy nutritivas y ricas en proteína.",
                  "fats": 2.0,
                  "food_id": 120,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642620/xbn4bkipr9f9kmtmhx5w.jpg",
                  "name": "Guisantes secos",
                  "proteins": 21.7,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Rico en proteínas y bajo en grasas, ideal para dietas equilibradas.",
                  "calories": 81.0,
                  "carbohydrates": 1.2,
                  "category": "pescados",
                  "description": "Pescado blanco con carne firme y delicada",
                  "fats": 1.3,
                  "food_id": 43,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732634636/zw8ml0jfrcamsoohxy2u.jpg",
                  "name": "Rodaballo",
                  "proteins": 16.3,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Alto en omega-3, beneficioso para el cerebro y el sistema cardiovascular.",
                  "calories": 176.0,
                  "carbohydrates": 0.0,
                  "category": "pescados",
                  "description": "Pescado azul graso con sabor intenso.",
                  "fats": 12.0,
                  "food_id": 44,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732634634/e2dorns64zusaxkm4r4i.jpg",
                  "name": "Salmón",
                  "proteins": 18.4,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Mejora la digestión, combate la hinchazón y proporciona fibra.",
                  "calories": 19.0,
                  "carbohydrates": 2.5,
                  "category": "verduras/hortalizas",
                  "description":
                      "Vegetal crucífero con sabor suave y textura firme.",
                  "fats": 0.1,
                  "food_id": 113,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638624/syrbaqc1purfxr7calqk.jpg",
                  "name": "Repollo",
                  "proteins": 2.1,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Baja en grasas, excelente fuente de proteínas magras y vitaminas.",
                  "calories": 120.0,
                  "carbohydrates": 0.0,
                  "category": "carnes",
                  "description":
                      "Carne magra y tierna, baja en grasas y colesterol, excelente para dietas equilibradas.",
                  "fats": 6.6,
                  "food_id": 8,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732632227/jv8yfzqbdalgnlys3njq.jpg",
                  "name": "Conejo",
                  "proteins": 21.2,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 41,
              "meal_status": false,
              "meal_type": "almuerzo",
              "name": "almuerzo",
              "total_calories": 700.0,
              "total_carbohydrates": 57.300000000000004,
              "total_fats": 22.0,
              "total_proteins": 79.7
            },
            {
              "date": "2025-01-05T15:49:18",
              "day": 1,
              "foods": [
                {
                  "benefits":
                      "Rica en grasas monoinsaturadas, beneficiosa para la salud cardiovascular.",
                  "calories": 625.0,
                  "carbohydrates": 1.8,
                  "category": "frutos secos",
                  "description":
                      "Fruto seco con textura crujiente y sabor a nuez.",
                  "fats": 62.9,
                  "food_id": 79,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638452/upnebrtarjbmxnoe8i6a.jpg",
                  "name": "Avellana",
                  "proteins": 13.0,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Alto en proteínas, grasas saludables, y energía sostenida.",
                  "calories": 452.0,
                  "carbohydrates": 35.0,
                  "category": "frutos secos",
                  "description":
                      "Legumbre con alto contenido de proteínas y grasas.",
                  "fats": 25.6,
                  "food_id": 80,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638450/xyxxgr4dk5gk3sdqs5dx.jpg",
                  "name": "Cacahuete",
                  "proteins": 20.4,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 42,
              "meal_status": false,
              "meal_type": "cena",
              "name": "cena",
              "total_calories": 1077.0,
              "total_carbohydrates": 36.8,
              "total_fats": 88.5,
              "total_proteins": 33.4
            },
            {
              "date": "2025-01-06T15:49:18",
              "day": 2,
              "foods": [
                {
                  "benefits":
                      "Rico en antioxidantes, mejora el rendimiento cognitivo y combate el envejecimiento.",
                  "calories": 564.0,
                  "carbohydrates": 50.8,
                  "category": "otros",
                  "description":
                      "Producto dulce hecho a base de cacao, usado como golosina o ingrediente de repostería.",
                  "fats": 37.9,
                  "food_id": 163,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732643088/ooozh9fiyaei78wtqukb.jpg",
                  "name": "Chocolate",
                  "proteins": 8.9,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Fuente de grasas monoinsaturadas, beneficioso para el corazón y la piel.",
                  "calories": 232.0,
                  "carbohydrates": 3.2,
                  "category": "frutas",
                  "description": "Fruto cremoso y rico en grasas saludables.",
                  "fats": 23.5,
                  "food_id": 53,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732637897/vhelx5ihsog1uir9pyqm.jpg",
                  "name": "Aguacate",
                  "proteins": 1.9,
                  "quantity": 98.47790948275863,
                  "type_quantity": "unidad"
                }
              ],
              "meal_id": 43,
              "meal_status": false,
              "meal_type": "desayuno",
              "name": "desayuno",
              "total_calories": 792.46875,
              "total_carbohydrates": 54.0,
              "total_fats": 61.4,
              "total_proteins": 10.8
            },
            {
              "date": "2025-01-06T15:49:18",
              "day": 2,
              "foods": [
                {
                  "benefits":
                      "Baja en grasas y rica en proteínas, ideal para dietas saludables.",
                  "calories": 120.0,
                  "carbohydrates": 0.5,
                  "category": "carnes",
                  "description":
                      "Ave de carne magra y delicada, rica en proteínas y baja en grasas.",
                  "fats": 1.4,
                  "food_id": 20,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732632565/xl36nny6fnx2kiduydwu.jpg",
                  "name": "Perdiz",
                  "proteins": 25.0,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Mejora la digestión, combate la hinchazón y proporciona fibra.",
                  "calories": 19.0,
                  "carbohydrates": 2.5,
                  "category": "verduras/hortalizas",
                  "description":
                      "Vegetal crucífero con sabor suave y textura firme.",
                  "fats": 0.1,
                  "food_id": 113,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638624/syrbaqc1purfxr7calqk.jpg",
                  "name": "Repollo",
                  "proteins": 2.1,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Alto en proteínas, favorece el mantenimiento muscular.",
                  "calories": 78.0,
                  "carbohydrates": 1.2,
                  "category": "pescados",
                  "description":
                      "Pescado blanco de carne suave y bajo en grasas.",
                  "fats": 0.9,
                  "food_id": 32,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732634518/vv0ae3vtwbdvkudvrpog.jpg",
                  "name": "Gallo",
                  "proteins": 16.2,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Propiedades digestivas y antiinflamatorias, mejora la salud intestinal.",
                  "calories": 10.0,
                  "carbohydrates": 1.7,
                  "category": "verduras/hortalizas",
                  "description":
                      "Tallo comestible con textura fibrosa y sabor suave.",
                  "fats": 0.1,
                  "food_id": 97,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638665/buvsc9b6zqsh8burf7nt.jpg",
                  "name": "Cardo",
                  "proteins": 0.6,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits": "Rico en vitamina A, mejora la piel y la vista.",
                  "calories": 70.0,
                  "carbohydrates": 10.6,
                  "category": "verduras/hortalizas",
                  "description":
                      "Legumbre verde con sabor dulce y textura crujiente.",
                  "fats": 0.2,
                  "food_id": 104,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638647/pqtlv7crwefqwjsxb7lk.jpg",
                  "name": "Guisantes frescos",
                  "proteins": 7.0,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 44,
              "meal_status": false,
              "meal_type": "almuerzo",
              "name": "almuerzo",
              "total_calories": 297.0,
              "total_carbohydrates": 16.5,
              "total_fats": 2.7,
              "total_proteins": 50.9
            },
            {
              "date": "2025-01-06T15:49:18",
              "day": 2,
              "foods": [
                {
                  "benefits":
                      "Rica en grasas monoinsaturadas, beneficiosa para la salud cardiovascular.",
                  "calories": 625.0,
                  "carbohydrates": 1.8,
                  "category": "frutos secos",
                  "description":
                      "Fruto seco con textura crujiente y sabor a nuez.",
                  "fats": 62.9,
                  "food_id": 79,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638452/upnebrtarjbmxnoe8i6a.jpg",
                  "name": "Avellana",
                  "proteins": 13.0,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Alto en proteínas y grasas saludables, ideal para el corazón.",
                  "calories": 600.0,
                  "carbohydrates": 0.0,
                  "category": "frutos secos",
                  "description":
                      "Fruto seco con textura crujiente y sabor dulce y salado.",
                  "fats": 49.0,
                  "food_id": 87,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638189/dm8boqy4c1ycscceouxm.png",
                  "name": "Pistacho",
                  "proteins": 0.0,
                  "quantity": 80.74,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 45,
              "meal_status": false,
              "meal_type": "cena",
              "name": "cena",
              "total_calories": 1109.44,
              "total_carbohydrates": 1.8,
              "total_fats": 111.9,
              "total_proteins": 13.0
            },
            {
              "date": "2025-01-07T15:49:18",
              "day": 3,
              "foods": [
                {
                  "benefits":
                      "Rica en carbohidratos complejos, ideal para una fuente de energía duradera.",
                  "calories": 420.0,
                  "carbohydrates": 83.0,
                  "category": "cereales y derivados",
                  "description":
                      "Pan tostado de harina blanca, con textura crujiente.",
                  "fats": 6.0,
                  "food_id": 133,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642585/je8deggcmlkc20b7aeia.jpg",
                  "name": "Pan Tostado",
                  "proteins": 11.3,
                  "quantity": 100.0,
                  "type_quantity": "rebanada"
                },
                {
                  "benefits":
                      "Fuente de energía sostenida, ideal para dietas balanceadas.",
                  "calories": 230.0,
                  "carbohydrates": 47.5,
                  "category": "cereales y derivados",
                  "description":
                      "Pan hecho con harina integral, más nutritivo que el pan blanco.",
                  "fats": 1.0,
                  "food_id": 132,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642588/qwyuaalermdfaeca0ixr.jpg",
                  "name": "Pan Integral",
                  "proteins": 9.0,
                  "quantity": 100.0,
                  "type_quantity": "rebanada"
                },
                {
                  "benefits":
                      "Fuente de vitamina C, mejora el sistema inmunológico.",
                  "calories": 53.0,
                  "carbohydrates": 11.7,
                  "category": "frutas",
                  "description": "Fruta cítrica dulce y rica en vitamina C.",
                  "fats": 0.2,
                  "food_id": 70,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732637661/lmhh9oj2q06zzu7l53eg.jpg",
                  "name": "Naranja",
                  "proteins": 1.0,
                  "quantity": 100.0,
                  "type_quantity": "unidad"
                },
                {
                  "benefits":
                      "Rico en fibra, ayuda a regular el colesterol y mejora la digestión.",
                  "calories": 373.0,
                  "carbohydrates": 82.3,
                  "category": "cereales y derivados",
                  "description":
                      "Grano entero utilizado en sopas y panes, rico en fibra.",
                  "fats": 1.4,
                  "food_id": 124,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642609/mzwbtmb0is751hochsyv.jpg",
                  "name": "Cebada",
                  "proteins": 10.4,
                  "quantity": 23.99,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 46,
              "meal_status": false,
              "meal_type": "desayuno",
              "name": "desayuno",
              "total_calories": 792.4827,
              "total_carbohydrates": 224.5,
              "total_fats": 8.6,
              "total_proteins": 31.700000000000003
            },
            {
              "date": "2025-01-07T15:49:18",
              "day": 3,
              "foods": [
                {
                  "benefits":
                      "Fuente de proteínas y antioxidantes, contribuye a la salud de la piel y el sistema inmune.",
                  "calories": 65.0,
                  "carbohydrates": 2.9,
                  "category": "pescados",
                  "description": "Marisco de carne tierna y dulce.",
                  "fats": 0.6,
                  "food_id": 33,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732634515/y2frtdtwjhdyxaaopjlw.jpg",
                  "name": "Gamba",
                  "proteins": 13.6,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Propiedades digestivas y antiinflamatorias, mejora la salud intestinal.",
                  "calories": 10.0,
                  "carbohydrates": 1.7,
                  "category": "verduras/hortalizas",
                  "description":
                      "Tallo comestible con textura fibrosa y sabor suave.",
                  "fats": 0.1,
                  "food_id": 97,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638665/buvsc9b6zqsh8burf7nt.jpg",
                  "name": "Cardo",
                  "proteins": 0.6,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Ayuda a reducir el riesgo de enfermedades cardíacas, contiene fibra.",
                  "calories": 31.0,
                  "carbohydrates": 4.3,
                  "category": "verduras/hortalizas",
                  "description":
                      "Pequeñas cabezas verdes de sabor ligeramente amargo.",
                  "fats": 0.5,
                  "food_id": 100,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638658/i9txzb3jl7qu3zap34ff.jpg",
                  "name": "Coles de Bruselas",
                  "proteins": 4.2,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Baja en grasas, rica en proteínas y minerales esenciales.",
                  "calories": 126.0,
                  "carbohydrates": 0.0,
                  "category": "carnes",
                  "description":
                      "Carne oscura y magra, con sabor fuerte, rica en proteínas y baja en grasas.",
                  "fats": 3.2,
                  "food_id": 16,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732633538/ovb3juv9lw1vhdlzbpkx.jpg",
                  "name": "Liebre",
                  "proteins": 22.8,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Rica en fibra, mejora la digestión y ayuda a controlar el colesterol.",
                  "calories": 17.0,
                  "carbohydrates": 2.3,
                  "category": "verduras/hortalizas",
                  "description":
                      "Flor comestible con sabor suave y ligeramente amargo.",
                  "fats": 0.2,
                  "food_id": 90,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638683/g6nc0ohzyd616mk52iph.jpg",
                  "name": "Alcachofa",
                  "proteins": 1.4,
                  "quantity": 100.0,
                  "type_quantity": "unidad"
                }
              ],
              "meal_id": 47,
              "meal_status": false,
              "meal_type": "almuerzo",
              "name": "almuerzo",
              "total_calories": 249.0,
              "total_carbohydrates": 11.2,
              "total_fats": 4.6000000000000005,
              "total_proteins": 42.6
            },
            {
              "date": "2025-01-07T15:49:18",
              "day": 3,
              "foods": [
                {
                  "benefits":
                      "Alto en proteínas, grasas saludables, y energía sostenida.",
                  "calories": 452.0,
                  "carbohydrates": 35.0,
                  "category": "frutos secos",
                  "description":
                      "Legumbre con alto contenido de proteínas y grasas.",
                  "fats": 25.6,
                  "food_id": 80,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638450/xyxxgr4dk5gk3sdqs5dx.jpg",
                  "name": "Cacahuete",
                  "proteins": 20.4,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Rica en carbohidratos complejos, ideal para energía prolongada.",
                  "calories": 349.0,
                  "carbohydrates": 89.0,
                  "category": "frutos secos",
                  "description": "Fruto seco con textura suave y sabor dulce.",
                  "fats": 3.0,
                  "food_id": 81,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638447/qkifkfmxmgzdaomyfqqq.jpg",
                  "name": "Castaña",
                  "proteins": 4.7,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Alta en omega-3, beneficiosa para el cerebro y la salud cardiovascular.",
                  "calories": 670.0,
                  "carbohydrates": 11.2,
                  "category": "frutos secos",
                  "description":
                      "Fruto seco con alto contenido de grasas saludables.",
                  "fats": 63.3,
                  "food_id": 85,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638435/bx56tetcyahemybhdrpg.jpg",
                  "name": "Nuez",
                  "proteins": 15.6,
                  "quantity": 46.04,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 48,
              "meal_status": false,
              "meal_type": "cena",
              "name": "cena",
              "total_calories": 1109.468,
              "total_carbohydrates": 135.2,
              "total_fats": 91.9,
              "total_proteins": 40.699999999999996
            }
          ],
          "name": "Ganar masa muscular",
          "plan_id": 11,
          "status": "en progreso"
        },
        {
          "calories": 3954.1834000000003,
          "date_generation": "2025-02-04T15:49:07",
          "meals": [
            {
              "date": "2025-01-05T15:49:07",
              "day": 1,
              "foods": [
                {
                  "benefits":
                      "Rica en grasas saturadas, proporciona energía, pero debe consumirse con moderación para evitar problemas de salud cardiovascular.",
                  "calories": 750.0,
                  "carbohydrates": 0.3,
                  "category": "grasas",
                  "description":
                      "Grasa derivada de la leche, usada para cocinar, untar o como ingrediente en repostería.",
                  "fats": 83.0,
                  "food_id": 142,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642562/ywosl94jyyb3vps0vek2.jpg",
                  "name": "Mantequilla",
                  "proteins": 0.6,
                  "quantity": 72.33,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 34,
              "meal_status": false,
              "meal_type": "desayuno",
              "name": "desayuno",
              "total_calories": 542.475,
              "total_carbohydrates": 0.3,
              "total_fats": 83.0,
              "total_proteins": 0.6
            },
            {
              "date": "2025-01-05T15:49:07",
              "day": 1,
              "foods": [
                {
                  "benefits":
                      "Baja en grasas y rica en proteínas, ideal para dietas saludables.",
                  "calories": 120.0,
                  "carbohydrates": 0.5,
                  "category": "carnes",
                  "description":
                      "Ave de carne magra y delicada, rica en proteínas y baja en grasas.",
                  "fats": 1.4,
                  "food_id": 20,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732632565/xl36nny6fnx2kiduydwu.jpg",
                  "name": "Perdiz",
                  "proteins": 25.0,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Rico en potasio y antioxidantes, favorece la salud cardiovascular.",
                  "calories": 26.0,
                  "carbohydrates": 6.0,
                  "category": "verduras/hortalizas",
                  "description":
                      "Vegetal de tallo blanco y verde con sabor dulce y suave.",
                  "fats": 0.1,
                  "food_id": 111,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638629/irrwczngelvmn0xdyfgf.jpg",
                  "name": "Puerro",
                  "proteins": 2.1,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits": "Rico en vitamina A, mejora la piel y la vista.",
                  "calories": 70.0,
                  "carbohydrates": 10.6,
                  "category": "verduras/hortalizas",
                  "description":
                      "Legumbre verde con sabor dulce y textura crujiente.",
                  "fats": 0.2,
                  "food_id": 104,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638647/pqtlv7crwefqwjsxb7lk.jpg",
                  "name": "Guisantes frescos",
                  "proteins": 7.0,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Buena fuente de proteínas y grasas, ideal para aportar energía.",
                  "calories": 361.0,
                  "carbohydrates": 0.0,
                  "category": "carnes",
                  "description":
                      "Parte curada del cerdo, de sabor intenso y rica en grasas, ideal para platos tradicionales.",
                  "fats": 31.6,
                  "food_id": 15,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732632571/yrwmcf2mfd1a1jjo3h2p.jpg",
                  "name": "Lacón",
                  "proteins": 19.2,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Propiedades antibacterianas, mejora la digestión y refuerza el sistema inmunológico.",
                  "calories": 124.0,
                  "carbohydrates": 26.3,
                  "category": "verduras/hortalizas",
                  "description":
                      "Bulbo con sabor intenso utilizado como condimento en la cocina.",
                  "fats": 0.1,
                  "food_id": 89,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638686/svhwdiyzfch6pmy6plkb.jpg",
                  "name": "Ajo",
                  "proteins": 6.0,
                  "quantity": 100.0,
                  "type_quantity": "unidad"
                }
              ],
              "meal_id": 35,
              "meal_status": false,
              "meal_type": "almuerzo",
              "name": "almuerzo",
              "total_calories": 701.0,
              "total_carbohydrates": 43.400000000000006,
              "total_fats": 33.400000000000006,
              "total_proteins": 59.3
            },
            {
              "date": "2025-01-05T15:49:07",
              "day": 1,
              "foods": [
                {
                  "benefits":
                      "Alto en proteínas, grasas saludables, y energía sostenida.",
                  "calories": 452.0,
                  "carbohydrates": 35.0,
                  "category": "frutos secos",
                  "description":
                      "Legumbre con alto contenido de proteínas y grasas.",
                  "fats": 25.6,
                  "food_id": 80,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638450/xyxxgr4dk5gk3sdqs5dx.jpg",
                  "name": "Cacahuete",
                  "proteins": 20.4,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Rica en fibra, mejora la digestión y regula el azúcar en sangre.",
                  "calories": 177.0,
                  "carbohydrates": 43.7,
                  "category": "frutos secos",
                  "description": "Ciruela deshidratada, dulce y rica en fibra.",
                  "fats": 0.5,
                  "food_id": 82,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638444/tn0bsq1arq0ggmtdkcgc.jpg",
                  "name": "Ciruela pasa",
                  "proteins": 2.2,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Fuente de grasas saludables, mejora el corazón y regula el colesterol.",
                  "calories": 499.0,
                  "carbohydrates": 4.0,
                  "category": "frutos secos",
                  "description":
                      "Fruto seco con sabor suave y ligeramente dulce.",
                  "fats": 51.4,
                  "food_id": 78,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638455/yfvutq6roegrxdw0wkzh.jpg",
                  "name": "Almendra",
                  "proteins": 16.0,
                  "quantity": 26.14,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 36,
              "meal_status": false,
              "meal_type": "cena",
              "name": "cena",
              "total_calories": 759.4386,
              "total_carbohydrates": 82.7,
              "total_fats": 77.5,
              "total_proteins": 38.599999999999994
            },
            {
              "date": "2025-01-06T15:49:07",
              "day": 2,
              "foods": [
                {
                  "benefits":
                      "Fuente de grasas saturadas, ayuda a dar sabor y textura a los alimentos, pero se debe consumir con moderación.",
                  "calories": 891.0,
                  "carbohydrates": 0.2,
                  "category": "grasas",
                  "description":
                      "Grasa animal derivada del cerdo, utilizada en cocina tradicional.",
                  "fats": 82.8,
                  "food_id": 143,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642559/hptavtuwtkiv2ziykv50.jpg",
                  "name": "Manteca de cerdo",
                  "proteins": 0.3,
                  "quantity": 60.88,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 37,
              "meal_status": false,
              "meal_type": "desayuno",
              "name": "desayuno",
              "total_calories": 542.4408000000001,
              "total_carbohydrates": 0.2,
              "total_fats": 82.8,
              "total_proteins": 0.3
            },
            {
              "date": "2025-01-06T15:49:07",
              "day": 2,
              "foods": [
                {
                  "benefits":
                      "Alto en proteínas y omega-3, promueve la salud del corazón y el cerebro.",
                  "calories": 158.0,
                  "carbohydrates": 0.0,
                  "category": "pescados",
                  "description": "Pescado magro de carne firme y versátil.",
                  "fats": 8.0,
                  "food_id": 26,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732634242/gsw3q7omnwyo3zwzw7ec.jpg",
                  "name": "Atún fresco",
                  "proteins": 21.5,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Carne magra, fácil de digerir y rica en proteínas y vitaminas del grupo B.",
                  "calories": 127.0,
                  "carbohydrates": 0.7,
                  "category": "carnes",
                  "description":
                      "Carne tierna y jugosa, baja en grasas y rica en minerales como el zinc y el fósforo",
                  "fats": 17.0,
                  "food_id": 3,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732632057/qodmk1xwxsimgiqgtnko.jpg",
                  "name": "Cabrito",
                  "proteins": 19.2,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Alta fuente de proteínas y fibra, ayuda a controlar los niveles de azúcar en sangre y favorece la digestión.",
                  "calories": 338.0,
                  "carbohydrates": 54.3,
                  "category": "legumbres",
                  "description":
                      "Leguminosa con sabor suave, usada en sopas, ensaladas y humus.",
                  "fats": 4.9,
                  "food_id": 119,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732642622/t54l0w8pilhavoubds1a.jpg",
                  "name": "Garbanzo",
                  "proteins": 21.8,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Regula el sistema digestivo y proporciona nutrientes esenciales.",
                  "calories": 10.4,
                  "carbohydrates": 2.0,
                  "category": "verduras/hortalizas",
                  "description":
                      "Fruto verde alargado con alto contenido de agua.",
                  "fats": 0.1,
                  "food_id": 110,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638632/bn4btg1k4wdnuue3wmu0.jpg",
                  "name": "Pepino",
                  "proteins": 0.7,
                  "quantity": 100.0,
                  "type_quantity": "unidad"
                },
                {
                  "benefits":
                      "Bajo en calorías, alto en antioxidantes y ayuda a la digestión.",
                  "calories": 16.0,
                  "carbohydrates": 2.6,
                  "category": "verduras/hortalizas",
                  "description":
                      "Fruto de color morado con textura suave y sabor neutro.",
                  "fats": 0.1,
                  "food_id": 92,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638678/mzlthsrjxgutdftbhnxh.jpg",
                  "name": "Berenjena",
                  "proteins": 1.1,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 38,
              "meal_status": false,
              "meal_type": "almuerzo",
              "name": "almuerzo",
              "total_calories": 649.4,
              "total_carbohydrates": 59.6,
              "total_fats": 30.1,
              "total_proteins": 64.3
            },
            {
              "date": "2025-01-06T15:49:07",
              "day": 2,
              "foods": [
                {
                  "benefits":
                      "Fuente de grasas saludables, mejora el corazón y regula el colesterol.",
                  "calories": 499.0,
                  "carbohydrates": 4.0,
                  "category": "frutos secos",
                  "description":
                      "Fruto seco con sabor suave y ligeramente dulce.",
                  "fats": 51.4,
                  "food_id": 78,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638455/yfvutq6roegrxdw0wkzh.jpg",
                  "name": "Almendra",
                  "proteins": 16.0,
                  "quantity": 100.0,
                  "type_quantity": "gramo"
                },
                {
                  "benefits":
                      "Alta en omega-3, beneficiosa para el cerebro y la salud cardiovascular.",
                  "calories": 670.0,
                  "carbohydrates": 11.2,
                  "category": "frutos secos",
                  "description":
                      "Fruto seco con alto contenido de grasas saludables.",
                  "fats": 63.3,
                  "food_id": 85,
                  "image_url":
                      "https://res.cloudinary.com/dnkvrqfus/image/upload/v1732638435/bx56tetcyahemybhdrpg.jpg",
                  "name": "Nuez",
                  "proteins": 15.6,
                  "quantity": 38.87,
                  "type_quantity": "gramo"
                }
              ],
              "meal_id": 39,
              "meal_status": false,
              "meal_type": "cena",
              "name": "cena",
              "total_calories": 759.429,
              "total_carbohydrates": 15.2,
              "total_fats": 114.69999999999999,
              "total_proteins": 31.6
            }
          ],
          "name": "Perder peso",
          "plan_id": 10,
          "status": "en progreso"
        }
      ];
    });
  }
    Future<void> _fetchDailyCalories() async {
    try {
      // Simula llamada a la API.
    final fetchCaloriesByDay = await _nutritionService.getDailyCalories();

      // Convierte los datos al formato requerido (List<double>).
      final List<double> calories = fetchCaloriesByDay
          .map<double>((item) => item['calorias'].toDouble())
          .toList();

      final List<String> days = fetchCaloriesByDay
          .map<String>((item) => item['fecha'].toString())
          .toList();
      setState(() {
        dailyCalories1 = calories;
        isLoading = false; // Finaliza la carga.
      });
    } catch (e) {
      print('Error al obtener calorías: $e');
      setState(() {
        isLoading = false; // Finaliza la carga incluso con error.
      });
    }
  }

  // Datos de ejemplo para el progreso de peso
  // final List<WeightEntry> weightEntries = [
  //   WeightEntry(date: DateTime(2023, 1, 1), weight: 80.5),
  //   WeightEntry(date: DateTime(2023, 1, 15), weight: 79.8),
  //   WeightEntry(date: DateTime(2023, 2, 1), weight: 79.2),
  //   WeightEntry(date: DateTime(2023, 2, 15), weight: 78.9),
  //   WeightEntry(date: DateTime(2023, 3, 1), weight: 78.5),
  //   WeightEntry(date: DateTime(2023, 3, 15), weight: 77.8),
  //   // WeightEntry(date: DateTime(2023, 4, 1), weight: 77.2),
  //   // WeightEntry(date: DateTime(2023, 4, 15), weight: 76.9),
  // ];

  final progresoPeso = [
    {'fecha': '2023-01-01', 'peso': 70.5},
    {'fecha': '2023-01-02', 'peso': 70.0},
    {'fecha': '2023-01-03', 'peso': 69.8},
    {'fecha': '2023-01-04', 'peso': 69.5},
    {'fecha': '2023-01-05', 'peso': 69.2},
  ];

  // Datos de ejemplo
  final List<double> caloriesData = [1800, 2000, 1500, 2200, 1900];
  final List<String> days = ["Lun", "Mar", "Mié", "Jue", "Vie"];

  // @override
  // Widget build(BuildContext context) {
  //   // Estos son datos de ejemplo. En una aplicación real, obtendrías estos datos de tu base de datos o API.
  //   final List<double> dailyCalories = [
  //     2100,
  //     2300,
  //     1950,
  //     2400,
  //     2200,
  //     1800,
  //     2000
  //   ];
  //   const double targetCalories = 2200;

  //   return Scaffold(
  //     backgroundColor: Colors.white,
  //     appBar: CustomAppBarWithBack(
  //       title: 'Mis progresos',
  //       backgroundColor: _appBarColor,
  //       textColor: _textColor,
  //       iconColor: _iconColor,
  //       iconBackgroundColor: _iconBackgroundColor,
  //     ),
  //     body: SingleChildScrollView(
  //       controller: _scrollController,
  //       child: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             MacronutrientSliderWidget(
  //               consumedCalories: 200,
  //               targetCalories: 2200,
  //               consumedProtein: 30,
  //               targetProtein: 150,
  //               consumedCarbs: 100,
  //               targetCarbs: 300,
  //               consumedFat: 20,
  //               targetFat: 70,
  //             ),
  //             const SizedBox(height: 24),
  //             DailyCaloriesReport(
  //               dailyCalories: dailyCalories,
  //               targetCalories: targetCalories,
  //             ),
  //             _plans.isEmpty
  //                 ? Center(child: CircularProgressIndicator())
  //                 : SingleChildScrollView(
  //                     padding: EdgeInsets.all(16),
  //                     child: NutritionReportSlider(plans: _plans),
  //                   ),
  //             // WeightProgressChart(weightEntries: weightEntries),
  //             ProgresoPesoReporte(progresoPeso: progresoPeso),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

 @override
 Widget build(BuildContext context) {
  const double targetCalories = 3200;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Mis progresos',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MacronutrientSliderWidget(
                      consumedCalories: 200,
                      targetCalories: 2200,
                      consumedProtein: 30,
                      targetProtein: 150,
                      consumedCarbs: 100,
                      targetCarbs: 300,
                      consumedFat: 20,
                      targetFat: 70,
                    ),
                    const SizedBox(height: 24),
                    dailyCalories1.isNotEmpty
                        ? DailyCaloriesReport(
                            dailyCalories: dailyCalories1,
                            targetCalories: targetCalories,
                            days: days,
                          )
                        : Center(
                            child: Text(
                              'No hay datos disponibles.',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                    const SizedBox(height: 24),
                    _plans.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                            padding: EdgeInsets.all(16),
                            child: NutritionReportSlider(plans: _plans),
                          ),
                    ProgresoPesoReporte(progresoPeso: progresoPeso),
                  ],
                ),
              ),
            ),
    );
  }
}