import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/screens/screens.dart';

import '../../config/theme/my_colors.dart';
import '../../controllers/meal/meal_controller.dart';
import '../../models/meal.dart';
import '../../providers/meal_provider.dart';
import '../../shared/appbar_with_back.dart';

class MealListScreen extends ConsumerStatefulWidget {
  static const String name = 'meal_list_screen';

  const MealListScreen({super.key});

  @override
  MealListScreenState createState() => MealListScreenState();
}

class MealListScreenState extends ConsumerState<MealListScreen> {
  final MealController _con = MealController();
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final List<String> _categories = [
    "Todos",
    "Desayuno",
    "Almuerzo",
    "Cena",
  ];
  String _selectedCategory = "Todos";

  late List<Meal> _filteredMealItems;

  @override
  void initState() {
    super.initState();

    // Se ejecuta despues del metodo build
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref);
    });

    _searchController.addListener(_filterFoodItems);
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
    _scrollController.dispose();
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _filterFoodItems({bool isFiltering = false}) {
    setState(() {
      String searchTerm = _searchController.text.toLowerCase();
      _filteredMealItems = ref.watch(mealProvider).where((meal) {
        bool matchesCategory = _selectedCategory == "Todos" ||
            meal.mealType.toLowerCase() == _selectedCategory.toLowerCase();
        bool matchesSearchTerm = meal.name.toLowerCase().contains(searchTerm);
        return matchesCategory && matchesSearchTerm;
      }).toList();
    });

    if (isFiltering) {
      // Desplazar el scroll al principio de la lista
      _scrollController.animateTo(
        0, // Desplazarse a la posición 0 (parte superior)
        duration: const Duration(milliseconds: 300), // Duración de la animación
        curve: Curves.easeInOut, // Tipo de curva de animación
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _filterFoodItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Comidas',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(context, ref),
          const SizedBox(height: 25),
          _filterCategory(),
          const SizedBox(height: 15),
          _mealList(),
        ],
      ),
    );
  }

  // Campo de Búsqueda
  Widget _searchBar(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 25, top: 25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocus,
              decoration: const InputDecoration(
                hintText: 'Buscar comidas...',
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          margin: const EdgeInsets.only(right: 25, top: 25),
          child: ElevatedButton(
            onPressed: () {
              context.pushNamed(MealCreateScreen.name);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
              iconColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(10), // Espaciado interno
            ),
            child: const Icon(Icons.add, size: 32),
          ),
        ),
      ],
    );
  }

  // Filtros de Categorías
  Widget _filterCategory() {
    return Container(
      margin: const EdgeInsets.only(left: 25),
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          bool isSelected = category == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _filterFoodItems(isFiltering: true);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? MyColors.primarySwatch : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  category,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Lista de Comidas Filtradas
  Widget _mealList() {
    if (_filteredMealItems.isEmpty) {
      // Mostrar un texto cuando no haya comidas con bordes punteados
      return Expanded(
        child: Container(
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 15,
            bottom: 25,
          ),
          child: DottedBorder(
            radius: const Radius.circular(15),
            borderType: BorderType.RRect,
            color: Colors.grey,
            strokeWidth: 1.5,
            dashPattern: const [7, 5],
            child: const Center(
              child: Text(
                'No se encontraron comidas',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    // Mostrar la lista de comidas cuando haya elementos
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(
          left: 25,
          right: 25,
          top: 15,
          bottom: 30,
        ),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _filteredMealItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final meal = _filteredMealItems[index];
          return _mealItemCard(meal: meal);
        },
      ),
    );
  }

  // Tarjeta de cada alimento
  Widget _mealItemCard({
    required Meal meal,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        // border: Border.all(color: MyColors.primarySwatch),
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: ListTile(
          splashColor: MyColors.primarySwatch[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () async {
            // Seleccionar el alimento y navegar a la pantalla de detalle
            await _con.getFoodsByMeal(meal.id!);
            
            if (mounted) {
              context.pushNamed(MealDetailScreen.name);
            }
          },
          title: Text(
            meal.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text("Tipo: ${meal.mealType}"),
          trailing: const Icon(
            Iconsax.arrow_circle_right,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
