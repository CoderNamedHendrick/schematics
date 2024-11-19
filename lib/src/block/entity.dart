import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'alignment.dart';
import 'tooling.dart';

/// opening for a block area defined by a start(0, 0) and end offset(maxWidth, maxHeight).
typedef BlockLayoutOpening = ({Offset start, Offset end});

/// Represents a layout area for a block in the schematic.
class BlockArea<T extends Object> {
  /// Unique identifier for the block layout area.
  final T identifier;

  /// Starting position of the block layout area.
  final Offset start;

  /// Ending position of the block layout area.
  final Offset end;

  /// Determines which sides of the block's border should be hidden.
  final HideFenceBorder fenceBorder;

  /// Color of the block.
  final Color blockColor;

  /// List of openings within the block layout area.
  final List<BlockLayoutOpening> openings;

  const BlockArea({
    required this.identifier,
    required this.start,
    required this.end,
    required this.fenceBorder,
    required this.blockColor,
    this.openings = const [],
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlockArea &&
        other.identifier == identifier &&
        other.start == start &&
        other.end == end &&
        other.fenceBorder == fenceBorder &&
        other.blockColor == blockColor &&
        listEquals(other.openings, openings);
  }

  @override
  int get hashCode {
    return identifier.hashCode ^
        start.hashCode ^
        end.hashCode ^
        fenceBorder.hashCode ^
        blockColor.hashCode ^
        openings.hashCode;
  }

  @override
  String toString() {
    return 'BlockLayoutArea(identifier: $identifier, start: $start, end: $end, hideFenceBorder: $fenceBorder, blockColor: $blockColor, openings: $openings)';
  }
}

/// Represents an opening in a block.
typedef BlockOpening = ({
  /// Position of the opening.
  Offset offset,

  /// Size of the opening.
  double? openingSize
});

/// Represents an opening with an arc in a block,
class BlockArcOpening {
  /// Position of the arc opening.
  final Offset offset;

  /// Radius of the arc opening. if radius is null, it defaults to the schema opening size.
  final double? radius;

  /// Indicates if the arc opening is a full opening.
  final bool isFullOpening;

  /// Label for the arc opening.
  final String? label;

  /// Style for the label text.
  final TextStyle? labelStyle;

  /// Alignment for the label text.
  final TextAlign? labelAlign;

  /// Margin for the label text.
  final double? labelMargin;

  /// Allow text paint over the boundaries of the opening
  final bool allowTextOverflow;

  const BlockArcOpening({
    required this.offset,
    required this.radius,
    required this.isFullOpening,
    required this.label,
    required this.labelStyle,
    required this.labelAlign,
    required this.labelMargin,
    this.allowTextOverflow = false,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BlockArcOpening &&
        other.offset == offset &&
        other.radius == radius &&
        other.isFullOpening == isFullOpening &&
        other.label == label &&
        other.labelStyle == labelStyle &&
        other.labelAlign == labelAlign &&
        other.labelMargin == labelMargin &&
        other.allowTextOverflow == allowTextOverflow;
  }

  @override
  int get hashCode {
    return offset.hashCode ^
        radius.hashCode ^
        isFullOpening.hashCode ^
        label.hashCode ^
        labelStyle.hashCode ^
        labelAlign.hashCode ^
        labelMargin.hashCode ^
        allowTextOverflow.hashCode;
  }

  @override
  String toString() {
    return 'BlockArcOpening(offset: $offset, radius: $radius, isFullOpening: $isFullOpening, label: $label, labelStyle: $labelStyle labelAlign: $labelAlign, labelMargin: $labelMargin)';
  }
}

/// [Block] represents a schematic block with specific dimensions, color, and optional labels.
/// where type[T] is the unique identifier for the block.
final class Block<T extends Object> {
  /// Unique block identifier
  final T? identifier;

  ///
  /// The width of the block.
  final double width;

  /// The height of the block.
  final double height;

