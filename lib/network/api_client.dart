import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:punk_api/model/beer.dart';

class APIClient {
  static final _instance = APIClient.private();

  factory APIClient() => _instance;

  Dio _dio;

  @visibleForTesting
  APIClient.private() {
    final options = BaseOptions(
      baseUrl: 'https://api.punkapi.com/v2',
      connectTimeout: 30000,
      receiveTimeout: 30000,
    );
    _dio = Dio(options);
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
      ),
    );
  }

  Future<List<Beer>> getBeers({
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final res = await _dio.get(
        '/beers',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      if (res.statusCode == HttpStatus.ok) {
        final List list = res.data;
        return list.map((json) => Beer.fromJson(json)).toList();
      } else {
        throw res.statusMessage;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Beer> getBeerDetail({double id}) async {
    try {
      final res = await _dio.get('/beers/${id.toInt()}');
      if (res.statusCode == HttpStatus.ok) {
        return Beer.fromJson(res.data[0]);
      } else {
        throw res.statusMessage;
      }
    } catch (e) {
      rethrow;
    }
  }
}
