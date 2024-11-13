import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:schematics/schematics.dart';

class SchemaOne extends StatelessWidget {
  const SchemaOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SchemaWidget(
      showBlocks: showBlockAreas.value,
      showGrid: showGridCells.value,
      onInitiateAxesScale: (constraints) => (
        xScale: constraints.maxWidth * 0.00188,
        yScale: constraints.maxHeight * 0.001885,
        openingScale: constraints.maxWidth * 0.00188
      ),
      blocks: [
        Block(
          blockLabel: 'Veranda',
          height: 200,
          width: 80,
          hideFenceBorder: HideFenceBorder.left,
          openings: [const Offset(80, 30).opening],
        ),
        Block(
          width: 250,
          height: 200,
          blockLabel: 'Sitting room',
          blockColor: const Color(0xffb6b0dd),
          position: const Offset(80, 0),
          openings: [
            const Offset(0, 30).opening,
            const Offset(190, 0).oSize(60),
            const Offset(250, 20).opening,
          ],
        ),
        Block(
          blockLabel: 'Bedroom 1',
          width: 200,
          height: 180,
          blockColor: const Color(0xffb6b0dd),
          position: const Offset(330, 0),
          openings: [
            const Offset(0, 0.01).opening,
            const Offset(30, 0).opening
          ],
        ),
        Block(
          blockLabel: 'Toilet 1',
          width: 200,
          height: 70,
          position: const Offset(330, 180),
          openings: [const Offset(30, 70).opening],
        ),
        Block(
          blockLabel: 'Corridor',
          height: 330,
          width: 60,
          blockColor: const Color(0xffb6bdcc),
          position: const Offset(270, 200),
          hideFenceBorder: HideFenceBorder.bottom,
          openings: [
            const Offset(0, 280).opening,
            const Offset(0, 100).opening,
            const Offset(60, 130).opening,
          ],
        ),
        Block(
          blockLabel: 'Master\'s toilet',
          width: 200,
          height: 80,
          position: const Offset(330, 250),
          openings: [const Offset(30, 0).opening],
        ),
        Block(
          blockLabel: 'Master\'s bedroom',
          height: 200,
          width: 200,
          position: const Offset(330, 330),
          blockColor: const Color(0xffb6b0dd),
          openings: [
            const Offset(0, 130).opening,
            const Offset(30, 200).opening,
          ],
        ),
        Block(
          blockLabel: 'Kitchen',
          height: 120,
          width: 190,
          position: const Offset(80, 200),
          blockColor: const Color(0xff88cd83),
          openings: [
            const Offset(190, 70).opening,
          ],
        ),
        Block(
          blockLabel: 'Toilet 2',
          width: 190,
          height: 60,
          position: const Offset(80, 320),
          openings: [const Offset(140, 0).opening],
        ),
        Block(
          blockLabel: 'Bedroom 2',
          width: 190,
          height: 150,
          blockColor: const Color(0xffb6b0dd),
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
