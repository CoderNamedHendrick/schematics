import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:schematics/schematics.dart';

class SchemaThree extends StatelessWidget {
  const SchemaThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SchemaWidget(
      showBlocks: showBlockAreas.value,
      showGrid: showGridCells.value,
      onInitiateAxesScale: (constraints) => (
      xScale: constraints.maxWidth * 0.00148,
      yScale: constraints.maxHeight * 0.001885,
      openingScale: constraints.maxWidth * 0.00148
      ),
      blocks: [
        const Block(
          blockLabel: 'First block',
          width: 400,
          position: Offset(100, 300),
        ),
        const Block(
          blockLabel: 'Second block',
          height: 200,
          alignmentToPreviousBlock: BlockAlignment.topRight,
        ),
        Block(
          blockLabel: 'Third block',
          alignmentToPreviousBlock: BlockAlignment.centerLeft.alignRight,
        ),
        Block(
          blockLabel: 'Fourth block',
          alignmentToPreviousBlock: BlockAlignment.topLeft.alignRight,
        ),
      ],
    );
  }
}
