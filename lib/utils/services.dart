import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './cfg_environment.dart';

class Services {
  final String _baseUrl = CfgEnvironment.baseUrl;

  Map<String, String> _renderHeader({dynamic uploadFile, String token}) {
    return {
      "Content-Type":
          uploadFile != null ? "multipart/form-data" : "application/json",
      "Authorization": token != null ? "Bearer $token" : null,
    };
  }

  Future<dynamic> post({
    @required String path,
    @required dynamic body,
    dynamic uploadFile,
  }) {
    return http
        .post(
      Uri.parse('$_baseUrl/$path'),
      headers: _renderHeader(),
      body: body,
    )
        .then((resp) {
      return json.decode(resp.body);
    }).catchError((error) {
      throw error.toString();
    });
  }

  Future<dynamic> get({
    @required String path,
  }) {
    return http
        .get(
      Uri.parse('$_baseUrl/$path'),
      headers: _renderHeader(),
    )
        .then((resp) {
      return json.decode(resp.body);
    }).catchError((error) {
      throw error;
    });
  }
}
