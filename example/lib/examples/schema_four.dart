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
      return Schema(
        config: SchemaConfiguration(
          layoutDirection: LayoutDirection.bottomRight,
          showBlocks: showBlockAreas.value,
          showGrid: showGridCells.value,
          size: SchemaSize(cell: kDefaultSchemaSize.cell, opening: 52),
        ),
        blocks: [
          Block(
            width: constraints.maxWidth,
            height: largeRoomHeight,
            fenceBorder: HideFenceBorder.right,
            label: 'Exhibition Room',
            color: const Color(0xffb6b0dd),
            openings: [
              Offset(constraints.maxWidth * 0.15, 0).opening,
              Offset(constraints.maxWidth * 0.8, 0).opening,
            ],
            arcOpenings: [
              Offset(constraints.maxWidth, largeRoomHeight / 2 + 45)
                  .arcSize(45)
                  .withLabel('ENTRANCE'),
            ],
          ),
          Block(
            width: constraints.maxWidth,
            height: largeRoomHeight,
            fenceBorder: HideFenceBorder.right,
            label: 'Room 1',
            color: const Color(0xffffd3bf),
            fenceStrokeWidth: 15,
            openings: [
              Offset(constraints.maxWidth * 0.8, largeRoomHeight).opening,
              Offset(constraints.maxWidth * 0.15, largeRoomHeight).opening,
              Offset(constraints.maxWidth * 0.8, 0).opening,
            ],
            arcOpenings: [
              Offset(constraints.maxWidth, largeRoomHeight / 2 + 45)
                  .arcSize(45)
                  .withLabel('ENTRANCE'),
            ],
          ),
          Block(
            width: constraints.maxWidth,
            height: largeRoomHeight,
            fenceBorder: HideFenceBorder.right,
            label: 'Room 2',
            color: const Color(0xff88cd83),
            openings: [
              Offset(constraints.maxWidth * 0.8, largeRoomHeight).opening,
              Offset(constraints.maxWidth * 0.673, 0)
                  .oSize(constraints.maxWidth * 0.082),
            ],
            arcOpenings: [
              Offset(constraints.maxWidth, largeRoomHeight / 2 + 52 / 2)
                  .arcOpening
                  .withFullOpening(false)
                  .withLabel('Exit'),
            ],
          ),
          Block(
            width: constraints.maxWidth * 0.082,
            height: constraints.maxHeight * 0.293,
            fenceBorder: HideFenceBorder.all,
            label: 'HALLWAY',
            color: const Color(0xffd9d0c3),
            position: Offset(constraints.maxWidth * 0.245, largeRoomHeight * 3),
          ),
          Block(
            width: constraints.maxWidth * 0.190,
            height: constraints.maxHeight * 0.14,
            fenceBorder: HideFenceBorder.all,
            label: 'Toilet',
            color: const Color(0xffbee673),
            alignmentToPreviousBlock: BlockAlignment.centerRight.alignVCenter,
          ),
          Block(
            width: constraints.maxWidth * 0.638,
            height: mediumRoomHeight,
            fenceBorder: HideFenceBorder.all,
            label: 'STAIRWAY',
            color: const Color(0xffd9d9d9),
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
            fenceBorder: HideFenceBorder.all,
            label: 'Room 3',
            color: const Color(0xffbee673),
            alignmentToPreviousBlock: BlockAlignment.topLeft.alignTop,
          ),
          Block(
            width: constraints.maxWidth * 0.344,
            height: mediumRoomHeight,
            fenceBorder: HideFenceBorder.all,
            label: 'Room 4',
            color: const Color(0xffbbddc9),
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
