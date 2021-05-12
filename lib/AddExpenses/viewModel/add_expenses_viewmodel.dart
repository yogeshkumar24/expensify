

import 'dart:io';

import 'package:expensify/AddExpenses/model/expense_info.dart';
import 'package:expensify/DatabaseHelper/database_helper.dart';
import 'package:scoped_model/scoped_model.dart';

class AddExpensesViewModel extends Model{


  Future saveExpenses(ExpenseInfo expenseInfo)async{
    await DatabaseHelper().saveInfo(expenseInfo);
  }

  Future editExpenses(ExpenseInfo expenseInfo,String id)async{
    await DatabaseHelper().updateInfo(expenseInfo, id);
  }

  Future<String> uploadImage(File file)async{
    return await DatabaseHelper().uploadImage(file);
  }

}