import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutrition_ai_app/models/current_plan.dart';
import 'package:nutrition_ai_app/models/plan.dart';
import 'package:nutrition_ai_app/shared/utils/shared_pref.dart';

import '../../config/constants/environment.dart';

class PlanService {
  final String _url = Environment.urlApi;
  final String _api = '/api/plan-meal';

  BuildContext? context;

  Future init(BuildContext context) async {
    this.context = context;
  }

  Future<dynamic> generatePlan(Map<String, dynamic> data, String token) async {
    Uri url = Uri.http(_url, '$_api/generate-plan1');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response =
        await http.post(url, headers: headers, body: json.encode(data));

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);

      print("PlanService::generatePlan::data: $data");

      return data;
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al generar el plan de comidas');
    }
  }

  Future<List<Plan>> getPlans(String token) async {
    Uri url = Uri.http(_url, '$_api/get-plans');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      print("PlanService::getPlans::data: $data");

      List<Plan> plans = data.map<Plan>((item) => Plan.fromJson(item)).toList();
      return plans;
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener los planes de comidas');
    }
  }

  Future<CurrentPlan> getCurrentPlan(String token) async {
    Uri url = Uri.http(_url, '$_api/get-plan');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      print("PlanService::getCurrentPlan::data: $data");
      return CurrentPlan.fromJson(data);
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener el plan actual');
    }
  }

  Future<CurrentPlan> getPlanById(int id, String token) async {
    Uri url = Uri.http(_url, '$_api/get-plan/$id');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      print("PlanService::getPlanById::data: $data");
      return CurrentPlan.fromJson(data);
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al obtener el plan');
    }
  }

  // Finalizar un plan
  Future<Map<String, dynamic>> finishPlan(int planId, String token) async {
    Uri url = Uri.http(_url, '$_api/update-plan-status');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    final response = await http.post(url,
        headers: headers, body: json.encode({'plan_id': planId}));

    print("PlanService::finishPlan::response: ${response.body}");

    if (response.statusCode == 200) {
      // Si la respuesta es exitosa, retornamos los datos
      final data = json.decode(response.body);
      print("PlanService::finishPlan::data: $data");
      return data;
    } else {
      // Si ocurre un error, devolvemos el mensaje original
      throw Exception('Ocurrió un error al finalizar el plan');
    }
  }

  Future<List<Map<String, dynamic>>> getDailyCalories() async {
   // final response = await http.get(Uri.parse(apiUrl));
    Uri url = Uri.http(_url, '$_api/list-calories');
    final token = await SharedPref().read('token');

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    try {
       final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final List<dynamic> responseData = json.decode(response.body);

        // Convertir la lista dinámica en una lista de mapas
      return responseData.map((item) => {
        "fecha": item["fecha"],
        "calorias": item["calorias"],
        "dia": item["dia_semana"],
      }).toList();      
      } else if (response.statusCode == 404) {
        throw Exception("No se encontraron planes o comidas asociadas.");
      } else {
        throw Exception("Error al obtener los datos: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
    return [];
  }
}