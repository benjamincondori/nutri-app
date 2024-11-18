import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/screens/screens.dart';

import '../../config/theme/my_colors.dart';
import '../../shared/appbar_with_back.dart';

class FoodListScreen extends StatefulWidget {
  static const String name = 'food_list_screen';

  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  final List<String> _categories = [
    "Todos",
    "Frutas",
    "Vegetales",
    "Proteínas",
    "Granos"
  ];
  String _selectedCategory = "Todos";
  final List<Map<String, String>> _foodItems = [
    {
      "title": "Manzana",
      "description": "Una fruta fresca y saludable.",
      "image":
          "https://i.pinimg.com/736x/66/1b/51/661b51817f56fbbea0ff3e0e05c8011d.jpg",
      "category": "Frutas",
    },
    {
      "title": "Brócoli",
      "description": "Una verdura verde rica en vitaminas.",
      "image":
          "https://cdn.pixabay.com/photo/2016/06/11/15/33/broccoli-1450274_1280.png",
      "category": "Vegetales",
    },
    {
      "title": "Pollo",
      "description": "Rica fuente de proteínas.",
      "image":
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-evQXcMZYobTq-fRFdkxdg6cgbfiV2ox7Iw&s",
      "category": "Proteínas",
    },
    {
      "title": "Arroz",
      "description": "Un grano básico en la alimentación.",
      "image":
          "https://i.pinimg.com/736x/66/1b/51/661b51817f56fbbea0ff3e0e05c8011d.jpg",
      "category": "Granos",
    },
    {
      "title": "Naranja",
      "description": "Una fruta cítrica rica en vitamina C.",
      "image":
          "https://i.pinimg.com/736x/66/1b/51/661b51817f56fbbea0ff3e0e05c8011d.jpg",
      "category": "Frutas",
    },
    {
      "title": "Zanahoria",
      "description": "Una verdura rica en betacarotenos.",
      "image":
          "https://cdn.pixabay.com/photo/2016/06/11/15/33/broccoli-1450274_1280.png",
      "category": "Vegetales",
    },
    {
      "title": "Pescado",
      "description": "Rica fuente de proteínas y omega 3.",
      "image":
          "https://cdn.pixabay.com/photo/2016/06/11/15/33/broccoli-1450274_1280.png",
      "category": "Proteínas",
    },
    {
      "title": "Avena",
      "description": "Un grano saludable y nutritivo.",
      "image":
          "https://cdn.pixabay.com/photo/2016/06/11/15/33/broccoli-1450274_1280.png",
      "category": "Granos",
    },
  ];

  List<Map<String, String>> _filteredFoodItems = [];

  @override
  void initState() {
    super.initState();
    _filteredFoodItems = _foodItems;
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

  void _filterFoodItems() {
    setState(() {
      String searchTerm = _searchController.text.toLowerCase();
      _filteredFoodItems = _foodItems.where((food) {
        bool matchesCategory = _selectedCategory == "Todos" ||
            food["category"] == _selectedCategory;
        bool matchesSearchTerm =
            food["title"]!.toLowerCase().contains(searchTerm);
        return matchesCategory && matchesSearchTerm;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Alimentos',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(),
          const SizedBox(height: 25),
          _filterCategory(),
          const SizedBox(height: 15),
          _foodList(),
        ],
      ),
    );
  }

  // Campo de Búsqueda
  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
      decoration: BoxDecoration(
        // color: MyColors.primarySwatch[50],
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
          hintText: 'Buscar alimentos...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(15),
          //   borderSide: BorderSide(color: MyColors.primarySwatch[200]!),
          // ),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
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
                _filterFoodItems();
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

  // Lista de Alimentos Filtrados
  Widget _foodList() {
    return Expanded(
      child: ListView.separated(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 30),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _filteredFoodItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final food = _filteredFoodItems[index];
          return _foodItemCard(
            title: food["title"]!,
            description: food["description"]!,
            imagePath: food["image"]!,
          );
        },
      ),
    );
  }

  // Tarjeta de cada alimento
  Widget _foodItemCard({
    required String title,
    required String description,
    required String imagePath,
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
          onTap: () {
            Map<String, dynamic> details = {
              "title": title,
              "description": description,
              "imagePath": imagePath,
            };
            context.pushNamed(
              FoodDetailScreen.name,
              extra: details,
            );
          },
          leading: Image.network(
            imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(description),
          trailing: const Icon(
            Iconsax.arrow_circle_right,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
