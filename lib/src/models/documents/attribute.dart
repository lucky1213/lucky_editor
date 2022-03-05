part of rich_editor_document;

enum AttributeScope {
  inline, // refer to https://quilljs.com/docs/formats/#inline
  block, // refer to https://quilljs.com/docs/formats/#block
  embeds, // refer to https://quilljs.com/docs/formats/#embeds
  ignore, // attributes that can be ignored
}

class Attribute<T> {
  Attribute(this.key, this.scope, this.value);

  /// Unique key of this attribute.
  final String key;
  final AttributeScope scope;
  final T value;

  static final Map<String, Attribute> _registry = LinkedHashMap.of({
    Attribute.bold.key: Attribute.bold,
    Attribute.italic.key: Attribute.italic,
    Attribute.small.key: Attribute.small,
    Attribute.underline.key: Attribute.underline,
    Attribute.strikeThrough.key: Attribute.strikeThrough,
    Attribute.inlineCode.key: Attribute.inlineCode,
    Attribute.font.key: Attribute.font,
    Attribute.size.key: Attribute.size,
    Attribute.link.key: Attribute.link,
    Attribute.color.key: Attribute.color,
    Attribute.background.key: Attribute.background,
    Attribute.placeholder.key: Attribute.placeholder,
    Attribute.header.key: Attribute.header,
    Attribute.align.key: Attribute.align,
    Attribute.direction.key: Attribute.direction,
    Attribute.list.key: Attribute.list,
    Attribute.codeBlock.key: Attribute.codeBlock,
    Attribute.blockQuote.key: Attribute.blockQuote,
    Attribute.indent.key: Attribute.indent,
    Attribute.width.key: Attribute.width,
    Attribute.height.key: Attribute.height,
    Attribute.style.key: Attribute.style,
    Attribute.token.key: Attribute.token,
    Attribute.script.key: Attribute.script,
  });

  static final BoldAttribute bold = BoldAttribute();

  static final ItalicAttribute italic = ItalicAttribute();

  static final SmallAttribute small = SmallAttribute();

  static final UnderlineAttribute underline = UnderlineAttribute();

  static final StrikeThroughAttribute strikeThrough = StrikeThroughAttribute();

  static final InlineCodeAttribute inlineCode = InlineCodeAttribute();

  static final FontAttribute font = FontAttribute(null);

  static final SizeAttribute size = SizeAttribute(null);

  static final LinkAttribute link = LinkAttribute(null);

  static final ColorAttribute color = ColorAttribute(null);

  static final BackgroundAttribute background = BackgroundAttribute(null);

  static final PlaceholderAttribute placeholder = PlaceholderAttribute();

  static final HeaderAttribute header = HeaderAttribute();

  static final IndentAttribute indent = IndentAttribute();

  static final AlignAttribute align = AlignAttribute(null);

  static final ListAttribute list = ListAttribute(null);

  static final CodeBlockAttribute codeBlock = CodeBlockAttribute();

  static final BlockQuoteAttribute blockQuote = BlockQuoteAttribute();

  static final DirectionAttribute direction = DirectionAttribute(null);

  static final WidthAttribute width = WidthAttribute(null);

  static final HeightAttribute height = HeightAttribute(null);

  static final StyleAttribute style = StyleAttribute(null);

  static final TokenAttribute token = TokenAttribute('');

  static final ScriptAttribute script = ScriptAttribute('');

  static const String mobileWidth = 'mobileWidth';

  static const String mobileHeight = 'mobileHeight';

  static const String mobileMargin = 'mobileMargin';

  static const String mobileAlignment = 'mobileAlignment';

  static final Set<String> inlineKeys = {
    Attribute.bold.key,
    Attribute.italic.key,
    Attribute.small.key,
    Attribute.underline.key,
    Attribute.strikeThrough.key,
    Attribute.link.key,
    Attribute.color.key,
    Attribute.background.key,
    Attribute.placeholder.key,
  };

  static final Set<String> blockKeys = LinkedHashSet.of({
    Attribute.header.key,
    Attribute.align.key,
    Attribute.list.key,
    Attribute.codeBlock.key,
    Attribute.blockQuote.key,
    Attribute.indent.key,
    Attribute.direction.key,
  });

  static final Set<String> blockKeysExceptHeader = LinkedHashSet.of({
    Attribute.list.key,
    Attribute.align.key,
    Attribute.codeBlock.key,
    Attribute.blockQuote.key,
    Attribute.indent.key,
    Attribute.direction.key,
  });

  static final Set<String> exclusiveBlockKeys = LinkedHashSet.of({
    Attribute.header.key,
    Attribute.list.key,
    Attribute.codeBlock.key,
    Attribute.blockQuote.key,
  });

  static Attribute<int?> get h1 => HeaderAttribute(level: 1);

  static Attribute<int?> get h2 => HeaderAttribute(level: 2);

  static Attribute<int?> get h3 => HeaderAttribute(level: 3);

  // "attributes":{"align":"left"}
  static Attribute<String?> get leftAlignment => AlignAttribute('left');

  // "attributes":{"align":"center"}
  static Attribute<String?> get centerAlignment => AlignAttribute('center');

  // "attributes":{"align":"right"}
  static Attribute<String?> get rightAlignment => AlignAttribute('right');

  // "attributes":{"align":"justify"}
  static Attribute<String?> get justifyAlignment => AlignAttribute('justify');

  // "attributes":{"list":"bullet"}
  static Attribute<String?> get ul => ListAttribute('bullet');

