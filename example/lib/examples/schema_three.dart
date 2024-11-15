import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:schematics/schematics.dart';

class SchemaThree extends StatelessWidget {
  const SchemaThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SchemaWidget(
      config: SchemaConfig(
        showBlocks: showBlockAreas.value,
        showGrid: showGridCells.value,
        initiateAxesScale: (constraints) => AxesScale(
          x: constraints.maxWidth * 0.00148,
          y: constraints.maxHeight * 0.001885,
          opening: constraints.maxWidth * 0.00148,
        ),
      ),
      blocks: [
        const Block(
          label: 'First block',
          width: 400,
          position: Offset(100, 300),
        ),
        const Block(
          label: 'Second block',
          height: 200,
          alignmentToPreviousBlock: BlockAlignment.topRight,
        ),
        Block(
          label: 'Third block',
          alignmentToPreviousBlock: BlockAlignment.centerLeft.alignRight,
        ),
        Block(
          label: 'Fourth block',
          alignmentToPreviousBlock: BlockAlignment.topLeft.alignRight,
        ),
      ],
    );
  }
}
