import 'package:cached_network_image/cached_network_image.dart';
import 'package:expensify/AddExpenses/model/expense_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';


class ShowExpensesDetails extends StatefulWidget {
  static final String route = "showExpensesDetails";

  @override
  _ShowExpensesDetailsState createState() => _ShowExpensesDetailsState();
}

class _ShowExpensesDetailsState extends State<ShowExpensesDetails> {


  ExpenseInfo expenseInfo;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    gettingArg();
  }

  void gettingArg(){
    Map map = ModalRoute.of(context).settings.arguments as Map;
    expenseInfo = map["expenseInfo"];
  }
  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMicrosecondsSinceEpoch(expenseInfo.date);
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(appBar: AppBar(title: Text("Expenses Details"),),
    body: SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 12,),
              expenseInfo.imageUrl != null ? CachedNetworkImage(
                imageUrl: expenseInfo.imageUrl,
              height:height*0.2, width:width*0.8,fit: BoxFit.contain,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ):
              Column(
                children: [
                  Icon(Icons.image,size: height * 0.3,color: Colors.grey,),
                  Text("No Image Found"),
                ],
              ),

              Column(
                children: [
                SizedBox(height: 24,),
                Center(child: textField("Expense Details")),
                  SizedBox(height: 12,),
                Row(children: [
                  textField("Date",),
                  textField(formattedDate,isValue: true),
                ],),
                SizedBox(height: 12,),
                textField("Item Name",),
                textField(expenseInfo.title,isValue: true),
                SizedBox(height: 12,),
                textField("Quantity"),
                textField(expenseInfo.quantity.toString(),isValue: true),
                SizedBox(height: 12,),
                textField("Price"),
                textField(expenseInfo.price.toString(),isValue: true),
                SizedBox(height: 12,),
                textField("Description"),
                textField(expenseInfo.description,isValue: true,isDes:true),
              ],),

            ],
          ),
        ),
      ),
    ),);
  }

  Widget textField(String value, {bool isValue = false,bool isDes = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isValue ==true || isDes ==true?Text(value,style: TextStyle(fontSize: 18,color: Colors.blue,),maxLines: 3,softWrap: true,overflow: TextOverflow.fade,):
          Text(value,style: TextStyle(fontSize: 24,),),
        ],
      ),
    );
  }
}
