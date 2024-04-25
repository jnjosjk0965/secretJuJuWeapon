import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTab extends StatefulWidget  {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "assets/images/yang.png",
              width: 22,
            ),
            SizedBox(width: 8), // 텍스트와 아이콘 사이의 공간 조정
            Text("양동이"),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset("assets/svg/bell.svg", width: 22),
          ),
        ],
      ),
    );
  }
}

