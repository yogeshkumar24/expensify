import 'dart:async';
import 'package:expensify/AddExpenses/model/expense_info.dart';
import 'package:expensify/AddExpenses/page/add_expenses_page.dart';
import 'package:expensify/Services/FirebaseAnalytics/firebase_analytics.dart';
import 'package:expensify/ShowExpensesDetails/show_expenses_details.dart';
import 'package:expensify/ViewExpenses/modal/viewModel/view_expenses_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

class ViewExpensesPage extends StatefulWidget {
  static  final String route = "viewExpense";
  @override
  _ViewExpensesPageState createState() => _ViewExpensesPageState();
}

class _ViewExpensesPageState extends State<ViewExpensesPage> {
  List<ExpenseInfo> list;
  bool isLoading = false;
  ViewExpensesViewModel viewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    viewModel = ViewExpensesViewModel();
    fetchInfo();
    FirebaseAnalyticsHelper().analyticsDemo("ViewExpense");FirebaseAnalyticsHelper().analyticsDemo("ViewExpense");
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModel<ViewExpensesViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<ViewExpensesViewModel>(
        builder: (context,child,viewModel){
          return Scaffold(
            body: isLoading == true
                ? Center(
              child: CircularProgressIndicator(),
            )
                : SmartRefresher(
              onRefresh: fetchInfo,
              controller: RefreshController(),
              child: list == null || list.length == 0
                  ? Center(child: Text("No Expenses Found"))
                  : ListView.builder(
                itemCount: list.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actions: [IconSlideAction(
                       caption: 'Delete',
                       iconWidget: Icon(Icons.delete,color: Colors.deepOrange,size: 32,),
                       onTap: () => deleteData(list[index].id).whenComplete(() {
                         setState(() {
                           list.removeAt(index);
                         });
                       })
                     ),
                      IconSlideAction(
                          caption: 'Update',
                          iconWidget: Icon(Icons.update,color: Colors.green,size: 32,),
                          onTap: (){Navigator.of(context).pushNamed(AddExpensesPage.route,arguments: {"expenseInfo":list[index],});
                          FirebaseAnalyticsHelper().setEvent("updateButtonClicked",);}),
                      ],

                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'More',
                          iconWidget: Icon(Icons.more,color: Colors.green,size: 32,),
                        ),
                      ],
                      child: GestureDetector(
                          onTap: ()=> Navigator.of(context).pushNamed(ShowExpensesDetails.route,arguments: {"expenseInfo":list[index]}),
                          child: getCardWidget(index))),
                ),
              ),
            ),
          );
        },

      ),
    );
  }

  Future deleteData(String id)async {
    await viewModel.deleteData(id);
  }

  Card getCardWidget(int index) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(list[index].date);
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return Card(
      elevation: 12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.pink,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          rowWidget("Title", list[index].title),
          rowWidget("Quantity", list[index].quantity.toString()),
          rowWidget("Price", list[index].price.toString()),
          rowWidget("Description", list[index].description),
          rowWidget("Date",formattedDate),
        ],
      ),
    );
  }

  Future fetchInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      list = await viewModel.fetchExpensesInfo().timeout(Duration(seconds: 30));
      onLoadingComplete();
    } on TimeoutException catch (e) {
      print('fetchInfo $e');
      onLoadingComplete();
    }
  }

  void onLoadingComplete() {
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget rowWidget(String name, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600,),
            ),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.fade,
              softWrap: false,
              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600,),
            ),
          ),
        ],
      ),
    );
  }
}
