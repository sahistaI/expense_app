import 'dart:async';

import 'package:expense_app/ui/on_boarding/dashboard_page.dart';
import 'package:expense_app/ui/on_boarding/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splashscreen extends StatefulWidget{
  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {

  String? uid;

  @override
  void initState(){
    super.initState();
  Timer(Duration(seconds: 2),()async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var getValues = prefs.getString("userId");
      if (getValues != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }

     /* *//*SharedPreferences prefs = await SharedPreferences.getInstance();
  uid = prefs.getString("userId") ?? "";

  Widget navigateTo = Login();

  if(uid != null){
    navigateTo = DashboardPage();
  }  else{
  
  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=>navigateTo));*//*
    }
*/
  });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        title: Text("Monety"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Center(
                child: Container(
                  width: 350,
                  height: 350,
                  //color: Colors.blueGrey,
                  child: Image.asset("assets/images/bg_splash.png",fit: BoxFit.cover,),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Easy way to monitor",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                "Your expense",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Safe Your Future by managing Your",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              Text(
                "expense right now",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              )
            ],
          )
        ],
      ),
    );
  }
}