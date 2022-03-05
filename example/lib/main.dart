import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lucky_rich_editor/lucky_rich_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: Locale('zh', 'CH'),
      supportedLocales: [
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// [
//   {
//     'type': 'paragraph',
//     'children': [
//       {'text': '纯文本 '},
//     ]
//   },
//   {
//     'type': 'paragraph',
//     'children': [
//       {'text': '321'},
//     ]
//   }
// ]

class _MyHomePageState extends State<MyHomePage> {
  final LuckyRichEditingController _controller =
      LuckyRichEditingController.fromJson(
          r'''[{"insert": "Lucky Editor"},{"insert": "\n", "attributes": {"header": 1}},{"insert": "Rich text editor for Flutter"},{
    "attributes": {
      "header": 2
    },
    "insert": "\n"
  }, {
    "insert": "this is a check list"
  },
  {
    "attributes": {
      "blockquote": true 
    },
    "insert": "\n"
  }, {
    "insert": "this is a check list2"
  },
  {
    "attributes": {
      "blockquote": true 
    },
    "insert": "\n"
  },{"insert": "This library is a WYSIWYG editor built for the modern mobile platform.\n"}]''');
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
        print(_controller.document.toDelta());
        print(_controller.value.text.length);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: LuckyEditor(
          controller: _controller,
        ),
      ),
    );
  }
}
// child: ExtendedTextField(
//             controller: _controller,
//             // maxLines: 10,
//             minLines: null,
//             maxLines: null,
//             expands: true,
//           ),
