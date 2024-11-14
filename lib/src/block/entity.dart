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

  /// An optional label for the entrance of the block.
  final String? entranceLabel;

  /// The style for the entrance label text.
  final TextStyle? entranceLabelStyle;

  /// Entrance opening radius
  final double? entranceOpeningRadius;

  /// The label for the block.
  final String? label;

  /// The style for the block label text.
  final TextStyle? labelStyle;

  /// The color of the block.
  final Color color;

  /// The position of the block.
  final Offset? position;

  /// A list of openings in the block.
  final List<BlockOpening> _openings;

  /// The alignment of the block relative to the previous block.
  final BlockAlignment? alignmentToPreviousBlock;

  const Block({
    this.identifier,
    this.width = 100,
    this.height = 100,
    this.fenceBorder = HideFenceBorder.none,
    this.entranceLabel,
    this.entranceLabelStyle,
    this.label,
    this.labelStyle,
    this.color = Colors.purpleAccent,
    this.position,
    List<BlockOpening> openings = const [],
    this.alignmentToPreviousBlock,
    this.entranceOpeningRadius,
  }) : _openings = openings;

  List<BlockOpening> get effectiveOpenings => [
        ..._openings,
        ...?switch (fenceBorder) {
          HideFenceBorder.right => [
              Offset(width, .005).oSize(height),
            ],
          HideFenceBorder.left => [
              // making y not equal zero allows it fall vertically
              const Offset(0, .001).oSize(height),
            ],
          HideFenceBorder.bottom => [
              Offset(.005, height).oSize(width),
            ],
          HideFenceBorder.top => [
              const Offset(.005, 0).oSize(width),
            ],
          _ => null,
        },
      ];

  List<BlockOpening> get openings => _openings.toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Block &&
        other.identifier == identifier &&
        other.width == width &&
        other.height == height &&
        other.fenceBorder == fenceBorder &&
        other.entranceLabel == entranceLabel &&
        other.entranceLabelStyle == entranceLabelStyle &&
        other.label == label &&
        other.labelStyle == labelStyle &&
        other.color == color &&
        other.position == position &&
        other.entranceOpeningRadius == entranceOpeningRadius &&
        listEquals(other._openings, _openings) &&
        other.alignmentToPreviousBlock == alignmentToPreviousBlock;
  }

  @override
  int get hashCode {
    return identifier.hashCode ^
        width.hashCode ^
        height.hashCode ^
        fenceBorder.hashCode ^
        entranceLabel.hashCode ^
        entranceLabelStyle.hashCode ^
        label.hashCode ^
        labelStyle.hashCode ^
        color.hashCode ^
        position.hashCode ^
        entranceOpeningRadius.hashCode ^
        _openings.hashCode ^
        alignmentToPreviousBlock.hashCode;
  }

  @override
  String toString() {
    return 'Block(identifier: $identifier, width: $width, height: $height, fence: $fenceBorder, entranceLabel: $entranceLabel, entranceLabelStyle: $entranceLabelStyle, entranceOpeningRadius: $entranceOpeningRadius, label: $label, labelStyle: $labelStyle, blockColor: $color, position: $position, openings: $effectiveOpenings, alignment: $alignmentToPreviousBlock)';
  }
}
