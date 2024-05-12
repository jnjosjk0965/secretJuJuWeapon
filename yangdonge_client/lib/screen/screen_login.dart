import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                children: [
                  getKakaoLoginButton(),
                  getNaverLoginButton(),
                  // GestureDetector(
                  //   onTap: () async {
                  //     await loginModel.login();
                  //     if (loginModel.isLogin) {
                  //       // 사용자 id를 spring 서버에 확인 받아서 isJoin
                  //       // isJoin true 시 토큰 발급 요청하고 토큰 저장 홈으로
                  //       // isJoin false 시
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const RegisterScreen(),
                  //         ),
                  //       );
                  //     }
                  //   },
                  //   child: Image.asset(
                  //       'assets/images/kakao_login_medium_wide.png'),
                  // ),
                  ElevatedButton(
                    onPressed: () async {},
                    child: const Text("logout"),
                  ),
                ],
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
          height: 50,
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

  Widget getNaverLoginButton() {
    return InkWell(
      onTap: () {
        // 네이버 로그인 후 Token 받음
        signInWithNaver();
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(3, 199, 90, 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Image.asset('assets/images/naver_login_green.png')],
          ),
        ),
      ),
    );
  }

  void signInWithKakao() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        log('카카오톡으로 로그인 성공');
      } catch (error) {
        log('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          log('카카오계정으로 로그인 성공');
        } catch (error) {
          log('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        log('카카오계정으로 로그인 성공');
      } catch (error) {
        log('카카오계정으로 로그인 실패 $error');
      }
    }
    //
    final User user = await UserApi.instance.me();
    final String userId = "kakao${user.id}";
    final String? email = user.kakaoAccount?.email;
    await UserApi.instance.unlink();
    final SignInResponse res = await AuthService.signIn(userId, email!);
    log('kakao: ${res.accessToken}');
  }

  void signInWithNaver() async {
    AuthService.oauth2SignIn("naver");
  }

  void navigateToRegisterPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const RegisterScreen(),
    ));
  }
}
