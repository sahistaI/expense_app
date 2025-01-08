import 'package:expense_app/ui/bloc/expense_event.dart';
import 'package:expense_app/ui/bloc/expense_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/local_data/db_helper.dart';

class ExpenseBloc extends Bloc<ExpenseEvent,ExpenseState>{
  DbHelper dbHelper;

  ExpenseBloc({required this.dbHelper}) : super(ExpenseInitialState()){

    //add

    on<AddExpenseEvent>((event,emit)async{

      emit(ExpenseInitialState());
      bool check = await dbHelper.addExpense(event.newExp);

      if(check){

        var allExp = await dbHelper.getAllExp();
        emit(ExpenseLoadedState(mExp: allExp));
      } else {
        emit(ExpenseErrorState(errMsg: "Expense cannot be added."));
      }

    });

    on<FetchInitialExpenseEvent>((event,emit)async{

      emit(ExpenseLoadingState());

      var allExp = await dbHelper.getAllExp();
      emit(ExpenseLoadedState(mExp: allExp));


    });


  }

}
