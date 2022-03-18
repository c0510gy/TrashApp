import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/home.dart';
import 'src/providers/bottom_navigation_provider.dart';
import 'src/providers/trash_cans_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trash App: 쓰레기앱 - Provider',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => BottomNavigationProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => TrashCansProvider(),
          )
        ],
        child: MyHomePage(),
      ),
    );
  }
}
