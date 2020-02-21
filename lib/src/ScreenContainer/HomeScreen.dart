import 'dart:convert';

import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:laravel_login/src/PagerContainer/AtmsPageViewer.dart';
import 'package:laravel_login/src/PagerContainer/HomePageViewer.dart';
import 'package:laravel_login/src/PagerContainer/SettingPageViewer.dart';
import 'package:laravel_login/src/PagerContainer/UserPageViewer.dart';
import 'package:laravel_login/src/ScreenContainer/LoginScreen.dart';
import 'package:laravel_login/src/ServicesContainer/Network.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeScreenState();
  }

}





  class HomeScreenState extends State<HomeScreen>

  {

    ScrollController controller;
    int _currentIndex = 0;
    PageController _pageController;

    String name;
    var zones;
    @override
    void initState(){
      _loadUserData();
      _pageController = PageController();

      controller = new ScrollController()..addListener(_scrollListener);


      super.initState();
    }
    _loadUserData() async{

      SharedPreferences localStorage = await SharedPreferences.getInstance();

      var res = await Network().getData('/me');
      var body = json.decode(res.body);
      localStorage.setString('user', json.encode(body['user']['name']));
      var user = jsonDecode(localStorage.getString('user'));



      GetZones();

      if(user != null) {
        setState(() {
           name = user;
           zones=jsonDecode(localStorage.getString('Zones'));
        });
      }
    }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return WillPopScope(
      onWillPop: _onBackPressed,


      child:  Scaffold(
        appBar: AppBar(
          title: Text('e-Banking'),
          backgroundColor: Colors.teal,
        ),

        bottomNavigationBar: BottomNavyBar(
          selectedIndex:_currentIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text('Home'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: Colors.deepPurple
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.account_balance),
                title: Text('ATM'),
                activeColor: Colors.pink
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
                activeColor: Colors.green
            ),
          ],
        ),

        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },


            children: <Widget>[
              HomePageViewer(),
              UserPageViewer(name),
              AtmsPageViewer(zones,controller),
              SettingPageViewer(),
            ],
          ),
        ),
      ),
    );








  }





    Future<bool> _onBackPressed() {
      return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            new GestureDetector(
              onTap:() {
                Navigator.of(context).pop(true);
              },
              child: Text("YES"),
            ),
          ],
        ),
      ) ??
          false;
    }







    void logout() async
    {


      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context)=>LoginScreen())
      );

    }



    Widget SettingPageViewer(){

      return Scaffold(
          body: ListView(

                          children: <Widget>[
                            ListItem("ProfileSetting","Profile Setting"),
                            ListItem("JoingAccount","Join Your Account"),
                            ListItem("Aboutus","About us"),

                            RaisedButton(
                              onPressed: logout,
                              child: Text('Logout'),
                            ),

                          ],

          )
      );

    }




    // card view 

    Widget ListItem(name,description){

      return Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            print('Card tapped.$name');
          },
          child: Container(
            width: 300,
            height: 50,
            padding: EdgeInsets.all(10),
            child: Text(description),
          ),
        ),
      );

    }





    GetZones() async{

      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var res = await Network().getData('/GetZones');
      var body = json.decode(res.body);
      localStorage.setString('Zones', json.encode(body['ZonesInfo']));



    }




  void _scrollListener() {

    print(controller.position.extentAfter);
    if (controller.position.extentAfter > 500) {

      print("ss");
    }


  }
}




