import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/environment.dart';

class LoginService {
  final String _url = Environment.urlApi;
  final String _api = '/api';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    Uri url = Uri.http(_url, '$_api/login');
    String bodyParams = json.encode({
      'email': email,
      'password': password,
    });
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, headers: headers, body: bodyParams);
    // print('Response: ${response.body}');
    // print('Response code: ${response.statusCode}');

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      return json.decode(response.body);
    } else if (response.statusCode == 404 || response.statusCode == 401) {
      // Si el error es de credenciales inválidas
      throw 'El email o la contraseña son incorrectos';
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al iniciar sesión');
    }
  }
}
