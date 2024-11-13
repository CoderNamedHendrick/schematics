import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../block/block.dart';
import '../grid/grid.dart';
import 'block_painter.dart';
import 'layout.dart';

typedef BlockLayoutCallback = void Function(List<BlockLayoutArea> areas);
typedef GridCallback = void Function(Grid<int> grid);

typedef InitiateAxesScaleCallback = AxesScale Function(
    BoxConstraints blockAreaConstraints);

AxesScale _kDefaultAxesScaleCallback([_]) => kDefaultAxesScale;

class SchemaWidget extends StatelessWidget {
  const SchemaWidget({
    super.key,
    required this.blocks,
    this.schemaSize = kDefaultSchemaSize,
    this.onBlocksLayout,
    this.onGridUpdate,
    this.showGrid = false,
    this.showBlocks = false,
    this.layoutDirection = LayoutDirection.bottomLeft,
    this.onInitiateAxesScale = _kDefaultAxesScaleCallback,
  });

  final List<Block> blocks;
  final SchemaSize schemaSize;
  final BlockLayoutCallback? onBlocksLayout;
  final GridCallback? onGridUpdate;
  final bool showGrid;
  final bool showBlocks;
  final LayoutDirection layoutDirection;
  final InitiateAxesScaleCallback onInitiateAxesScale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _SchemaWidget(
          blocks: blocks,
          schemaSize: schemaSize,
          axesScale: onInitiateAxesScale(constraints),
          layoutConstraints: constraints,
          onBlocksLayout: onBlocksLayout,
          onGridUpdate: onGridUpdate,
          showGrid: showGrid,
          showBlocks: showBlocks,
          layoutDirection: layoutDirection,
        );
      },
    );
  }
}

class _SchemaWidget extends StatefulWidget {
  const _SchemaWidget({
    required this.blocks,
    required this.schemaSize,
    required this.layoutConstraints,
    required this.onBlocksLayout,
    required this.onGridUpdate,
    required this.showGrid,
    required this.showBlocks,
    required this.layoutDirection,
    required this.axesScale,
  });

  final List<Block> blocks;
  final SchemaSize schemaSize;
  final BoxConstraints layoutConstraints;
  final BlockLayoutCallback? onBlocksLayout;
  final GridCallback? onGridUpdate;
  final bool showGrid;
  final bool showBlocks;
  final LayoutDirection layoutDirection;
  final AxesScale axesScale;

  @override
  State<_SchemaWidget> createState() => _SchemaWidgetState();
}

class _SchemaWidgetState extends State<_SchemaWidget> {
  late List<Block> alignedBlocks;
  late SchemaSize alignedSchemaSize;
  late Grid<int> grid = Grid.make(
    widget.layoutConstraints.maxHeight ~/ alignedSchemaSize.cellSize,
    widget.layoutConstraints.maxWidth ~/ alignedSchemaSize.cellSize,
    0,
  );

  @override
  void initState() {
    super.initState();
    alignedBlocks = widget.blocks
        .map((block) => block.alignedBlock(widget.axesScale))
        .toList();
    alignedSchemaSize = widget.schemaSize.alignedSchema(widget.axesScale);
  }

  @override
  void didUpdateWidget(covariant _SchemaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.layoutConstraints != oldWidget.layoutConstraints) {
      grid = Grid.make(
        widget.layoutConstraints.maxHeight ~/ alignedSchemaSize.cellSize,
        widget.layoutConstraints.maxWidth ~/ alignedSchemaSize.cellSize,
        0,
      );
      alignedBlocks = widget.blocks
          .map((block) => block.alignedBlock(widget.axesScale))
          .toList();
      alignedSchemaSize = widget.schemaSize.alignedSchema(widget.axesScale);
    }

    if (!listEquals(widget.blocks, oldWidget.blocks)) {
      alignedBlocks = widget.blocks
          .map((block) => block.alignedBlock(widget.axesScale))
          .toList();
    }

