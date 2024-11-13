import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'alignment.dart';
import 'tooling.dart';

typedef BlockLayoutArea = ({
  String identifier,
  Offset start,
  Offset end,
  HideFenceBorder hideFenceBorder,
  Color blockColor,
  List<({Offset start, Offset end})> openings,
});

typedef BlockOpening = ({Offset offset, double? openingSize});

final class Block {
  final double width;
  final double height;
  final HideFenceBorder hideFenceBorder;
  final String? entranceLabel;
  final TextStyle? entranceLabelStyle;
  final String blockLabel;
  final TextStyle? blockLabelStyle;
  final Color blockColor;
  final Offset? position;
  final List<BlockOpening> _openings;
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
