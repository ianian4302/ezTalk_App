import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EztalkApi {
  static const String baseUrl = 'https://eztalk-backend.onrender.com/api';

  Future<SeriesConnecting> seriesConnectingGet(String input) async {
    if (input == 's') {
      input = '借過';
    }
    final msg = jsonEncode({"stn": input});
    final response = await http.post(Uri.parse('$baseUrl/lookupDic'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*',
          'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        },
        body: msg);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return SeriesConnecting.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load seriesConnecting');
    }
  }

  Future<void> eztalkApiTest() async {
    final response = await http.get(
      Uri.parse('$baseUrl/test'),
      headers: <String, String>{
        'Accept': '*/*',
        'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
      },
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
    } else {
      throw Exception('Failed to load');
    }
  }
}

class SeriesConnecting {
  final List<String> frontWords;
  final List<String> backWords;

  SeriesConnecting({
    required this.frontWords,
    required this.backWords,
  });

  factory SeriesConnecting.fromJson(Map<String, dynamic> json) {
    return SeriesConnecting(
      frontWords: List<String>.from(json['front'] as List<dynamic>),
      backWords: List<String>.from(json['back'] as List<dynamic>),
    );
  }
}
