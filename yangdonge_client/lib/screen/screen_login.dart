import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:yangdonge_client/model/response/auth/sign_in_response.dart';
import 'package:yangdonge_client/screen/screen_register.dart';
import 'package:yangdonge_client/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
    serverClientId:
        '171733729247-9j7965f9ed5erkqhrok59n83m23b6r1v.apps.googleusercontent.com',
  );
  GoogleSignInAccount? _currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(36, 84, 252, 1),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      "언제\n어디서나\n대학생활에 필요한것만",
                      style: TextStyle(
                        fontSize: 24,
                        height: 1.33333,
                        letterSpacing: -0.096,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(240, 240, 240, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [getKakaoLoginButton(), getGoogleLoginButton()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getKakaoLoginButton() {
    return InkWell(
      onTap: () {
        // 카카오 로그인 후 Token 받음
        signInWithKakao();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(254, 229, 0, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/kakao_login_medium_wide.png')
            ],
          ),
        ),
      ),
    );
  }

  Widget getGoogleLoginButton() {
    return InkWell(
      onTap: () {
        // 네이버 로그인 후 Token 받음
        signInWithGoogle();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/googleLogo.png',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(
                  width: 24,
                ),
                const Text(
                  "구글 로그인",
                  style: TextStyle(
                      fontFamily: "Roboto", fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signInWithKakao() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    //String? redirectUri = await AuthCodeClient.instance.platformRedirectUri();
    final url = Uri.parse("http://127.0.0.1:4040/api/v1/auth/sign-in/kakao");
    late String authCode;
    String stateToken = "";
    if (await isKakaoTalkInstalled()) {
      try {
        stateToken = generateRandomString(20);
        authCode = await AuthCodeClient.instance.authorizeWithTalk(
          redirectUri: KakaoSdk.redirectUri,
          stateToken: stateToken,
        );
        log("redirect(talk):${KakaoSdk.redirectUri}");
        log("authCode: $authCode");
      } catch (error) {
        log("login with kakaoTalk is  failed $error");
      }
    } else {
      try {
        authCode = await AuthCodeClient.instance
            .authorize(redirectUri: KakaoSdk.redirectUri);
        log("redirect(account):${KakaoSdk.redirectUri}");
        log("authCode: $authCode");
      } catch (error) {
        log("login with kakaoAccount is  failed $error");
      }
    }
    Map<String, String> requestBody = {
      "code": authCode,
      "state": stateToken,
    };
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );
    log("status code: ${response.statusCode}");
    if (response.statusCode == 200) {
      log(response.body);
      navigateToRegisterPage();
    } else {
      log("failed to sign in");
    }
  }

  void signInWithGoogle() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      final authentication = await _currentUser!.authentication;
      final accessToken = authentication.accessToken;
      if (accessToken != null) {
        final url =
            Uri.parse("http://127.0.0.1:4040/api/v1/auth/sign-in/google");
        Map<String, String> requestBody = {"accessToken": accessToken};
        final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(requestBody),
        );
        log("status code: ${response.statusCode}");
        if (response.statusCode == 200) {
          log(response.body);
          navigateToRegisterPage();
        } else {
          log("failed to sign in");
        }
      }
    } catch (error) {
      log("Google Login Error : $error");
    }
  }

  void navigateToRegisterPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const RegisterScreen(),
    ));
  }
}
