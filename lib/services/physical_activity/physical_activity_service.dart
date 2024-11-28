import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/constants/environment.dart';
import '../../models/physical_activity.dart';

class PhysicalActivityService {
  final String _url = Environment.urlApi;
  final String _api = '/api/physical-activity';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<List<PhysicalActivity>> getAllPhysicalActivities() async {
    Uri url = Uri.http(_url, '$_api/physical-activities');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      List<PhysicalActivity> activities = data
        .map<PhysicalActivity>((item) => PhysicalActivity.fromJson(item))
        .toList();
      return activities;
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener las actividades físicas');
    }
  }
}
