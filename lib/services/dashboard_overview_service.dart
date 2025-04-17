import 'dart:convert';

import 'package:inventory/core/api/api_client.dart';
import 'package:inventory/core/api/enpoints.dart';
import 'package:inventory/features/inventory/data/dashboard_stats.dart';

class DashboardOverviewService {
  static final LocalHttp _http = ApiClient.http;

  static Future<DashboardStats> getDashboardStatistics() async {
    final response = await _http.get(ApiEndpoints.dashboardStatistics);

    return DashboardStats.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  }
}
