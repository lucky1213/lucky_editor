part of lucky_rich_editor;

class ToolbarButton extends StatelessWidget {
  const ToolbarButton({
    Key? key,
    this.child,
    this.padding,
    this.onTap,
  }) : super(key: key);

  final Widget? child;
  final EdgeInsets? padding;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(3),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
        onTap: onTap,
      ),
    );
  }
}
