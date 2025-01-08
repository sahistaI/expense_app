import 'dart:ui';

import 'package:expense_app/data/local_data/db_helper.dart';
import 'package:expense_app/ui/on_boarding/dashboard_page.dart';
import 'package:expense_app/ui/on_boarding/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget{
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPassvisible = false;

  void saveUserId(String UserId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(UserId.isNotEmpty) {
      await prefs.setString("userId", UserId);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DashboardPage()));
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("UserId is invalid."),
        backgroundColor: Colors.red,
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
         body:
         SingleChildScrollView(
           child: Column(
             children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Padding(
                     padding: const EdgeInsets.only(top:30.0),
                     child: Container(
                       margin: EdgeInsets.only(top:50),
                       width: 200,
                       height: 200,
                       child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(51),
                         color: Colors.grey.withOpacity(0.8),
                       ),
                     ),
                   )
                
                 ],
               ),
               SizedBox(
                 height: 50,
               ),
                
               Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: TextField(
                   controller: emailController,
                   obscureText: false,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(11),
                       borderSide: BorderSide(
                         color: Colors.deepPurple,
                       ),
                     ),
                     hintText: "abc@gmail.com",
                     label: Text("Emailid"),
                     prefixIcon: Icon(Icons.mail_lock),
                   ),
                 ),
               ),
               SizedBox(
                 height: 10,
               ),
                
               Padding(
                 padding: const EdgeInsets.all(15.0),
                 child: TextField(
                   controller: passwordController,
                   obscureText: !isPassvisible,
                   decoration: InputDecoration(
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(11),
                       borderSide: BorderSide(
                         color: Colors.deepPurple,
                       ),
                     ),
                     hintText: "Enter Your Password",
                     label: Text("Password"),
                     prefixIcon:InkWell(
                         onTap: (){
                           isPassvisible = !isPassvisible;
                           setState(() {
                
                           });
                         },
                         child: Icon(isPassvisible ? Icons.remove_red_eye : Icons.visibility_off_outlined))
                   ),
                 ),
               ),
               SizedBox(
                 height: 3,
               ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal:25.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: [
                     Text('Forgot Password?',style: TextStyle(
                         color: Colors.black.withOpacity(0.8),
                         fontSize: 15
                     ),),
                
                   ],
                 ),
               ),
               SizedBox(
                 height:40,
               ),
               ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor:Colors.grey.withOpacity(0.8),
                
                 ),
                 onPressed: ()async{
                
                   DbHelper dbHelper = DbHelper.getInstance();
                
                   if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){
                
                     if( await dbHelper.authenticateUser(email: emailController.text, pass: passwordController.text)){
                       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
                     }else {
                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                         content: Text("Invalid Credentials, login again!!"),backgroundColor: Colors.red,
                       ));
                     }
                
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       content: Text("Please fill all the required blanks!!"),backgroundColor: Colors.red,
                     ));
                   }
                
                
                
                 }, child: Text('Login',
                   style: TextStyle(fontSize: 21,color: Colors.black,)),
               ),
               SizedBox(height: 10,),
                
               Divider(),
               SizedBox(height: 10,),
                
               Text('OR',style: TextStyle(
                   color: Colors.black.withOpacity(0.8),
                   fontSize: 20,fontWeight:FontWeight.bold
               ),),
                
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Text('Don\'t have Account?',style: TextStyle(
                       color: Colors.black.withOpacity(0.8),
                       fontSize: 18
                   ),),
                   SizedBox(width: 10,),
                
                   InkWell(
                     onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>Signup()));
                     },
                    child: Text('Regiter here',style: TextStyle(
                        color: Colors.blue.withOpacity(0.8),
                        fontSize: 20
                    ),),
                
                   )
                
                 ],
               )
                
             ],
           ),
         )
     
     ),
   );
  }
}