import 'package:flutter/material.dart';
import 'pages/trash_can_list_page.dart';
import 'pages/favorite_trash_cans_page.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trash App: 쓰레기앱'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: _selectedIndex, //현재 선택된 Index
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: '즐겨찾는 쓰레기통',
            icon: Icon(Icons.favorite),
          ),
          BottomNavigationBarItem(
            label: '쓰레기통 목록',
            icon: Icon(Icons.manage_search),
          ),
          BottomNavigationBarItem(
            label: '지도에서 찾기',
            icon: Icon(Icons.location_on),
          ),
          BottomNavigationBarItem(
            label: '내 페이지',
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  List _widgetOptions = [
    FavoriteteTrashCanListPage(),
    TrashCanListPage(),
    Text(
      '지도에서 찾기',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
    Text(
      '내 페이지',
      style: TextStyle(fontSize: 30, fontFamily: 'DoHyeonRegular'),
    ),
  ];
}
