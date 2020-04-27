import 'package:flutter/material.dart';
import 'CpuCore.dart';
import 'Memory.dart';
import 'CPU.dart';
import 'Processes.dart';


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

class ProcessScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 5000,
        child: ProcessTable(),

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



class _MetricFormState extends State<MetricForm>
    with SingleTickerProviderStateMixin {

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

  void _showCPUGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CPUScreen()));
  }
  void _showMemoryMetrics() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MemScreen()));
  }
  void _showProcessGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProcessScreen()));
  }
  void _showCPUCoreGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CPUCoreScreen()));
  }

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
      ],
    );
  }
}
