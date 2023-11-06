import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:workoutapp/screens/add_workouts/addworkouts.dart';
import 'package:workoutapp/screens/favorites/favorites_screen.dart';
import 'package:workoutapp/screens/homepage.dart';
import 'package:workoutapp/screens/profilescreen.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  NavPageState createState() => NavPageState();
}

class NavPageState extends State<NavPage> {
  int _currentIndex = 0; // Track the current index of the selected tab

  final List<Widget> _pages = [
    const HomePage(),
    const AddWorkouts(),
    const FavoriteScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: PageStorage(
        bucket: PageStorageBucket(),
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(39, 38, 39, 1),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, // Adjust horizontal padding
            vertical: 10,
          ),
          child: GNav(
            backgroundColor: const Color.fromRGBO(39, 38, 39, 1),
            curve: Curves.bounceIn, // tab animation curves
            color: Colors.white70,
            activeColor: Colors.white,
            tabBackgroundColor: const Color.fromARGB(255, 66, 66, 66),
            padding: EdgeInsets.all(screenWidth * 0.02), // Adjust padding
            gap: screenWidth * 0.01, // Adjust gap
            tabs: const [
              GButton(
                icon: Icons.home,
                iconColor: Colors.grey,
                text: "Home",
              ),
              GButton(
                icon: Icons.sports_gymnastics,
                iconColor: Colors.grey,
                text: "Workouts",
              ),
              GButton(
                icon: Icons.favorite,
                iconColor: Colors.grey,
                text: "Favorites",
              ),
              GButton(
                icon: Icons.supervised_user_circle,
                iconColor: Colors.grey,
                text: "Profile",
              ),
            ],
            selectedIndex: _currentIndex,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
