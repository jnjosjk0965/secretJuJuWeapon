import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:yangdonge_client/screen/screen_index.dart';
import 'package:yangdonge_client/screen/screen_login.dart';
import 'package:yangdonge_client/screen/screen_register.dart';
import 'package:yangdonge_client/screen/screen_splash.dart';

void main() {
  // SharedPreferences 초기 설정시 정상 동작을 위한 코드?
  WidgetsFlutterBinding.ensureInitialized();
  // 네이티브 앱만 서비스
  KakaoSdk.init(nativeAppKey: "ca9166e0d74c074c19e17d1a19ba3c28");
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '양동이',
      routes: {
        //'/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/index': (context) => const IndexScreen(),
        '/register': (context) => const RegisterScreen(),
      },
      initialRoute: '/register',
      theme: ThemeData(
        primaryColor: const Color.fromRGBO(36, 84, 252, 1),
        useMaterial3: true,
        fontFamily: "Pretendard",
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 24,
            height: 1.33333,
            letterSpacing: -0.096,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            height: 1.44444,
            letterSpacing: -0.072,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            height: 1.571428,
            letterSpacing: -0.056,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            height: 1.571428,
            letterSpacing: -0.056,
            fontWeight: FontWeight.bold,
          ),
          bodySmall: TextStyle(
            fontSize: 10,
            height: 1.8,
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            height: 1.6667,
            letterSpacing: -0.048,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
