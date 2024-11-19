part of 'widget.dart';

/// A custom painter for drawing a block within a schema.
class _SchemaBlockPainter extends CustomPainter {
  /// The block to be painted.
  final Block block;

  /// The size of the schema.
  final SchemaSize schemaSize;

  /// Creates a new instance of [_SchemaBlockPainter].
  const _SchemaBlockPainter({required this.block, required this.schemaSize});

  @override
  void paint(Canvas canvas, Size size) {
    _drawBlock(canvas, size);
  }

  /// Draws the block on the canvas.
  void _drawBlock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = block.color
      ..style = PaintingStyle.fill;

    assert(() {
      final openingPositionAligned = () {
        return block.effectiveOpenings
            .map((opening) => opening.offset)
            .map((openingPosition) {
          // opening position must be aligned correctly at the horizontal edges of the block
          if (openingPosition.dx == 0 || openingPosition.dx == size.width) {
            return openingPosition.dy >= 0 && openingPosition.dy <= size.height;
          }

          // opening position must be aligned correctly at the vertical edges of the block
          if (openingPosition.dy == 0 || openingPosition.dy == size.height) {
            return openingPosition.dx >= 0 && openingPosition.dx <= size.width;
          }

          return false;
        }).fold(true, (prev, current) => prev && current);
      }();

      if (!openingPositionAligned) {
        throw FlutterError(
          'Opening position must be aligned correctly at the edges of the block',
        );
      }
      return openingPositionAligned;
    }());

    // paint inside
    Path path = _blockPathWithArcs(block.arcOpenings, size, canvas);
    canvas.drawPath(path, paint);

    // paint border
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = block.fenceStrokeWidth;

    path = switch (block.fenceBorder) {
      HideFenceBorder.all => _getPathWithOpenings(
          [],
          size,
          (left: false, right: false, top: false, bottom: false),
        ),
      _ => _getPathWithOpenings(
          block.effectiveOpenings,
          size,
          _defaultAllowedEdges,
        ),
    };

    canvas.drawPath(path, paint);

    canvas.save();
    // render block label
    final labelPainter = TextPainter(
      textAlign: block.labelAlign ?? TextAlign.center,
      text: TextSpan(
        text: block.label,
        style: block.labelStyle ??
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
      ),
      textDirection: TextDirection.ltr,
    );

    labelPainter.layout();
    // render block label
    if (labelPainter.width > size.width) {
      canvas.rotate(_getRadFromDeg(-90));
      labelPainter.paint(
        canvas,
        Offset(-(size.height + labelPainter.width) / 2,
            (size.width - labelPainter.height) / 2),
      );
    } else {
      labelPainter.paint(
        canvas,
        Offset((size.width - labelPainter.width) / 2,
            (size.height - labelPainter.height) / 2),
      );
    }

