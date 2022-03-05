library lucky_rich_editor;

import 'dart:collection';
import 'dart:convert';
import 'dart:ui' as ui hide TextStyle;
import 'package:flutter/material.dart';

import 'package:lucky_rich_editor/src/models/documents/document.dart';
import 'package:lucky_rich_editor/src/raw_editor/extended_textfield.dart';
import 'package:tuple/tuple.dart';

export 'package:lucky_rich_editor/src/models/documents/document.dart';

part 'src/iconfont.dart';
part 'src/widgets/editor.dart';
part 'src/widgets/toolbar.dart';
part 'src/widgets/toolbar/toolbar_button.dart';
part 'src/editing_controller.dart';
part 'src/widgets/text_line.dart';
part 'src/widgets/text_block.dart';
part 'src/themes/theme.dart';
part 'src/themes/inline_code_theme.dart';
part 'src/themes/text_block_theme.dart';

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}
