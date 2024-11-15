import 'package:flutter/material.dart';

import '../block/block.dart';
import 'widget.dart';

/// Callback function type for initiating axes scale.
typedef InitiateAxesScaleCallback = AxesScale Function(
    BoxConstraints blockAreaConstraints);

AxesScale _kDefaultAxesScaleCallback([_]) => kDefaultAxesScale;

/// Configuration class for the schema.
///
/// This class holds various configuration options for the schema, such as
/// the size of the schema, whether to show the grid and blocks, and the
/// layout direction.
final class SchemaConfig {
  /// The size of the schema.
  final SchemaSize size;

  /// Whether to show the grid.
  final bool showGrid;

  /// Whether to show the blocks.
  final bool showBlocks;

  /// The direction of the layout.
  final LayoutDirection layoutDirection;

  /// Callback for initiating the axes scale.
  final InitiateAxesScaleCallback initiateAxesScale;

  /// Creates a new `SchemaConfig` instance.
  ///
  /// The [size] parameter specifies the size of the schema.
  /// The [showGrid] parameter specifies whether to show the grid.
  /// The [showBlocks] parameter specifies whether to show the blocks.
  /// The [layoutDirection] parameter specifies the direction of the layout.
  const SchemaConfig({
    this.size = kDefaultSchemaSize,
    this.showGrid = false,
    this.showBlocks = false,
    this.layoutDirection = LayoutDirection.bottomLeft,
    this.initiateAxesScale = _kDefaultAxesScaleCallback,
  });

  @override
  int get hashCode => Object.hash(size, showGrid, showBlocks, layoutDirection);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemaConfig &&
        other.size == size &&
        other.showGrid == showGrid &&
        other.showBlocks == showBlocks &&
        other.layoutDirection == layoutDirection;
  }
}
