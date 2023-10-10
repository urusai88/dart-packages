import 'package:flutter/material.dart';
import 'package:mhc_popup/mhc_popup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Popup Demo',
      home: Home(),
    );
  }
}

final keys = <String, GlobalKey>{};
const rightBottomDelegate = PopupAlignPositionDelegate.withoutInsets(
  keyAlignment: Alignment(0.5, 0.5),
  popupAlignment: Alignment.topLeft,
);

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          children: const [
            Tile(
              text: 'right bottom 1',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 2',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 3',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 4',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 5',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 6',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 7',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 8',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 9',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 10',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 11',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 12',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 13',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 14',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 15',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 16',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 17',
              delegate: rightBottomDelegate,
            ),
            Tile(
              text: 'right bottom 18',
              delegate: rightBottomDelegate,
            ),
          ],
        ),
      ),
    );
  }
}

class Popup extends StatelessWidget {
  const Popup({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.yellow,
        border: Border.fromBorderSide(
          BorderSide(color: Colors.blueGrey),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 50, height: 25, color: Colors.green),
          Container(height: 10, color: Colors.red),
          Container(width: 75, height: 25, color: Colors.black),
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    super.key,
    required this.text,
    required this.delegate,
  });

  final String text;
  final PopupPositionDelegate delegate;

  @override
  Widget build(BuildContext context) {
    final key = keys.putIfAbsent(text, GlobalKey.new);
    return GestureDetector(
      key: key,
      behavior: HitTestBehavior.opaque,
      onTap: () {
        showPopup(
          context: context,
          key: key,
          builder: (_) => const Popup(),
          positionDelegate: delegate,
        );
      },
      child: Container(
        color: Colors.grey,
        child: Text(text),
      ),
    );
  }
}
