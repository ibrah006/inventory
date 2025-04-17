class ApiEndpoints {
  static const String products = '/products';
  static const String lookupProducts = "$products/lookup";
  static String productById(String id) => "$products/$id";

  static const String stock = '/stock';
  static const String deliveries = '/deliveries';
  static const String invoices = '/invoice';
  static const String salesOverview = '/invoiceItems/sales';
  static const String party = '/party';

  // Inventory Dashboard endpoints
  static const String dashboard = '/dashboard';
  static const String dashboardStatistics = '/dashboard/stats';
}
