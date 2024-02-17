import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:open_route_test/my_map.dart';
import 'package:open_route_test/search_example.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: 'ikbldglmgm');
  runApp(
    MaterialApp(
      // home: MyMap(),
      home: DaumPostcodeSearchExample(
        title: 'sd',
      ),
    ),
  );
}
