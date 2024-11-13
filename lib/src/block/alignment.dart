import 'dart:ui' as ui;

enum XEdgeAlignment { left, center, right }

enum YEdgeAlignment { top, center, bottom }

class BlockAlignment {
  final double x;
  final XEdgeAlignment xEdgeAlignment;
  final double y;
  final YEdgeAlignment yEdgeAlignment;

  const BlockAlignment(
    this.x,
    this.y, {
    this.xEdgeAlignment = XEdgeAlignment.left,
    this.yEdgeAlignment = YEdgeAlignment.bottom,
  });

  static const topLeft = BlockAlignment(-1, -1);
  static const topCenter = BlockAlignment(0.0, -1.0);
  static const topRight = BlockAlignment(1.0, -1.0);

  static const centerLeft = BlockAlignment(-1.0, 0.0);
  static const center = BlockAlignment(0, 0);
  static const centerRight = BlockAlignment(1.0, 0);

  static const bottomLeft = BlockAlignment(-1.0, 1.0);
  static const bottomCenter = BlockAlignment(0.0, 1.0);
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

  /// Divides the [Alignment] in each dimension by the given factor.
  BlockAlignment operator /(double other) {
    return BlockAlignment(x / other, y / other);
  }

  /// Integer divides the [Alignment] in each dimension by the given factor.
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

extension BlockEdgeAlignmentX on BlockAlignment {
  BlockAlignment get alignLeft => BlockAlignment(
        x,
        y,
        xEdgeAlignment: XEdgeAlignment.left,
        yEdgeAlignment: yEdgeAlignment,
      );

  BlockAlignment get alignHCenter => BlockAlignment(
        x,
        y,
        xEdgeAlignment: XEdgeAlignment.center,
        yEdgeAlignment: yEdgeAlignment,
      );

  BlockAlignment get alignRight => BlockAlignment(
        x,
        y,
        xEdgeAlignment: XEdgeAlignment.right,
        yEdgeAlignment: yEdgeAlignment,
      );

  BlockAlignment get alignTop => BlockAlignment(
        x,
        y,
        xEdgeAlignment: xEdgeAlignment,
        yEdgeAlignment: YEdgeAlignment.top,
      );

  BlockAlignment get alignVCenter => BlockAlignment(
        x,
        y,
        xEdgeAlignment: xEdgeAlignment,
        yEdgeAlignment: YEdgeAlignment.center,
      );

  BlockAlignment get alignBottom => BlockAlignment(
        x,
        y,
        xEdgeAlignment: xEdgeAlignment,
        yEdgeAlignment: YEdgeAlignment.bottom,
      );
}
