import 'package:flutter/material.dart';
import 'dart:async';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api.dart';
import 'CpuCore.dart';
import 'Memory.dart';
import 'CPU.dart';


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
        child: new CPUCoreGraph(),

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