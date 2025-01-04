import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/environment.dart';

class MealFoodService {
  final String _url = Environment.urlApi;
  final String _api = '/api/meal-food';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  // Agregar un alimento a una comida
  Future<dynamic> addFoodToMeal(
      int mealId, int foodId, double? quantity, String? typeQuantity) async {
    Uri url = Uri.http(_url, '$_api/add');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    Map<String, dynamic> body = {
      'meal_id': mealId,
      'food_id': foodId,
    };

    if (quantity != null) {
      body['quantity'] = quantity;
    }

    if (typeQuantity != null && typeQuantity.isNotEmpty) {
      body['type_quantity'] = typeQuantity;
    }

    final response =
        await http.post(url, headers: headers, body: json.encode(body));

    print("response: ${response.body}");

    if (response.statusCode == 201) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      print("data: $data");

      return data['message'];
    } else if (response.statusCode == 400) {
      // Si la respuesta es un error, devolvemos el mensaje de error
      throw Exception('El alimento ya está agregado a la comida');
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al agregar el alimento a la comida');
    }
  }

  // Eliminar un alimento de una comida
  Future<dynamic> removeFoodFromMeal(int mealId, int foodId) async {
    Uri url = Uri.http(_url, '$_api/remove/$mealId/$foodId');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      return data['message'];
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al eliminar el alimento de la comida');
    }
  }
}
