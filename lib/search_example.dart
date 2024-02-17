import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';
import 'package:open_route_test/searching_page.dart';

class DaumPostcodeSearchExample extends StatefulWidget {
  DaumPostcodeSearchExample({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _DaumPostcodeSearchExampleState createState() =>
      _DaumPostcodeSearchExampleState();
}

class _DaumPostcodeSearchExampleState extends State<DaumPostcodeSearchExample> {
  DataModel? _daumPostcodeSearchDataModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TableRow _buildTableRow(String label, String value) {
      return TableRow(
        children: [
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(label, textAlign: TextAlign.center),
          ),
          TableCell(
            child: Text(value, textAlign: TextAlign.center),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    DataModel model = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchingPage(),
                      ),
                    );

                    setState(
                      () {
                        _daumPostcodeSearchDataModel = model;
                      },
                    );
                  } catch (error) {
                    print(error);
                  }
                },
                icon: Icon(Icons.search),
                label: Text("주소 검색"),
              ),
              Visibility(
                visible: _daumPostcodeSearchDataModel != null,
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: RichText(
                            text: TextSpan(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                              children: [
                                // WidgetSpan(
                                //   child: Icon(
                                //     Icons.check_circle,
                                //     color: Theme.of(context).accentColor,
                                //   ),
                                // ),
                                TextSpan(text: "주소 검색 결과"),
                              ],
                            ),
                          ),
                        ),
                        Table(
                          border: TableBorder.symmetric(
                              inside: BorderSide(color: Colors.grey)),
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(2),
                          },
                          children: [
                            _buildTableRow(
                              "한글주소",
                              _daumPostcodeSearchDataModel?.address ?? "",
                            ),
                            _buildTableRow(
                              "영문주소",
                              _daumPostcodeSearchDataModel?.addressEnglish ??
                                  "",
                            ),
                            _buildTableRow(
                              "우편번호",
                              _daumPostcodeSearchDataModel?.zonecode ?? "",
                            ),
                            _buildTableRow(
                              "지번주소",
                              _daumPostcodeSearchDataModel?.autoJibunAddress ??
                                  "",
                            ),
                            _buildTableRow(
                              "지번주소(영문)",
                              _daumPostcodeSearchDataModel
                                      ?.autoJibunAddressEnglish ??
                                  "",
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