  /// Determines which sides of the block's border should be hidden.
  final HideFenceBorder fenceBorder;

  /// The label for the block.
  final String? label;

  /// The style for the block label text.
  final TextStyle? labelStyle;

  /// The alignment for the block label text.
  final TextAlign? labelAlign;

  /// The color of the block.
  final Color color;

  /// The position of the block.
  final Offset? position;

  /// A list of openings in the block.
  final List<BlockOpening> _openings;

  /// List of arc openings within the block.
  final List<BlockArcOpening> arcOpenings;

  /// The alignment of the block relative to the previous block.
  final BlockAlignment? alignmentToPreviousBlock;

  /// The stroke width for the fence border.
  final double fenceStrokeWidth;

  const Block({
    this.identifier,
    this.width = 100,
    this.height = 100,
    this.fenceBorder = HideFenceBorder.none,
    this.label,
    this.labelStyle,
    this.labelAlign,
    this.color = Colors.purpleAccent,
    this.position,
    List<BlockOpening> openings = const [],
    this.alignmentToPreviousBlock,
    this.arcOpenings = const [],
    this.fenceStrokeWidth = 1.5,
  }) : _openings = openings;

  List<BlockOpening> get effectiveOpenings {
    final effectiveArcOpenings = arcOpenings.toList()
      ..removeWhere((opening) {
        return switch (fenceBorder) {
          HideFenceBorder.right => opening.offset.dx == width,
          HideFenceBorder.left => opening.offset.dx == 0,
          HideFenceBorder.bottom => opening.offset.dy == height,
          HideFenceBorder.top => opening.offset.dy == 0,
          _ => false,
        };
      });
    final fenceOpenings = switch (fenceBorder) {
      HideFenceBorder.right => Offset(width, .001).oSize(height),
      // making y not equal zero allows it fall vertically
      HideFenceBorder.left => const Offset(0, .001).oSize(height),
      HideFenceBorder.bottom => Offset(.001, height).oSize(width),
      HideFenceBorder.top => const Offset(.001, 0).oSize(width),
      _ => null,
    };
    return [
      ..._openings,
      if (fenceOpenings != null) fenceOpenings,
      ...effectiveArcOpenings.map((opening) {
        if (opening.radius != null) {
          return opening.offset.oSize(opening.radius! * 2);
        } else {
          return opening.offset.opening;
        }
      }),
    ];
  }

  List<BlockOpening> get openings => _openings.toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Block &&
        other.identifier == identifier &&
        other.width == width &&
        other.height == height &&
        other.fenceBorder == fenceBorder &&
        other.label == label &&
        other.labelStyle == labelStyle &&
        other.labelAlign == labelAlign &&
        other.color == color &&
        other.position == position &&
        listEquals(other._openings, _openings) &&
        listEquals(other.arcOpenings, arcOpenings) &&
        other.alignmentToPreviousBlock == alignmentToPreviousBlock &&
        other.fenceStrokeWidth == fenceStrokeWidth;
  }

  @override
  int get hashCode {
    return identifier.hashCode ^
        width.hashCode ^
        height.hashCode ^
        fenceBorder.hashCode ^
        label.hashCode ^
        labelStyle.hashCode ^
        labelAlign.hashCode ^
        color.hashCode ^
        position.hashCode ^
        _openings.hashCode ^
        arcOpenings.hashCode ^
        alignmentToPreviousBlock.hashCode ^
        fenceStrokeWidth.hashCode;
  }

  @override
  String toString() {
    return 'Block(identifier: $identifier, width: $width, height: $height, fence: $fenceBorder, label: $label, labelStyle: $labelStyle, labelAlign: $labelAlign, blockColor: $color, position: $position, openings: $effectiveOpenings, arcOpenings: $arcOpenings, alignment: $alignmentToPreviousBlock, fenceStrokeWidth: $fenceStrokeWidth)';
  }
}
