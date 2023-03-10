import 'package:dio/dio.dart';

abstract class AppApi {
  Future<dynamic> signUp({
    required String password,
    required String username,
    required String email,
  });

  Future<dynamic> signIn({
    required String username,
    required String password,
  });

  Future<dynamic> getProfile();

  Future<dynamic> updateUser({String? username, String? email});

  Future<dynamic> updatePassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<dynamic> refreshToken({String? refreshToken});

  Future<dynamic> request(String path);

  Future<dynamic> fetch(RequestOptions requestOptions);

  Future<dynamic> fetchPosts();

  Future<dynamic> fetchPost(String id);

  Future<dynamic> createPosts(Map args);

  Future<dynamic> deletePost(String id);
}
