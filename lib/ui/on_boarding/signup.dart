import 'package:expense_app/data/local_data/db_helper.dart';
import 'package:expense_app/data/local_data/model/user_model.dart';
import 'package:expense_app/ui/on_boarding/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget{
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController userNameController = TextEditingController();
  TextEditingController uMobNoController = TextEditingController();
  TextEditingController uEmailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confPassController = TextEditingController();

  DbHelper dbHelper = DbHelper.getInstance();

  bool isPassVisible = false;
  bool isConfPassVisible = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar:   AppBar(
     //   title: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
      //  backgroundColor: Colors.grey.withOpacity(0.8),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text('Create Account',style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    label: Text("User Name"),
                    hintText: "User Name", hintStyle: TextStyle(
                    fontSize:18
                  ),
                    focusedBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11)
                    )
                  ),
                ),
              ),
              SizedBox(height: 10,),
          
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: uMobNoController,
                  decoration: InputDecoration(
                      label: Text("Mobile No"),
                      hintText: "Mobile No", hintStyle: TextStyle(
                      fontSize:18
                  ),
                      focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      )
                  ),
                ),
              ),
              SizedBox(height: 10,),
          
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: uEmailController,
                  decoration: InputDecoration(
                      label: Text("Email id"),
                      hintText: "abcd@gmail.com", hintStyle: TextStyle(
                      fontSize:18
                  ),
                      focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      )
                  ),
                ),
              ),
          
              SizedBox(height: 10,),
          
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: passController,
                  obscureText: !isPassVisible,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: (){
                          isPassVisible = !isPassVisible;
                          setState(() {
          
                          });
                        },
                        child: Icon(isPassVisible ? Icons.visibility : Icons.visibility_off_outlined )),
                      label: Text("Password"),
                      hintText: "Enter Password", hintStyle: TextStyle(
                      fontSize:18
                  ),
                      focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      )
                  ),
                ),
              ),
          
              SizedBox(height: 10,),
          
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: confPassController,
                  obscureText: !isConfPassVisible,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    suffixIcon: InkWell(
                        onTap: (){
                          isConfPassVisible = !isConfPassVisible;
                          setState(() {
          
                          });
                        },
                        child: Icon(isConfPassVisible ? Icons.visibility : Icons.visibility_off_outlined)),
                      label: Text("Confirm Password"),
                      hintText: "Confirm Password", hintStyle: TextStyle(
                      fontSize:18
                  ),
                      focusedBorder:OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11)
                      )
                  ),
                ),
              ),
          
              SizedBox(height: 20,),
          
              ElevatedButton(onPressed: ()async{
          
                 if(userNameController.text.isNotEmpty && uEmailController.text.isNotEmpty && uMobNoController.text.isNotEmpty && passController.text.isNotEmpty && confPassController.text.isNotEmpty){
          
                  if(passController.text == confPassController.text){
                    // register user
          
                    if(await dbHelper.checkIfEmailAlreadyExists(email:uEmailController.text.toString())){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Email already Exists, login now!!"),backgroundColor: Colors.orange
                      ));
                    }
                    else {
                      bool check = await dbHelper.registerUser(newUser: UserModel(uName: userNameController.text,
                          uPass: passController.text,
                          uEmail: uEmailController.text,
                          uMobNo: uMobNoController.text,
                          uCreatedAt: DateTime.now().millisecondsSinceEpoch.toString()));
                      if(check){
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Account Registered Succesfully!!"), backgroundColor: Colors.green
                        )
                        );
                        Navigator.pop(context);
                      }
                      else{
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Failed to registered account, try again!!"),backgroundColor: Colors.red,
                        ));
                      }
          
          
                    }
          
          
                  }
                  else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Password doesn\'t match!!"),backgroundColor: Colors.orange
                    ));
                  }
          
                }
                 else {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                       content: Text("Please fill all the requirements!!"),backgroundColor: Colors.orange
                   ));
                 }
          
          
          
              }, child: Text("Sign In",style: TextStyle(
                fontSize: 21,fontWeight: FontWeight.bold
              ),),),
          
              SizedBox(height:10,),
          
              Divider(),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an Account',style: TextStyle(
                      color: Colors.black.withOpacity(0.8),
                      fontSize: 18
                  ),),
                  SizedBox(width: 20,),
          
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                    },
                    child: Text('Login here',style: TextStyle(
                        color: Colors.blue.withOpacity(0.8),
                        fontSize: 20
                    ),),
          
                  )
          
                ],
              )
          
          
          
          
          
          
          
            ]
              ),
        ),
      )

    );
  }
}