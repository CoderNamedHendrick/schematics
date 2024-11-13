part of 'widget.dart';

/// Represents the layout direction of the schematic.
enum LayoutDirection {
  bottomLeft,
  topLeft,
  bottomRight,
  topRight,
}

/// A delegate for laying out blocks within a schema.
class _SchemaLayoutDelegate extends MultiChildLayoutDelegate {
  /// The list of blocks to be laid out.
  final List<Block> blocks;

  /// Callback that is called when the blocks are laid out.
  final ValueChanged<List<BlockLayoutArea>>? onBlocksLayout;

  /// The direction in which the layout should be performed.
  final LayoutDirection layoutDirection;

  /// The size of the schema.
  final SchemaSize schemaSize;

  /// Creates a new instance of [_SchemaLayoutDelegate].
  ///
  /// The [blocks] parameter specifies the list of blocks to be laid out.
  /// The [onBlocksLayout] parameter is a callback that is called when the blocks are laid out.
  /// The [layoutDirection] parameter specifies the direction in which the layout should be performed.
  /// The [schemaSize] parameter specifies the size of the schema.
  _SchemaLayoutDelegate({
    this.blocks = const [],
    this.onBlocksLayout,
    this.layoutDirection = LayoutDirection.bottomLeft,
    required this.schemaSize,
  });

  /// Sums the heights of the blocks up to the specified [index].
  double _sumBlocHeightsToIndex(int index) {
    double sum = 0;
    for (int i = 0; i < index; i++) {
      sum += blocks[i].height;
    }
    return sum;
  }

  @override
  void performLayout(Size size) {
    final blockLayouts = <BlockLayoutArea>[];
    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final childId = i;
      final childSize = Size(block.width, block.height);
      final currentSize = layoutChild(childId, BoxConstraints.tight(childSize));

      final xOffset = () {
        final usePreviousBlockAlignment = block.position == null &&
            blockLayouts.lastOrNull != null &&
            block.alignmentToPreviousBlock != null;
        if (usePreviousBlockAlignment) {
          final lastBlock = blockLayouts.last;

          final middleOffset =
              (lastBlock.end.dx - lastBlock.start.dx).abs() / 2;
          final zeroOrigin =
              switch (block.alignmentToPreviousBlock!.xEdgeAlignment) {
            XEdgeAlignment.left => (lastBlock.start.dx + middleOffset),
            XEdgeAlignment.right =>
              (lastBlock.start.dx + middleOffset - currentSize.width),
            XEdgeAlignment.center =>
              (lastBlock.start.dx + middleOffset - (currentSize.width / 2)),
          };

          return zeroOrigin +
              (middleOffset * block.alignmentToPreviousBlock!.x);
        }

        if (block.position == null) {
          return switch (layoutDirection) {
            LayoutDirection.bottomLeft || LayoutDirection.topLeft => 0.0,
            LayoutDirection.bottomRight ||
            LayoutDirection.topRight =>
              size.width - currentSize.width,
          };
        }

        return switch (layoutDirection) {
          LayoutDirection.bottomLeft ||
          LayoutDirection.topLeft =>
            block.position!.dx,
          LayoutDirection.bottomRight ||
          LayoutDirection.topRight =>
            size.width - currentSize.width - block.position!.dx,
        };
      }();
      final yOffset = () {
        final useBlockAlignment = block.position == null &&
            blockLayouts.lastOrNull != null &&
            block.alignmentToPreviousBlock != null;

        if (useBlockAlignment) {
          final lastBlock = blockLayouts.last;

          final middleOffset =
              (lastBlock.end.dy - lastBlock.start.dy).abs() / 2;
          final zeroOrigin =
              switch (block.alignmentToPreviousBlock!.yEdgeAlignment) {
            YEdgeAlignment.top =>
              (lastBlock.start.dy + middleOffset - currentSize.height),
            YEdgeAlignment.bottom => (lastBlock.start.dy + middleOffset),
            YEdgeAlignment.center =>
              (lastBlock.start.dy + middleOffset - (currentSize.height / 2)),
          };

          return zeroOrigin +
              (middleOffset * block.alignmentToPreviousBlock!.y);
        }

        if (block.position == null && blockLayouts.lastOrNull != null) {
          return switch (layoutDirection) {
            LayoutDirection.bottomLeft ||
            LayoutDirection.bottomRight =>
              blockLayouts.last.start.dy - currentSize.height,
            LayoutDirection.topLeft ||
            LayoutDirection.topRight =>
              blockLayouts.last.end.dy,
          };
        }

        if (block.position == null) {
          return switch (layoutDirection) {
            LayoutDirection.bottomLeft ||
            LayoutDirection.bottomRight =>
              size.height - currentSize.height - _sumBlocHeightsToIndex(i),
            LayoutDirection.topLeft || LayoutDirection.topRight => 0.0,
          };
        }

        return switch (layoutDirection) {
          LayoutDirection.bottomLeft ||
          LayoutDirection.bottomRight =>
            size.height - currentSize.height - block.position!.dy,
          LayoutDirection.topLeft ||
          LayoutDirection.topRight =>
            block.position!.dy,
        };
      }();

      final childOffset = Offset(xOffset, yOffset);

      blockLayouts.add(
        (
          identifier: () {
            if (block.identifier != null) return block.identifier!;

            if (block.blockLabel != null) return block.blockLabel!;

            throw AssertionError(
                'Ensure block identifier or block label is passed for block');
          }(),
          start: childOffset,
          end: Offset(childOffset.dx + currentSize.width,
              childOffset.dy + currentSize.height),
          hideFenceBorder: block.hideFenceBorder,
          blockColor: block.blockColor,
          openings: block.effectiveOpenings
              .asMap()
              .map((index, openingPosition) {
                final startX = childOffset.dx + openingPosition.offset.dx;
                final startY = childOffset.dy + openingPosition.offset.dy;

                final openingSize =
                    openingPosition.openingSize ?? schemaSize.openingRadius;
                late Offset start;
                late Offset end;

                final blockStartFromEnd =
                    (block.entranceLabel?.isNotEmpty ?? false) ? 25.0 : 0.0;
                // if is at left edge
                if (openingPosition.offset.dx == 0) {
                  start = Offset(startX, startY);
                  end = Offset(startX, startY + openingSize);
                } // if is at right edge
                else if (openingPosition.offset.dx - blockStartFromEnd ==
                    block.width) {
                  start = Offset(startX, startY);
                  end = Offset(startX, startY + openingSize);
                } // if is at top edge
                else if (openingPosition.offset.dy == 0) {
                  start = Offset(startX - blockStartFromEnd, startY);
                  end =
                      Offset(startX + openingSize - blockStartFromEnd, startY);
                } // if is at bottom edge
                else {
                  start = Offset(
                      startX - blockStartFromEnd, startY - schemaSize.cellSize);
                  end = Offset(startX + openingSize - blockStartFromEnd,
                      startY - schemaSize.cellSize);
                }

                return MapEntry(index, (start: start, end: end));
              })
              .values
              .toList(),
        ),
      );

      positionChild(childId, childOffset);
    }

    onBlocksLayout?.call(blockLayouts);
  }

  @override
  bool shouldRelayout(_SchemaLayoutDelegate oldDelegate) {
    if (oldDelegate.layoutDirection != layoutDirection) return true;
    if (oldDelegate.schemaSize != schemaSize) return true;
    return !listEquals(oldDelegate.blocks, blocks);
  }
}
