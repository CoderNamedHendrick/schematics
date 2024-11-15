import 'package:flutter/material.dart';

import 'entity.dart';

const _kOpeningRadius = 32.0;
const _kCellSize = 8.0;

const kDefaultSchemaSize = SchemaSize();
const kDefaultAxesScale = AxesScale();

/// Represents the size of a schema with cell size and opening radius.
final class SchemaSize {
  /// The size of each cell in the grid.
  final double cell;

  /// The radius of the opening.
  final double opening;

  const SchemaSize({this.cell = _kCellSize, this.opening = _kOpeningRadius});

  @override
  int get hashCode => Object.hash(cell, opening);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemaSize &&
        other.cell == cell &&
        other.opening == opening;
  }
}

/// Represents the scale of axes with x, y, and opening scales.
final class AxesScale {
  /// The scale of the x-axis.
  final double x;

  /// The scale of the y-axis.
  final double y;

  /// The scale of the opening.
  /// The opening scale is used to adjust the size of the opening in the block.
  /// Opening is advised to be same scale as the x-axis.
  final double opening;

  const AxesScale({
    this.x = 1.0,
    this.y = 1.0,
    this.opening = 1.0,
  });

  @override
  int get hashCode => Object.hash(x, y, opening);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AxesScale &&
        other.x == x &&
        other.y == y &&
        other.opening == opening;
  }
}

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
extension BlockLayouts on List<BlockArea> {
  /// Gets the layout for a given identifier.
  BlockArea getLayoutForIdentifier(identifier) {
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

  BlockArcOpening get arcOpening => BlockArcOpening(
        offset: this,
        radius: null,
        isFullOpening: true,
        label: null,
        labelStyle: null,
        labelAlign: null,
      );

  BlockArcOpening arcSize(double radius) => BlockArcOpening(
        offset: this,
        radius: radius,
        isFullOpening: true,
        label: null,
        labelStyle: null,
        labelAlign: null,
      );
}

extension BlockArcUtilsX on BlockArcOpening {
  BlockArcOpening withLabel(String labelText,
          {TextStyle? style, TextAlign? textAlign}) =>
      BlockArcOpening(
        offset: offset,
        radius: radius,
        isFullOpening: isFullOpening,
        label: labelText,
        labelStyle: style,
        labelAlign: textAlign,
      );

  BlockArcOpening withRadius(double arcRadius) => BlockArcOpening(
        offset: offset,
        radius: arcRadius,
        isFullOpening: isFullOpening,
        label: label,
        labelStyle: labelStyle,
        labelAlign: labelAlign,
      );

  BlockArcOpening withFullOpening(bool isFullOpening) => BlockArcOpening(
        offset: offset,
        radius: radius,
        isFullOpening: isFullOpening,
        label: label,
        labelStyle: labelStyle,
        labelAlign: labelAlign,
      );
}
