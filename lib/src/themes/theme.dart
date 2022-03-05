part of lucky_rich_editor;

class LuckyTheme extends InheritedWidget {
  final LuckyThemeData data;

  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const LuckyTheme({
    Key? key,
    required this.data,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(LuckyTheme oldWidget) {
    return data != oldWidget.data;
  }

  /// The data from the closest [ZefyrTheme] instance that encloses the given
  /// context.
  ///
  /// Returns `null` if there is no [ZefyrTheme] in the given build context
  /// and [nullOk] is set to `true`. If [nullOk] is set to `false` (default)
  /// then this method asserts.
  static LuckyThemeData? of(BuildContext context, {bool nullOk = false}) {
    final widget = context.dependOnInheritedWidgetOfExactType<LuckyTheme>();
    if (widget == null && nullOk) return null;
    assert(widget != null,
        '$LuckyTheme.of() called with a context that does not contain a LuckyEditor.');
    return widget!.data;
  }
}

class LuckyThemeData {
  final TextBlockThemeData? h1;
  final TextBlockThemeData? h2;
  final TextBlockThemeData? h3;
  final TextBlockThemeData paragraph;

  /// Style of bold text.
  final TextStyle? bold;

  /// Style of italic text.
  final TextStyle? italic;

  /// Style of underline text.
  final TextStyle? underline;

  /// Style of strikethrough text.
  final TextStyle? strikethrough;

  /// Theme of inline code.
  final InlineCodeThemeData? inlineCode;

  final TextStyle? link;

  final TextBlockThemeData? placeholder;
  final TextBlockThemeData? lists;
  final TextBlockThemeData? quote;
  final TextBlockThemeData? code;
  final TextBlockThemeData? indent;
  final TextBlockThemeData? align;
  final TextBlockThemeData? leading;

  LuckyThemeData({
    this.h1,
    this.h2,
    this.h3,
    required this.paragraph,
    this.bold,
    this.italic,
    this.underline,
    this.strikethrough,
    this.inlineCode,
    this.link,
    this.placeholder,
    this.lists,
    this.quote,
    this.code,
    this.indent,
    this.align,
    this.leading,
  });

  factory LuckyThemeData.fallback(BuildContext context) {
    final themeData = Theme.of(context);
    final defaultTextStyle =
        (themeData.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: 14.0,
      height: 1.4,
    );
    const defaultSpacing = Tuple2<double, double>(6, 0);

    String fontFamily;
    switch (themeData.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        fontFamily = 'Menlo';
        break;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        fontFamily = 'Roboto Mono';
        break;
    }

    final inlineCodeStyle = defaultTextStyle.copyWith(
      fontSize: 12,
      color: themeData.colorScheme.primary,
      fontFamily: fontFamily,
    );
    final TextBlockThemeData defaultTextBlockStyle =
        TextBlockThemeData(style: defaultTextStyle);

    return LuckyThemeData(
      h1: defaultTextBlockStyle.copyWith(
        style: defaultTextStyle.copyWith(
          fontSize: 28,
          color: defaultTextStyle.color,
          fontWeight: FontWeight.w500,
        ),
        spacing: const Tuple2(14, 0),
      ),
      h2: defaultTextBlockStyle.copyWith(
        style: defaultTextStyle.copyWith(
          fontSize: 24,
          color: defaultTextStyle.color,
          fontWeight: FontWeight.w500,
        ),
        spacing: const Tuple2(12, 0),
      ),
      h3: defaultTextBlockStyle.copyWith(
        style: defaultTextStyle.copyWith(
          fontSize: 20,
          color: defaultTextStyle.color,
          fontWeight: FontWeight.normal,
        ),
        spacing: const Tuple2(10, 0),
      ),
      paragraph: defaultTextBlockStyle,
      bold: const TextStyle(fontWeight: FontWeight.bold),
      italic: const TextStyle(fontStyle: FontStyle.italic),
      underline: const TextStyle(decoration: TextDecoration.underline),
      strikethrough: const TextStyle(decoration: TextDecoration.lineThrough),
      inlineCode: InlineCodeThemeData(
        style: inlineCodeStyle,
        header1: inlineCodeStyle.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w300,
        ),
        header2: inlineCodeStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.normal,
        ),
        header3: inlineCodeStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
      link: defaultTextStyle.copyWith(
        color: themeData.colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
      placeholder: defaultTextBlockStyle.copyWith(
        style: defaultTextStyle.copyWith(
          color: themeData.colorScheme.primary,
        ),
        spacing: const Tuple2(0, 0),
      ),
      lists: defaultTextBlockStyle.copyWith(
        spacing: defaultSpacing,
        lineSpacing: const Tuple2(0, 6),
      ),
      quote: defaultTextBlockStyle.copyWith(
        style: defaultTextStyle,
        spacing: defaultSpacing,
        lineSpacing: const Tuple2(6, 2),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 4, color: Colors.grey.shade300),
          ),
        ),
      ),
      code: defaultTextBlockStyle.copyWith(
        style: defaultTextStyle.copyWith(
          color: themeData.colorScheme.primary.withOpacity(0.5),
        ),
        spacing: defaultSpacing,
        lineSpacing: const Tuple2(0, 0),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      indent: defaultTextBlockStyle.copyWith(
        spacing: defaultSpacing,
        lineSpacing: const Tuple2(0, 8),
      ),
      align: defaultTextBlockStyle.copyWith(
        spacing: const Tuple2(0, 0),
        lineSpacing: const Tuple2(0, 0),
      ),
      leading: defaultTextBlockStyle.copyWith(
        spacing: const Tuple2(0, 0),
        lineSpacing: const Tuple2(0, 0),
      ),
    );
  }

  LuckyThemeData copyWith({
    TextBlockThemeData? h1,
    TextBlockThemeData? h2,
    TextBlockThemeData? h3,
    TextBlockThemeData? paragraph,
    TextStyle? bold,
    TextStyle? italic,
    TextStyle? underline,
    TextStyle? strikethrough,
    InlineCodeThemeData? inlineCode,
    TextStyle? link,
    TextBlockThemeData? placeholder,
    TextBlockThemeData? lists,
    TextBlockThemeData? quote,
    TextBlockThemeData? code,
    TextBlockThemeData? indent,
    TextBlockThemeData? align,
    TextBlockThemeData? leading,
  }) {
    return LuckyThemeData(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      paragraph: paragraph ?? this.paragraph,
      bold: bold ?? this.bold,
      italic: italic ?? this.italic,
      underline: underline ?? this.underline,
      strikethrough: strikethrough ?? this.strikethrough,
      inlineCode: inlineCode ?? this.inlineCode,
      link: link ?? this.link,
      placeholder: placeholder ?? this.placeholder,
      lists: lists ?? this.lists,
      quote: quote ?? this.quote,
      code: code ?? this.code,
      indent: indent ?? this.indent,
      align: align ?? this.align,
      leading: leading ?? this.leading,
    );
  }

  LuckyThemeData merge(LuckyThemeData other) {
    return copyWith(
      h1: other.h1,
      h2: other.h2,
      h3: other.h3,
      paragraph: other.paragraph,
      bold: other.bold,
      italic: other.italic,
      underline: other.underline,
      strikethrough: other.strikethrough,
      inlineCode: other.inlineCode,
      link: other.link,
      placeholder: other.placeholder,
      lists: other.lists,
      quote: other.quote,
      code: other.code,
      indent: other.indent,
      align: other.align,
      leading: other.leading,
    );
  }
}
