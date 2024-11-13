import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'alignment.dart';
import 'tooling.dart';

/// Represents a layout area for a block in the schematic.
typedef BlockLayoutArea = ({
  /// Unique identifier for the block layout area.
  String identifier,

  /// Starting position of the block layout area.
  Offset start,

  /// Ending position of the block layout area.
  Offset end,

  /// Determines which sides of the block's border should be hidden.
  HideFenceBorder hideFenceBorder,

  /// Color of the block.
  Color blockColor,

  /// List of openings within the block layout area.
  List<({Offset start, Offset end})> openings,
});

/// Represents an opening in a block.
typedef BlockOpening = ({
  /// Position of the opening.
  Offset offset,

  /// Size of the opening.
  double? openingSize
});

/// [Block] represents a schematic block with specific dimensions, color, and optional labels.
final class Block {
  ///
  /// The width of the block.
  final double width;

  /// The height of the block.
  final double height;

  /// Determines which sides of the block's border should be hidden.
  final HideFenceBorder hideFenceBorder;

  /// An optional label for the entrance of the block.
  final String? entranceLabel;

  /// The style for the entrance label text.
  final TextStyle? entranceLabelStyle;

  /// Entrance opening radius
  final double? entranceOpeningRadius;

  /// The label for the block.
  final String blockLabel;

  /// The style for the block label text.
  final TextStyle? blockLabelStyle;

  /// The color of the block.
  final Color blockColor;

  /// The position of the block.
  final Offset? position;

  /// A list of openings in the block.
  final List<BlockOpening> _openings;

  /// The alignment of the block relative to the previous block.
  final BlockAlignment? alignmentToPreviousBlock;

  const Block({
    this.width = 100,
    this.height = 100,
    this.hideFenceBorder = HideFenceBorder.none,
    this.entranceLabel,
    this.entranceLabelStyle,
    required this.blockLabel,
    this.blockLabelStyle,
    this.blockColor = Colors.purpleAccent,
    this.position,
    List<BlockOpening> openings = const [],
    this.alignmentToPreviousBlock,
    this.entranceOpeningRadius,
  }) : _openings = openings;

  List<BlockOpening> get effectiveOpenings => [
        ..._openings,
        ...?switch (hideFenceBorder) {
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
        other.width == width &&
        other.height == height &&
        other.hideFenceBorder == hideFenceBorder &&
        other.entranceLabel == entranceLabel &&
        other.entranceLabelStyle == entranceLabelStyle &&
        other.blockLabel == blockLabel &&
        other.blockLabelStyle == blockLabelStyle &&
        other.blockColor == blockColor &&
        other.position == position &&
        listEquals(other._openings, _openings) &&
        other.alignmentToPreviousBlock == alignmentToPreviousBlock;
  }

  @override
  int get hashCode {
    return width.hashCode ^
        height.hashCode ^
        hideFenceBorder.hashCode ^
        entranceLabel.hashCode ^
        entranceLabelStyle.hashCode ^
        blockLabel.hashCode ^
        blockLabelStyle.hashCode ^
        blockColor.hashCode ^
        position.hashCode ^
        _openings.hashCode ^
        alignmentToPreviousBlock.hashCode;
  }

  @override
  String toString() {
    return 'Block(width: $width, height: $height, hideFenceBorder: $hideFenceBorder, entranceLabel: $entranceLabel, entranceLabelStyle: $entranceLabelStyle, blockLabel: $blockLabel, blockLabelStyle: $blockLabelStyle, blockColor: $blockColor, position: $position, openings: $effectiveOpenings, alignment: $alignmentToPreviousBlock)';
  }
}
