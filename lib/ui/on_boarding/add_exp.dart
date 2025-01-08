
import 'package:expense_app/data/local_data/db_helper.dart';
import 'package:expense_app/data/local_data/model/expense_model.dart';
import 'package:expense_app/domain/app_constants.dart';
import 'package:expense_app/domain/ui_helper.dart';
import 'package:expense_app/ui/bloc/expense_bloc.dart';
import 'package:expense_app/ui/bloc/expense_event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AddExp extends StatefulWidget{
  @override
  State<AddExp> createState() => _AddExpState();
}

class _AddExpState extends State<AddExp> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descController = TextEditingController();

  TextEditingController amtController = TextEditingController();

  String selectedExpType = "Debit";

  int selextedCatindex = -1;

  DateTime selectedDate = DateTime.now();

  DateFormat mFormat = DateFormat.yMMMd();

  List<String> mExpenseType = ["Debit","Credit","Loan","Lend","Borrow"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: mFieldDecor(hint: "Enter title here...", heading: "Title")
            ),
            mSpacer(),
            TextField(
                controller: descController,
                decoration: mFieldDecor(hint: "Enter desc here...", heading: "Desc")
            ),
            mSpacer(),
            TextField(
                controller: amtController,
                decoration: mFieldDecor(
                   mprefixText: "\$ ",
                    hint: "Enter amount here...", heading: "Amount")
            ),

            mSpacer(),


            // Expense Type

           StatefulBuilder(builder: (_,ss){
            /* return  DropdownButton(
                 value: selectedExpType,
                 items:
                   mExpenseType.map((expenseType){
                      return DropdownMenuItem(child: Text(expenseType),value: expenseType);
                   }).toList(),
                 onChanged: (value){
               selectedExpType = value ?? "Debit";
               ss((){});*/
             return DropdownMenu(
              // width: double.infinity,
               width: 390,
               inputDecorationTheme: InputDecorationTheme(
                 enabledBorder: OutlineInputBorder(
                   borderRadius:BorderRadius.circular(21),
                   borderSide: BorderSide(color: Colors.black,width: 1)
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius:BorderRadius.circular(21),
                   borderSide: BorderSide(color: Colors.black,width: 1)
                 )
               ),

                         initialSelection: selectedExpType,
                         onSelected: (value){
              selectedExpType = value ?? "Debit";
                         },
                         dropdownMenuEntries: mExpenseType.map((expenseType){
              return DropdownMenuEntry(value: expenseType, label: expenseType);

               }).toList());

             }),
            mSpacer(),

            InkWell(
              onTap: (){
                showModalBottomSheet(context: context, builder:(_){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 21),
                    child: Container(
                      child: GridView.builder(
                          itemCount: AppConstants.mCat.length,
                          gridDelegate:
                      SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                          itemBuilder: (_,index){
                        return InkWell(
                          onTap: (){
                            selextedCatindex = index;
                            setState(() {
                              
                            });
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                                  Image.asset(AppConstants.mCat[index].imgPath!, width: 40,height:40,),
                                  Text(AppConstants.mCat[index].title!,maxLines: 1,overflow: TextOverflow.ellipsis,)
                            ],
                          ),
                        );

                          }),
                    ),
                  );

                });
              },
              child: Container(
                width: double.infinity,
                height: 55,
                child: Center(
                    child: selextedCatindex>-1 ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AppConstants.mCat[selextedCatindex].imgPath!,width: 35,height: 35,),
                        Text(" - ${AppConstants.mCat[selextedCatindex].title!}")
                      ],
                    ):Text("Choose a Category")),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  border: Border.all(
                    width: 1,
                    color: Colors.black
                  )
                ),
              ),
            ),
            mSpacer(),

            InkWell(
              onTap: ()async{
                if(Platform.isIOS || Platform.isMacOS){
                  showCupertinoModalPopup(context: context, builder: (_){
                    return Container(
                      height: 200,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.dateAndTime,
                          minimumDate: DateTime.now().subtract(Duration(days: 365)),
                          minimumYear: DateTime.now().year-1 ,
                          maximumYear: DateTime.now().year ,
                          maximumDate: DateTime.now().add(Duration(hours: 1)),
                          onDateTimeChanged:(selectedvalue){
                            selectedDate = selectedvalue;
                            setState(() {

                            });

                      }),
                    );
                  });
                }else {
                 selectedDate = await showDatePicker(context: context,
                      firstDate: DateTime(DateTime.now().year-1), lastDate: DateTime.now()) ??
                DateTime.now();

                 setState(() {

                 });

                }


              },
              child: Container(
                width: double.infinity,
                height: 55,
                child: Center(
                    child: Text(mFormat.format(selectedDate).toString())),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    border: Border.all(
                        width: 1,
                        color: Colors.black
                    )
                ),
              ),
            ),


            mSpacer(),
            
            OutlinedButton(onPressed: ()async{

              if(titleController.text.isNotEmpty &&
                  descController.text.isNotEmpty &&
                  amtController.text.isNotEmpty &&
                  selextedCatindex > -1
                  ){
                var prefs = await SharedPreferences.getInstance();
                String uid = prefs.getString("userId") ?? "";

                context.read<ExpenseBloc>().add(AddExpenseEvent(newExp:ExpenseModel(

                    userId: int.parse(uid),
                    expenseType: selectedExpType,
                    title: titleController.text, desc: descController.text,
                    createdAt: selectedDate .millisecondsSinceEpoch.toString(),
                    amount: double.parse(amtController.text), balance: 0,
                    catId: AppConstants.mCat[selextedCatindex].id

                )));

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Expense added!!'), backgroundColor: Colors.green,));
                }

               /* DbHelper dbHelper = DbHelper.getInstance();

                bool check =await dbHelper.addExpense(ExpenseModel(
                    userId: int.parse(uid),
                    expenseType: selectedExpType,
                    title: titleController.text, desc: descController.text,
                    createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
                    amount: double.parse(amtController.text), balance: 0,
                    catId: AppConstants.mCat[selextedCatindex].id));
                if(check){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Expense added!!"),
                    backgroundColor: Colors.green,
                  ));
                }else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Adding Expense!!"),
                    backgroundColor: Colors.red,
                  ));*/

            }, child: Text("Add Expense"),
            style: ElevatedButton.styleFrom(
              side: BorderSide(
                width: 1
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21)
              ),
              minimumSize: Size(double.infinity, 56)
            ),)

          ],
        ),
      ),
    );
  }
}