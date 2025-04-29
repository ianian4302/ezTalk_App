import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class EztalkApi {
  static const String baseUrl = 'https://eztalk-backend.onrender.com/api';

  // 前後文語句搜尋
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

  // 歷史語句搜尋
  Future<List<String>> historySeriesGet(String input) async {
    if (input == 's') {
      input = '你好嗎';
    }
    final msg = jsonEncode({"keyword": input});
    final response = await http.post(Uri.parse('$baseUrl/get_vocal_sentence'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*',
          'User-Agent': 'Thunder Client (https://www.thunderclient.com)',
        },
        body: msg);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return List<String>.from(jsonDecode(response.body) as List<dynamic>);
    } else {
      throw Exception('Failed to load historySeties');
    }
  }

  // 回傳確認語音辨識結果
  Future<String> confirmAudio(String input) async {
    final msg = jsonEncode({"original": input});
    final response = await http.put(Uri.parse('$baseUrl/updates'), body: msg);
    if (response.statusCode == 200) {
      debugPrint(response.body);
      return jsonDecode(response.body)['res'] as String;
    } else {
      throw Exception('Failed to load confirmAudio');
    }
  }

  // 上傳音檔
  Future<String> uploadFile(String filePath, String username) async {
    var url = Uri.parse('$baseUrl/process_audio');
    var file = File(filePath);

    if (!file.existsSync()) {
      print('❌ 檔案不存在: $filePath');
      return '❌ 檔案不存在: $filePath';
    }

    var request = http.MultipartRequest('POST', url)
      ..fields['login_user'] = username
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      print('✅ 音檔上傳成功');
      return jsonResponse['res'];
    } else {
      print('❌ 上傳失敗，錯誤碼: ${response.statusCode}');
      return '❌ 上傳失敗，錯誤碼: ${response.statusCode}';
    }
  }

  // 上傳音檔 transfer
  Future<String> transfer(String filePath, String username) async {
    var url = Uri.parse('$baseUrl/transfer');
    var file = File(filePath);

    if (!file.existsSync()) {
      print('❌ 檔案不存在: $filePath');
      return '❌ 檔案不存在: $filePath';
    }

    var request = http.MultipartRequest('POST', url)
      ..fields['login_user'] = username
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      print('✅ 音檔上傳成功');
      return jsonResponse['res'];
    } else {
      print('❌ 上傳失敗，錯誤碼: ${response.statusCode}');
      return '❌ 上傳失敗，錯誤碼: ${response.statusCode}';
    }
  }

  // 下載音檔
  Future<String?> downloadFile(String filename) async {
    var url = Uri.parse('$baseUrl/download/$filename');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final Directory appDoduleDirectory =
          await getApplicationDocumentsDirectory();
      final String filePath = path.join(appDoduleDirectory.path, filename);
      var outputFile = File(filePath);
      await outputFile.writeAsBytes(response.bodyBytes);
      print('✅ 音檔下載成功: ${outputFile.path}');
      return outputFile.path;
    } else {
      print('❌ 下載失敗，錯誤碼: ${response.statusCode}');
      return null;
    }
  }

  // 下載隨機音檔
  Future<String?> downloadRandomFile() async {
    var url = Uri.parse('$baseUrl/download-random');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final Directory appDoduleDirectory =
          await getApplicationDocumentsDirectory();
      final String filePath =
          path.join(appDoduleDirectory.path, 'random_audio.wav');
      var outputFile = File(filePath);
      await outputFile.writeAsBytes(response.bodyBytes);
      print('✅ 隨機音檔下載成功: ${outputFile.path}');
      return outputFile.path;
    } else {
      print('❌ 隨機音檔下載失敗，錯誤碼: ${response.statusCode}');
      return null;
    }
  }

  // 確認整句串接/歷史句子
  Future<String?> feedback(
      String username, String correctWord, String filename) async {
    var url = Uri.parse('$baseUrl/feedback');
    String baseFileName = path.basename(filename);
    var request = http.MultipartRequest('POST', url)
      ..fields['login_user'] = username
      ..fields['correct'] = correctWord
      ..fields['filename'] = baseFileName;
    print('上傳的檔案名稱: $baseFileName');
    print('上傳的正確字: $correctWord');
    print('上傳的使用者名稱: $username');
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      print('✅ 確認整句串接成功');
      return jsonResponse['res'] as String?;
    } else {
      print('❌ 確認整句串接失敗，錯誤碼: ${response.statusCode}');
      return null;
    }
  }

  // 歷史句子查詢
  Future<String?> checkHsitory(String username) async {
    var url = Uri.parse('$baseUrl/check_history');
    var request = http.MultipartRequest('POST', url)
      ..fields['account'] = username;
    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      var jsonResponse = jsonDecode(responseBody.body);
      print('✅ 歷史句子查詢成功');
      return jsonResponse['res'] as String?;
    } else {
      print('❌ 歷史句子查詢失敗，錯誤碼: ${response.statusCode}');
      return null;
    }
  }

  //  TODO:資料蒐集的API串接

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
