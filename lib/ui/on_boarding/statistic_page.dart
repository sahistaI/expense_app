import 'dart:ui';

import 'package:d_chart/commons/data_model/data_model.dart';
import 'package:d_chart/d_chart.dart';
import 'package:expense_app/data/local_data/model/filter_cat_model.dart';
import 'package:expense_app/data/local_data/model/filter_exp_model.dart';
import 'package:expense_app/domain/ui_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../data/local_data/model/cat_model.dart';
import '../../data/local_data/model/expense_model.dart';
import '../../domain/app_constants.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_state.dart';

class StatisticPage extends StatefulWidget{
  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {

  String selectedFilter ="Month Wise";

  DateFormat mFormat = DateFormat.yMMM();

  List<String> durationList = ["Year Wise","Month Wise","Day Wise"];

  List<FilterCatModel> filteredCategory = [];

  List<FilterExpModel> filteredData = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: MediaQuery.of(context).orientation == Orientation.landscape ? Row(
            children: [
              Expanded(child: getUIOne()),
              Expanded(child: SingleChildScrollView(child: getUITwo())),

            ],
          ): Column(
            children: [
              getUIOne(),
              getUITwo(),






            ],
          ),
        ) ,



      ),
    );
  }



  Widget getUITwo(){
    return BlocBuilder<ExpenseBloc,ExpenseState>(builder: (_,state){
      if(state is ExpenseLoadingState){
        return Center(child: CircularProgressIndicator());
      } else if (state is ExpenseErrorState){
        return Center(child: Text(state.errMsg),);
      } else if (state is ExpenseLoadedState){

        filterDataDateWise(allExp: state.mExp);

        List<OrdinalData> mData = [];
        num highestAmt = 0;

        for(FilterExpModel eachFilterData in filteredData){

          if(highestAmt<eachFilterData.totalAmt){
            highestAmt = eachFilterData.totalAmt;
          }


          mData.add(OrdinalData(domain: eachFilterData.typeName,
              measure: eachFilterData.totalAmt));

        }

        return filteredData.isNotEmpty ?
        Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:25.0),
            child: AspectRatio(
              aspectRatio: 16/9,
              child: DChartBarO(
                measureAxis: MeasureAxis(
                  lineStyle: LineStyle(
                    color: Colors.black,
                    thickness: 1,



                  ),
                ),
                domainAxis: (
                    DomainAxis(
                      showLine: true,
                      lineStyle:LineStyle(
                          color: Colors.black
                      ),
                    )
                ),

                groupList: [
                  OrdinalGroup(id: "1", data: mData)
                ],
                configRenderBar: ConfigRenderBar(
                    radius: 11
                ),
                fillColor: (group,data,index){
                  return data.measure == highestAmt ? Colors.pink.shade300 : Colors.deepPurple.shade200;
                },
              ),


            ),
          ),
            SizedBox(height: 16,),

            Expanded(
              child: BlocBuilder<ExpenseBloc,ExpenseState>(builder: (_,state){
              if(state is ExpenseLoadingState){
              return Center(child: CircularProgressIndicator());
              } else if (state is ExpenseErrorState){
              return Center(child: Text(state.errMsg),);
              } else if (state is ExpenseLoadedState){
              
              filterDataCategoryWise(expenseList: state.mExp);
              
              return filteredCategory.isNotEmpty ?
              
              ListView.builder(
              
              itemCount: filteredCategory.length,
              itemBuilder: (_,index){
              
              final category = filteredCategory[index];
              
              return Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
              leading: Image.asset(
              AppConstants.mCat.where((exp){
              return exp.id == category.id;
              }).toList()[0].imgPath,
              fit: BoxFit.contain,height: 30,width: 30,),
              title: Text(category.title, style: TextStyle(fontSize: 18)),
              trailing: Text(
              "Total: \$${category.amount.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
              )));
              
              
              }) : Center(
              child: Text("No Expenses yet!!"),
              );
              
              }
              return Container();
              
              }),
            ),
        ],
                )

            : Center(
          child: Text("No Expenses yet!!"),
        );

      }
      return Container();

    });




  }

  Widget getUIOne(){
    return Column(
      children: [
        ListTile(
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,size: 18,)),
          title:Text("Statistic",style: TextStyle(fontSize:25,fontWeight: FontWeight.bold),),
          trailing: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 130,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                color: Color(0xffE78BBC),
              ),
              child: DropdownButton(
                dropdownColor:Color(0xffE78BBC) ,
                value: selectedFilter,
                borderRadius: BorderRadius.circular(11),
                items: durationList.map((_element){
                  return DropdownMenuItem(
                    value: _element,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: Text(_element,style: TextStyle(color: Colors.white),),),
                    ),
                  );
                }).toList(),
                onChanged:(value){
                  selectedFilter = value!;
                  setState(() {
                    if(selectedFilter=="Day Wise"){
                      mFormat = DateFormat.yM(); // Day Wise
                    } else if(selectedFilter== "Month Wise"){
                      mFormat = DateFormat.yMMM(); // Month Wise
                    } else if(selectedFilter=="Year Wise"){
                      mFormat = DateFormat.y(); // Year Wise
                    }
                    else {
                      mFormat = DateFormat.yMMMd();
                    }
                  });
                } ,
              ),
            ),
          ),
        ),
        mSpacer(
            mHeigt: 10
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:10.0),
          child: Container(
            width: 430,
            height: 120,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Total Balance",style: TextStyle(fontSize:20,color: Colors.white,fontWeight:FontWeight.bold ),),mSpacer(),
                  Text("\$1347",style: TextStyle(fontSize:20,color: Colors.white,fontWeight:FontWeight.bold),),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(11),
              color:Color(0xffE78BBC),
            ),
          ),
        ),

      ],
    );
  }
