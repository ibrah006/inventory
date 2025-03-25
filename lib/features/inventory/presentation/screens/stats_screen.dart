import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/features/inventory/presentation/widgets/date_input_box.dart';

class StatsScreen extends StatelessWidget {
  final TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(title: Text('Sales Statistics')),
      content: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdowns for Units Sold and Location
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InfoLabel(
                    label: "Show Units Sold in:",
                    child: ComboBox<String>(
                      placeholder: Text("Select Unit"),
                      items: [
                        ComboBoxItem(value: "Each", child: Text("Each")),
                        ComboBoxItem(value: "Box", child: Text("Box")),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: InfoLabel(
                    label: "For Location:",
                    child: ComboBox<String>(
                      placeholder: Text("Select Location"),
                      items: [
                        ComboBoxItem(
                            value: "Primary Location",
                            child: Text("Primary Location")),
                        ComboBoxItem(
                            value: "Secondary Location",
                            child: Text("Secondary Location")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Statistics Section
            Row(
              children: [
                // Year To Date
                Expanded(
                  child: _buildStatisticsCard(
                    context,
                    title: "Year To Date",
                    data: {
                      "No. of Transactions:": "0",
                      "Units Sold:": "0.00",
                      "Amount Sold:": "0.00",
                      "Cost of Goods Sold:": "0.00",
                    },
                  ),
                ),
                SizedBox(width: 16),

                // Last Year
                Expanded(
                  child: _buildStatisticsCard(
                    context,
                    title: "Last Year",
                    data: {
                      "No. of Transactions:": "0",
                      "Units Sold:": "0.00",
                      "Amount Sold:": "0.00",
                      "Cost of Goods Sold:": "0.00",
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Date of Last Sale
            InfoLabel(
              label: "Date of Last Sale:",
              child: Row(
                children: [
                  Expanded(child: DateTextBox(controller: dateController)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(BuildContext context,
      {required String title, required Map<String, String> data}) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withAlpha(75)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: FluentTheme.of(context).typography.subtitle,
          ),
          SizedBox(height: 16),
          for (var entry in data.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(entry.key),
                  Text(entry.value),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
