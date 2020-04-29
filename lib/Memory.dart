import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'api.dart';

class MemoryGraph extends StatefulWidget {
  @override
  _MemState createState() => _MemState();
}

class _MemState extends State<MemoryGraph> {
  List<charts.Series> MemList;
  final url = 'http://localhost:5000/api/memory';
  List<LinearValue> data = [];
  Timer _everyFiveSecond;
  var count = 0;


  @override
  void initState() {
    super.initState();
    setState(() {
      _updateData();
    });
    _everyFiveSecond = Timer.periodic(Duration(seconds: 5), (Timer t) {
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
        id: 'Memory Utilization %',
        data: data,
      )
    ];

    MemList = series;
    var chart = new charts.LineChart(MemList, animate: true, behaviors: [new charts.SeriesLegend()]);

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

  /// Method to get new data from Getdata and append it to data then update
  /// MemList.
  Future<List<charts.Series<LinearValue, int>>> _updateData() async {
    var body = await Getdata(url);
    Map parsed = json.decode(body.toString());
    data.add(LinearValue(count, parsed['value']*100));
    count++;
    MemList = [
      new charts.Series<LinearValue, int>(
        id: 'Memory Utilization %',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearValue value, _) => value.time,
        measureFn: (LinearValue value, _) => value.usage,
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