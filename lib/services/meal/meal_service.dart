import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/environment.dart';
import '../../models/meal.dart';
import '../../models/meal_detail.dart';

class MealService {
  final String _url = Environment.urlApi;
  final String _api = '/api/meal';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  // Obtener todas las comidas
  Future<List<Meal>> getAllMeals() async {
    Uri url = Uri.http(_url, '$_api/meals/all');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      List<Meal> meals = data.map<Meal>((item) => Meal.fromJson(item)).toList();

      return meals;
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener las comidas');
    }
  }

  // Agregar una comida
  Future<Meal> addMeal(Meal meal) async {
    Uri url = Uri.http(_url, '$_api/meals');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url,
        headers: headers, body: json.encode(meal.toJson()));

    if (response.statusCode == 201) {
      // Si la respuesta es exitosa, retornamos los datos
      final Map<String, dynamic> data = json.decode(response.body);
      return Meal.fromJson(data['meal']);
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al agregar la comida');
    }
  }

  // Actualizar una comida
  Future<Meal> updateMeal(Meal meal) async {
    Uri url = Uri.http(_url, '$_api/meals/${meal.id}');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response =
        await http.put(url, headers: headers, body: json.encode(meal.toJson()));

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final Map<String, dynamic> data = json.decode(response.body);
      return Meal.fromJson(data['meal']);
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al actualizar la comida');
    }
  }

  // Obtener los alimentos de una comida
  Future<MealDetail> getFoodsByMeal(int mealId) async {
    Uri url = Uri.http(_url, '$_api/meals/$mealId/foods');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      return MealDetail.fromJson(data);
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener los alimentos de la comida');
    }
  }
  
}
