import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import './cfg_environment.dart';

//model
import '../models/http_exceptions.dart';

class Services {
  final String _baseUrl = CfgEnvironment.baseUrl;

  Map<String, String> _renderHeader({
    dynamic uploadFile,
    // String token,
  }) {
    return {
      "Content-Type":
          uploadFile != null ? "multipart/form-data" : "application/json",
      // "Authorization": token != null ? "Bearer $token" : null, //firebase using token in query parameter
    };
  }

  Map<String, dynamic> _response(http.Response resp) {
    debugPrint("Head: ${resp.headers.toString()}");
    debugPrint("Body: ${resp.body}");
    debugPrint("StatusCode: ${resp.statusCode.toString()}");
    return {
      'headers': resp?.headers,
      'body': json.decode(resp?.body),
      'statusCode': resp?.statusCode,
    };
  }

  Future<dynamic> post({
    @required String path,
    @required dynamic body,
    String token,
    String userId,
    dynamic uploadFile,
  }) {
    return http
        .post(
          Uri.parse('$_baseUrl/$path'),
          headers: _renderHeader(),
          body: json.encode(body),
        )
        .then((resp) => _response(resp))
        .catchError(
      (error) {
        debugPrint(error);
        throw HttpException(
            'Could not run POST operation, something wrong with http request | exception: $error');
      },
    );
  }

  Future<dynamic> get({
    @required String path,
    String token,
    String userId,
  }) {
    return http
        .get(
          Uri.parse('$_baseUrl/$path'),
          headers: _renderHeader(),
        )
        .then((resp) => _response(resp))
        .catchError((error) {
      debugPrint(error);
      throw HttpException(
          'Could not run GET operation, something wrong with http request | exception: $error');
    });
  }

  Future<dynamic> patch({
    @required String path,
    @required dynamic body,
    String token,
    String userId,
    dynamic uploadFile,
  }) {
    return http
        .patch(
          Uri.parse('$_baseUrl/$path'),
          headers: _renderHeader(),
          body: json.encode(body),
        )
        .then((resp) => _response(resp))
        .catchError((error) {
      debugPrint(error);
      throw HttpException(
          'Could not run PATCH operation, something wrong with http request | exception: $error');
    });
  }

  Future<dynamic> put({
    @required String path,
    @required dynamic body,
    String token,
    String userId,
    dynamic uploadFile,
  }) {
    return http
        .put(
          Uri.parse('$_baseUrl/$path'),
          headers: _renderHeader(),
          body: json.encode(body),
        )
        .then((resp) => _response(resp))
        .catchError((error) {
      debugPrint(error);
      throw HttpException(
          'Could not run PATCH operation, something wrong with http request | exception: $error');
    });
  }

  Future<dynamic> delete({
    @required String path,
    String token,
    String userId,
  }) {
    return http
        .delete(
          Uri.parse('$_baseUrl/$path'),
          headers: _renderHeader(),
        )
        .then((resp) => _response(resp))
        .catchError((error) {
      debugPrint(error);
      throw HttpException(
          'Could not run DELETE operation, something wrong with http request | exception: $error');
    });
  }
}
