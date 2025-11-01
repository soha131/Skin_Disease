import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'models/skin_model.dart';

class ApiService {

  Future<SkinPrediction?> fetchDataFromApi(File file, BuildContext context) async {
    if (!(await file.exists())) {
      Fluttertoast.showToast(msg: "Error: File does not exist");
      return null;
    }

    // Validate file type
    String? mimeType = lookupMimeType(file.path);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      Fluttertoast.showToast(msg: "Error: Invalid image file");
      return null;
    }

    final String apiUrl = context.locale.languageCode == 'ar'
        ? "http://192.168.100.3:8000/predict-ar/"
        : "http://192.168.100.3:8000/predict/";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType('image', mimeType.split('/')[1]), // e.g., image/jpeg
        ))
        ..headers.addAll({'Accept': 'application/json'});

      var streamedResponse = await request.send().timeout(Duration(seconds: 120));
      final responseBody = await streamedResponse.stream.bytesToString();
      print("Response body: $responseBody");

      if (streamedResponse.statusCode == 200 && responseBody.isNotEmpty) {
        try {
          final jsonData = json.decode(responseBody);
          return SkinPrediction.fromJson(jsonData);
        } catch (e) {
          Fluttertoast.showToast(msg: "Error parsing response: $e");
          return null;
        }
      } else {
        try {
          final jsonData = json.decode(responseBody);
          String errorMsg = jsonData['detail'] ?? "Unknown error";
          Fluttertoast.showToast(msg: "API Error: ${streamedResponse.statusCode} - $errorMsg");
          print("API Error: ${streamedResponse.statusCode} - $errorMsg");
        } catch (e) {
          Fluttertoast.showToast(msg: "API Error: ${streamedResponse.statusCode}");
          print("API Error: ${streamedResponse.statusCode}");
        }
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Request failed. Check connection. Error: $e");
      print("Request failed. Check connection. Error: $e");
      return null;
    }
  }
}
