import 'package:flutter/material.dart';
import 'package:eztalk/api/eztalk_api.dart'; // 確保導入 EztalkApi

class TestApiPage extends StatefulWidget {
  @override
  _TestApiPageState createState() => _TestApiPageState();
}

class _TestApiPageState extends State<TestApiPage> {
  final EztalkApi api = EztalkApi();
  String? apiResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test API'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                try {
                  await api.seriesConnectingGet("借過");
                  setState(() {
                    apiResponse = 'API call successful';
                  });
                } catch (e) {
                  setState(() {
                    apiResponse = 'Error: $e';
                    print('Error: $e');
                  });
                }
              },
              child: Text('Send API Request'),
            ),
            if (apiResponse != null) Text(apiResponse!),
          ],
        ),
      ),
    );
  }
}