    canvas.restore();
  }

  Path _blockPathWithArcs(
      Iterable<BlockArcOpening> openings, Size size, Canvas canvas) {
    final path = Path()..moveTo(0, 0);
    final leftArcOpenings = openings
        .where((opening) => opening.offset.dx == 0)
        .toList()
      ..sort((a, b) => a.offset.dy.compareTo(b.offset.dy));

    if (leftArcOpenings.isNotEmpty) {
      for (final opening in leftArcOpenings) {
        final openingRadius = opening.radius ?? (schemaSize.opening / 2);
        path.lineTo(0, opening.offset.dy);
        path.arcTo(
          Rect.fromLTWH(
            -openingRadius,
            opening.offset.dy + (opening.isFullOpening ? 0 : openingRadius / 2),
            openingRadius * 2,
            openingRadius * 2,
          ),
          -pi / 2,
          opening.isFullOpening ? pi : pi / 2,
          false,
        );
        path.lineTo(
          0,
          opening.offset.dy +
              (opening.isFullOpening ? openingRadius : openingRadius * 1.5),
        );

        if (opening.label != null) {
          final textPainter = _getTextPainter(opening, openingRadius);

          canvas.save();
          canvas.rotate(_getRadFromDeg(90));
          textPainter.paint(
            canvas,
            Offset(
              opening.offset.dy + openingRadius - textPainter.width / 2,
              opening.labelMargin ?? 0,
            ),
          );
          canvas.restore();
        }
      }

      path.lineTo(0, size.height);
    } else {
      path.lineTo(0, size.height);
    }

    final bottomArcOpenings = block.arcOpenings
        .where((opening) => opening.offset.dy == size.height)
        .toList()
      ..sort((a, b) => a.offset.dx.compareTo(b.offset.dx));

    if (bottomArcOpenings.isNotEmpty) {
      for (final opening in bottomArcOpenings) {
        final openingRadius = opening.radius ?? (schemaSize.opening / 2);
        path.lineTo(opening.offset.dx, size.height);
        path.arcTo(
          Rect.fromLTWH(
            opening.offset.dx + (opening.isFullOpening ? 0 : openingRadius / 2),
            size.height - openingRadius,
            openingRadius * 2,
            openingRadius * 2,
          ),
          -pi,
          opening.isFullOpening ? pi : pi / 2,
          false,
        );
        path.lineTo(
            opening.offset.dx +
                (opening.isFullOpening ? openingRadius : openingRadius * 1.5),
            size.height);

        if (opening.label != null) {
          final textPainter = _getTextPainter(opening, openingRadius);

          canvas.save();
          textPainter.paint(
            canvas,
            Offset(
              opening.offset.dx + openingRadius - textPainter.width / 2,
              size.height + (opening.labelMargin ?? 0),
            ),
          );
          canvas.restore();
        }
      }

      //
      path.lineTo(size.width, size.height);
    } else {
      path.lineTo(size.width, size.height);
    }

    final rightArcOpenings = block.arcOpenings
        .where((opening) => opening.offset.dx == size.width)
        .toList()
      ..sort((a, b) => b.offset.dy.compareTo(a.offset.dy));

    if (rightArcOpenings.isNotEmpty) {
      for (final opening in rightArcOpenings) {
        final openingRadius = opening.radius ?? (schemaSize.opening / 2);
        path.arcTo(
          Rect.fromLTWH(
            size.width - openingRadius,
            opening.offset.dy -
                (openingRadius * 2) -
                (opening.isFullOpening ? 0 : openingRadius / 2),
            openingRadius * 2,
            openingRadius * 2,
          ),
          pi / 2,
          opening.isFullOpening ? pi : pi / 2,
          false,
        );
        path.lineTo(
            size.width,
            opening.offset.dy -
                openingRadius -
                (opening.isFullOpening ? 0 : openingRadius / 2));

        if (opening.label != null) {
          final textPainter = _getTextPainter(opening, openingRadius);

          canvas.save();
          canvas.rotate(_getRadFromDeg(-90));
          canvas.translate(-size.height, 0);
          textPainter.paint(
            canvas,
            Offset(
              size.height -
                  opening.offset.dy +
                  openingRadius -
                  textPainter.width / 2,
              size.width + (opening.labelMargin ?? 0),
            ),
          );
          canvas.restore();
        }
      }

      path.lineTo(size.width, 0);
    } else {
      path.lineTo(size.width, 0);
    }

    final topArcOpenings = block.arcOpenings
        .where((opening) => opening.offset.dy == 0)
        .toList()
      ..sort((a, b) => b.offset.dx.compareTo(a.offset.dx));

    if (topArcOpenings.isNotEmpty) {
      for (final opening in topArcOpenings) {
        final openingRadius = opening.radius ?? (schemaSize.opening / 2);
        path.arcTo(
          Rect.fromLTWH(
            opening.offset.dx - (opening.isFullOpening ? 0 : openingRadius / 2),
            -openingRadius,
            openingRadius * 2,
            openingRadius * 2,
          ),
          0,
          opening.isFullOpening ? pi : pi / 2,
          false,
        );
        path.lineTo(
            opening.offset.dx -
                openingRadius +
                (opening.isFullOpening ? 0 : openingRadius * 1.5),
            0);

        if (opening.label != null) {
          final textPainter = _getTextPainter(opening, openingRadius);

          canvas.save();
          canvas.rotate(_getRadFromDeg(-180));
          textPainter.paint(
            canvas,
            Offset(
              -(opening.offset.dx + (openingRadius * 2)) +
                  (openingRadius - textPainter.width / 2),
              (opening.labelMargin ?? 0),
            ),
          );
          canvas.restore();
        }
      }
      path.lineTo(0, 0);
    } else {
      path.lineTo(0, 0);
    }

    path.close();
    return path;
  }

  /// Generates a path with openings for the block
  Path _getPathWithOpenings(Iterable<BlockOpening> openings, Size size,
      [_AllowedEdges edges = _defaultAllowedEdges,
      double horizontalPaddingFactor = 0]) {
    final path = Path();

    if (edges.left) {
      final edgeOpenings = openings
          .where((opening) => opening.offset.dx == 0)
          .toList()
        ..sort((a, b) => a.offset.dy.compareTo(b.offset.dy));

      if (edgeOpenings.isNotEmpty) {
        path.moveTo(0, 0);
        for (int i = 0; i < edgeOpenings.length; i++) {
          path.lineTo(0, edgeOpenings[i].offset.dy);
          path.moveTo(
            0,
            edgeOpenings[i].offset.dy +
                (edgeOpenings[i].openingSize ?? schemaSize.opening),
          );
        }
        path.lineTo(0, size.height);
      } else {
        path.moveTo(0, 0);
        path.lineTo(0, size.height);
      }
    } else {
      path.moveTo(0, 0);
      path.moveTo(0, size.height);
    }

    if (edges.bottom) {
      final bottomEdgeOpenings = openings
          .where((opening) => opening.offset.dy == size.height)
          .toList()
        ..sort((a, b) => a.offset.dx.compareTo(b.offset.dx));

      if (bottomEdgeOpenings.isNotEmpty) {
        path.moveTo(0, size.height);
        for (int i = 0; i < bottomEdgeOpenings.length; i++) {
          path.lineTo(bottomEdgeOpenings[i].offset.dx - horizontalPaddingFactor,
              size.height);
          path.moveTo(
              bottomEdgeOpenings[i].offset.dx -
                  horizontalPaddingFactor +
                  (bottomEdgeOpenings[i].openingSize ?? schemaSize.opening),
              size.height);
        }
        path.lineTo(size.width, size.height);
      } else {
        path.moveTo(0, size.height);
        path.lineTo(size.width, size.height);
      }
    } else {
      path.moveTo(0, size.height);
      path.moveTo(size.width, size.height);
    }

    if (edges.right) {
      final edgeOpenings = openings
          .where((opening) =>
              opening.offset.dx - horizontalPaddingFactor == size.width)
          .toList()
        ..sort((a, b) => b.offset.dy.compareTo(a.offset.dy));

      if (edgeOpenings.isNotEmpty) {
        path.moveTo(size.width, size.height);
        for (int i = 0; i < edgeOpenings.length; i++) {
          path.lineTo(
              size.width,
              edgeOpenings[i].offset.dy +
                  (edgeOpenings[i].openingSize ?? schemaSize.opening));
          path.moveTo(size.width, edgeOpenings[i].offset.dy);
        }
        path.lineTo(size.width, 0);
      } else {
        path.lineTo(size.width, 0);
      }
    } else {
      path.moveTo(size.width, size.height);
      path.moveTo(size.width, 0);
    }

    if (edges.top) {
      final topEdgeOpenings = openings
          .where((opening) => opening.offset.dy == 0)
          .toList()
        ..sort((a, b) => b.offset.dx.compareTo(a.offset.dx));

      if (topEdgeOpenings.isNotEmpty) {
        path.moveTo(size.width, 0);
        for (int i = 0; i < topEdgeOpenings.length; i++) {
          path.lineTo(
              topEdgeOpenings[i].offset.dx -
                  horizontalPaddingFactor +
                  (topEdgeOpenings[i].openingSize ?? schemaSize.opening),
              0);
          path.moveTo(
              topEdgeOpenings[i].offset.dx - horizontalPaddingFactor, 0);
        }

        path.lineTo(0, 0);
      } else {
        path.moveTo(size.width, 0);
        path.lineTo(0, 0);
      }
    } else {
      path.moveTo(size.width, 0);
      path.moveTo(0, 0);
    }

    return path;
  }

  TextPainter _getTextPainter(
      final BlockArcOpening opening, final double openingRadius) {
    final textPainter = TextPainter(
      textAlign: opening.labelAlign ?? TextAlign.center,
      text: TextSpan(
        text: opening.label!,
        style: opening.labelStyle ??
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 10,
            ),
      ),
      textDirection: TextDirection.ltr,
    );

    if (opening.allowTextOverflow) {
      textPainter.maxLines = 1;
      textPainter.layout();
    } else {
      textPainter.layout(maxWidth: openingRadius * 2);
    }

    return textPainter;
  }

  @override
  bool shouldRepaint(_SchemaBlockPainter oldDelegate) {
    return oldDelegate.block != block || oldDelegate.schemaSize != schemaSize;
  }
}

typedef _AllowedEdges = ({bool left, bool right, bool top, bool bottom});

const _AllowedEdges _defaultAllowedEdges =
    (left: true, right: true, top: true, bottom: true);

double _getRadFromDeg(double angle) {
  return angle * (pi / 180);
}
