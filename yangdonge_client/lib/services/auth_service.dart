import 'dart:convert';
import 'dart:developer';

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:yangdonge_client/model/response/auth/sign_in_response.dart';
import 'package:yangdonge_client/model/response/auth/user_check_response.dart';
import 'package:http/http.dart' as http;
import 'package:yangdonge_client/model/response/response_dto.dart';

abstract class AuthService {
  static const String baseUrl = "http://127.0.0.1:4040/api/v1/auth";
  static const callbackUrlScheme = "com.secretjuju.yangdonge-client";

  // Oauth2 로그인 Future<SignInResponse>
  static Future<SignInResponse> naverSignIn() async {
    String state = generateRandomString(20);
    final authUrl = Uri.http("127.0.0.1:4040", "/api/v1/auth/oauth2/naver");
    // Uri.https("nid.naver.com", "/oauth2.0/authorize", {
    //   'response_type': 'code',
    //   'client_id': "OJwFoWECcjPN0SWB8tDi",
    //   'redirect_uri': '$callbackUrlScheme:/',
    //   'state': state,
    // });

    final result = await FlutterWebAuth2.authenticate(
      url: authUrl.toString(),
      callbackUrlScheme: callbackUrlScheme,
    );
    final code = Uri.parse(result).queryParameters['code'];

    log("authCode: $code state: $state");
    // auth code를 받고 액세스 토큰 요청
    final url = Uri.parse("http://127.0.0.1:4040/api/v1/auth/sign-in/naver");

    final response = await http.post(url,
        headers: {"Content-Type": "application/json"},
        body: {'code': code, 'state': state});

    if (response.statusCode == 200) {
      return SignInResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
          'Failed to sign in: ${ResponseDto.fromJson(jsonDecode(response.body)).message}');
    }
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
