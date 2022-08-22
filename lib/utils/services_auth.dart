import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import './cfg_environment.dart';

//provider
import '../providers/auth_provider.dart';

//model
import '../models/http_exceptions.dart';

class ServicesAuth {
  final String _apiKey = CfgEnvironment.googleAPIKey;
  final String _googleAuthBaseUrl =
      'https://identitytoolkit.googleapis.com/v1/accounts:';

  Map<String, String> _renderHeader() {
    return {
      "Content-Type": "application/json",
    };
  }

  Future<dynamic> postSignUp({
    @required dynamic body,
    dynamic uploadFile,
  }) {
    return http
        .post(
      Uri.parse('${_googleAuthBaseUrl}signUp?key=$_apiKey'),
      headers: _renderHeader(),
      body: json.encode(body),
    )
        .then((resp) {
      var decodedData = json.decode(resp?.body);
      if (decodedData['error'] != null) {
        String error = decodedData['error']['message'] as String;
        switch (error) {
          case 'EMAIL_EXISTS':
            throw HttpException('Email already exist.');
            break;
          case 'OPERATION_NOT_ALLOWED':
            throw HttpException(
                'Unable to signIn using email and password, please try again later.');
            break;
          case 'TOO_MANY_ATTEMPTS_TRY_LATER':
            throw HttpException(
                'Unusual activity detected, please try again later.');
            break;
          default:
            throw HttpException('[Undefined error] | error message: $error');
        }
      }
      return {
        'headers': resp?.headers,
        'idToken': decodedData['idToken'],
        'refreshToken': decodedData['refreshToken'],
        'expiresIn': decodedData['expiresIn'],
        'localId': decodedData['localId'],
        'email': decodedData['email'],
        'statusCode': resp?.statusCode,
      };
    }).catchError(
      (error) => throw HttpException('Sign Up failed, note: $error'),
    );
  }

  Future<dynamic> postSignIn({
    @required dynamic body,
    dynamic uploadFile,
  }) {
    return http
        .post(
      Uri.parse('${_googleAuthBaseUrl}signInWithPassword?key=$_apiKey'),
      headers: _renderHeader(),
      body: json.encode(body),
    )
        .then((resp) {
      var decodedData = json.decode(resp?.body);
      if (decodedData['error'] != null) {
        String error = decodedData['error']['message'] as String;
        if (error == 'EMAIL_NOT_FOUND' || error == 'INVALID_PASSWORD') {
          throw HttpException('The email or password is not valid.');
        } else if (error == 'USER_DISABLED') {
          throw HttpException('The user is disabled');
        } else {
          throw HttpException('[Undefined error] | error message: $error');
        }
      }
      return {
        'headers': resp?.headers,
        'idToken': decodedData['idToken'],
        'refreshToken': decodedData['refreshToken'],
        'expiresIn': decodedData['expiresIn'],
        'displayName': decodedData['displayName'],
        'email': decodedData['email'],
        'localId': decodedData['localId'],
        'registered': decodedData['registered'],
        'statusCode': resp?.statusCode,
      };
    }).catchError(
      (error) => throw HttpException('Sign In failed, note: $error'),
    );
  }

//   Future<dynamic> refreshToken({
//     @required String path,
//   }) {
//     return http
//         .get(
//           Uri.parse('$_baseUrl/$path'),
//           headers: _renderHeader(),
//         )
//         .then((resp) => _response(resp))
//         .catchError((error) {
//       debugPrint(error);
//       throw HttpException(
//           'Could not run GET operation, something wrong with http request | exception: $error');
//     });
//   }
}
