import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yangdonge_client/tabs/tab_comunity.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedIndex = 0; // 홈 bottomNavigationBar 아이템 인덱스

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
  
  Widget _bodyWidget(){
    
    return Column(
      children: [
        Container(
          width: 400,
          height: 200,
          decoration: ShapeDecoration(
            color: Color(0xFFF9F9F9),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Color(0xFFD9D9D9),
              ),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
      ],
    );
    

  }
  
  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: _onItemTapped, // 수정된 콜백
      selectedFontSize: 12,
      selectedItemColor: Colors.black,
      currentIndex: _selectedIndex, // 현재 선택된 인덱스
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/svg/home_off.svg", width: 22),
          activeIcon: SvgPicture.asset("assets/svg/home_on.svg", width: 22),
          label: "홈",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/svg/heart_off.svg", width: 22),
          activeIcon: SvgPicture.asset("assets/svg/heart_on.svg", width: 22),
          label: "시간표",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/svg/notes_off.svg", width: 22),
          activeIcon: SvgPicture.asset("assets/svg/notes_on.svg", width: 22),
          label: "커뮤니티",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/svg/chat_off.svg", width: 22),
          activeIcon: SvgPicture.asset("assets/svg/chat_on.svg", width: 22),
          label: "채팅",
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset("assets/svg/user_off.svg", width: 22),
          activeIcon: SvgPicture.asset("assets/svg/user_on.svg", width: 22),
          label: "사용자",
        ),
      ],
    );
  }

  // 바텀 네비게이션 아이템 탭 시 호출되는 콜백
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // 각 인덱스에 따른 페이지 이동
      switch (_selectedIndex) {
        case 0:
          // 홈 페이지
          break;
        case 1:
          // 시간표 페이지
          break;
        case 2:
          // 커뮤니티 페이지로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComunityTab()),
          );
          break;
        case 3:
          // 채팅 페이지
          break;
        case 4:
          // 사용자 페이지
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }
}
