import 'dart:ui';

import 'entity.dart';

typedef SchemaSize = ({double cellSize, double openingRadius});

typedef AxesScale = ({double xScale, double yScale, double openingScale});

const _kOpeningRadius = 32.0;
const _kCellSize = 8.0;

const kDefaultSchemaSize =
    (cellSize: _kCellSize, openingRadius: _kOpeningRadius);
const kDefaultAxesScale = (xScale: 1.0, yScale: 1.0, openingScale: 1.0);

enum HideFenceBorder {
  none,
  top,
  right,
  bottom,
  left,
  all;
}

extension BlockLayouts on List<BlockLayoutArea> {
  BlockLayoutArea getLayoutForIdentifier(String identifier) {
    return firstWhere((layout) => layout.identifier == identifier);
  }

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

extension BlockOffsetUtilsX on Offset {
  BlockOpening get opening => (offset: this, openingSize: null);

  BlockOpening oSize(double space) => (offset: this, openingSize: space);
}
