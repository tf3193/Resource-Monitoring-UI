import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'api.dart';


/// Create the cpuGraph state
class CPUGraph extends StatefulWidget {
  @override
  _CPUState createState() => _CPUState();
}

/// Class to manage the CPU graph state
class _CPUState extends State<CPUGraph> {
  List<charts.Series> CPUList;
  final url = 'http://localhost:5000/api/cpu';
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
  void dispose() {
    _everyFiveSecond.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    var series = [
      new charts.Series<LinearValue, int>(
        domainFn: (LinearValue valdata, _) => valdata.time,
        measureFn: (LinearValue valdata, _) => valdata.usage,
        id: 'CPU Utilization %',
        data: data,
      )
    ];
    CPUList = series;
    var chart = new charts.LineChart(CPUList, animate: true, behaviors: [new charts.SeriesLegend()]);


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
    );
  }

  /// Method to get new data from Getdata and append it to data then update
  /// MemList.
  Future<List<charts.Series<LinearValue, int>>> _updateData() async {
    var body = await Getdata(url);
    Map parsed = json.decode(body.toString());
    data.add(LinearValue(count, parsed['value']*100));
    count++;
    CPUList = [
      new charts.Series<LinearValue, int>(
        id: 'CPU Utilization %',
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
