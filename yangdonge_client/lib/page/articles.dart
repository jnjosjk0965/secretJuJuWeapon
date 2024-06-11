import 'package:flutter/material.dart';

class ArticlesPage extends StatefulWidget {
  final Map<String, String> data;
  /*
  * final변수 사용시 변수값이 한번 초기화된 후 변경X -> 데이터의 일관성 유지
  * 객체 생성된 후 해당 변수가 변경되지 않음
  * final 변수에 대해 Dart컴파일러가 최적화 수행 가능 -> 성능 향상
  */
  const ArticlesPage({super.key, required this.data});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(widget.data["title"] ?? "null값 처리"),
      ),
    );
  }
}
