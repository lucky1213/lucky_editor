part of lucky_rich_editor;

// class RichTextEditingController extends ValueNotifier<TextEditingValue> {
//   RichTextEditingController({String? text})
//       : super(text == null
//             ? TextEditingValue.empty
//             : TextEditingValue(text: text));

class LuckyRichEditingController extends TextEditingController {
  LuckyRichEditingController({required Document document})
      : document = document,
        super(text: document.toPlainText()) {
    print(document.toPlainText());
  }

  final Document document;
  factory LuckyRichEditingController.fromJson(String data) {
    return LuckyRichEditingController(
        document: Document.fromJson(json.decode(data)));
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final themeData = LuckyTheme.of(context);
    // return super.buildTextSpan(
    //   context: context,
    //   style: style,
    //   withComposing: withComposing,
    // );
    final List<InlineSpan> textSpan = [];
    for (final node in document.root.children) {
      if (node is Line) {
        textSpan.addAll(TextLine(line: node).build(context));
      } else if (node is Block) {
        textSpan.addAll(TextBlock(block: node).build(context));
      }
      // if (!node.isLast) {
      //   textSpan.add(const TextSpan(text: '\n'));
      // }
    }
    return TextSpan(
      style: style,
      children: textSpan,
    );

    // final List<InlineSpan> textSpan = [];
    // for (final e in document.children) {
    //   if (e is Paragraph) {
    //     for (final t in e.children) {
    //       textSpan.add(TextSpan(text: t.text));
    //     }
    //   } else if (e is ImageElement) {
    //     textSpan.add(WidgetSpan(
    //       child: Container(
    //         width: double.infinity,
    //         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    //         padding: EdgeInsets.all(5),
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black.withOpacity(0.5),
    //               blurRadius: 5,
    //               spreadRadius: 2,
    //             ),
    //           ],
    //           borderRadius: BorderRadius.circular(5),
    //         ),
    //         child: Image.network(e.url),
    //       ),
    //     ));
    //   }
    //   textSpan.add(const TextSpan(text: '\n'));
    // }

    // return TextSpan(
    //   style: style,
    //   children: textSpan,
    // );
  }
}
