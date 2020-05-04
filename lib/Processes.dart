import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'api.dart';

///Create the process table state
class ProcessTable extends StatefulWidget {
  @override
  _ProcessState createState() => _ProcessState();
}

/// Create the processes table.
class _ProcessState extends State<ProcessTable> {
  bool sort = true;
  List<DataRow> _rowList = [
    DataRow(cells: <DataCell>[
      DataCell(Text('Initial Data Loading')),
      DataCell(Text('Initial Data Loading')),
      DataCell(Text('Initial Data Loading')),
      DataCell(Text("Initial Data Loading"))
    ]),
  ];
  Timer _everyFiveSecond;
  final url = 'http://localhost:5000/api/processes';

  @override
  void initState() {
    super.initState();
    //Grab the initial set of data
    _updateData();
    // Now every 5 seconds update the sate and grab new data.
    _everyFiveSecond = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _updateData();
      });
    });


  }

  @override
  void dispose() {
    _everyFiveSecond.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //creates the app bar to go back to main page
          appBar: AppBar(
            title: Text('Processes'),
          ),
          body: ListView(children: <Widget>[
            //Title of Table
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
    );

  }

  ///Update data method to call Getdata and then parse for each process and
  ///add it to the row.
  ///It then overwrites our entire row list with the new list generated
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
