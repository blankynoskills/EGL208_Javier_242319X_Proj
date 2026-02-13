import 'package:flutter/material.dart';
import 'screens/auth_screens.dart';
import 'screens/home_screen.dart';
import 'screens/profile_about_screens.dart';
import 'screens/menu_cart_screens.dart'; 


void main() {
  runApp(const SwiftEatsApp());
}

class SwiftEatsApp extends StatelessWidget {
  const SwiftEatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftEats',
      debugShowCheckedModeBanner: false, 
      
      //  the global theme 
      theme: ThemeData(
        useMaterial3: true,
        // orange as the color for the whole app
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        appBarTheme: const AppBarTheme(
          centerTitle: true, 
          elevation: 0,
        ),
      ),
      
      home: const LoginScreen(),
    );
  }
}

// handles the navigation bar 
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0; // Tracks which tab is currently active

  // List of screens corresponding to the bottom tabs
  final List<Widget> _pages = [
    const HomeScreen(),
    const AboutScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Displays the screen based on the selected index
      body: _pages[_selectedIndex],
      
      // The bottom tab bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          // Updates the state to switch screens
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.info_outline), label: 'About'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      
      // Global floating action button for the cart (visible on all main tabs)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
        backgroundColor: Colors.orange, // app theme
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}