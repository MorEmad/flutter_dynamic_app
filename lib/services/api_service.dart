// lib/services/api_service.dart

import 'dart:convert';
import 'package:flutter/services.dart'; // Add this to read from assets

class ApiService {
  // Simulate GET request by loading from local JSON file
  Future<dynamic> get(String endpoint) async {
    String jsonString;
    if (endpoint == '/api/users') {
      jsonString = await rootBundle.loadString('assets/json/users.json');
    } else if (endpoint == '/api/content') {
      jsonString = await rootBundle.loadString('assets/json/content.json');
    } else {
      throw Exception('Unknown endpoint: $endpoint');
    }

    return json.decode(jsonString);
  }

  // Simulate POST, PUT, and DELETE as no-op for now
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    return {}; // Not implementing actual data creation in local JSON
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> data) async {
    return {}; // Not implementing actual data update in local JSON
  }

  Future<void> delete(String endpoint) async {
    // No-op
  }
}
