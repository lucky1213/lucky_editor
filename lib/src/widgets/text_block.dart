part of lucky_rich_editor;

class TextBlock {
  const TextBlock({required this.block});

  final Block block;

  List<InlineSpan> build(BuildContext context) {
    final List<InlineSpan> textSpan = [];
    for (final child in Iterable.castFrom<dynamic, Line>(block.children)) {
      textSpan.addAll(TextLine(line: child).build(context));
    }
    return textSpan;
  }
}
