import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var color = '0xffffff';

  var channel = const MethodChannel('mycolor');
  var calculationChannel = const MethodChannel('calculationChannel');
  var subtractChannel = const MethodChannel('subtractChannel');
  var cameraChannel = const MethodChannel('cameraChannel');

  setColor(clr) {
    setState(() {
      color = clr;
    });
  }

  void changeColor() async {
    var res = await channel.invokeMethod('changeColor');
    setColor(res);
  }

  Future<void> openCam() async {
    await cameraChannel.invokeMethod('openCamera');
  }

  int _num1 = 0;
  int _num2 = 0;
  int _sum = 0;
  int _subtract = 0;

  Future<void> _addNumbers() async {
    try {
      final int result =
          await calculationChannel.invokeMethod('add', {'num1': 1, 'num2': 4});
      setState(() {
        _sum = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _sum = 0;
      });
      print("Failed to add numbers: ${e.message}");
    }
  }

  Future<void> subtract() async {
    try {
      final int result = await subtractChannel
          .invokeMethod('subtract', {'num1': 1, 'num2': 4});
      setState(() {
        _subtract = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _subtract = 0;
      });
      print("Failed to add numbers: ${e.message}");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _addNumbers();
    subtract();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse(color)),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "add: ${_sum.toString()}",
            ),
            Text(
              "subtract: ${_subtract.toString()}",
            ),
            ElevatedButton(
                onPressed: () {
                  setColor('0xffE60003');
                },
                child: const Text('Flutter code')),
            ElevatedButton(
                onPressed: changeColor, child: const Text('Native code')),
            ElevatedButton(
                onPressed: () async {
                  await openCam();
                },
                child: const Text('open camera'))
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
