import 'package:flutter/material.dart';
import 'package:laravel_login/src/ScreenContainer/HomeScreen.dart';
import 'package:laravel_login/src/ScreenContainer/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: checkAuthentication(),
    );
  }
}

class checkAuthentication extends StatefulWidget
{
  @override
  State<StatefulWidget> createState()
  {
    // TODO: implement createState
    return checkAuthenticationState();
  }

}


class checkAuthenticationState extends State<checkAuthentication>
{


  bool isAuth = false;
  @override
  void initState()
  {
    _checkIfLoggedIn();
    super.initState();
  }




  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if(token != null)
    {

      setState(() {
        isAuth = true;

      });


    }

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    Widget child;

    if (isAuth) {

      child = HomeScreen();
    }
    else {

      child = LoginScreen();
    }

    return Scaffold(
      body: child,
    );
  }

}






