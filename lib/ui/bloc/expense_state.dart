import '../../data/local_data/model/expense_model.dart';

abstract class ExpenseState {}

class ExpenseInitialState extends ExpenseState{}
class ExpenseLoadingState extends ExpenseState{}
class ExpenseLoadedState extends ExpenseState{
  List<ExpenseModel> mExp;
  ExpenseLoadedState({required this.mExp});
}
class ExpenseErrorState extends ExpenseState{
  String errMsg;
  ExpenseErrorState({required this.errMsg});
}