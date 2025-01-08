import 'dart:ui';

import 'package:expense_app/domain/app_constants.dart';
import 'package:expense_app/domain/ui_helper.dart';
import 'package:expense_app/ui/bloc/expense_bloc.dart';
import 'package:expense_app/ui/bloc/expense_event.dart';
import 'package:expense_app/ui/bloc/expense_state.dart';
import 'package:expense_app/ui/on_boarding/add_exp.dart';
import 'package:expense_app/ui/on_boarding/statistic_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/local_data/model/cat_model.dart';
import '../../data/local_data/model/expense_model.dart';
import '../../data/local_data/model/filter_exp_model.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  List<ExpenseModel> mExpenses = [];

  int selectedIndex = 0;

  DateFormat mFormat = DateFormat.yMMMd();

  List<String> durationList = ['Day Wise','Month Wise','Year Wise'];

  String selectedFilter = 'Day Wise';

  List<FilterExpModel> filteredData = [];



  @override
  void initState() {
    super.initState();

    context.read<ExpenseBloc>().add(FetchInitialExpenseEvent());

  }


  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        title: Text("Monety"),
        actions: [
          IconButton(onPressed: (){}, icon:Icon(Icons.search))
        ],
      ),
      body: Column(
                children: [
          ListTile(
            leading: Icon(Icons.account_circle_sharp,size:60,),
            title:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("User Name",style: TextStyle(fontSize:15),),
                Text("User Desc",style: TextStyle(fontSize:15,fontWeight: FontWeight.bold),)
              ],
            ),
            trailing: DropdownButton(
              value: selectedFilter,
              items: durationList.map((_element){
                return DropdownMenuItem(
                  value: _element,
                  child: Text(_element),
              );
              }).toList(),
              onChanged:(value){
               selectedFilter = value!;
               setState(() {
                 if(selectedFilter=="Day Wise"){
                   mFormat = DateFormat.yMMMd(); // Day Wise
                 } else if(selectedFilter== "Month Wise"){
                   mFormat = DateFormat.yMMM(); // Month Wise
                 } else if(selectedFilter=="Year Wise"){
                   mFormat = DateFormat.y(); // Year Wise
                 } /*else if{
                // filteredCategory(allExp : state.mExp);
                 }*/ else {
                 mFormat = DateFormat.yMMMd();
                 }

               });


              } ,
            ),
          ),

          mSpacer(
            mHeigt:10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                // color: Colors.blue[200],
              ),
              child: Image.asset("assets/images/dash_cont.png",fit: BoxFit.cover,),

              width: double.infinity,
              height:160,

            ),
          ),
          SizedBox(height: 15,),

          Expanded(
            child: BlocBuilder<ExpenseBloc,ExpenseState>(builder: (_,state){
              if(state is ExpenseLoadingState){
                return Center(child: CircularProgressIndicator());
              } else if (state is ExpenseErrorState){
                return Center(child: Text(state.errMsg),);
              } else if (state is ExpenseLoadedState){

                filterDataDateWise(allExp: state.mExp);


                return state.mExp.isNotEmpty ? ListView.builder(


                    itemCount: filteredData.length,
                    itemBuilder: (_,index){
            
                 // var allExp = filteredData;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(filteredData[index].typeName,style: TextStyle(fontSize: 17,fontWeight:FontWeight.bold ),),
                                Text("-\$${filteredData[index].totalAmt}",style: TextStyle(fontSize: 17,fontWeight:FontWeight.bold ),),
                              ],
                            ),
                            Divider(),

                            ListView.builder(
                                itemCount: filteredData[index].allExpenses.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (_,childIndex){
                              return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Image.asset(
                            AppConstants.mCat.where((exp){
                              return exp.id == filteredData[index].allExpenses[childIndex].catId;
                            }).toList()[0].imgPath,
                            fit: BoxFit.contain,height: 30,width: 30,),
                        ),
                        SizedBox(width: 15,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(filteredData[index].allExpenses[childIndex].title,style: TextStyle(
                                fontSize: 18,fontWeight: FontWeight.bold
                            ),),
                            Text(filteredData[index].allExpenses[childIndex].desc)
                          ],
                        ),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("${mFormat.format(DateTime.fromMillisecondsSinceEpoch(int.parse(filteredData[index].allExpenses[childIndex].createdAt)))}",style: TextStyle(fontSize: 15,color: Colors.grey),),
                            Text("-\$${filteredData[index].allExpenses[childIndex].amount}",style: TextStyle(fontSize: 20,color: Colors.pinkAccent),),
                          ],
                        )
                      ],
                    ),
                                      );

                            })

                          ],
                        ),
                      ),
                    ),
                  );
            

                }) : Center(
                  child: Text("No Expenses yet!!"),
                );
            
              }
              return Container();
            
            }),
          )


         
         



        ],
      ),

     bottomNavigationBar:  BottomNavigationBar(
          elevation: 10,
          items:[
            BottomNavigationBarItem(icon: Icon(Icons.drafts_outlined,size: 30,),label: 'Home'),
            BottomNavigationBarItem(icon: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddExp()));
                },
                child: Icon(Icons.add,size: 30,)
            ),label: 'Add'),
            BottomNavigationBarItem(icon: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>StatisticPage()));

              },
              child: Icon(Icons.bar_chart,size: 30,),
            ),label: 'Statistic'),
          ],
       selectedFontSize: 10,
       selectedItemColor: Color(0xffE78BBC),
       unselectedItemColor: Color(0xffC2C1CE),
      currentIndex: selectedIndex,
      onTap: (value){
            setState(() {
              selectedIndex = value;

            });

      },

      // currentIndex: ,





     ),

    );

  }

  void filterDataDateWise({required List<ExpenseModel> allExp}){

    filteredData.clear();

    List<String> uniqueDates = [];

    for(ExpenseModel eachExp in allExp){
      String eachDate = mFormat.format(DateTime.fromMillisecondsSinceEpoch
        (int.parse(eachExp.createdAt)));
      print(eachDate);

      if(!uniqueDates.contains(eachDate)){
        uniqueDates.add(eachDate);
      }
    }
    print(uniqueDates);

    for (String eachDate in uniqueDates){
      num totalAmt = 0.0;
      List<ExpenseModel> eachDateExp = [];

      for(ExpenseModel eachExp in allExp){
        String expDate = mFormat.format(DateTime.fromMillisecondsSinceEpoch
          (int.parse(eachExp.createdAt)));

        if(eachDate == expDate){
          eachDateExp.add(eachExp);

          if(eachExp.expenseType=="Debit"){
            //debit
            totalAmt += eachExp.amount;
          } else {
            //credit
            totalAmt -= eachExp.amount;
          }

        }
      }
      filteredData.add(FilterExpModel
        (typeName: eachDate, totalAmt: totalAmt, allExpenses: eachDateExp));
    }
    
    print(filteredData[1].allExpenses.length);

  }



}