import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';

class MemoryGraph extends StatefulWidget {
  @override
  _MemState createState() => _MemState();
}

class _MemState extends State<MemoryGraph> {
  List<charts.Series> MemList;
  bool animate;
  final url = 'http://localhost:5000/api/memory';
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

//  factory _MemState.withSampleData() {
//    return new _MemState(
//      _createSampleData(),
//      // Disable animations for image tests.
//      animate: true,
//    );
//  }

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
    MemList = series;
    var chart = new charts.LineChart(MemList, animate: true);


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
          title: new Text("Memory Graph"),
        ),
        body: new Center(child: chartWidget),
    );
  }

  Future<List<charts.Series<LinearSales, int>>> _updateData() async {
    var body = await Getdata(url);
    Map parsed = json.decode(body.toString());
    data.add(LinearValue(count, parsed['value']*100));
    count++;
    MemList = [
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
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}

/// Sample linear data type.
class LinearValue {
  final int time;
  final double usage;

  LinearValue(this.time, this.usage);
}