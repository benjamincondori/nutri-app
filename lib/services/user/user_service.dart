import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutrition_ai_app/models/user.dart';

import '../../config/constants/environment.dart';

class UserService {
  final String _url = Environment.urlApi;
  final String _api = '/api/user';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<User> getProfile(String token) async {
    Uri url = Uri.http(_url, '$_api/profile');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else if (response.statusCode == 401) {
      // Si el token es inválido, redirigimos al login
      throw 'Token inválido';
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener el perfil');
    }
  }
}
