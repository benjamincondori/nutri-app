import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/environment.dart';
import '../../models/user_request.dart';
import '../../models/health_profile.dart';

class RegisterService {
  final String _url = Environment.urlApi;
  final String _api = '/api';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<Map<String, dynamic>> registerUser(UserRequest user) async {
    Uri url = Uri.http(_url, '$_api/user/create');
    String bodyParams = json.encode(user);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, headers: headers, body: bodyParams);

    if (response.statusCode == 201) {
      // Si la respuesta es exitosa, retornamos los datos
      return json.decode(response.body);
    } else {
      // Si el error es una violación de clave duplicada
      final error = json.decode(response.body);
      String errorMessage =
          error['message'] ?? 'Ocurrió un error al registrar el usuario';

      // Revisar si el error es un error de duplicación de email
      if (errorMessage.contains('UniqueViolation') &&
          errorMessage.contains('user_email_key')) {
        throw 'El email ya se encuentra registrado';
      } else {
        // En caso de otros errores, devolvemos el mensaje original
        throw Exception(errorMessage);
      }
    }
  }
  
  Future<Map<String, dynamic>> registerHealthProfile(HealthProfile profile) async {
    Uri url = Uri.http(_url, '$_api/health-profile/create');
    String bodyParams = json.encode(profile);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, headers: headers, body: bodyParams);

    if (response.statusCode == 201) {
      // Si la respuesta es exitosa, retornamos los datos
      return json.decode(response.body);
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al registrar el perfil de salud');
    }
  }
}
