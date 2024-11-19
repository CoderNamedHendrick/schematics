// ignore_for_file: prefer_const_constructors

import 'package:example/examples/schema_four.dart';
import 'package:example/examples/schema_three.dart';
import 'package:flutter/material.dart';
import 'package:schematics/schematics.dart';

import 'examples/schema_two.dart';

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
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

final showBlockAreas = ValueNotifier(false);
final showGridCells = ValueNotifier(false);

class _MyHomePageState extends State<MyHomePage> {
  void _toggleShowBlockArea(bool value) {
    showBlockAreas.value = value;
  }

  void _toggleShowGridCells(bool value) {
    showGridCells.value = value;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListenableBuilder(
              listenable: Listenable.merge([showBlockAreas, showGridCells]),
              builder: (BuildContext context, Widget? child) {
                return Wrap(
                  children: [
                    ChoiceChip(
                      label: const Text('Show block areas'),
                      selected: showBlockAreas.value,
                      onSelected: _toggleShowBlockArea,
                    ),
                    const SizedBox(width: 12),
                    ChoiceChip(
                      label: const Text('Show grid cells'),
                      selected: showGridCells.value,
                      onSelected: _toggleShowGridCells,
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Listenable.merge([showBlockAreas, showGridCells]),
              builder: (context, child) => PageView(
                children: [
                  _page(SchemaOne()),
                  _page(SchemaTwo()),
                  _page(SchemaThree()),
                  _page(SchemaFour()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _page(Widget child) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.95,
        child: ColoredBox(
          color: Colors.grey,
          child: child,
        ),
      ),
    );
  }
}

class SchemaOne extends StatelessWidget {
  const SchemaOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Schema(
      config: SchemaConfiguration(
        showBlocks: showBlockAreas.value,
        showGrid: showGridCells.value,
        initiateAxesScale: (constraints) => AxesScale(
          x: constraints.maxWidth * 0.00188,
          y: constraints.maxHeight * 0.001885,
          opening: constraints.maxWidth * 0.00188,
        ),
      ),
      blocks: [
        Block(
          label: 'Veranda',
          height: 200,
          width: 80,
          fenceBorder: HideFenceBorder.left,
          openings: [const Offset(80, 30).opening],
        ),
        Block(
          width: 250,
          height: 200,
          label: 'Sitting room',
          color: const Color(0xffb6b0dd),
          position: const Offset(80, 0),
          openings: [
            const Offset(0, 30).opening,
            const Offset(190, 0).oSize(60),
            const Offset(250, 20).opening,
          ],
        ),
        Block(
          label: 'Bedroom 1',
          width: 200,
          height: 180,
          color: const Color(0xffb6b0dd),
          position: const Offset(330, 0),
          openings: [
            const Offset(0, 0.01).opening,
            const Offset(30, 0).opening
          ],
        ),
        Block(
          label: 'Toilet 1',
          width: 200,
          height: 70,
          position: const Offset(330, 180),
          openings: [const Offset(30, 70).opening],
        ),
        Block(
          label: 'Corridor',
          height: 330,
          width: 60,
          color: const Color(0xffb6bdcc),
          position: const Offset(270, 200),
          fenceBorder: HideFenceBorder.bottom,
          openings: [
            const Offset(0, 280).opening,
            const Offset(0, 100).opening,
            const Offset(60, 130).opening,
          ],
        ),
        Block(
          label: 'Master\'s toilet',
          width: 200,
          height: 80,
          position: const Offset(330, 250),
          openings: [const Offset(30, 0).opening],
        ),
        Block(
          label: 'Master\'s bedroom',
          height: 200,
          width: 200,
          position: const Offset(330, 330),
          color: const Color(0xffb6b0dd),
          openings: [
            const Offset(0, 130).opening,
            const Offset(30, 200).opening,
          ],
        ),
        Block(
          label: 'Kitchen',
          height: 120,
          width: 190,
          position: const Offset(80, 200),
          color: const Color(0xff88cd83),
          openings: [
            const Offset(190, 70).opening,
          ],
        ),
        Block(
          label: 'Toilet 2',
          width: 190,
          height: 60,
          position: const Offset(80, 320),
          openings: [const Offset(140, 0).opening],
        ),
        Block(
          label: 'Bedroom 2',
          width: 190,
          height: 150,
          color: const Color(0xffb6b0dd),
          position: const Offset(80, 380),
          openings: [
            const Offset(140, 150).opening,
            const Offset(190, 100).opening,
          ],
        ),
      ],
    );
  }
}
