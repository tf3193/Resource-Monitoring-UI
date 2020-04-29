import 'package:flutter/material.dart';
import 'CpuCore.dart';
import 'Memory.dart';
import 'CPU.dart';
import 'Processes.dart';


void main() => runApp(MyApp());

///Base class to create the home screen
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

///The card form which creates the buttons to direct you to other metric viewers.
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

///Creates the base metric from the metric form state.
class MetricForm extends StatefulWidget {
  @override
  _MetricFormState createState() => _MetricFormState();
}

///Creates the memory state from teh memory graph class
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

/// Creates the cpu screen from the CPUGraph class
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

/// Creates the process screen from the ProcessTable class
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

/// Creates the CPU Core screen from the CPUCoreGraph Class
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


/// Extends the metrics form state to create the basic view.
class _MetricFormState extends State<MetricForm>
    with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
  }

  ///Method to push the CPUScreen onto the stack
  void _showCPUGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CPUScreen()));
  }
  ///Method to push the MemScreen onto the stack
  void _showMemoryMetrics() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MemScreen()));
  }
  ///Method to push the Processcreen onto the stack
  void _showProcessGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ProcessScreen()));
  }
  ///Method to push the CPUCoreScreen onto the stack
  void _showCPUCoreGraph() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CPUCoreScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      /// Create a list of buttons to direct you to different states
      children: [
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
