import 'dart:ui' as ui;

/// Enum representing the horizontal edge alignment.
enum XEdgeAlignment { left, center, right }

/// Enum representing the vertical edge alignment.
enum YEdgeAlignment { top, center, bottom }

/// Class representing the alignment of a block.
class BlockAlignment {
  /// The x-coordinate of the alignment.
  final double x;

  /// The horizontal edge alignment.
  final XEdgeAlignment xEdgeAlignment;

  /// The y-coordinate of the alignment.
  final double y;

  /// The vertical edge alignment.
  final YEdgeAlignment yEdgeAlignment;

  const BlockAlignment(
    this.x,
    this.y, {
    this.xEdgeAlignment = XEdgeAlignment.left,
    this.yEdgeAlignment = YEdgeAlignment.bottom,
  });

  /// Predefined alignment for the top-left corner.
  static const topLeft = BlockAlignment(-1, -1);

  /// Predefined alignment for the top-center.
  static const topCenter = BlockAlignment(0.0, -1.0);

  /// Predefined alignment for the top-right corner.
  static const topRight = BlockAlignment(1.0, -1.0);

  /// Predefined alignment for the center-left.
  static const centerLeft = BlockAlignment(-1.0, 0.0);

  /// Predefined alignment for the center.
  static const center = BlockAlignment(0, 0);

  /// Predefined alignment for the center-right.
  static const centerRight = BlockAlignment(1.0, 0);

  /// Predefined alignment for the bottom-left corner.
  static const bottomLeft = BlockAlignment(-1.0, 1.0);

  /// Predefined alignment for the bottom-center.
  static const bottomCenter = BlockAlignment(0.0, 1.0);

  /// Predefined alignment for the bottom-right corner.
  static const bottomRight = BlockAlignment(1.0, 1.0);

  /// Returns the difference between two [BlockAlignment]s.
  BlockAlignment operator -(BlockAlignment other) {
    return BlockAlignment(x - other.x, y - other.y);
  }

  /// Returns the sum of two [BlockAlignment]s.
  BlockAlignment operator +(BlockAlignment other) {
    return BlockAlignment(x + other.x, y + other.y);
  }

  /// Returns the negation of the given [BlockAlignment].
  BlockAlignment operator -() {
    return BlockAlignment(-x, -y);
  }

  /// Scales the [BlockAlignment] in each dimension by the given factor.
  BlockAlignment operator *(double other) {
    return BlockAlignment(x * other, y * other);
  }

  /// Divides the [BlockAlignment] in each dimension by the given factor.
  BlockAlignment operator /(double other) {
    return BlockAlignment(x / other, y / other);
  }

  /// Integer divides the [BlockAlignment] in each dimension by the given factor.
  BlockAlignment operator ~/(double other) {
    return BlockAlignment((x ~/ other).toDouble(), (y ~/ other).toDouble());
  }

  /// Computes the remainder in each dimension by the given factor.
  BlockAlignment operator %(double other) {
    return BlockAlignment(x % other, y % other);
  }

  static BlockAlignment? lerp(BlockAlignment? a, BlockAlignment? b, double t) {
    if (identical(a, b)) return a;

    if (a == null) {
      return BlockAlignment(
        ui.lerpDouble(0.0, b!.x, t)!,
        ui.lerpDouble(0.0, b.y, t)!,
        xEdgeAlignment: b.xEdgeAlignment,
        yEdgeAlignment: b.yEdgeAlignment,
      );
    }

    if (b == null) {
      return BlockAlignment(
        ui.lerpDouble(a.x, 0.0, t)!,
        ui.lerpDouble(a.y, 0.0, t)!,
        xEdgeAlignment: a.xEdgeAlignment,
        yEdgeAlignment: a.yEdgeAlignment,
      );
    }

    return BlockAlignment(
        ui.lerpDouble(a.x, b.x, t)!, ui.lerpDouble(a.y, b.y, t)!);
  }

  static String _stringify(double x, double y) {
    if (x == -1.0 && y == -1.0) {
      return 'BlockAlignment.topLeft';
    }
    if (x == 0.0 && y == -1.0) {
      return 'BlockAlignment.topCenter';
    }
    if (x == 1.0 && y == -1.0) {
      return 'BlockAlignment.topRight';
    }
    if (x == -1.0 && y == 0.0) {
      return 'BlockAlignment.centerLeft';
    }
    if (x == 0.0 && y == 0.0) {
      return 'BlockAlignment.center';
    }
    if (x == 1.0 && y == 0.0) {
      return 'BlockAlignment.centerRight';
    }
    if (x == -1.0 && y == 1.0) {
      return 'BlockAlignment.bottomLeft';
    }
    if (x == 0.0 && y == 1.0) {
      return 'BlockAlignment.bottomCenter';
    }
    if (x == 1.0 && y == 1.0) {
      return 'BlockAlignment.bottomRight';
    }
    return 'BlockAlignment(${x.toStringAsFixed(1)}, '
        '${y.toStringAsFixed(1)})';
  }

  @override
  String toString() => _stringify(x, y);
}

/// Extension on [BlockAlignment] to provide additional alignment functionality.
extension BlockEdgeAlignmentX on BlockAlignment {
  /// Aligns the block to the left edge.
  BlockAlignment get alignLeft => BlockAlignment(
        x,
        y,
        xEdgeAlignment: XEdgeAlignment.left,
        yEdgeAlignment: yEdgeAlignment,
      );

  /// Aligns the block to the horizontal center.
  BlockAlignment get alignHCenter => BlockAlignment(
        x,
        y,
        xEdgeAlignment: XEdgeAlignment.center,
        yEdgeAlignment: yEdgeAlignment,
      );

  /// Aligns the block to the right edge.
  BlockAlignment get alignRight => BlockAlignment(
        x,
        y,
        xEdgeAlignment: XEdgeAlignment.right,
        yEdgeAlignment: yEdgeAlignment,
      );

  /// Aligns the block to the top edge.
  BlockAlignment get alignTop => BlockAlignment(
        x,
        y,
        xEdgeAlignment: xEdgeAlignment,
        yEdgeAlignment: YEdgeAlignment.top,
      );

  /// Aligns the block to the vertical center.
  BlockAlignment get alignVCenter => BlockAlignment(
        x,
        y,
        xEdgeAlignment: xEdgeAlignment,
        yEdgeAlignment: YEdgeAlignment.center,
      );

  /// Aligns the block to the bottom edge.
  BlockAlignment get alignBottom => BlockAlignment(
        x,
        y,
        xEdgeAlignment: xEdgeAlignment,
        yEdgeAlignment: YEdgeAlignment.bottom,
      );
}
