import 'package:flutter/material.dart';
import 'package:testapp/screens/settings/settings_screen.dart';
import 'package:testapp/theme/colors.dart';
import 'package:testapp/screens/profile/profile_screen.dart';
import 'package:testapp/screens/home/home_screen.dart';


class MyNavigationBar extends StatefulWidget {  
 const  MyNavigationBar ({Key? key}) : super(key: key);  
  
  @override  
  _MyNavigationBarState createState() => _MyNavigationBarState();  
}  
  
class _MyNavigationBarState extends State<MyNavigationBar > {  
  int _selectedIndex = 0;  
  static const List<Widget> _widgetOptions = <Widget>[  
    HomeScreen(),  
    ProfileScreen(),  
    SettingsScreen(),  
  ];  
  
  void _onItemTapped(int index) {  
    setState(() {  
      _selectedIndex = index;  
    });  
  }  
  
  @override  
  Widget build(BuildContext context) {  
    return Scaffold(  
      
      body: Center(  
        child: _widgetOptions.elementAt(_selectedIndex),  
      ),  
      bottomNavigationBar: BottomNavigationBar(  
       
        items: const <BottomNavigationBarItem>[  
          BottomNavigationBarItem(  
            icon: Icon(Icons.home),  
            label: 'Home',  
             backgroundColor: AppColors.primary,
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.person),  
            label:'Profile', 
             backgroundColor: AppColors.primary,
          ),  
          BottomNavigationBarItem(  
            icon: Icon(Icons.settings),  
            label: 'Settings'  ,
             backgroundColor: AppColors.primary,
          ),  
        ],  
        type: BottomNavigationBarType.shifting,  
        currentIndex: _selectedIndex,  
        selectedItemColor: Colors.white,  
        unselectedItemColor: Colors.white.withOpacity(0.5),
        iconSize: 24,  
        onTap: _onItemTapped,  
        elevation: 5  ,

      ),  
    );  
  }  
}  