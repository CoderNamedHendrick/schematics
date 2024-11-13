import 'dart:math';

import 'package:flutter/material.dart';

import '../block/block.dart';

class SchemaBlockPainter extends CustomPainter {
  final Block block;
  final SchemaSize schemaSize;

  const SchemaBlockPainter({required this.block, required this.schemaSize});

  static const double _fenceStrokeWidth = 1.5;

  @override
  void paint(Canvas canvas, Size size) {
    _drawBlock(canvas, size);
  }

  void _drawBlock(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = block.blockColor
      ..style = PaintingStyle.fill;

    final entranceLabelExists = block.entranceLabel != null;
    const textHeightFactor = 20.0;
    final textPainter = TextPainter(
      text: TextSpan(
        text: block.entranceLabel ?? '',
        style: block.entranceLabelStyle ??
            const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // render entrance label
    if (entranceLabelExists) {
      canvas.save();
      canvas.rotate(_getRadFromDeg(-90));
      textPainter.paint(
        canvas,
        Offset(-(size.height + textPainter.width) / 2,
            size.width - textHeightFactor),
      );

      canvas.restore();
    }

    // 5 is padding between entrance label and block
    final blockStartFromEnd =
        entranceLabelExists ? textHeightFactor + 5.0 : 0.0;
    final blockWidth = size.width - blockStartFromEnd;

    assert(() {
      final openingPositionAligned = () {
        return block.effectiveOpenings
            .map((opening) => opening.offset)
            .map((openingPosition) {
          // opening position must be aligned correctly at the horizontal edges of the block
          if (openingPosition.dx == 0 ||
              openingPosition.dx - blockStartFromEnd == blockWidth) {
            return openingPosition.dy >= 0 && openingPosition.dy <= size.height;
          }

          // opening position must be aligned correctly at the vertical edges of the block
          if (openingPosition.dy == 0 || openingPosition.dy == size.height) {
            return openingPosition.dx >= 0 &&
                openingPosition.dx - blockStartFromEnd <= blockWidth;
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
    late Path path;
    if (entranceLabelExists) {
      path = Path()
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(blockWidth, size.height)
        ..lineTo(blockWidth, size.height * 0.75)
        ..arcToPoint(Offset(blockWidth, size.height * 0.25),
            radius: const Radius.circular(22))
        ..lineTo(blockWidth, 0)
        ..close();
    } else {
      path = Path()
        ..moveTo(0, 0)
        ..lineTo(0, size.height)
        ..lineTo(blockWidth, size.height)
        ..lineTo(blockWidth, 0)
        ..close();
    }
    canvas.drawPath(path, paint);

    // paint border
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _fenceStrokeWidth;

    path = switch (block.hideFenceBorder) {
      HideFenceBorder.all => _getPathWithOpenings(
          [],
          Size(blockWidth, size.height),
          (left: false, right: false, top: false, bottom: false),
        ),
      _ => _getPathWithOpenings(
          block.effectiveOpenings,
          Size(blockWidth, size.height),
          _defaultAllowedEdges,
          blockStartFromEnd,
        ),
    };

    canvas.drawPath(path, paint);

    canvas.save();
    // render block label
    final labelPainter = TextPainter(
      text: TextSpan(
        text: block.blockLabel,
        style: block.blockLabelStyle ??
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
    if (labelPainter.width > blockWidth) {
      canvas.rotate(_getRadFromDeg(-90));
      labelPainter.paint(
        canvas,
        Offset(-(size.height + labelPainter.width) / 2,
            (blockWidth - labelPainter.height) / 2),
      );
    } else {
      labelPainter.paint(
        canvas,
        Offset((blockWidth - labelPainter.width) / 2,
            (size.height - labelPainter.height) / 2),
      );
    }

    canvas.restore();
  }

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
                (edgeOpenings[i].openingSize ?? schemaSize.openingRadius),
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
                  (bottomEdgeOpenings[i].openingSize ??
                      schemaSize.openingRadius),
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
                  (edgeOpenings[i].openingSize ?? schemaSize.openingRadius));
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
                  (topEdgeOpenings[i].openingSize ?? schemaSize.openingRadius),
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

  @override
  bool shouldRepaint(SchemaBlockPainter oldDelegate) {
    return oldDelegate.block != block;
  }
}

typedef _AllowedEdges = ({bool left, bool right, bool top, bool bottom});

const _AllowedEdges _defaultAllowedEdges =
    (left: true, right: true, top: true, bottom: true);

double _getRadFromDeg(double angle) {
  return angle * (pi / 180);
}
