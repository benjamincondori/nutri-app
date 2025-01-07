import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutrition_ai_app/models/user.dart';

import '../../config/constants/environment.dart';
import '../../models/totals.dart';

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

  Future<UserNutritionist> getProfileNutritionist(String token) async {
    Uri url = Uri.http(_url, '$_api/profile/nutritionist');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      print("UserService::getProfileNutritionist::data: $data");
      return UserNutritionist.fromJson(data);
    } else if (response.statusCode == 401) {
      // Si el token es inválido, redirigimos al login
      throw 'Token inválido';
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener el perfil');
    }
  }

  Future<String> updateProfile(
    String token, {
    Map<String, dynamic>? data,
    File? image,
  }) async {
    Uri url = Uri.http(_url, '$_api/update');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final request = http.MultipartRequest('PUT', url);
    request.headers.addAll(headers);

    if (data != null) {
      request.fields['name'] = data['name'];
      request.fields['lastname'] = data['lastname'];
      request.fields['email'] = data['email'];
      request.fields['telephone'] = data['telephone'];
      request.fields['weight'] = data['weight'];
      request.fields['height'] = data['height'];
      // request.fields['gender'] = data['gender'];
      // request.fields['physical_activity_id'] = data['physical_activity_id'];
      // request.fields['health_restrictions'] = data['health_restrictions'];
    }

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', image.path),
      );
    }

    final response = await request.send();
    print("UserService::updateProfile::response: $response");

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(await response.stream.bytesToString());
      return data['message'];
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al actualizar el perfil');
    }
  }

  Future<Totals> getTotals(String token) async {
    Uri url = Uri.http(_url, '$_api/totals');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      return Totals.fromJson(data);
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener los totales');
    }
  }
  
  // Obtener todos los usuarios
  Future<List<User>> getUsers(String token) async {
    Uri url = Uri.http(_url, '$_api/users');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      return List<User>.from(data.map((x) => User.fromJson(x)));
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener los usuarios');
    }
  }
}
