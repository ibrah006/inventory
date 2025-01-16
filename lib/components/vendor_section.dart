import 'package:fluent_ui/fluent_ui.dart';

List<String> vendors = [
  'Apple Inc.',
  'Samsung Electronics',
  'Sony Corporation',
  'LG Electronics',
  'Microsoft Corporation',
  'Intel Corporation',
  'Dell Technologies',
  'HP Inc.',
  'Lenovo Group',
  'Panasonic Corporation',
  'Bosch',
  'Huawei Technologies',
  'Xiaomi Corporation',
  'Nokia',
  'Canon Inc.',
  'Bose Corporation',
  'Seagate Technology',
  'Western Digital',
  'Philips',
  'Sharp Corporation',
  'Toshiba Corporation',
  'Acer Inc.',
  'Asus Computer International',
  'Corsair Components',
  'Razer Inc.',
  'Vizio Inc.',
  'Electrolux AB',
  'KitchenAid',
  'Whirlpool Corporation',
  'GE Appliances',
  'Miele',
  'Frigidaire',
  'Coca-Cola Company',
  'PepsiCo',
  'Nestlé S.A.',
  'Unilever',
  'Procter & Gamble',
  'Johnson & Johnson',
  'Mondelez International',
  'Colgate-Palmolive',
  'Kimberly-Clark',
  'General Mills',
  'Mars, Inc.',
  'Hershey Company',
  'Toyota Motor Corporation',
  'Ford Motor Company',
  'Volkswagen Group',
  'General Motors',
  'Honda Motor Co.',
  'BMW AG',
  'Mercedes-Benz',
  'Audi AG',
  'Nissan Motor Co.',
  'Hyundai Motor Company',
  'Tesla, Inc.',
  'BMW',
  'Porsche',
  'Ferrari',
  'Rolex SA',
  'Swatch Group',
  'Tag Heuer',
  'Omega SA',
];

class VendorSection extends StatefulWidget {
  @override
  _VendorSectionState createState() => _VendorSectionState();
}

class _VendorSectionState extends State<VendorSection> {
  List<String> vendors = ['Vendor 1', 'Vendor 2', 'Vendor 3'];
  bool isVendorListOpen = false;

  // Function to add/select a new vendor
  void addVendor(String vendor) {
    setState(() {
      vendors.add(vendor);
    });
  }

  String selectedVendor = "";

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vendor",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Button(child: Text("Open vendor list"), onPressed: () {})
          ],
        ),
        Expanded(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(width: 1, color: Colors.grey.withAlpha(75))),
              child: SizedBox(
                height: 90,
                child: ListView(
                    children: List.generate(vendors.length, (index) {
                  final vendor = vendors[index];
                  return ListTile.selectable(
                    title: Text(vendor),
                    contentPadding: EdgeInsets.zero,
                    selectionMode: ListTileSelectionMode.single,
                    selected: selectedVendor == vendor,
                    onSelectionChange: (v) =>
                        setState(() => selectedVendor = vendor),
                  );
                })),
              )),
        )
      ],
    );
  }
}

class AddVendorDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return ContentDialog(
      title: Text('Add New Vendor'),
      content: Column(
        children: [
          TextBox(
            controller: controller,
            placeholder: 'Enter Vendor Name',
            autofocus: true,
          ),
        ],
      ),
      actions: [
        Button(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Button(
          child: Text('Add'),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      ],
    );
  }
}
