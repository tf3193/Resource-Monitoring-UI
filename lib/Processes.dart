import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';


class ProcessTable extends StatefulWidget {
  @override
  _ProcessState createState() => _ProcessState();
}

class _ProcessState extends State<ProcessTable> {
  bool sort = true;
  final List<Map<String, String>> listOfColumns = [
    {"PID": "0", "Name": "1", "Memory": "0", "State": ""}
  ];
  List<DataRow> _rowList = [
    DataRow(cells: <DataCell>[
      DataCell(Text('0')),
      DataCell(Text('a')),
      DataCell(Text('0')),
      DataCell(Text(""))
    ]),
  ];

  List<charts.Series> CPUList;
  Map processes = new Map();
  bool animate;
  final url = 'http://localhost:5000/api/processes';
  Timer _everySecond;

  @override
  void initState() {

    super.initState();
    _updateData();
    _everySecond = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        //_updateData();
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text('Processes'),
          ),
          body: ListView(children: <Widget>[
            Center(
                child: Text(
                  'Processes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
            DataTable(
              columns: [
                DataColumn(label: Text('PID')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Memory(kb)'),),
                DataColumn(label: Text('State')),
              ],
              rows: _rowList,
            ),

          ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            //_addRow();
            _updateData();
          });
        },
        label: Text('Update Table'),
        backgroundColor: Colors.green,
      ),
    );

  }

  onSortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _rowList.sort((a, b) => a.toString().compareTo(b.toString()));
      } else {
        _rowList.sort((a, b) => b.toString().compareTo(a.toString()));
      }
    }
  }


  Future _updateData() async {
    List<DataRow> _newList = [];

    var body = await Getdata(url);
    //print(body);
    Map parsed = json.decode(body.toString());
    parsed.forEach((key, value) {
      DataRow row = DataRow(cells: <DataCell>[
        DataCell(Text(key.toString())),
        DataCell(Text(parsed[key]["name"].toString())),
        DataCell(Text(parsed[key]["memory"].toString())),
        DataCell(Text(parsed[key]["state"].toString()))
      ]);

      _newList.add(row);
    });
    _rowList = _newList;
  }

}
