import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/environment.dart';
import '../../models/food.dart';

class FoodService {
  final String _url = Environment.urlApi;
  final String _api = '/api/food';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<Food>> getAllFoods() async {
    Uri url = Uri.http(_url, '$_api/foods');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.get(url, headers: headers);
    
    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      
      List<Food> foods = data
        .map<Food>((item) => Food.fromJson(item))
        .toList();
      return foods;
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener los alimentos');
    }
  }
}
