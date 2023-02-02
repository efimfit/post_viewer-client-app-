import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:it_product_client/app/app.dart';

@Singleton(as: AppApi)
class DioAppApi implements AppApi {
  late final Dio dio;
  late final Dio dioTokens;

  DioAppApi(AppConfig appConfig) {
    final options = BaseOptions(
      baseUrl: appConfig.baseUrl,
      connectTimeout: 15000,
    );
    dio = Dio(options);
    dioTokens = Dio(options);
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger());
      dioTokens.interceptors.add(PrettyDioLogger());
    }
    dio.interceptors.add(AuthInterceptor());
  }

  @override
  Future<Response> getProfile() {
    try {
      return dio.get('/auth/user');
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> refreshToken({String? refreshToken}) {
    try {
      return dioTokens.post('/auth/token/$refreshToken');
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> signIn(
      {required String username, required String password}) {
    try {
      return dio.post(
        '/auth/token',
        data: {
          'username': username,
          'password': password,
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> signUp(
      {required String password,
      required String username,
      required String email}) {
    try {
      return dio.put(
        '/auth/token',
        data: {
          'username': username,
          'password': password,
          'email': email,
        },
      );
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<Response> updatePassword(
      {required String oldPassword, required String newPassword}) {
    return dio.put(
      '/auth/user',
      queryParameters: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }

  @override
  Future<Response> updateUser({String? username, String? email}) {
    return dio.post(
      '/auth/user',
      data: {
        'username': username,
        'email': email,
      },
    );
  }

  @override
  Future request(String path) {
    try {
      return dio.request(path);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future fetch(RequestOptions requestOptions) {
    return dioTokens.fetch(requestOptions);
  }

  @override
  Future fetchPosts() {
    return dio.get('/data/posts');
  }

  @override
  Future createPosts(Map args) {
    return dio.post('/data/posts', data: {
      'name': args['name'],
      'content': args['content'],
    });
  }

  @override
  Future fetchPost(String id) {
    return dio.get('/data/posts/$id');
  }

  @override
  Future deletePost(String id) {
    return dio.delete('/data/posts/$id');
  }
}
