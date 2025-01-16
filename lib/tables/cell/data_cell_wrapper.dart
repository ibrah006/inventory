import 'package:flutter/material.dart';
import 'package:inventory/components/popup/popup_helper.dart';

class DataCellWrapper extends StatefulWidget {
  final Widget child;
  final int flex;
  final Color? fillColor;
  final bool isHeader;
  final PopupHelper? popup;

  final GestureTapCallback? onPressed;

  static final BORDER_COLOR = Colors.grey.shade300;

  static EdgeInsets DEFAULT_PADDING(bool isCenter) =>
      EdgeInsets.symmetric(vertical: 8.5).copyWith(left: isCenter ? 0 : 20);

  DataCellWrapper(
      {required this.child,
      this.flex = 1,
      this.fillColor,
      this.isHeader = false,
      isCenter = false,
      padding,
      this.onPressed,
      this.popup}) {
    this.isCenter = !isCenter ? isHeader : isCenter;
    this.padding = padding ?? DEFAULT_PADDING(this.isCenter);
  }

  late final bool isCenter;
  late final EdgeInsetsGeometry padding;

  @override
  State<DataCellWrapper> createState() => _DataCellWrapperState();
}

class _DataCellWrapperState extends State<DataCellWrapper> {
  MenuController _menuController = MenuController();

  Widget get childWidget {
    final resultChild = widget.isHeader
        ? DefaultTextStyle(
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black.withOpacity(.8)),
            child: widget.child,
          )
        : DefaultTextStyle(
            child: widget.child,
            style: TextStyle(fontSize: 12),
          );

    return widget.popup != null
        ? MenuAnchor(
            style: MenuStyle(
                elevation: WidgetStatePropertyAll(3),
                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3)))),
            //TODO:
            // controller: popup!.controller,
            controller: _menuController,
            builder: (BuildContext context, MenuController controller,
                Widget? child) {
              return Tooltip(
                message: widget.popup!.popupTooltip,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    textStyle: TextStyle(fontSize: 12),
                  ),
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: this.widget.child,
                ),
              );
            },
            menuChildren: [widget.popup!.content])
        : resultChild;
  }

  final borderSide = BorderSide(width: 1, color: DataCellWrapper.BORDER_COLOR);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: widget.flex,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Container(
              padding: widget.popup != null ? EdgeInsets.zero : widget.padding,
              alignment: widget.isCenter ? Alignment.center : null,
              decoration: BoxDecoration(
                  color: widget.fillColor,
                  border: Border(
                      right: borderSide,
                      bottom: borderSide,
                      top: widget.isHeader ? borderSide : BorderSide.none),
                  borderRadius: BorderRadius.circular(1)),
              child: childWidget),
        ));
  }
}
