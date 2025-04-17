import 'package:fl_chart/fl_chart.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:inventory/core/extensions/date_conversions.dart';
import 'package:inventory/core/models/invoice.dart';
import 'package:inventory/features/invoice/data/invoice_item.dart';
import 'package:inventory/services/invoice_item_service.dart';

class SalesOverviewChart extends StatefulWidget {
  @override
  _SalesOverviewChartState createState() => _SalesOverviewChartState();
}

class _SalesOverviewChartState extends State<SalesOverviewChart> {
  String selectedDuration = 'Last 7 Days';
  String selectedCategory = 'All';

  final List<String> durationOptions = ['Last 7 Days'];
  List<String> categoryOptions = ['All'];

  // Dummy data
  List<FlSpot> stockInSpots = [];

  List<FlSpot> stockOutSpots = [];

  @override
  Widget build(BuildContext context) {
    print("stock in spots: ${stockInSpots}");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sales overview',
          style: FluentTheme.of(context).typography.subtitle,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            ComboBox<String>(
              value: selectedDuration,
              items: durationOptions
                  .map((e) => ComboBoxItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) selectedDuration = value;
              },
            ),
            const SizedBox(width: 12),
            ComboBox<String>(
              value: selectedCategory,
              items: categoryOptions
                  .map((e) => ComboBoxItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: onSelectedCategoryChanged,
            ),
          ],
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final day = value.toInt() + 1;
                        return Text(day == 7 ? "Today" : day.toString());
                      }),
                ),
                topTitles: AxisTitles(axisNameSize: 0),
              ),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (lineBarSpot) => Colors.grey[50],
                  tooltipRoundedRadius: 5,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final y = spot.y.toStringAsFixed(2);
                      final fgColor = spot.bar.color;
                      return LineTooltipItem(
                        "\$$y",
                        TextStyle(
                          color: fgColor,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: stockInSpots,
                  // isCurved: true,
                  color: Colors.red,
                  barWidth: 2,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, bar, index) {
                      return FlDotCirclePainter(
                        radius: 3,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
                LineChartBarData(
                  spots: stockOutSpots,
                  // isCurved: true,
                  color: const Color.fromARGB(255, 25, 183, 25),
                  barWidth: 2,
                  dotData: FlDotData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onSelectedCategoryChanged(String? category) async {
    if (category != null && category != selectedCategory) {
      setState(() {
        selectedCategory = category;
      });
      await calculateChartSpots(
          category: category.toLowerCase() == "all" ? null : category);
    }
  }

  Future<void> calculateChartSpots({String? category}) async {
    categoryOptions = ['All'];

    List<FlSpot?> stockInSpots = List.generate(7, (index) => null);
    List<FlSpot?> stockOutSpots = List.generate(7, (index) => null);

    // days in integer
    const int salesOverviewFor = 7;

    final sales = await InvoiceItemService.getSalesOverview();

    for (List<InvoiceItem> categories in sales) {
      print("categories: $categories");
      for (InvoiceItem invoiceItem in categories) {
        if (!categoryOptions.contains(invoiceItem.category)) {
          categoryOptions.add(invoiceItem.category ?? "Uncategorized");
        }

        final chartY = invoiceItem.amountNonTransformed;
        final isPurchaseInvoice =
            invoiceItem.invoice.type == InvoiceType.purchase;

        final daysAgo = DateFormat("dd/MM/yyyy")
            .parse(invoiceItem.invoice.issueDate)
            .daysAgo();

        final categoryCheckNot =
            category != null ? invoiceItem.category != category : false;

        final chartX = salesOverviewFor - daysAgo - 1;
        // if categoryCheckNot == false then it means no category has passed in
        if (categoryCheckNot || chartX < 0 || chartX > 6) {
          continue;
        }

        final FlSpot? spot = stockInSpots[chartX];

        final updatedSpot =
            FlSpot(chartX.toDouble(), spot != null ? spot.y + chartY : chartY);

        if (isPurchaseInvoice) {
          stockInSpots[chartX] = updatedSpot;
        } else {
          stockOutSpots[chartX] = updatedSpot;
        }
      }
    }

    print("stockInSpots: ${stockInSpots}");

    this.stockInSpots = stockInSpots.asMap().entries.map((entry) {
      final index = entry.key;
      final spot = entry.value;
      return spot ?? FlSpot(index.toDouble(), 0);
    }).toList();

    this.stockOutSpots = stockOutSpots.asMap().entries.map((entry) {
      final index = entry.key;
      final spot = entry.value;
      return spot ?? FlSpot(index.toDouble(), 0);
    }).toList();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    calculateChartSpots();
  }
}
