

import 'package:expense_app/data/local_data/db_helper.dart';

class ExpenseModel {
  int? eid;
  int userId;
  String expenseType;
  String title;
  String desc;
  String createdAt;
  double amount;
  double balance;
  int catId;

  ExpenseModel({
    this.eid,
    required this.userId,
    required this.expenseType,
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.amount,
    required this.balance,
    required this.catId,
});

  factory ExpenseModel.fromMap(Map<String,dynamic> map){
    return ExpenseModel(
      eid: map[DbHelper.EXP_ID],
      userId: map[DbHelper.EXP_USER_ID],
      expenseType: map[DbHelper.EXP_TYPE],
      title: map[DbHelper.EXP_TITLE],
      desc: map[DbHelper.EXP_DESC],
      createdAt: map[DbHelper.EXP_CREATEDAT],
      amount: map[DbHelper.EXP_AMT],
      balance: map[DbHelper.EXP_BAL],
      catId: map[DbHelper.EXP_CAT_ID]
    );

  }

Map<String,dynamic> toMap(){
  return{
     DbHelper.EXP_USER_ID:userId,
    DbHelper.EXP_TYPE : expenseType,
    DbHelper.EXP_TITLE : title,
    DbHelper.EXP_DESC : desc,
    DbHelper.EXP_CREATEDAT: createdAt,
    DbHelper.EXP_AMT: amount,
    DbHelper.EXP_BAL: balance,
    DbHelper.EXP_CAT_ID: catId,
  };
}


}
