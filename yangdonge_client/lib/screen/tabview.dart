import 'package:flutter/material.dart';
import 'package:yangdonge_client/screen/chatting_screen.dart';
import 'package:yangdonge_client/screen/comunity_screen.dart';
import 'package:yangdonge_client/screen/home_screen.dart';
import 'package:yangdonge_client/screen/profile_screen.dart';
import 'package:yangdonge_client/screen/timetable_screen.dart';

class TabView extends StatefulWidget {
  const TabView({super.key});

  @override
  State<TabView> createState() => _TabViewState();
}

class _TabViewState extends State<TabView> with SingleTickerProviderStateMixin {
  int _index = 0;
  late TabController _tabController;
  static const _navItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_outlined,
      ),
      label: '홈',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.table_chart_outlined,
      ),
      label: '시간표',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.table_rows_rounded,
      ),
      label: '커뮤니티',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.chat_bubble_outline,
      ),
      label: '채팅',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.person_outlined,
      ),
      label: '커뮤니티',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _navItems.length, vsync: this);
    _tabController.addListener(tabListener);
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListener);
    super.dispose();
  }

  void tabListener() {
    setState(() {
      _index = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        currentIndex: _index, // 현재 인덱스
        items: _navItems,
        selectedItemColor: const Color(0xFF2454FC),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const [
          MyHomePage(),
          TimeTablePage(),
          ComunityPage(),
          ChattingPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
