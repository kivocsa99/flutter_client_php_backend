import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_client_php_backend/models/base/EventObject.dart';
import 'package:flutter_client_php_backend/models/ApiRequest.dart';
import 'package:flutter_client_php_backend/models/ApiResponse.dart';
import 'package:flutter_client_php_backend/utils/constants.dart';
import 'package:flutter_client_php_backend/models/User.dart';

///////////////////////////////////////////////////////////////////////////////
Future<EventObject> loginUser(String emailId, String password) async {
  ApiRequest apiRequest = new ApiRequest();
  User user = new User(email: emailId, password: password);

  apiRequest.operation = APIOperations.LOGIN;
  apiRequest.user = user;

  try {
    final encoding = "application/octet-stream";
    final response = await http.post(APIConstants.API_BASE_URL,
        body: json.encode(apiRequest.toJson()),
        encoding: Encoding.getByName(encoding));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        final responseJson = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(responseJson);
        if (apiResponse.result == "success") {
          return new EventObject(
              id: EventConstants.LOGIN_USER_SUCCESSFUL,
              object: apiResponse.user);
        } else {
          return new EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
        }
      } else {
        return new EventObject(id: EventConstants.LOGIN_USER_UN_SUCCESSFUL);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}

///////////////////////////////////////////////////////////////////////////////
Future<EventObject> registerUser(
    String name, String emailId, String password) async {
  ApiRequest apiRequest = new ApiRequest();
  User user = new User(name: name, email: emailId, password: password);

  apiRequest.operation = APIOperations.REGISTER;
  apiRequest.user = user;

  try {
    final encoding = "application/octet-stream";
    final response = await http.post(APIConstants.API_BASE_URL,
        body: json.encode(apiRequest.toJson()),
        encoding: Encoding.getByName(encoding));
    if (response != null) {
      if (response.statusCode == APIResponseCode.SC_OK &&
          response.body != null) {
        final responseJson = json.decode(response.body);
        ApiResponse apiResponse = ApiResponse.fromJson(responseJson);
        if (apiResponse.result == "success") {
          return new EventObject(
              id: EventConstants.USER_REGISTRATION_SUCCESSFUL,
              object: apiResponse.user);
        } else if (apiResponse.result == "failure") {
          return new EventObject(id: EventConstants.USER_ALREADY_REGISTERED);
        } else {
          return new EventObject(
              id: EventConstants.USER_REGISTRATION_UN_SUCCESSFUL);
        }
      } else {
        return new EventObject(
            id: EventConstants.USER_REGISTRATION_UN_SUCCESSFUL);
      }
    } else {
      return new EventObject();
    }
  } catch (Exception) {
    return EventObject();
  }
}
///////////////////////////////////////////////////////////////////////////////
