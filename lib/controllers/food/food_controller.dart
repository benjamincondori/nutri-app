import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutrition_ai_app/models/food.dart';
import 'package:nutrition_ai_app/services/food/food_service.dart';
import 'package:nutrition_ai_app/shared/utils/my_toastbar.dart';

import '../../models/meal_detail.dart';
import '../../providers/food_provider.dart';
import '../../providers/meal_provider.dart';
import '../../services/meal/meal_service.dart';

class FoodController {
  BuildContext? context;

  final FoodService _apiService = FoodService();
  final MealService _apiMealService = MealService();
  late Function refresh;
  late WidgetRef ref;

  PickedFile? imagePicker;
  File? selectedImage; // Archivo de imagen seleccionado
  String? selectedCategory;

  final ImagePicker _imagePicker = ImagePicker();

  // Controladores para cada campo
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController proteinsController = TextEditingController();
  final TextEditingController fatsController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController benefitsController = TextEditingController();

  Future init(BuildContext context, Function refresh, WidgetRef ref) async {
    this.context = context;
    this.refresh = refresh;
    this.ref = ref;

    _apiService.init(context);

    await getAllFoods();
  }

  Future<void> getAllFoods() async {
    try {
      final List<Food> foods = await _apiService.getAllFoods();
      ref.read(foodProvider.notifier).setFoods(foods);
    } catch (e) {
      print(e);
    }
  }

  Future<void> addFood() async {
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    String proteins = proteinsController.text.trim();
    String fats = fatsController.text.trim();
    String carbs = carbsController.text.trim();
    String calories = caloriesController.text.trim();
    String benefits = benefitsController.text.trim();

    if (name.isEmpty ||
        description.isEmpty ||
        benefits.isEmpty ||
        proteins.isEmpty ||
        fats.isEmpty ||
        carbs.isEmpty ||
        calories.isEmpty) {
      MyToastBar.showInfo(context!, 'Todos los campos son requeridos');
      return;
    }

    if (selectedCategory == null) {
      MyToastBar.showInfo(context!, 'Debe seleccionar una categoría');
      return;
    }

    if (selectedImage == null) {
      MyToastBar.showInfo(context!, 'Debe seleccionar una imagen');
      return;
    }

    Food food = Food(
      name: name,
      description: description,
      benefits: benefits,
      proteins: double.parse(proteins),
      fats: double.parse(fats),
      carbohydrates: double.parse(carbs),
      calories: double.parse(calories),
      category: selectedCategory!,
    );

    try {
      final newFood = await _apiService.addFood(food, selectedImage!);
      // Actualizamos la lista local tras agregar un nuevo alimento
      ref.read(foodProvider.notifier).addFood(newFood);
      refresh(); // Refresca la UI si es necesario

      MyToastBar.showSuccess(context!, 'Alimento agregado exitosamente');
      context!.pop();
    } catch (e) {
      print("Error al agregar el alimento: $e");
      MyToastBar.showError(context!, 'Error al agregar el alimento');
    }
  }

  Future<void> updateFood(int id) async {
    String name = nameController.text.trim();
    String description = descriptionController.text.trim();
    String proteins = proteinsController.text.trim();
    String fats = fatsController.text.trim();
    String carbs = carbsController.text.trim();
    String calories = caloriesController.text.trim();
    String benefits = benefitsController.text.trim();

    if (name.isEmpty ||
        description.isEmpty ||
        benefits.isEmpty ||
        proteins.isEmpty ||
        fats.isEmpty ||
        carbs.isEmpty ||
        calories.isEmpty) {
      MyToastBar.showInfo(context!, 'Todos los campos son requeridos');
      return;
    }

    if (selectedCategory == null) {
      MyToastBar.showInfo(context!, 'Debe seleccionar una categoría');
      return;
    }

    // if (selectedImage == null) {
    //   MyToastBar.showInfo(context!, 'Debe seleccionar una imagen');
    //   return;
    // }

    Food food = Food(
      id: id,
      name: name,
      description: description,
      benefits: benefits,
      proteins: double.parse(proteins),
      fats: double.parse(fats),
      carbohydrates: double.parse(carbs),
      calories: double.parse(calories),
      category: selectedCategory!,
    );

    try {
      final updatedFood = await _apiService.updateFood(food, selectedImage);
      // Actualizamos la lista local tras agregar un nuevo alimento
      ref.read(foodProvider.notifier).updateFood(updatedFood);

      // Actualizamos el alimento seleccionado en el detalle
      ref.read(selectedFoodProvider.notifier).state = updatedFood;

      // Actualizamos la lista de alimentos en la comida seleccionada
      final mealDetail = ref.read(selectedMealProvider);
      await getFoodsByMeal(mealDetail!.meal.id!);
      refresh(); // Refresca la UI si es necesario

      MyToastBar.showSuccess(context!, 'Alimento actualizado exitosamente');
      context!.pop();
    } catch (e) {
      print("Error al actualizar el alimento: $e");
      MyToastBar.showError(context!, 'Error al actualizar el alimento');
    }
  }

  Future<void> pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
    }
    refresh();
  }

  Future<void> getFoodsByMeal(int mealId) async {
    try {
      final MealDetail mealDetail =
          await _apiMealService.getFoodsByMeal(mealId);

      // Actualizar el estado de la comida seleccionada
      ref.read(selectedMealProvider.notifier).state = mealDetail;
      refresh();
    } catch (e) {
      print(e);
    }
  }
}
