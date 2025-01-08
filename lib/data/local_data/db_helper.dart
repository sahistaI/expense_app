import 'dart:async';

import 'package:expense_app/data/local_data/model/expense_model.dart';
import 'package:expense_app/data/local_data/model/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{

  DbHelper._();

  static DbHelper getInstance()=>DbHelper._();

  Database? mDB;

  static final String TABLE_EXP = "usertable";
  static final String EXP_USER_ID = "u_id";
  static final String EXP_USER_NAME = "u_name";
  static final String EXP_USER_PASS = "u_pass";
  static final String EXP_USER_EMAIL = "u_email";
  static final String EXP_USER_MOBNO = "u_mob";
  static final String EXP_USER_CREATEDAT = "u_createdAt";

  static final String EXP_TABLE = "exptable";
  static final String EXP_ID = "e_id";
  static final String TABLE_USER_ID = "u_id";
  static final String EXP_TYPE = "e_type";
  static final String EXP_TITLE = "e_title";
  static final String EXP_DESC = "e_desc";
  static final String EXP_CREATEDAT = "e_createdAT";
  static final String EXP_AMT = "e_amt";
  static final String EXP_BAL = "e_bal";
  static final String EXP_CAT_ID = "e_catId";

  Future<Database> initDB()async{
  mDB = mDB ?? await openDB();
  print("Open DB!!");
  return mDB!;
  }

  Future<Database> openDB()async{
    var appDir = await getApplicationDocumentsDirectory();
    var dbPath = join(appDir.path,"expenso.db");

    return openDatabase(dbPath,version: 1,onCreate:(db,version){
    print("DB Created");
    db.execute("create table $TABLE_EXP ( $EXP_USER_ID integer primary key autoincrement, $EXP_USER_NAME text, $EXP_USER_PASS text, $EXP_USER_EMAIL text, $EXP_USER_MOBNO text, $EXP_USER_CREATEDAT text)");
    db.execute("create table $EXP_TABLE ( $EXP_ID integer primary key autoincrement, $TABLE_USER_ID int, $EXP_TYPE text, $EXP_TITLE text, $EXP_DESC text, $EXP_AMT real, $EXP_BAL real, $EXP_CAT_ID int, $EXP_CREATEDAT text)");
    });

  }

 Future<bool>  checkIfEmailAlreadyExists({required String email})async{
    var db = await initDB();

    List<Map<String,dynamic>> data = await db.query(TABLE_EXP, where: "$EXP_USER_EMAIL = ?",whereArgs: [email]);

    return data.isNotEmpty;
  }

  Future<bool> registerUser({required UserModel newUser}) async{
    var db = await initDB();

    int rowsEffected = await db.insert(TABLE_EXP, newUser.toMap());
    return rowsEffected>0;

   /* if(!await checkIfEmailAlreadyExists(email: newUser.uEmail)){
      int rowsEffected = await db.insert(TABLE_EXP, newUser.toMap());
      return rowsEffected>0;
    }
    else{
      return false;
    }*/

  }

  Future<bool> authenticateUser({required String email, required String pass}) async{

    var db = await initDB();

   List<Map<String,dynamic>> mData = await db.query(TABLE_EXP,
       where: "$EXP_USER_EMAIL = ? AND $EXP_USER_PASS = ?",whereArgs: [email,pass]);

   /// saving userid in prefs
    if(mData.isNotEmpty){
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("userId", mData[0][EXP_USER_ID].toString());
    }

   return mData.isNotEmpty;

  }

  Future<bool> addExpense(ExpenseModel newExpense)async{

    var db = await initDB();

   /* var prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString("userId") ?? "";
    newExpense.userId = uid;*/

    int rowsEffected = await db.insert(EXP_TABLE, newExpense.toMap());
    return rowsEffected >0;
  }

  Future<List<ExpenseModel>> getAllExp()async{
    var db = await initDB();
    List<Map<String,dynamic>> mData = await db.query(EXP_TABLE);
    List<ExpenseModel> allExp = [];

    for(Map<String,dynamic> eachExp in mData){
      allExp.add(ExpenseModel.fromMap(eachExp));
    }
    return allExp;

  }







}