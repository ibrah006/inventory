import 'package:dio/dio.dart';

class ApiClient {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168..0.117:3000', // Database url
    connectTimeout: Duration(milliseconds: 5000),
    receiveTimeout: Duration(milliseconds: 3000),
  ));

  static Dio get dio => _dio;
}
