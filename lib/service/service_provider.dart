import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

abstract class ServiceProvider {
  static final String _baseEndpoint = 'https://api.cryptowat.ch/';

  Future<Response> httpGet({@required String service}) async {
    assert(!service.startsWith('/'), 'The parameter cannot start with "/"!');

    final Dio dio = Dio();
    final String endpoint = _baseEndpoint + service;
    try {
      return await dio.get(endpoint);
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");

      throw Exception(error);
    }
  }
}
