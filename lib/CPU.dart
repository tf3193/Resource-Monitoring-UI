import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';


class CPUGraph extends StatefulWidget {
  @override
  _CPUState createState() => _CPUState();
}

class _CPUState extends State<CPUGraph> {
  List<charts.Series> CPUList;
  bool animate;
  final url = 'http://localhost:5000/api/cpu';
  var data;
  Timer _everySecond;

  var count = 1;

  //_MemState(this.MemList, {this.animate});

  @override
  void initState() {
    data = [
      LinearValue(0,0)
    ];
    super.initState();
    _everySecond = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _updateData();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      new charts.Series<LinearValue, int>(
        domainFn: (LinearValue valdata, _) => valdata.time,
        measureFn: (LinearValue valdata, _) => valdata.usage,
        id: 'Memory',
        data: data,
      )
    ];
    CPUList = series;
    var chart = new charts.LineChart(CPUList, animate: true);


    //var chart = new charts.LineChart(MemList, animate: animate);
    //return new charts.LineChart(CPUList, animate: animate);
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 800.0,
        child: chart,
      ),
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("CPU Graph"),
        ),
        body: new Center(child: chartWidget),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _updateData();
                    });
                  },
                  child: Icon(
                    Icons.add,
                  ),
                  backgroundColor: Colors.red,
                ),
              ),
            ]
        )
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<LinearSales, int>> _createSampleData() {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    return [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  Future<List<charts.Series<LinearSales, int>>> _updateData() async {
    var body = await Getdata(url);
    print(body);
    Map parsed = json.decode(body.toString());
    print("adding " + parsed['value'].toString());
    data.add(LinearValue(count, parsed['value']));
    count++;
    CPUList = [
      new charts.Series<LinearSales, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: data,
      )
    ];

  }

}


/// Sample linear data type.
class LinearValue {
  final int time;
  final double usage;

  LinearValue(this.time, this.usage);
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}