    if (widget.schemaSize != oldWidget.schemaSize) {
      alignedSchemaSize = widget.schemaSize.alignedSchema(widget.axesScale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: GridPainter(
        grid: grid,
        cellSize: alignedSchemaSize.cellSize,
        showBlocks: widget.showBlocks,
        showGrid: widget.showGrid,
      ),
      child: CustomMultiChildLayout(
        delegate: SchemaLayoutDelegate(
          blocks: alignedBlocks,
          schemaSize: alignedSchemaSize,
          layoutDirection: widget.layoutDirection,
          onBlocksLayout: (areas) {
            // send a copy of the areas list
            widget.onBlocksLayout?.call(areas.toList());
            WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
              areas.forEach(_fillBlock);
            });
          },
        ),
        children: List.generate(
          alignedBlocks.length,
          (i) => LayoutId(
            id: i,
            child: CustomPaint(
              painter: SchemaBlockPainter(
                block: alignedBlocks[i],
                schemaSize: alignedSchemaSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _fillBlock(BlockLayoutArea area) {
    final cellSize = alignedSchemaSize.cellSize;
    Grid<int> newGrid = Grid.make(
        widget.layoutConstraints.maxHeight ~/ cellSize,
        widget.layoutConstraints.maxWidth ~/ cellSize,
        0);

    newGrid = newGrid.copyWith(grid: grid.grid.toList());

    final startTouchColumn = (area.start.dx / cellSize).floor();
    final endTouchColumn = (area.end.dx / cellSize).floor();
    final startTouchRow = (area.start.dy / cellSize).floor();
    final endTouchRow = (area.end.dy / cellSize).floor();

    for (int i = startTouchRow; i < endTouchRow; i++) {
      for (int j = startTouchColumn; j < endTouchColumn; j++) {
        final leftEdge = j == startTouchColumn;
        final rightEdge = j == endTouchColumn;
        final topEdge = i == startTouchRow;
        final bottomEdge = i == endTouchRow - 1;

        // deal with edges
        if (leftEdge || rightEdge || topEdge || bottomEdge) {
          if (area.hideFenceBorder != HideFenceBorder.all) {
            final openingsGridPoints = area.openings.map((opening) {
              final startTouchColumn = (opening.start.dx / cellSize).floor();
              final endTouchColumn = (opening.end.dx / cellSize).floor();
              final startTouchRow = (opening.start.dy / cellSize).floor();
              final endTouchRow = (opening.end.dy / cellSize).floor();

              return (
                startGridColumn: startTouchColumn,
                endGridColumn: endTouchColumn,
                startGridRow: startTouchRow,
                endGridRow: endTouchRow,
              );
            });

            for (final gridPoint in openingsGridPoints) {
              final isWithinColumnRange = j >= gridPoint.startGridColumn &&
                  j <= gridPoint.endGridColumn;
              final isWithinRowRange =
                  i >= gridPoint.startGridRow && i <= gridPoint.endGridRow;

              // try block to silent fuzzy errors that come from resizing the
              // window
              try {
                if (isWithinColumnRange && isWithinRowRange) {
                  newGrid.grid[i][j] = _getCellStateFromColor(area.blockColor);
                  continue;
                }
              } catch (_) {}
            }

            continue;
          }
        }

        newGrid.grid[i][j] = _getCellStateFromColor(area.blockColor);
      }
    }

    setState(() {
      grid = newGrid;
    });
    widget.onGridUpdate?.call(grid);
  }

  int _getCellStateFromColor(Color color) {
    int bHue = HSLColor.fromColor(color).hue.toInt() - 20;
    if (bHue < 20) {
      bHue = 360 - bHue.abs();
    }

    return bHue;
  }
}

extension on SchemaSize {
  SchemaSize alignedSchema(AxesScale axesScale) {
    return (
      cellSize: cellSize,
      openingRadius: axesScale.openingScale * openingRadius,
    );
  }
}

extension on Block {
  Block alignedBlock(AxesScale axesScale) {
    return Block(
      blockLabel: blockLabel,
      width: width * axesScale.xScale,
      height: height * axesScale.yScale,
      hideFenceBorder: hideFenceBorder,
      entranceLabel: entranceLabel,
      entranceLabelStyle: entranceLabelStyle,
      blockLabelStyle: blockLabelStyle,
      blockColor: blockColor,
      position: position != null
          ? Offset(
              position!.dx * axesScale.xScale, position!.dy * axesScale.yScale)
          : null,
      openings: openings.alignedOpenings(axesScale),
      alignmentToPreviousBlock: alignmentToPreviousBlock,
    );
  }
}

extension on List<BlockOpening> {
  List<BlockOpening> alignedOpenings(AxesScale axesScale) {
    return map((opening) => opening.alignedOpening(axesScale)).toList();
  }
}

extension on BlockOpening {
  BlockOpening alignedOpening(AxesScale axesScale) {
    return (
      offset:
          Offset(offset.dx * axesScale.xScale, offset.dy * axesScale.yScale),
      openingSize:
          openingSize != null ? openingSize! * axesScale.openingScale : null,
    );
  }
}
