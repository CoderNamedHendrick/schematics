import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:schematics/schematics.dart';

class SchemaTwo extends StatelessWidget {
  const SchemaTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SchemaWidget(
      layoutDirection: LayoutDirection.topLeft,
      schemaSize: (cellSize: kDefaultSchemaSize.cellSize, openingRadius: 25),
      showBlocks: showBlockAreas.value,
      showGrid: showGridCells.value,
      onInitiateAxesScale: (constraints) => (
        xScale: constraints.maxWidth * 0.00249,
        yScale: constraints.maxHeight * 0.002216,
        openingScale: constraints.maxWidth * 0.00249
      ),
      blocks: [
        Block(
          blockLabel: 'Visitor\'s toilet',
          height: 120,
          width: 150,
          position: const Offset(60, 0),
          openings: [const Offset(20, 120).opening],
        ),
        Block(
          blockLabel: 'Veranda',
          height: 120,
          width: 60,
          hideFenceBorder: HideFenceBorder.left,
          alignmentToPreviousBlock: BlockAlignment.topLeft.alignRight,
          openings: [
            const Offset(30, 120).opening,
          ],
        ),
        Block(
          blockLabel: 'Sitting room',
          height: 180,
          width: 250,
          blockColor: const Color(0xffb6b0dd),
          alignmentToPreviousBlock: BlockAlignment.bottomLeft,
          openings: [
            const Offset(30, 0).opening,
            const Offset(80, 0).opening,
            const Offset(120, 180).oSize(50),
            const Offset(250, 120).opening,
          ],
        ),
        Block(
          blockLabel: 'Corridor',
          height: 50,
          width: 140,
          alignmentToPreviousBlock: BlockAlignment.bottomRight.alignRight,
          openings: [
            const Offset(10, 0).oSize(50),
            const Offset(40, 50).opening,
            const Offset(70, 50).opening,
          ],
        ),
        Block(
          blockLabel: 'Room 1 Toilet',
          width: 110,
          height: 50,
          alignmentToPreviousBlock: BlockAlignment.topLeft.alignRight,
          openings: [
            const Offset(60, 50).opening,
          ],
        ),
        Block(
          blockLabel: 'Room 1',
          width: 180,
          alignmentToPreviousBlock: BlockAlignment.bottomLeft,
          blockColor: const Color(0xffb6b0dd),
          openings: [
            const Offset(60, 0).opening,
            const Offset(150, 0).opening,
          ],
        ),
        Block(
          blockLabel: 'Room 2',
          width: 220,
          alignmentToPreviousBlock: BlockAlignment.topRight,
          blockColor: const Color(0xffb6b0dd),
          openings: [
            const Offset(0.001, 0).opening,
            const Offset(70, 0).oSize(150),
          ],
        ),
        Block(
          blockLabel: 'Room 2 annex',
          blockLabelStyle: const TextStyle(fontSize: 0.001),
          width: 150,
          height: 25,
          alignmentToPreviousBlock: const BlockAlignment(-0.365, -1).alignTop,
          blockColor: const Color(0xffb6b0dd),
          hideFenceBorder: HideFenceBorder.bottom,
          openings: [
            const Offset(0.001, 0).opening,
          ],
        ),
        Block(
          blockLabel: 'Room 2 Toilet',
          alignmentToPreviousBlock: BlockAlignment.topLeft.alignTop,
          width: 150,
          height: 65,
          openings: [
            const Offset(0.001, 65).opening,
          ],
        ),
        Block(
          blockLabel: 'Kitchen',
          height: 140,
          width: 150,
          alignmentToPreviousBlock: BlockAlignment.topLeft.alignTop,
          blockColor: const Color(0xffb6b0dd),
          openings: [
            const Offset(0, 120).opening,
          ],
        ),
      ],
    );
  }
}
