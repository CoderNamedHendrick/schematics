import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schematics/src/schema/config.dart';

import '../block/block.dart';
import '../grid/grid.dart';

part 'layout.dart';

part 'painter.dart';

part 'block_painter.dart';

/// Callback function type for block layout.
typedef BlockLayoutCallback = void Function(List<BlockArea> areas);

/// Callback function type for grid updates.
typedef GridCallback = void Function(Grid<int> grid);

/// A widget that displays a schema with blocks
/// A widget that displays a schema with blocks.
///
/// This widget is responsible for rendering the blocks passed to it. It also allows
/// the client to set the axes scales, the size of the schema, and various other parameters.
class SchemaWidget extends StatelessWidget {
  /// Creates a [SchemaWidget].
  ///
  /// - [config]: Configuration for the schema. Defaults to [SchemaConfig].
  /// - [blocks]: The list of blocks to display in the schema.
  /// - [onBlocksLayout]: Callback for when the blocks are laid out.
  /// - [onGridUpdate]: Callback for when the grid is updated.
  /// - [onInitiateAxesScale]: Callback for initiating the axes scale. Defaults to [_kDefaultAxesScaleCallback].
  const SchemaWidget({
    super.key,
    this.config = const SchemaConfig(),
    required this.blocks,
    this.onBlocksLayout,
    this.onGridUpdate,
  });

  /// Configuration for the schema.
  final SchemaConfig config;

  /// The list of blocks to display in the schema.
  final List<Block> blocks;

  /// Callback for when the blocks are laid out.
  final BlockLayoutCallback? onBlocksLayout;

