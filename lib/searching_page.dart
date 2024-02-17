import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';

class SearchingPage extends StatefulWidget {
  @override
  _SearchingPageState createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  bool _isError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    DaumPostcodeSearch daumPostcodeSearch = DaumPostcodeSearch(
      onConsoleMessage: (_, message) => print(message),
      onLoadError: (controller, uri, errorCode, message) => setState(
        () {
          _isError = true;
          errorMessage = message;
        },
      ),
      onLoadHttpError: (controller, uri, errorCode, message) => setState(
        () {
          _isError = true;
          errorMessage = message;
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("주소 검색 페이지입니다."),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: daumPostcodeSearch,
            ),
            Visibility(
              visible: _isError,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(errorMessage ?? ""),
                  ElevatedButton(
                    child: Text("Refresh"),
                    onPressed: () {
                      daumPostcodeSearch.controller?.reload();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
