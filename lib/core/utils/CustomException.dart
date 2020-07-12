import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as _dio;

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  String toString() {
    return "$_message";
  }

  dynamic streamedResponse(http.StreamedResponse response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.toString());
        return responseJson;
        break;
      case 201:
        var responseJson = json.decode(response.toString());
        return responseJson;
        break;
      case 400:
        throw BadRequestException(response.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.toString());

      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic response(_dio.Response response) {
    switch (response.statusCode) {
      case 200:
        // var responseJson = jsonDecode(response.data.toString());
        return response.data;
        break;
      case 201:
        // var responseJson = json.decode(response.toString());
        return response.data;
        break;
      case 400:
        throw BadRequestException(response.data.toString());
      case 401:

      case 403:
        throw UnauthorisedException(response.data.toString());

      case 500:

      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }

  dynamic responseDioError(_dio.DioError error) {
    if (error.type == _dio.DioErrorType.RESPONSE) {
      switch (error.response.statusCode) {
        case 401:
        case 403:
          throw Exception(error.message.toString());
        case 500:
          throw Exception(error.message.toString());
        default:
          throw FetchDataException(
              'Error occured while Communication with Server with StatusCode : ${error.response.statusCode}');
      }
    } else if (error.type == _dio.DioErrorType.DEFAULT) {
      throw Exception(error.message.toString());
    }
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String message])
      : super(message, "Error During Communication");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Bad Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthoraised: ");
}

class ServerException extends CustomException {
  ServerException([message]) : super(message, "Server Error: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([message]) : super(message, "Invalid Input: ");
}