  /// Callback for when the grid is updated.
  final GridCallback? onGridUpdate;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return _SchemaWidget(
          blocks: blocks,
          schemaSize: config.size,
          axesScale: config.initiateAxesScale(constraints),
          layoutConstraints: constraints,
          onBlocksLayout: onBlocksLayout,
          onGridUpdate: onGridUpdate,
          showGrid: config.showGrid,
          showBlocks: config.showBlocks,
          layoutDirection: config.layoutDirection,
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
    widget.layoutConstraints.maxHeight ~/ alignedSchemaSize.cell,
    widget.layoutConstraints.maxWidth ~/ alignedSchemaSize.cell,
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
        widget.layoutConstraints.maxHeight ~/ alignedSchemaSize.cell,
        widget.layoutConstraints.maxWidth ~/ alignedSchemaSize.cell,
        0,
      );
      alignedBlocks = widget.blocks
          .map((block) => block.alignedBlock(widget.axesScale))
          .toList();
      alignedSchemaSize = widget.schemaSize.alignedSchema(widget.axesScale);
      return;
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
      foregroundPainter: _GridPainter(
        grid: grid,
        cellSize: alignedSchemaSize.cell,
        showBlocks: widget.showBlocks,
        showGrid: widget.showGrid,
      ),
      child: CustomMultiChildLayout(
        delegate: _SchemaLayoutDelegate(
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
              painter: _SchemaBlockPainter(
                block: alignedBlocks[i],
                schemaSize: alignedSchemaSize,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Fills the grid with the block layout area.
  ///
  /// This function updates the grid with the block layout area provided. It calculates
  /// the grid cells that the block occupies and updates the grid state accordingly.
  void _fillBlock(BlockArea area) {
    final cellSize = alignedSchemaSize.cell;
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
          if (area.fenceBorder != HideFenceBorder.all) {
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

  /// Converts a [Color] to a cell state represented by an integer.
  /// The cell state is derived from the hue of the color, adjusted by -20.
  /// If the adjusted hue is less than 20, it wraps around to the range [340, 360).
  ///
  /// - Parameter color: The [Color] to convert.
  /// - Returns: An integer representing the cell state.
  int _getCellStateFromColor(Color color) {
    int bHue = HSLColor.fromColor(color).hue.toInt() - 20;
    if (bHue < 20) {
      bHue = 360 - bHue.abs();
    }

    return bHue;
  }
}

extension on SchemaSize {
  /// Aligns the [SchemaSize] based on the provided [AxesScale].
  ///
  /// This function adjusts the `cellSize` and `openingRadius` of the [SchemaSize]
  /// according to the scaling factors defined in the [AxesScale].
  ///
  /// - Parameter axesScale: The scaling factors for the x, y, and opening dimensions.
  /// - Returns: A new [SchemaSize] with the adjusted `cellSize` and `openingRadius`.
  SchemaSize alignedSchema(AxesScale axesScale) {
    return SchemaSize(
      cell: cell,
      opening: axesScale.opening * opening,
    );
  }
}

extension on Block {
  /// Aligns the [Block] based on the provided [AxesScale].
  ///
  /// This function adjusts the dimensions, position, and openings of the [Block]
  /// according to the scaling factors defined in the [AxesScale].
  ///
  /// - Parameter axesScale: The scaling factors for the x, y, and opening dimensions.
  /// - Returns: A new [Block] with the adjusted dimensions, position, and openings.
  Block alignedBlock(AxesScale axesScale) {
    return Block(
      identifier: identifier,
      label: label,
      width: width * axesScale.x,
      height: height * axesScale.y,
      fenceBorder: fenceBorder,
      labelStyle: labelStyle,
      color: color,
      position: position != null
          ? Offset(position!.dx * axesScale.x, position!.dy * axesScale.y)
          : null,
      openings: openings.alignedOpenings(axesScale),
      arcOpenings: arcOpenings
          .map((arcOpening) => arcOpening.alignedArcOpening(axesScale))
          .toList(),
      alignmentToPreviousBlock: alignmentToPreviousBlock,
    );
  }
}

extension on List<BlockOpening> {
  /// Aligns the list of [BlockOpening]s based on the provided [AxesScale].
  ///
  /// This function adjusts each [BlockOpening] in the list according to the scaling
  /// factors defined in the [AxesScale].
  ///
  /// - Parameter axesScale: The scaling factors for the x, y, and opening dimensions.
  /// - Returns: A new list of [BlockOpening]s with the adjusted offset and opening size.
  List<BlockOpening> alignedOpenings(AxesScale axesScale) {
    return map((opening) => opening.alignedOpening(axesScale)).toList();
  }
}

extension on BlockOpening {
  /// Aligns the [BlockOpening] based on the provided [AxesScale].
  ///
  /// This function adjusts the offset and opening size of the [BlockOpening]
  /// according to the scaling factors defined in the [AxesScale].
  ///
  /// - Parameter axesScale: The scaling factors for the x, y, and opening dimensions.
  /// - Returns: A new [BlockOpening] with the adjusted offset and opening size.
  BlockOpening alignedOpening(AxesScale axesScale) {
    return (
      offset: Offset(offset.dx * axesScale.x, offset.dy * axesScale.y),
      openingSize:
          openingSize != null ? openingSize! * axesScale.opening : null,
    );
  }
}

extension on BlockArcOpening {
  /// Aligns the [BlockArcOpening] based on the provided [AxesScale].
  ///
  /// This function adjusts the offset and radius of the [BlockArcOpening]
  /// according to the scaling factors defined in the [AxesScale].
  ///
  /// - Parameter axesScale: The scaling factors for the x, y, and opening dimensions.
  /// - Returns: A new [BlockArcOpening] with the adjusted offset and radius.
  BlockArcOpening alignedArcOpening(AxesScale axesScale) {
    return BlockArcOpening(
      offset: Offset(offset.dx * axesScale.x, offset.dy * axesScale.y),
      radius: radius != null ? radius! * axesScale.opening : null,
      isFullOpening: isFullOpening,
      label: label,
      labelStyle: labelStyle,
      labelAlign: labelAlign,
    );
  }
}
