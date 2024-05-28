import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool isAttendanceExpanded = false;
  bool isDiningExpanded = false;

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: Row(
        children: [
          Image.asset("assets/images/yang.png", width: 22),
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
    );
  }

  Widget _bodyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 400,
              height: 150,
              decoration: ShapeDecoration(
                color: Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Color(0xFFD9D9D9),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.book, color: Colors.grey),
                          title: Text("수강 정보"),
                          selected: isAttendanceExpanded,
                          onTap: () {
                            setState(() {
                              isAttendanceExpanded = !isAttendanceExpanded;
                              isDiningExpanded = false;
                            });
                          },
                        ),
                        if (isAttendanceExpanded)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "19학 시 수업",
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "23시 12분 종료",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.restaurant, color: Colors.grey),
                          title: Text("학식 정보"),
                          selected: isDiningExpanded,
                          onTap: () {
                            setState(() {
                              isDiningExpanded = !isDiningExpanded;
                              isAttendanceExpanded = false;
                            });
                          },
                        ),
                        if (isDiningExpanded)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "소시지 오므라이스",
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  "스파게티 마라탕 플레이터",
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15), // 간격 추가
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 400,
              height: 240, // 높이 조정
              decoration: ShapeDecoration(
                color: Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Color(0xFFD9D9D9),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.notifications, color: Colors.grey),
                    title: Text(
                      "학교 공지사항",
                      style: TextStyle(fontSize: 16), // 글자 크기 조정
                    ),
                    onTap: () {
                      // 학교 공지사항을 보여주는 동작 추가
                    },
                    trailing: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          // 전체보기 동작 추가
                        },
                        child: Center(
                          child: Text(
                            "전체보기",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    // 연한 선 추가
                    color: Colors.grey[400],
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  // 학교 공지사항 리스트 폼
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            '공지사항 1',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 공지사항 1에 대한 동작 추가
                          },
                        ),
                        ListTile(
                          title: Text(
                            '공지사항 2',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 공지사항 2에 대한 동작 추가
                          },
                        ),
                        ListTile(
                          title: Text(
                            '공지사항 3',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 공지사항 3에 대한 동작 추가
                          },
                        ),
                        ListTile(
                          title: Text(
                            '공지사항 4',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 공지사항 4에 대한 동작 추가
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15), // 간격 추가
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: 400,
              height: 240, // 높이 조정
              decoration: ShapeDecoration(
                color: Color(0xFFF9F9F9),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Color(0xFFD9D9D9),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(Icons.announcement, color: Colors.grey),
                    title: Text(
                      "학과 공지사항",
                      style: TextStyle(fontSize: 16), // 글자 크기 조정
                    ),
                    onTap: () {
                      // 학과 공지사항을 보여주는 동작 추가
                    },
                    trailing: Container(
                      width: 60,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        onTap: () {
                          // 전체보기 동작 추가
                        },
                        child: Center(
                          child: Text(
                            "전체보기",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    // 연한 선 추가
                    color: Colors.grey[400],
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  // 학과 공지사항 리스트 폼
                  Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text(
                            '학과 공지사항 1',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 학과 공지사항 1에 대한 동작 추가
                          },
                        ),
                        ListTile(
                          title: Text(
                            '학과 공지사항 2',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 학과 공지사항 2에 대한 동작 추가
                          },
                        ),
                        ListTile(
                          title: Text(
                            '학과 공지사항 3',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 학과 공지사항 3에 대한 동작 추가
                          },
                        ),
                        ListTile(
                          title: Text(
                            '학과 공지사항 4',
                            style: TextStyle(fontSize: 14),
                          ),
                          onTap: () {
                            // 학과 공지사항 4에 대한 동작 추가
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
    );
  }
}
