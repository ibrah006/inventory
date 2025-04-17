import 'package:fluent_ui/fluent_ui.dart';
import 'package:inventory/features/inventory/data/dashboard_stats.dart';
import 'package:inventory/services/dashboard_overview_service.dart';

class DashboardStatsSection extends StatefulWidget {
  const DashboardStatsSection({super.key});

  @override
  State<DashboardStatsSection> createState() => _DashboardStatsSectionState();
}

class _DashboardStatsSectionState extends State<DashboardStatsSection> {
  late DashboardStats stats;

  @override
  Widget build(BuildContext context) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard Statistics',
            style: FluentTheme.of(context).typography.subtitle,
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                icon: FluentIcons.product,
                title: 'Total Products',
                value: stats.productsCount.toString(),
                backgroundColor: Colors.grey[10],
              ),
              _StatCard(
                icon: FluentIcons.cube_shape,
                title: 'Items In Stock',
                value: stats.itemsInStock.toString(),
                backgroundColor: Colors.grey[10],
              ),
              _StatCard(
                icon: FluentIcons.warning,
                title: 'Low Stock Alerts',
                value: stats.lowStockItems.length.toString(),
                backgroundColor: Colors.orange.withOpacity(0.15),
                textColor: Colors.orange.dark,
                iconColor: Colors.orange.dark,
              ),
              _StatCard(
                icon: FluentIcons.download,
                title: 'Recent Purchases',
                value: stats.recentPurchases.length.toString(),
                backgroundColor: Colors.grey[10],
              ),
              _StatCard(
                icon: FluentIcons.upload,
                title: 'Recent Sales',
                value: stats.recentSales.length.toString(),
                backgroundColor: Colors.grey[10],
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      return SizedBox();
    }
  }

  @override
  void initState() {
    super.initState();

    DashboardOverviewService.getDashboardStatistics().then((stats) {
      setState(() {
        this.stats = stats;
      });
    });
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final typography = FluentTheme.of(context).typography;

    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[10],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[30]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: iconColor ?? Colors.grey[120]),
          const SizedBox(height: 8),
          Text(
            title,
            style: typography.caption!.copyWith(
              color: textColor ?? Colors.grey[110],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: typography.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
