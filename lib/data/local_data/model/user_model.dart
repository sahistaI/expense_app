import 'package:expense_app/data/local_data/db_helper.dart';
import 'package:sqflite/sql.dart';

class UserModel {

  int? id;
  String uName;
  String uPass;
  String uEmail;
  String uMobNo;
  String uCreatedAt;

  UserModel({
    this.id,
    required this.uName,
    required this.uPass,
    required this.uEmail,
    required this.uMobNo,
    required this.uCreatedAt,

  });

  factory UserModel.fromMap(Map<String,dynamic> map){
    return UserModel(
      id: map[DbHelper.EXP_USER_ID],
      uName: map[DbHelper.EXP_USER_NAME],
      uPass: map[DbHelper.EXP_USER_PASS],
      uEmail: map[DbHelper.EXP_USER_EMAIL],
      uMobNo: map[DbHelper.EXP_USER_MOBNO],
      uCreatedAt: map[DbHelper.EXP_USER_CREATEDAT]
    );

  }


  Map<String, dynamic> toMap() {
    return {
      DbHelper.EXP_USER_NAME: uName,
      DbHelper.EXP_USER_PASS: uPass,
      DbHelper.EXP_USER_EMAIL: uEmail,
      DbHelper.EXP_USER_MOBNO: uMobNo,
    //  DbHelper.EXP_USER_CREATEDAT: uCreatedAt
    };
  }
}
