import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/home.dart';
import 'src/providers/bottom_navigation_provider.dart';
import 'src/providers/trash_cans_provider.dart';
import 'src/providers/detail_page_provider.dart';
import 'src/config/config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Config.loadConfig(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Splash Screen
          return MaterialApp(
            home: Container(
              child: Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // Error Screen
          return MaterialApp();
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => BottomNavigationProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => TrashCansProvider(),
              ),
              ChangeNotifierProvider(
                create: (_) => DetailPageProvider(),
              ),
            ],
            child: MaterialApp(
              title: 'Trash App: 쓰레기앱 - Provider',
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              home: MyHomePage(),
            ),
          );
        }
      },
    );
  }
}
