import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mpsf_app/common/config/config.dart';
import 'package:mpsf_app/common/local/local_storage.dart';

/*
AuthInterceptor：主要作用在请求内加入http中header的信息：
*/
class AuthInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options) async {
    String accessToken;
    String authorizationCodeRespone =
        await LocalStorage.get(Config.Authorization_Code_Respone);
    String clientCredentialsRespone =
        await LocalStorage.get(Config.Client_Credentials_Respone);

    if (authorizationCodeRespone != null) {
      Map object = json.decode(authorizationCodeRespone);
      accessToken = object["access_token"];
    } else if (clientCredentialsRespone != null) {
      Map object = json.decode(clientCredentialsRespone);
      accessToken = object["access_token"];
    }

    if (accessToken != null && accessToken != '') {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    return super.onRequest(options);
  }
}
