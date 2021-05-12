import 'package:expensify/AddExpenses/model/expense_info.dart';
import 'package:expensify/DatabaseHelper/database_helper.dart';
import 'package:scoped_model/scoped_model.dart';

class ViewExpensesViewModel extends Model{

  Future<List<ExpenseInfo>>fetchExpensesInfo()async{
    return await DatabaseHelper().fetchInfo();
  }


  Future deleteData(String id)async {
    await DatabaseHelper().deleteInfo(id);
  }
}