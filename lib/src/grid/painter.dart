import 'package:flutter/material.dart';
import 'object.dart';

class GridPainter extends CustomPainter {
  GridPainter({
    required this.grid,
    required this.cellSize,
    this.showGrid = false,
    this.showBlocks = false,
  });

  final Grid<int> grid;
  final double cellSize;
  final bool showGrid;
  final bool showBlocks;

  @override
  void paint(Canvas canvas, Size size) {
    if (showGrid) _paintGrid(canvas, size);
    if (showBlocks) _paintBlocks(canvas, size);
  }

  void _paintGrid(Canvas canvas, Size size) {
    for (int i = 0; i < grid.rows; i++) {
      for (int j = 0; j < grid.columns; j++) {
        final yOrigin = 0 + (size.height ~/ grid.rows * i).toDouble();
        final xOrigin = 0 + (size.width ~/ grid.columns * j).toDouble();
        final center = cellSize / 2;
        Path path = Path()
          ..moveTo(xOrigin, yOrigin)
          ..addRect(
            Rect.fromCenter(
              center: Offset(xOrigin + center, yOrigin + center),
              width: cellSize,
              height: cellSize,
            ),
          );
        canvas.drawPath(
          path,
          Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5,
        );
      }
    }
  }

  void _paintBlocks(Canvas canvas, Size size) {
    for (int i = 0; i < grid.rows; i++) {
      for (int j = 0; j < grid.columns; j++) {
        final state = grid.grid[i][j];

        if (state > 0) {
          final yOrigin = 0 + (size.height ~/ grid.rows * i).toDouble();
          final xOrigin = 0 + (size.width ~/ grid.columns * j).toDouble();
          final center = cellSize / 2;
          Path path = Path()
            ..moveTo(xOrigin, yOrigin)
            ..addRect(
              Rect.fromCenter(
                center: Offset(xOrigin + center, yOrigin + center),
                width: cellSize,
                height: cellSize,
              ),
            );

          HSLColor hue = HSLColor.fromAHSL(1, state.toDouble(), 1, 0.5);

          canvas.drawPath(
            path,
            Paint()
              ..color = hue.toColor()
              ..style = PaintingStyle.fill,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! GridPainter) return false;

    if (oldDelegate.grid != grid) return true;
    if (oldDelegate.cellSize != cellSize) return true;
    if (oldDelegate.showGrid != showGrid) return true;
    if (oldDelegate.showBlocks != showBlocks) return true;
    return false;
  }
}
