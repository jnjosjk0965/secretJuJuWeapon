// tab_community.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ComunityTab extends StatefulWidget {
  const ComunityTab({super.key});

  @override
  State<ComunityTab> createState() => _ComunityTabState();
}

class _ComunityTabState extends State<ComunityTab> {
  int _selectedIndex = 2; // 커뮤니티 bottomNavigationBar 아이템 인덱스
  List<Map<String, String>> datas = [];

//데이터 초기화
  @override
  void initState() {
    super.initState();
    datas = [
      //나중에 서버에서 json 타입으로 받아오기.
      {
        "image": "assets/sample/1.jpeg",
        "title": "벚꽃놀이 간 사람??",
        "txt": "오늘 개봉동에 벚꽃 겁나 피었더라 ;; 얼른 보러 가셈",
        "nick": "행복한 김치찌개",
        "time": "· 1시간전",
        "likes": "2",
        "chat": "9"
      },
      {
        "image": "assets/sample/2.jpeg",
        "title": "이 볼펜 정보 아시는 분 계신가요",
        "txt": "폴앤조 에디션 같기는 한데 넘 갖고 싶어서 ㅠ 정보 아시는 분 공유좀요...",
        "nick": "건축학개론",
        "time": "· 1시간전",
        "likes": "4",
        "chat": "1"
      },
      {
        "image": "assets/sample/3.jpeg",
        "title": "Spin-ball홍보하겠음",
        "txt":
            "스핀볼 동아리 홍보하는 거임? 어떻게 가입하는 거임 아니 나 가입하고 싶어서 여기저기 찾아보는데 방법을 모르겠음 가입한 사람 있으면 댓글 좀 달아줘.",
        "nick": "최우진",
        "time": "· 1시간전",
        "likes": "4",
        "chat": "6"
      },
      {
        "image": "assets/sample/4.jpeg",
        "title": "도박해보실?",
        "txt": "손모가지 날아가부러",
        "nick": "익명",
        "time": "· 1시간전",
        "likes": "14",
        "chat": "9"
      },
      {
        "image": "assets/sample/5.jpeg",
        "title": "우리집 고양이 존귀임",
        "txt": "초코발바닥을 가졌음ㅎㅎ",
        "nick": "그레이기여웡",
        "time": "· 1시간전",
        "likes": "12",
        "chat": "3"
      },
      {
        "image": "assets/sample/6.jpeg",
        "title": "여기 어딘지 정보 좀..",
        "txt": "제발 찾아주세요 ㅠ 사진 속 테이블 정보랑 의자 제발요",
        "nick": "인테리어집착남",
        "time": "· 1시간전",
        "likes": "4",
        "chat": "4"
      },
    ];
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      title: const Text("커뮤니티"),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              "assets/svg/notes_on.svg",
              width: 22,
            ))
      ],
    );
  }

  Widget _bodyWidget() {
    return Column(
      children: [
        _buildCategoryTab(),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            itemBuilder: (BuildContext _context, int index) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 100,
                            padding: EdgeInsets.only(right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  datas[index]["title"]!,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  datas[index]["txt"]!,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // txt와 images 사이 간격 조절
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          child: Image.asset(
                            datas[index]["image"]!,
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10), // txt와 nick/time 사이 간격 조절
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(datas[index]["nick"]!,
                                style: TextStyle(fontSize: 12)),
                            SizedBox(width: 5), // nick과 time 사이 간격 조절
                            Text(datas[index]["time"]!,
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            SvgPicture.asset("assets/svg/heart_off.svg",
                                width: 13, height: 13),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(datas[index]["likes"]!,
                                  style: TextStyle(fontSize: 12)),
                            ),
                            SizedBox(width: 10),
                            SvgPicture.asset("assets/svg/chat_off.svg",
                                width: 13, height: 13),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(datas[index]["chat"]!,
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext _context, int index) {
              return Container(height: 1, color: Colors.black.withOpacity(0.3));
            },
            itemCount: datas.length,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTab() {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildCategoryButton("전체"),
              SizedBox(width: 8),
              _buildCategoryButton("일반"),
              SizedBox(width: 8),
              _buildCategoryButton("질문"),
              SizedBox(width: 8),
              _buildCategoryButton("장터"),
            ],
          ),
          _buildToggleButton("인기글"),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return InkWell(
      onTap: () {
        // 클릭 이벤트 처리
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 236, 238, 248),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text) {
    bool isToggled = false; // 토글 상태를 나타내는 변수, 여기에 실제 상태를 가져와야 합니다.
    return InkWell(
      onTap: () {
        // 클릭 이벤트 처리
        // 토글 상태 변경 및 UI 갱신
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isToggled ? Colors.lightBlueAccent : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isToggled ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.toggle_on, // 토글이 활성화되었을 때의 아이콘
              color: isToggled ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      // const Center(child: Text('커뮤니티 화면')),
    );
  }
}
