import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'api.dart';

///Create the Network state
class networkGraph extends StatefulWidget {
  @override
  _NetworkState createState() => _NetworkState();
}

///The class to manage the Network state.
class _NetworkState extends State<networkGraph> {
  List<charts.Series> networkList = [];
  final url = 'http://localhost:5000/api/network';
  List<LinearValue> sendData = [];
  List<LinearValue> receiveData = [];

  Timer _everyFiveSecond;
  var count = 0;

  @override
  void initState() {
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
    List<charts.Series<LinearValue, int>> series = [
      new charts.Series<LinearValue, int>(
        id: 'send',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: sendData,
      ),
      new charts.Series<LinearValue, int>(
        id: 'receive',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: receiveData,
      )
    ];

    //Updating CPUCoreList in place resulted in errors so I had to use this way.
    networkList = series;
    var chart = new charts.LineChart(networkList, animate: true, behaviors: [new charts.SeriesLegend()]);

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 800.0,
        child: chart,
      ),
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Network Graph"),
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

  ///Method to update our networkList with new data and add the new points to our
  ///chart lines.
  Future<List<charts.Series<LinearValue, int>>> _updateData() async {
    var body = await Getdata(url);
    Map parsed = json.decode(body.toString());
    print(parsed.toString());
    sendData.add(LinearValue(count, parsed['send']));
    receiveData.add(LinearValue(count, parsed['receive']));
    count++;
    List<charts.Series<LinearValue, int>> series = [
      new charts.Series<LinearValue, int>(
        id: 'send',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: sendData,
      ),
      new charts.Series<LinearValue, int>(
        id: 'receive',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (LinearValue sales, _) => sales.time,
        measureFn: (LinearValue sales, _) => sales.usage,
        data: receiveData,
      )
    ];
    networkList = series;
  }

}


/// Sample linear data type.
class LinearValue {
  final int time;
  final double usage;

  LinearValue(this.time, this.usage);
}
