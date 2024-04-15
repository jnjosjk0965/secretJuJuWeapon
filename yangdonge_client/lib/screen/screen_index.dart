import 'package:flutter/material.dart';
import 'package:yangdonge_client/tabs/tab_chatting.dart';
import 'package:yangdonge_client/tabs/tab_comunity.dart';
import 'package:yangdonge_client/tabs/tab_home.dart';
import 'package:yangdonge_client/tabs/tab_profile.dart';
import 'package:yangdonge_client/tabs/tab_timetable.dart';

class IndexScreen extends StatefulWidget {
  const IndexScreen({super.key});

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  final List<Widget> _tabs = [
    const HomeTab(),
    const TimetableTab(),
    const ComunityTab(),
    const ChattingTab(),
    const ProfileTab(),
  ];
  late TabController _tabController;

  static const _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: '홈',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.table_chart_outlined),
      label: '시간표',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.table_rows_rounded),
      label: '커뮤니티',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat_bubble_outline),
      label: '채팅',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outlined),
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
      _currentIndex = _tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30,
        selectedItemColor: const Color(0xFF2454FC),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        currentIndex: _currentIndex, // 현재 인덱스
        onTap: (int index) {
          _tabController.animateTo(index);
        },
        items: _navItems,
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _tabs,
      ),
    );
  }
}
