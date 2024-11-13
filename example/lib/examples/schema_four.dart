import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:schematics/schematics.dart';

class SchemaFour extends StatelessWidget {
  const SchemaFour({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final largeRoomHeight = constraints.maxHeight * 0.200;
      final mediumRoomHeight = constraints.maxHeight * 0.09;
      return SchemaWidget(
        layoutDirection: LayoutDirection.bottomRight,
        showBlocks: showBlockAreas.value,
        showGrid: showGridCells.value,
        schemaSize: (cellSize: kDefaultSchemaSize.cellSize, openingRadius: 52),
        blocks: [
          Block(
            width: constraints.maxWidth,
            height: largeRoomHeight,
            hideFenceBorder: HideFenceBorder.right,
            entranceLabel: 'ENTRANCE',
            blockLabel: 'Exhibition Room',
            blockColor: const Color(0xffb6b0dd),
            openings: [
              Offset(constraints.maxWidth * 0.15, 0).opening,
              Offset(constraints.maxWidth * 0.8, 0).opening,
            ],
          ),
          Block(
            width: constraints.maxWidth,
            height: largeRoomHeight,
            hideFenceBorder: HideFenceBorder.right,
            entranceLabel: 'ENTRANCE',
            blockLabel: 'Room 1',
            blockColor: const Color(0xffffd3bf),
            entranceOpeningRadius: 90,
            openings: [
              Offset(constraints.maxWidth * 0.8, largeRoomHeight).opening,
              Offset(constraints.maxWidth * 0.15, largeRoomHeight).opening,
              Offset(constraints.maxWidth * 0.8, 0).opening,
            ],
          ),
          Block(
            width: constraints.maxWidth,
            height: largeRoomHeight,
            hideFenceBorder: HideFenceBorder.right,
            entranceLabel: 'Exit',
            blockLabel: 'Room 2',
            blockColor: const Color(0xff88cd83),
            openings: [
              Offset(constraints.maxWidth * 0.8, largeRoomHeight).opening,
              Offset(constraints.maxWidth * 0.74, 0)
                  .oSize(constraints.maxWidth * 0.082),
            ],
          ),
          Block(
            width: constraints.maxWidth * 0.082,
            height: constraints.maxHeight * 0.293,
            hideFenceBorder: HideFenceBorder.all,
            blockLabel: 'HALLWAY',
            blockColor: const Color(0xffd9d0c3),
            position: Offset(constraints.maxWidth * 0.245, largeRoomHeight * 3),
          ),
          Block(
            width: constraints.maxWidth * 0.190,
            height: constraints.maxHeight * 0.14,
            hideFenceBorder: HideFenceBorder.all,
            blockLabel: 'Toilet',
            blockColor: const Color(0xffbee673),
            alignmentToPreviousBlock: BlockAlignment.centerRight.alignVCenter,
          ),
          Block(
            width: constraints.maxWidth * 0.638,
            height: mediumRoomHeight,
            hideFenceBorder: HideFenceBorder.all,
            blockLabel: 'STAIRWAY',
            blockColor: const Color(0xffd9d9d9),
            position: Offset(
              constraints.maxWidth * 0.245 + constraints.maxWidth * 0.082,
              largeRoomHeight * 3 +
                  constraints.maxHeight * 0.293 -
                  constraints.maxHeight * 0.09,
            ),
          ),
          Block(
            width: constraints.maxWidth * 0.344,
            height: mediumRoomHeight,
            hideFenceBorder: HideFenceBorder.all,
            blockLabel: 'Room 3',
            blockColor: const Color(0xffbee673),
            alignmentToPreviousBlock: BlockAlignment.topLeft.alignTop,
          ),
          Block(
            width: constraints.maxWidth * 0.344,
            height: mediumRoomHeight,
            hideFenceBorder: HideFenceBorder.all,
            blockLabel: 'Room 4',
            blockColor: const Color(0xffbbddc9),
            position: Offset(
              constraints.maxWidth * 0.245 +
                  constraints.maxWidth * 0.082 +
                  constraints.maxWidth * 0.294,
              largeRoomHeight * 3 + constraints.maxHeight * 0.115,
            ),
          ),
        ],
      );
    });
  }
}
