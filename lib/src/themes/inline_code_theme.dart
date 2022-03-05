part of lucky_rich_editor;

/// Theme data for inline code.
class InlineCodeThemeData {
  InlineCodeThemeData({
    required this.style,
    this.header1,
    this.header2,
    this.header3,
    this.backgroundColor,
    this.radius,
  });

  /// Base text style for an inline code.
  final TextStyle style;

  /// Style override for inline code in header level 1.
  final TextStyle? header1;

  /// Style override for inline code in headings level 2.
  final TextStyle? header2;

  /// Style override for inline code in headings level 3.
  final TextStyle? header3;

  /// Background color for inline code.
  final Color? backgroundColor;

  /// Radius used when paining the background.
  final Radius? radius;

  /// Returns effective style to use for inline code for the specified
  /// [lineStyle].
  TextStyle styleFor(Style lineStyle) {
    if (lineStyle.containsKey(Attribute.h1.key)) {
      return header1 ?? style;
    }
    if (lineStyle.containsKey(Attribute.h2.key)) {
      return header2 ?? style;
    }
    if (lineStyle.containsKey(Attribute.h3.key)) {
      return header3 ?? style;
    }
    return style;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! InlineCodeThemeData) {
      return false;
    }
    return other.style == style &&
        other.header1 == header1 &&
        other.header2 == header2 &&
        other.header3 == header3 &&
        other.backgroundColor == backgroundColor &&
        other.radius == radius;
  }

  @override
  int get hashCode =>
      Object.hash(style, header1, header2, header3, backgroundColor, radius);
}
