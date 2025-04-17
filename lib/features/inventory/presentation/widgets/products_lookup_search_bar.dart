import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/config/routes.dart';
import 'package:inventory/services/product_service.dart';

class LookupSearchBar extends StatefulWidget {
  const LookupSearchBar({
    super.key,
  });

  @override
  State<LookupSearchBar> createState() => _LookupSearchBarState();
}

class _LookupSearchBarState extends State<LookupSearchBar> {
  bool showSearchBar = false;
  bool canSearch = false;

  int selected = 0;

  static const options = ["ID", "Name", "Barcode"];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 3.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: List.generate(options.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 10),
              child: RadioButton(
                  checked: selected == index,
                  content: Text(options[index]),
                  onChanged: (checked) {
                    if (checked) {
                      setState(() => selected = index);
                    }
                  }),
            );
          }),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: width,
          child: TextBox(
            onSubmitted: search,
            placeholder:
                "Enter Item${options.isNotEmpty ? " ${options[selected]}" : ""}",
          ),
        ),
      ],
    );
  }

  void search(String newValue) async {
    final results = await ProductService.productsLookup(
        id: selected == 0 ? newValue : null,
        name: selected == 1 ? newValue : null,
        barcode: selected == 2 ? newValue : null);

    print("results from products lookup: ${results}");

    if (!mounted) return;

    Navigator.pushNamed(context, AppRoutes.productsLookupResults,
        arguments: results);
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Row(
  //     children: [
  //       AnimatedContainer(
  //           duration: Duration(milliseconds: 200),
  //           width: showSearchBar ? 10 : 0),
  //       AnimatedContainer(
  //           duration: Duration(milliseconds: 200),
  //           width: showSearchBar ? 175 : 0,
  //           child: TextBox(
  //               onChanged: (value) {
  //                 if (canSearch == value.isEmpty) {
  //                   setState(() {
  //                     canSearch = value.isNotEmpty;
  //                   });
  //                 }
  //               },
  //               controller: _controller)),
  //       SizedBox(width: 5),
  //       IconButton(
  //           style: !canSearch
  //               ? null
  //               : ButtonStyle(
  //                   foregroundColor: WidgetStatePropertyAll(Colors.white),
  //                   backgroundColor: WidgetStatePropertyAll(Colors.blue)),
  //           icon: const Icon(FluentIcons.search),
  //           onPressed: () {
  //             if (showSearchBar && _controller.text.isNotEmpty) {
  //             } else {
  //               setState(() {
  //                 showSearchBar = !showSearchBar;
  //               });
  //             }
  //           })
  //     ],
  //   );
  // }
}