  // "attributes":{"list":"ordered"}
  static Attribute<String?> get ol => ListAttribute('ordered');

  // "attributes":{"list":"checked"}
  static Attribute<String?> get checked => ListAttribute('checked');

  // "attributes":{"list":"unchecked"}
  static Attribute<String?> get unchecked => ListAttribute('unchecked');

  // "attributes":{"direction":"rtl"}
  static Attribute<String?> get rtl => DirectionAttribute('rtl');

  // "attributes":{"indent":1"}
  static Attribute<int?> get indentL1 => IndentAttribute(level: 1);

  // "attributes":{"indent":2"}
  static Attribute<int?> get indentL2 => IndentAttribute(level: 2);

  // "attributes":{"indent":3"}
  static Attribute<int?> get indentL3 => IndentAttribute(level: 3);

  static Attribute<int?> getIndentLevel(int? level) {
    if (level == 1) {
      return indentL1;
    }
    if (level == 2) {
      return indentL2;
    }
    if (level == 3) {
      return indentL3;
    }
    return IndentAttribute(level: level);
  }

  bool get isInline => scope == AttributeScope.inline;

  bool get isBlockExceptHeader => blockKeysExceptHeader.contains(key);

  Map<String, dynamic> toJson() => <String, dynamic>{key: value};

  static Attribute? fromKeyValue(String key, dynamic value) {
    final origin = _registry[key];
    if (origin == null) {
      return null;
    }
    final attribute = clone(origin, value);
    return attribute;
  }

  static int getRegistryOrder(Attribute attribute) {
    var order = 0;
    for (final attr in _registry.values) {
      if (attr.key == attribute.key) {
        break;
      }
      order++;
    }

    return order;
  }

  static Attribute clone(Attribute origin, dynamic value) {
    return Attribute(origin.key, origin.scope, value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Attribute) return false;
    final typedOther = other;
    return key == typedOther.key &&
        scope == typedOther.scope &&
        value == typedOther.value;
  }

  @override
  int get hashCode => hash3(key, scope, value);

  @override
  String toString() {
    return 'Attribute{key: $key, scope: $scope, value: $value}';
  }
}

class BoldAttribute extends Attribute<bool> {
  BoldAttribute() : super('bold', AttributeScope.inline, true);
}

class ItalicAttribute extends Attribute<bool> {
  ItalicAttribute() : super('italic', AttributeScope.inline, true);
}

class SmallAttribute extends Attribute<bool> {
  SmallAttribute() : super('small', AttributeScope.inline, true);
}

class UnderlineAttribute extends Attribute<bool> {
  UnderlineAttribute() : super('underline', AttributeScope.inline, true);
}

class StrikeThroughAttribute extends Attribute<bool> {
  StrikeThroughAttribute() : super('strike', AttributeScope.inline, true);
}

class InlineCodeAttribute extends Attribute<bool> {
  InlineCodeAttribute() : super('code', AttributeScope.inline, true);
}

class FontAttribute extends Attribute<String?> {
  FontAttribute(String? val) : super('font', AttributeScope.inline, val);
}

class SizeAttribute extends Attribute<String?> {
  SizeAttribute(String? val) : super('size', AttributeScope.inline, val);
}

class LinkAttribute extends Attribute<String?> {
  LinkAttribute(String? val) : super('link', AttributeScope.inline, val);
}

class ColorAttribute extends Attribute<String?> {
  ColorAttribute(String? val) : super('color', AttributeScope.inline, val);
}

class BackgroundAttribute extends Attribute<String?> {
  BackgroundAttribute(String? val)
      : super('background', AttributeScope.inline, val);
}

/// This is custom attribute for hint
class PlaceholderAttribute extends Attribute<bool> {
  PlaceholderAttribute() : super('placeholder', AttributeScope.inline, true);
}

class HeaderAttribute extends Attribute<int?> {
  HeaderAttribute({int? level}) : super('header', AttributeScope.block, level);
}

class IndentAttribute extends Attribute<int?> {
  IndentAttribute({int? level}) : super('indent', AttributeScope.block, level);
}

class AlignAttribute extends Attribute<String?> {
  AlignAttribute(String? val) : super('align', AttributeScope.block, val);
}

class ListAttribute extends Attribute<String?> {
  ListAttribute(String? val) : super('list', AttributeScope.block, val);
}

class CodeBlockAttribute extends Attribute<bool> {
  CodeBlockAttribute() : super('code-block', AttributeScope.block, true);
}

class BlockQuoteAttribute extends Attribute<bool> {
  BlockQuoteAttribute() : super('blockquote', AttributeScope.block, true);
}

class DirectionAttribute extends Attribute<String?> {
  DirectionAttribute(String? val)
      : super('direction', AttributeScope.block, val);
}

class WidthAttribute extends Attribute<String?> {
  WidthAttribute(String? val) : super('width', AttributeScope.ignore, val);
}

class HeightAttribute extends Attribute<String?> {
  HeightAttribute(String? val) : super('height', AttributeScope.ignore, val);
}

class StyleAttribute extends Attribute<String?> {
  StyleAttribute(String? val) : super('style', AttributeScope.ignore, val);
}

class TokenAttribute extends Attribute<String> {
  TokenAttribute(String val) : super('token', AttributeScope.ignore, val);
}

// `script` is supposed to be inline attribute but it is not supported yet
class ScriptAttribute extends Attribute<String> {
  ScriptAttribute(String val) : super('script', AttributeScope.ignore, val);
}
