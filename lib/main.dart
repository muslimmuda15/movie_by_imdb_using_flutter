import 'package:flutter/material.dart';
import 'package:submission_movie_catalog/movie/tv.dart';

import 'movie/movie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  TabPage createState() => TabPage();
}

class TabPage extends State<LandingPage> {
  int tabIndex = 0;
  bool isLoaded = false;

  List<Image> tabImage = [
    Image.asset('images/icon_movie.png'),
    Image.asset('images/tab_home.png')
  ];
  List<Image> tabSelectedImages = [
    Image.asset('images/icon_movie_selected.png'),
    Image.asset('images/tab_home_selected.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: tabIndex,
        children: const [MoviePage(), TvPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        currentIndex: tabIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: getTabIcon(0),
            label: "My movie",
          ),
          BottomNavigationBarItem(
            icon: getTabIcon(1),
            label: "My tv",
          ),
        ],
        onTap: (index) => setState(() {
          tabIndex = index;
        }),
      ),
    );
  }

  Image getTabIcon(int index) {
    if (index == tabIndex) {
      return tabSelectedImages[index];
    } else {
      return tabImage[index];
    }
  }
}
