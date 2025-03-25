import 'package:fluent_ui/fluent_ui.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard(
      {super.key,
      required this.child,
      this.margin,
      this.disableShadow = false});

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final bool disableShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: margin,
        padding: EdgeInsets.all(19),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: disableShadow
                ? null
                : [
                    BoxShadow(
                        color: Colors.grey[30],
                        spreadRadius: 6.0,
                        blurRadius: 6.0)
                  ],
            color: Colors.white),
        child: child);
  }
}
