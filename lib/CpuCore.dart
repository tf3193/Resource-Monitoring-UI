import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';


class CPUCoreGraph extends StatefulWidget {
  @override
  _CPUCoreState createState() => _CPUCoreState();
}

class _CPUCoreState extends State<CPUCoreGraph> {
  List<charts.Series> CPUCoreList;
  bool animate;
  final url = 'http://localhost:5000/api/core';
  final Coreurl = 'http://localhost:5000/api/total_core';
  List<LinearValue> core1;
  List<LinearValue> core2;
  List<LinearValue> core3;
  List<LinearValue> core4;
  List<LinearValue> core5;
  List<LinearValue> core6;
  Timer _everySecond;

  var count = 1;

  @override
  void initState() {
    core1 = [
      LinearValue(0,0)
    ];
    core2 = [
      LinearValue(0,0)
    ];
    core3 = [
      LinearValue(0,0)
    ];
    core4 = [
      LinearValue(0,0)
    ];
    core5 = [
      LinearValue(0,0)
    ];
    core6 = [
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
        id: 'Core1',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core1,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core2',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core2,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core3',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core3,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core4',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core4,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core5',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core5,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core6',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core6,
      )
    ];
    CPUCoreList = series;
    var chart = new charts.LineChart(CPUCoreList, animate: true, behaviors: [new charts.SeriesLegend()]);


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
          title: new Text("CPU Core Graph"),
        ),
        body: new Center(child: chartWidget),
        floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
              ),
            ]
        )
    );
  }


  Future<List<charts.Series<LinearSales, int>>> _updateData() async {
    var body = await Getdata(url);
    var num_cores = await Getdata(Coreurl);
    Map parsed = json.decode(body.toString());
    core1.add(LinearValue(count, parsed['0']*100));
    core2.add(LinearValue(count, parsed['1']*100));
    core3.add(LinearValue(count, parsed['2']*100));
    core4.add(LinearValue(count, parsed['3']*100));
    core5.add(LinearValue(count, parsed['4']*100));
    core6.add(LinearValue(count, parsed['5']*100));
    count++;
    CPUCoreList = [
      new charts.Series<LinearValue, int>(
        id: 'Core1',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core1,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core2',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core2,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core3',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core3,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core4',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core4,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core5',
        colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core5,
      ),
      new charts.Series<LinearValue, int>(
        id: 'Core6',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: core6,
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