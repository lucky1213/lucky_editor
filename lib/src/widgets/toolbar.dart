part of lucky_rich_editor;

class LuckyToolbar extends StatefulWidget {
  const LuckyToolbar({Key? key}) : super(key: key);

  @override
  LuckyToolbarState createState() => LuckyToolbarState();
}

class LuckyToolbarState extends State<LuckyToolbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: Row(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ToolbarButton(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      IconFont.icon_keyboard,
                      size: 24,
                    ),
                  ),
                  // padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                  onTap: () {},
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      ToolbarButton(
                        child: Icon(
                          IconFont.icon_unkeyboard,
                          size: 24,
                        ),
                        onTap: () {},
                        padding: EdgeInsets.all(6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
