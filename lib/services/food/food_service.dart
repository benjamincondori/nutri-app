import 'dart:convert';
import 'dart:io';

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

      List<Food> foods = data.map<Food>((item) => Food.fromJson(item)).toList();
      return foods;
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener los alimentos');
    }
  }

  Future<Food> addFood(Food food, File image) async {
    Uri url = Uri.http(_url, '$_api/foods');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // Crear una solicitud multipart para enviar la imagen
    final request = http.MultipartRequest('POST', url);
    request.headers.addAll(headers);

    request.fields['name'] = food.name;
    request.fields['description'] = food.description;
    request.fields['calories'] = food.calories.toString();
    request.fields['proteins'] = food.proteins.toString();
    request.fields['fats'] = food.fats.toString();
    request.fields['carbohydrates'] = food.carbohydrates.toString();
    request.fields['category'] = food.category;
    request.fields['benefits'] = food.benefits;

    // Adjuntar imagen
    final file = await http.MultipartFile.fromPath('image', image.path);
    request.files.add(file);

    final response = await request.send();

    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();

      // Extraer solo el objeto "food" del response
      final Map<String, dynamic> responseData = json.decode(responseBody);
      final Map<String, dynamic> foodData = responseData['food'];

      return Food.fromJson(foodData); // Convertir foodData a un objeto Food
    } else {
      throw Exception('Ocurrió un error al agregar el alimento');
    }
  }

  Future<Food> updateFood(Food food, File? image) async {
    print("Actualizando alimento: ${food.id}");
    Uri url = Uri.http(_url, '$_api/foods/${food.id}');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    // Crear una solicitud multipart para actualizar la imagen si es necesario
    final request = http.MultipartRequest('PUT', url);
    request.headers.addAll(headers);

    request.fields['name'] = food.name;
    request.fields['description'] = food.description;
    request.fields['calories'] = food.calories.toString();
    request.fields['proteins'] = food.proteins.toString();
    request.fields['fats'] = food.fats.toString();
    request.fields['carbohydrates'] = food.carbohydrates.toString();
    request.fields['category'] = food.category;
    request.fields['benefits'] = food.benefits;

    if (image != null) {
      // Adjuntar imagen
      final file = await http.MultipartFile.fromPath('image', image.path);
      request.files.add(file);
    }

    final response = await request.send();
    
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();

      // Extraer solo el objeto "food" del response
      final Map<String, dynamic> responseData = json.decode(responseBody);
      final Map<String, dynamic> foodData = responseData['food'];

      return Food.fromJson(foodData); // Convertir foodData a un objeto Food
    } else {
      throw Exception('Ocurrió un error al actualizar el alimento');
    }
  }
}
