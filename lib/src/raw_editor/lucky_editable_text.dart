part of flutter_extended_text_field;

class LuckyEditableTextState extends ExtendedEditableTextState
    implements DeltaTextInputClient {
  @override
  TextInputConfiguration get textInputConfiguration {
    final List<String>? autofillHints =
        widget.autofillHints?.toList(growable: false);
    final AutofillConfiguration autofillConfiguration = autofillHints != null
        ? AutofillConfiguration(
            uniqueIdentifier: autofillId,
            autofillHints: autofillHints,
            currentEditingValue: currentTextEditingValue,
          )
        : AutofillConfiguration.disabled;

    return TextInputConfiguration(
      inputType: widget.keyboardType,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      enableSuggestions: widget.enableSuggestions,
      inputAction: widget.textInputAction ??
          (widget.keyboardType == TextInputType.multiline
              ? TextInputAction.newline
              : TextInputAction.done),
      textCapitalization: widget.textCapitalization,
      keyboardAppearance: widget.keyboardAppearance,
      autofillConfiguration: autofillConfiguration,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      enableDeltaModel: true,
    );
  }

  @override
  void userUpdateTextEditingValue(
      TextEditingValue value, SelectionChangedCause? cause) {
    // if (value.selection.start == 0 && value.selection.end == 0) {
    //   value = value.copyWith(
    //     selection: value.selection.copyWith(
    //       baseOffset: value.selection.baseOffset + 1,
    //       extentOffset: value.selection.extentOffset + 1,
    //     ),
    //   );
    // }
    super.userUpdateTextEditingValue(value, cause);
  }

  @override
  void updateEditingValueWithDeltas(List<TextEditingDelta> deltas) {
    TextEditingValue value = currentTextEditingValue;
    final LuckyRichEditingController controller =
        widget.controller as LuckyRichEditingController;
    for (final TextEditingDelta delta in deltas) {
      value = delta.apply(value);
      if (delta is TextEditingDeltaInsertion) {
        print('插入' + delta.textInserted);
        controller.document.insert(delta.insertionOffset, delta.textInserted);
      } else if (delta is TextEditingDeltaReplacement) {
        controller.document.replace(
            delta.replacedRange.start,
            delta.replacedRange.end - delta.replacedRange.start,
            delta.replacementText);
        print('替换' + delta.replacementText);
      } else if (delta is TextEditingDeltaDeletion) {
        controller.document.delete(delta.deletedRange.start,
            delta.deletedRange.end - delta.deletedRange.start);
        print('删除' + delta.textDeleted);
      } else if (delta is TextEditingDeltaNonTextUpdate) {
        print('非文本更新');
      }
    }

    updateEditingValue(value);
  }
}

class LuckyTextField extends StatefulWidget {
  const LuckyTextField({
    Key? key,
    this.focusNode,
    this.controller,
    this.padding,
  }) : super(key: key);
  final FocusNode? focusNode;
  final LuckyRichEditingController? controller;
  final EdgeInsetsGeometry? padding;
  @override
  State<LuckyTextField> createState() => _LuckyTextFieldState();
}