/*
  Widget getUIThree(){
    return
      Expanded(
      child: BlocBuilder<ExpenseBloc,ExpenseState>(builder: (_,state){
        if(state is ExpenseLoadingState){
          return Center(child: CircularProgressIndicator());
        } else if (state is ExpenseErrorState){
          return Center(child: Text(state.errMsg),);
        } else if (state is ExpenseLoadedState){

          filterDataCategoryWise(expenseList: state.mExp);

          return filteredCategory.isNotEmpty ?

          ListView.builder(


              itemCount: filteredCategory.length,
              itemBuilder: (_,index){

                final category = filteredCategory[index];

                return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                        leading: Image.asset(
                          AppConstants.mCat.where((exp){
                            return exp.id == category.id;
                          }).toList()[0].imgPath,
                          fit: BoxFit.contain,height: 30,width: 30,),
                        title: Text(category.title, style: TextStyle(fontSize: 18)),
                        trailing: Text(
                          "Total: \$${category.amount.toStringAsFixed(2)}",
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                        )));


              }) : Center(
            child: Text("No Expenses yet!!"),
          );

        }
        return Container();

      }),
    );


  }*/



  void filterDataCategoryWise({required List<ExpenseModel> expenseList}){
    filteredCategory.clear();
    List<int> uniqueId = [];

    for(ExpenseModel eachExp in expenseList){
      int eachId = eachExp.catId;
      if(!uniqueId.contains(eachId)){
        uniqueId.add(eachId);
      }
      }
    print(uniqueId);

    for(int eachId in uniqueId){
      double totalAmount = 0.0;
      String title = "";
      String expenseType = "";
      for(ExpenseModel eachExp in expenseList){
        int expId = eachExp.catId;
        if(eachId == expId){
          title = eachExp.title;
          expenseType = eachExp.expenseType;
          totalAmount = totalAmount+eachExp.amount;
        }

      }
      filteredCategory.add(FilterCatModel
        (id: eachId, title: title, amount: totalAmount, expenseType:expenseType));




    }



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




