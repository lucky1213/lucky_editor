part of lucky_rich_editor;

class TextLine {
  const TextLine({required this.line});

  final Line line;

  List<InlineSpan> _buildTextSpanList(LinkedList<Node> nodes,
      {TextStyle? style}) {
    final List<InlineSpan> textSpan = [];

    for (final node in nodes) {
      final textNode = node as TextLeaf;
      Attribute? block;
      line.style.getBlocksExceptHeader().forEach((key, value) {
        if (Attribute.exclusiveBlockKeys.contains(key)) {
          block = value;
        }
      });
      // textSpan.addAll(_buildTextSpan(node, style: style));
      textSpan.add(WidgetSpan(
        child: Container(
          width: double.infinity,

          // padding: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            textNode.value,
            style: style,
            strutStyle: StrutStyle.fromTextStyle(style!),
          ),
        ),
      ));
    }
    return textSpan;
  }

  List<InlineSpan> _buildTextSpan(Node node, {TextStyle? style}) {
    final List<InlineSpan> textSpan = [];
    final textNode = node as TextLeaf;
    textSpan.add(TextSpan(
      text: textNode.value,
      style: style,
    ));
    Attribute? block;
    line.style.getBlocksExceptHeader().forEach((key, value) {
      if (Attribute.exclusiveBlockKeys.contains(key)) {
        block = value;
      }
    });

    if (block == Attribute.blockQuote && !line.isLast) {
      textSpan.insert(
          0,
          WidgetSpan(
              alignment: ui.PlaceholderAlignment.middle,
              child: Container(
                width: 16,
                height: 26,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 4, color: Colors.grey.shade300),
                  ),
                ),
              )));
      textSpan.add(TextSpan(
        text: '\n',
        style: style,
      ));
    }
    return textSpan;
  }

  TextStyle _getLineStyle(Style style, LuckyThemeData themeData,
      [Attribute? block]) {
    TextStyle textStyle = const TextStyle();
    final header = line.style.attributes[Attribute.header.key];
    final headerStyles = <Attribute, TextStyle?>{
      Attribute.h1: themeData.h1?.style,
      Attribute.h2: themeData.h2?.style,
      Attribute.h3: themeData.h3?.style,
    };
    textStyle =
        textStyle.merge(headerStyles[header] ?? themeData.paragraph.style);
    // Only retrieve exclusive block format for the line style purpose

    TextStyle? toMerge;
    if (block == Attribute.blockQuote) {
      toMerge = themeData.quote?.style;
    } else if (block == Attribute.codeBlock) {
      toMerge = themeData.code?.style;
    } else if (block == Attribute.list) {
      toMerge = themeData.lists?.style;
    }

    textStyle = textStyle.merge(toMerge);
    // textStyle = _applyCustomAttributes(textStyle, line.style.attributes);

    return textStyle;
  }

  List<InlineSpan> build(BuildContext context) {
    final themeData = LuckyTheme.of(context)!;
    final List<InlineSpan> textSpan = [];
    Attribute? block;
    line.style.getBlocksExceptHeader().forEach((key, value) {
      if (Attribute.exclusiveBlockKeys.contains(key)) {
        block = value;
      }
    });
    final style = _getLineStyle(line.style, themeData, block);

    if (block == Attribute.blockQuote) {
      // textSpan.add(WidgetSpan(
      //     alignment: ui.PlaceholderAlignment.middle,
      //     child: Container(
      //       width: 16,
      //       height: 26,
      //       decoration: themeData.quote?.decoration,
      //     )));
    }
    // } else if (block == Attribute.ul) {
    //   textSpan.add(WidgetSpan(
    //       alignment: ui.PlaceholderAlignment.middle,
    //       child: Container(
    //         width: 5,
    //         height: 5,
    //         margin: EdgeInsets.symmetric(horizontal: 10, vertical: 16),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(2.5),
    //           color: themeData.lists?.style.color,
    //         ),
    //       )));
    // }
    if (!line.hasEmbed) {
      textSpan.addAll(_buildTextSpanList(line.children, style: style));
    } else {
      for (final child in line.children) {
        if (child is EmbedLeaf) {
          if (child.value.type == BlockEmbed.imageType) {
            textSpan.add(WidgetSpan(
                child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 6,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.network(child.value.data),
            )));
          }
        } else {
          textSpan.addAll(_buildTextSpan(child, style: style));
        }
      }
    }

    return textSpan;
  }
}
