import 'dart:convert';
import 'dart:developer';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:yangdonge_client/model/response/auth/sign_in_response.dart';
import 'package:yangdonge_client/model/response/auth/user_check_response.dart';
import 'package:http/http.dart' as http;
import 'package:yangdonge_client/model/response/response_dto.dart';

abstract class AuthService {
  static const String baseUrl = "http://10.0.2.2:4040/api/v1/auth";
  final clientIds = {
    "naver": "OJwFoWECcjPN0SWB8tDi",
    "kakao": "4b69ceabe1d6983cb63ab8f99be6e515",
  };

  // 소셜 로그인
  static Future<SignInResponse> signIn(String id, String email) async {
    final url = Uri.parse("$baseUrl/sign-in");
    Map<String, String> requestBody = {
      "userId": id,
      "email": email,
    };

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return SignInResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to sign in: ${ResponseDto.fromJson(jsonDecode(response.body)).message}');
    }
  }

  // Oauth2 로그인 Future<SignInResponse>
  static void oauth2SignIn(String oauthClient) async {
    final authUrl =
        Uri.parse("http://10.0.2.2:4040/api/v1/auth/oauth2/$oauthClient");

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: "com.secretjuju.yangdonge-client",
    );
    final accessToken = Uri.parse(result).queryParameters['accessToken'];
    log(accessToken!);
  }

  //가입 체크 (user-check)
  static Future<UserCheckResponse> isJoin(String id) async {
    final url = Uri.parse("$baseUrl/user-check");
    Map<String, String> requestBody = {"user_id": id};
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      return UserCheckResponse.fromJson(jsonDecode(response.body));
    }
    throw Error();
  }
  //학교 이메일 인증 (이메일 전송 요청)

  //이메일 인증 확인 (인증번호 확인)

  //회원 가입 요청

  // 헤더
  // Map<String, String> headers = {
  //   'Content-Type': 'application/json', // JSON 형식으로 요청을 보낼 때
  //   'Authorization': 'Bearer YourTokenHere', // 예시로 토큰을 헤더에 추가하는 경우
  // };
}
