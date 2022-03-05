part of lucky_rich_editor;

class LuckyEditor extends StatefulWidget {
  const LuckyEditor({Key? key, required this.controller, this.themeData})
      : super(key: key);

  final LuckyRichEditingController controller;
  final LuckyThemeData? themeData;

  @override
  _LuckyEditorState createState() => _LuckyEditorState();
}

class _LuckyEditorState extends State<LuckyEditor> {
  @override
  Widget build(BuildContext context) {
    final editorThemeData =
        widget.themeData ?? LuckyThemeData.fallback(context);
    return LuckyTheme(
      data: editorThemeData,
      child: Column(
        children: [
          Expanded(
            child: ExtendedTextField(
              controller: widget.controller,
              minLines: null,
              maxLines: null,
              expands: true,
              style: editorThemeData.paragraph.style,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                fillColor: Colors.grey,
              ),
              selectionHeightStyle: ui.BoxHeightStyle.max,
              selectionWidthStyle: ui.BoxWidthStyle.tight,
              strutStyle:
                  StrutStyle.fromTextStyle(editorThemeData.paragraph.style),
              enableIMEPersonalizedLearning: true,
            ),
          ),
          LuckyToolbar(),
        ],
      ),
    );
  }
}
