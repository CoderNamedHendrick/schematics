import 'dart:ui';

import 'entity.dart';

const _kOpeningRadius = 32.0;
const _kCellSize = 8.0;

const kDefaultSchemaSize =
    (cellSize: _kCellSize, openingRadius: _kOpeningRadius);
const kDefaultAxesScale = (xScale: 1.0, yScale: 1.0, openingScale: 1.0);

/// Represents the size of a schema with cell size and opening radius.
typedef SchemaSize = ({double cellSize, double openingRadius});

/// Represents the scale of axes with x, y, and opening scales.
typedef AxesScale = ({double xScale, double yScale, double openingScale});

/// Enum representing which sides of the block's border should be hidden.
enum HideFenceBorder {
  none,
  top,
  right,
  bottom,
  left,
  all;
}

/// Extension on List<BlockLayoutArea> to provide additional functionality.
extension BlockLayouts on List<BlockLayoutArea> {
  /// Gets the layout for a given identifier.
  BlockLayoutArea getLayoutForIdentifier(identifier) {
    return firstWhere((layout) => layout.identifier == identifier);
  }

  /// Prints the layout information with grid cell positions.
  String printLayout(double cellSize) {
    final buffer = StringBuffer();
    for (final layout in this) {
      buffer.write('Identifier: ${layout.identifier}\t');
      buffer.write('Start: ${layout.start}\t');
      buffer.writeln('End: ${layout.end}');
      buffer.write(
        'Start GridCell(row: ${(layout.start.dy / cellSize).floor()}, column: ${(layout.start.dx / cellSize).floor()})\t',
      );
      buffer.writeln(
        'End GridCell(row: ${(layout.end.dy / cellSize).floor()}, column: ${(layout.end.dx / cellSize).floor()})',
      );
    }
    return buffer.toString();
  }
}

/// Extension on Offset to provide additional functionality for BlockOpening.
extension BlockOffsetUtilsX on Offset {
  /// Converts the offset to a BlockOpening with no size.
  BlockOpening get opening => (offset: this, openingSize: null);

  /// Converts the offset to a BlockOpening with a specified size.
  BlockOpening oSize(double space) => (offset: this, openingSize: space);
}
