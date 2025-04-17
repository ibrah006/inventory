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

class VendorListScreen extends StatefulWidget {
  @override
  _VendorListScreenState createState() => _VendorListScreenState();
}

class _VendorListScreenState extends State<VendorListScreen> {
  // Selected vendor
  String? selectedVendor;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text('Vendor'),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the selected vendor
            Row(
              children: [
                Text(
                  selectedVendor != null
                      ? 'Selected Vendor: '
                      : 'No vendor selected',
                  style: FluentTheme.of(context).typography.bodyLarge,
                ),
                if (selectedVendor != null)
                  Text(
                    selectedVendor!,
                    style: FluentTheme.of(context)
                        .typography
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  )
              ],
            ),
            SizedBox(height: 16.0),
            // ListView with Selectable List Tiles
            Expanded(
              child: ListView.builder(
                itemCount: vendors.length,
                itemBuilder: (context, index) {
                  final vendor = vendors[index];
                  return SizedBox(
                    height: 25,
                    child: ListTile.selectable(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        vendor,
                        style: FluentTheme.of(context)
                            .typography
                            .body // Standard text style for list tiles
                            ?.copyWith(fontSize: 13),
                      ),
                      selected: selectedVendor == vendor,
                      onPressed: () {
                        setState(() {
                          selectedVendor = vendor; // Update selected vendor
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
