library flutter_okta;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';
import 'package:web_auth/web_auth.dart';

class FlutterOkta {
  FlutterOkta._();

  static FlutterOkta I = FlutterOkta._();

  /// OpenID Connect & OAuth 2.0
  /// https://developer.okta.com/docs/reference/api/oidc/#authorize
  /// Okta OpenID login
  /// Return <idToken, accessToken>
  Future<Tuple2<String, String>> openIdOktaLogin(BuildContext context,
      String oktaDomain, String clientId, String redirectUri) async {
    return openIdSocialLogin(context, null, oktaDomain, clientId, redirectUri);
  }

  /// Social OpenID login
  Future<Tuple2<String, String>> openIdSocialLogin(
      BuildContext context,
      String idpId,
      String oktaDomain,
      String clientId,
      String redirectUri) async {
    try {
      String authorizationUrl =
          '$oktaDomain/oauth2/v1/authorize?client_id=$clientId&response_type=id_token%20token&response_mode=fragment&scope=openid&redirect_uri=$redirectUri&state=any&nonce=any&prompt=login';
      if (idpId != null) {
        authorizationUrl += '&idp=$idpId';
      }
      final String result =
          await WebAuth.open(context, authorizationUrl, redirectUri);

      if (result == null) {
        return null;
      }
      // Extract token from resulting url
      final Uri token = Uri.parse(result);
      // Just for easy parsing
      final String normalUrl = 'http://website/index.html?${token.fragment}';
      final Uri parser = Uri.parse(normalUrl);
      final String idToken = parser.queryParameters['id_token'];
      final String accessToken = parser.queryParameters['access_token'];
      return Tuple2(idToken, accessToken);
    } catch (e) {
      return null;
    }
  }

  /// https://developer.okta.com/docs/reference/api/authn/
  Future<Response<Map<String, dynamic>>> restLogin(
      String oktaDomain, String email, String password) async {
    final Options options = Options(
        headers: <String, String>{}, contentType: Headers.jsonContentType);
    final Dio dio = Dio();
    if (!kReleaseMode) {
      dio.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));
    }
    return dio.post<Map<String, dynamic>>('$oktaDomain/api/v1/authn',
        options: options,
        data: <String, String>{
          'username': email,
          'password': password,
        });
  }

  /// https://developer.okta.com/docs/reference/api/users/#create-user-with-password
  Future<Response<Map<String, dynamic>>> restRegister(
      String oktaDomain,
      String oktaApiKey,
      String firstName,
      String lastName,
      String email,
      String password) async {
    final Options options = Options(
        headers: <String, String>{}, contentType: Headers.jsonContentType);
    options.headers
        .addAll(<String, String>{'Authorization': 'SSWS $oktaApiKey'});
    final Dio dio = Dio();
    if (!kReleaseMode) {
      dio.interceptors
          .add(LogInterceptor(responseBody: true, requestBody: true));
    }
    return dio.post<Map<String, dynamic>>(
        '$oktaDomain/api/v1/users?activate=true',
        options: options,
        data: <String, dynamic>{
          'profile': <String, String>{
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'login': email,
          },
          'credentials': <String, dynamic>{
            'password': <String, String>{
              'value': password,
            },
          },
        });
  }
}
