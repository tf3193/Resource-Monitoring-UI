import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SelectMetricScreen(),
      ),
    );
  }
}

class SelectMetricScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        child: Card(
          child: MetricForm(),
        ),
      ),
    );
  }
}

class MetricForm extends StatefulWidget {
  @override
  _MetricFormState createState() => _MetricFormState();
}



class MemoryGraph extends StatefulWidget {
  @override
  _MemState createState() => _MemState();
}

class CPUGraph extends StatefulWidget {
  @override
  _CPUState createState() => _CPUState();
}

class CPUCoreGraph extends StatefulWidget {
  @override
  _CPUCoreState createState() => _CPUCoreState();
}

class MemScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 5000,
          child: MemoryGraph(),

      ),
    );
  }
}

class CPUScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 5000,
        child: CPUGraph(),

      ),
    );
  }
}

class CPUCoreScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 5000,
        child: CPUCoreGraph(),

      ),
    );
  }
}

CallApi() async {
  var api = "http://localhost:5000/api/cpu";

  Getdata(api).then((data) {

      Map parsed = json.decode(data);
      //var decoded = json.decode(data);
      print(parsed['value']);
      return parsed['value'];
      //_currentData = data.toString();

    });
}


class _MetricFormState extends State<MetricForm>
    with SingleTickerProviderStateMixin {



  void GetData() {
    var api = "http://localhost:5000/api/cpu";

    Getdata(api).then((data) {
      setState(() {
        apiCall= false; //Disable Progressbar
        Map parsed = json.decode(data);
        //var decoded = json.decode(data);
        print(parsed['value']);
        //_currentData = data.toString();
        _currentData = parsed['value'].toString();
      });
    }, onError: (error) {
      setState(() {
        apiCall=false; //Disable Progressbar
        _currentData = error.toString();
      });
    });
  }

  bool _formCompleted = false;
  AnimationController animationController;
  Animation<Color> colorAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200));
    var colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,

      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);
    colorAnimation = animationController.drive(colorTween); // NEW
  }


  void _showWelcomeScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }
  void _showCPUGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CPUScreen()));
  }
  void _showServerGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }
  void _showMemoryMetrics() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MemScreen()));
  }
  void _showProcessGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
  }
  void _showCPUCoreGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CPUCoreScreen()));
  }


  bool apiCall = false;
  String _currentData = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: animationController.value,
              valueColor: colorAnimation,
              backgroundColor: colorAnimation.value.withOpacity((0.4)),
            );
          },
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: _showCPUGraph, // UPDATES
            child: Text('CPU Stats'),
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: _showMemoryMetrics, // UPDATES
            child: Text('Memory Stats'),
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed: _showCPUCoreGraph, // UPDATES
            child: Text('CPU Core Stats'),
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed:  _showProcessGraph, // UPDATES
            child: Text('Process Stats'),
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: FlatButton(
            color: Colors.blue,
            textColor: Colors.white,
            onPressed:  (){
              setState((){
                apiCall=true; // Set state like this
              });
              GetData();

            }, // UPDATES
            child: Text('Test API'),
          ),
        ),
        Container(
          height: 40,
          width: double.infinity,
          margin: EdgeInsets.all(12),
          child: getProperWidget(),
        )


      ],
    );
  }
  Widget getProperWidget(){
    if(apiCall)
      return new CircularProgressIndicator();
    else
      return new Text(
        '$_currentData',
        style: Theme.of(context).textTheme.display1,
      );
  }

}


class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome!', style: Theme.of(context).textTheme.display3),
      ),
    );
  }
}

class MemoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final data = [
      new LinearSales(0, 5),
      new LinearSales(1, 25),
      new LinearSales(2, 100),
      new LinearSales(3, 75),
    ];

    new charts.Series<LinearSales, int>(
      id: 'Sales',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: data,
    );
    return Scaffold(
      body: Center(
        child: Text('Welcome!', style: Theme.of(context).textTheme.display3),
      ),
    );
  }
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
        height: 200.0,
        child: chart,
      ),
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Memory Graph"),
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
        height: 200.0,
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
    var chart = new charts.LineChart(CPUCoreList, animate: true);


    //var chart = new charts.LineChart(MemList, animate: animate);
    //return new charts.LineChart(CPUList, animate: animate);
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
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


  Future<List<charts.Series<LinearSales, int>>> _updateData() async {
    var body = await Getdata(url);
    var num_cores = await Getdata(Coreurl);
    print(body);
    Map parsed = json.decode(body.toString());
    print("adding " + parsed['value'].toString());
    core1.add(LinearValue(count, parsed['0']));
    core2.add(LinearValue(count, parsed['1']));
    core3.add(LinearValue(count, parsed['2']));
    core4.add(LinearValue(count, parsed['3']));
    core5.add(LinearValue(count, parsed['4']));
    core6.add(LinearValue(count, parsed['5']));
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



class CPULineChart extends StatelessWidget {
  final List<charts.Series> CPUList;
  final bool animate;
  final url = 'http://localhost:5000/api/cpu';
  var Data;

  CPULineChart(this.CPUList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory CPULineChart.withSampleData() {
    return new CPULineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var chart = new charts.LineChart(CPUList, animate: animate);
    //return new charts.LineChart(CPUList, animate: animate);
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("CPU Graph"),
        ),
        body: new Center(child: chartWidget)
    );
    /*

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


                  });
                }
              )

            )
          ],
      ),


    );*/

    return Column(

        children: [
          Center(
            child: new charts.LineChart(CPUList, animate: animate),

          ),
          Container(
            height: 40,
            width: double.infinity,
            margin: EdgeInsets.all(12),
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed:  ()async{
                var Data = await Getdata('localhost:5000/api/cpu');
                var decodedData = jsonDecode(Data);
                print(decodedData);
              }, // UPDATES
              child: Text('Test API'),
            ),
          ),
        ],
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
}


class CPUCoreLineChart extends StatelessWidget {
  final List<charts.Series> CPUList;
  final bool animate;
  final url = 'http://localhost:5000/api/core';
  var Data;

  CPUCoreLineChart(this.CPUList, {this.animate});

  /// Creates a [LineChart] with sample data and no transition.
  factory CPUCoreLineChart.withSampleData() {
    return new CPUCoreLineChart(
      _createSampleData(),
      // Disable animations for image tests.
      animate: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    var chart = new charts.LineChart(CPUList, animate: animate);
    //return new charts.LineChart(CPUList, animate: animate);
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("CPU Graph"),
        ),
        body: new Center(child: chartWidget)
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