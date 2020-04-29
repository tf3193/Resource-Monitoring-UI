import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'api.dart';

///Create the CPU Core Graph state
class CPUCoreGraph extends StatefulWidget {
  @override
  _CPUCoreState createState() => _CPUCoreState();
}

///The class to manage the CPU Core state.
class _CPUCoreState extends State<CPUCoreGraph> {
  List<charts.Series> CPUCoreList = [];
  final url = 'http://localhost:5000/api/core';
  List<charts.Series<LinearValue, int>> cores;

  //This will only support up to 16 core processors.
  List<charts.Color> colors = [
    charts.MaterialPalette.blue.shadeDefault,
    charts.MaterialPalette.red.shadeDefault,
    charts.ColorUtil.fromDartColor(Colors.brown),
    charts.MaterialPalette.cyan.shadeDefault,
    charts.MaterialPalette.purple.shadeDefault,
    charts.ColorUtil.fromDartColor(Colors.amber),
    charts.MaterialPalette.yellow.shadeDefault,
    charts.MaterialPalette.green.shadeDefault,
    charts.MaterialPalette.indigo.shadeDefault,
    charts.MaterialPalette.lime.shadeDefault,
    charts.MaterialPalette.pink.shadeDefault,
    charts.MaterialPalette.teal.shadeDefault,
    charts.MaterialPalette.deepOrange.shadeDefault,
    charts.MaterialPalette.black,
    charts.MaterialPalette.gray.shadeDefault,
    charts.ColorUtil.fromDartColor(Colors.blueGrey)
  ];
  Map coreMap = Map<String, List<LinearValue>>();
  Timer _everyFiveSecond;
  var count = 0;

  @override
  void initState() {
    //For some reason I NEEDED to have a default value for multiple lines on one
    //graph.
    coreMap["1"] = [LinearValue(0,0)];
    super.initState();
    _updateData();
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
    List<charts.Series<LinearValue, int>> series = [];
    //For each core in our coreMap, we are creating a new chart series
    coreMap.forEach((key, valueList) {
      series.add(
          new charts.Series<LinearValue, int>(
            id: 'Core' + key.toString(),
            //Grab the color from our color list
            colorFn: (_, __) => colors[int.parse(key)-1],
            domainFn: (LinearValue value, _) => value.time,
            measureFn: (LinearValue value, _) => value.usage,
            data: valueList,
          )
      );

    });

    //Updating CPUCoreList in place resulted in errors so I had to use this way.
    CPUCoreList = series;
    var chart = new charts.LineChart(CPUCoreList, animate: true, behaviors: [new charts.SeriesLegend()]);

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

  ///Method to update our coreMap with new data and add the new points to our
  ///chart lines.
  Future<List<charts.Series<LinearValue, int>>> _updateData() async {
    var body = await Getdata(url);
    Map parsed = json.decode(body.toString());
    //For each core in our parsed json we need to append it to our core lists
    for (final name in parsed.keys) {
      //If this is not the first time we can append, otherwise we must
      //initialize the core value in our map.
      if(coreMap.containsKey((int.parse(name) + 1).toString())) {
        coreMap[(int.parse(name) + 1).toString()].add(LinearValue(count, parsed[name]*100));
      }
      else {
        coreMap[(int.parse(name) + 1).toString()] = [LinearValue(count, parsed[name]*100)];
      }
    }
    count++;
    var series = [];
    //Once we have updated our coreMap, we need to create a new series list and
    //assign it to our CPUCoreList.
    coreMap.forEach((key, valueList) {
      series.add(
          new charts.Series<LinearValue, int>(
            id: 'Core' + key.toString(),
            colorFn: (_, __) => colors[key-1],
            domainFn: (LinearValue value, _) => value.time,
            measureFn: (LinearValue value, _) => value.usage,
            data: valueList,
          )
      );

    });
    CPUCoreList = series;
  }

}


/// Sample linear data type.
class LinearValue {
  final int time;
  final double usage;

  LinearValue(this.time, this.usage);
}