class _LuckyTextFieldState extends State<LuckyTextField>
    with
        AutomaticKeepAliveClientMixin<LuckyTextField>,
        WidgetsBindingObserver,
        TickerProviderStateMixin<LuckyTextField>,
        TextSelectionDelegate
    implements DeltaTextInputClient {
  final List<InlineSpan> textSpan = [];
  TextInputConnection? _inputConnection;
  late FocusNode focusNode;
  late LuckyRichEditingController controller;

  final GlobalKey _editableKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    controller =
        widget.controller ?? LuckyRichEditingController(document: Document());
  }

  void _onTapUp(TapUpDetails details) {
    TextPosition linePosition =
        _renderParagraph.getPositionForOffset(details.localPosition);
    if (linePosition.offset >= _renderBoxes.length) {
      linePosition = TextPosition(offset: _renderBoxes.length - 1);
    }
    final textRenderParagraph =
        getText(_renderBoxes.elementAt(linePosition.offset));
    final position = textRenderParagraph.getPositionForOffset(
        textRenderParagraph.globalToLocal(details.globalPosition));
    final TextRange word = textRenderParagraph.getWordBoundary(position);
    if (position.offset >= word.end)
      print(TextSelection.fromPosition(position));
    else
      print(TextSelection(baseOffset: word.start, extentOffset: word.end));
  }

  RenderParagraph get _renderParagraph =>
      _editableKey.currentContext!.findRenderObject() as RenderParagraph;

  List<RenderBox> get _renderBoxes => _renderParagraph.getChildrenAsList();

  RenderParagraph getText(RenderBox box) {
    switch (box.runtimeType) {
      case RenderSemanticsAnnotations:
        return getText((box as RenderSemanticsAnnotations).child!);
      case RenderPadding:
        return getText((box as RenderPadding).child!);
      case RenderConstrainedBox:
        return getText((box as RenderConstrainedBox).child!);
      case RenderDecoratedBox:
        return getText((box as RenderDecoratedBox).child!);
      default:
        return box as RenderParagraph;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    textSpan.clear();
    for (final node in controller.document.root.children) {
      if (node is Line) {
        textSpan.addAll(TextLine(line: node).build(context));
      } else if (node is Block) {
        textSpan.addAll(TextBlock(block: node).build(context));
      }
      if (!node.isLast) {
        textSpan.add(const TextSpan(text: '\n'));
      }
    }
    return Focus(
      focusNode: focusNode,
      child: RawGestureDetector(
        behavior: HitTestBehavior.translucent,
        gestures: <Type, GestureRecognizerFactory>{
          TapGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
            () => TapGestureRecognizer(),
            (TapGestureRecognizer recognizer) {
              recognizer..onTapUp = _onTapUp;
            },
          ),
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: RichText(
            key: _editableKey,
            text: TextSpan(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              children: controller.document.root.children.map((e) {
                return WidgetSpan(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border(
                        left: BorderSide(width: 4, color: Colors.grey.shade300),
                      ),
                    ),
                    padding: EdgeInsets.only(left: 4),
                    child: Text(e.toPlainText()),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // child: SingleChildScrollView(
        //   padding: widget.padding,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: controller.document.root.children.map((e) {
        //       return Text(e.toPlainText());
        //     }).toList(),
        //   ),
        // ),
      ),
    );
  }

  @override
  void bringIntoView(ui.TextPosition position) {
    // TODO: implement bringIntoView
  }

  @override
  void connectionClosed() {
    // TODO: implement connectionClosed
  }

  @override
  void copySelection(SelectionChangedCause cause) {
    // TODO: implement copySelection
  }

  @override
  AutofillScope? get currentAutofillScope => throw UnimplementedError();

  @override
  TextEditingValue? get currentTextEditingValue => controller.value;

  @override
  void cutSelection(SelectionChangedCause cause) {
    // TODO: implement cutSelection
  }

  @override
  void hideToolbar([bool hideHandles = true]) {
    // TODO: implement hideToolbar
  }

  @override
  Future<void> pasteText(SelectionChangedCause cause) {
    // TODO: implement pasteText
    throw UnimplementedError();
  }

  @override
  void performAction(TextInputAction action) {
    // TODO: implement performAction
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {
    // TODO: implement performPrivateCommand
  }

  @override
  void selectAll(SelectionChangedCause cause) {
    // TODO: implement selectAll
  }

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    // TODO: implement showAutocorrectionPromptRect
  }

  @override
  TextEditingValue get textEditingValue => controller.value;

  TextInputConfiguration get textInputConfiguration {
    return TextInputConfiguration(
      enableDeltaModel: true,
      inputType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      autocorrect: true,
      enableSuggestions: true,
      inputAction: TextInputAction.newline,
      keyboardAppearance: MediaQuery.of(context).platformBrightness,
    );
  }

  @override
  void updateEditingValue(TextEditingValue value) {
    // TODO: implement updateEditingValue
  }

  @override
  void updateEditingValueWithDeltas(List<TextEditingDelta> textEditingDeltas) {
    // TODO: implement updateEditingValueWithDeltas
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    // TODO: implement updateFloatingCursor
  }

  @override
  void userUpdateTextEditingValue(
      TextEditingValue value, SelectionChangedCause cause) {
    // TODO: implement userUpdateTextEditingValue
  }

  @override
  bool get wantKeepAlive => true;
}
