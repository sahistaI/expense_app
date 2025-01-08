import 'expense_model.dart';

class FilterExpModel {

  String typeName;
  num totalAmt;
  List<ExpenseModel> allExpenses;
  FilterExpModel({required this.typeName,
  required this.totalAmt,
  required this.allExpenses});
}