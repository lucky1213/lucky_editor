part of lucky_rich_editor;

class TextBlockThemeData {
  TextBlockThemeData({
    required this.style,
    this.spacing = const Tuple2(8, 0),
    this.lineSpacing = const Tuple2(0, 0),
    this.decoration,
  });

  /// Base text style for a text block.
  final TextStyle style;

  /// Vertical spacing around a text block.
  final Tuple2<double, double> spacing;

  /// Vertical spacing for individual lines within a text block.
  ///
  final Tuple2<double, double> lineSpacing;

  /// Decoration of a text block.
  ///
  /// Decoration, if present, is painted in the content area, excluding
  /// any [spacing].
  final BoxDecoration? decoration;

  TextBlockThemeData copyWith({
    TextStyle? style,
    Tuple2<double, double>? spacing,
    Tuple2<double, double>? lineSpacing,
    BoxDecoration? decoration,
  }) {
    return TextBlockThemeData(
      style: style ?? this.style,
      spacing: spacing ?? this.spacing,
      lineSpacing: lineSpacing ?? this.lineSpacing,
      decoration: decoration ?? this.decoration,
    );
  }
}
