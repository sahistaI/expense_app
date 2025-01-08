import 'package:expense_app/data/local_data/db_helper.dart';
import 'package:expense_app/domain/app_constants.dart';
import 'package:expense_app/ui/bloc/expense_bloc.dart';
import 'package:expense_app/ui/on_boarding/add_exp.dart';
import 'package:expense_app/ui/on_boarding/dashboard_page.dart';
import 'package:expense_app/ui/on_boarding/login.dart';
import 'package:expense_app/ui/on_boarding/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

void main() {
  runApp(BlocProvider(
      create: (context)=>ExpenseBloc(dbHelper: DbHelper.getInstance()),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.App_Name,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Splashscreen(),
    );
  }
}
