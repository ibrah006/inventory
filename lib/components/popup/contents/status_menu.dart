import 'package:flutter/rendering.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/components/divider.dart';

class StatusMenu extends StatelessWidget {
  const StatusMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey.withOpacity(0.5),
          //     spreadRadius: 5,
          //     blurRadius: 7,
          //     offset: Offset(0, 3), // changes position of shadow
          //   ),
          // ],
        ),
        child: SingleChildScrollView(
            child: Column(children: [
          ...List.generate(3, (index) {
            final color = [
              Color(0xFF00c875),
              Color(0xFFdf2f4a),
              Color(0xFFc4c4c4)
            ][index];

            final orderStatus = ["On Order", "Not Ordered", ""][index];

            return Container(
                margin: EdgeInsets.all(5).copyWith(bottom: 0),
                color: color,
                width: 150,
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                child: Text(orderStatus,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)));
          }),
          SizedBox(height: 10),
          CustomDivider(),
          SizedBox(height: 10),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Button(
                onPressed: () {},
                style: ButtonStyle(
                    // backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    // shape: WidgetStatePropertyAll(
                    //     RoundedRectangleBorder(side: BorderSide.none))
                    ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FluentIcons.edit),
                    SizedBox(width: 10),
                    Text("Edit Labels")
                  ],
                )),
          )
        ])));
  }
}
