import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:expensify/AddExpenses/model/expense_info.dart';

class DatabaseHelper {
  final databaseRef = FirebaseDatabase.instance.reference();

  Future saveInfo(ExpenseInfo expensesInfo) async {
    DatabaseReference reference = databaseRef.child("Expenses").push();
    expensesInfo.id = reference.key;
    await reference.set(expensesInfo.toJson());
    print("information saved");
  }

  Future<String> uploadImage(File file)async{
    String fileName = file.path;
    FirebaseStorage storageRef = FirebaseStorage.instance;
    Reference reference = storageRef.ref().child("image").child(fileName);
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }


  Future<List<ExpenseInfo>> fetchInfo() async {
    List<ExpenseInfo> expensesInfoList = [];
    var reference = databaseRef.child("Students");
    DataSnapshot dataSnapshot = await reference.once();

    Map<dynamic, dynamic> map = dataSnapshot.value;
    if (map == null || map.length == 0) {
      return [];
    } else {
      map.forEach((key, value) {
        ExpenseInfo expenseInfo =
            ExpenseInfo.fromJson(value.cast<String, dynamic>());
        expenseInfo.id = key;
        expensesInfoList.add(expenseInfo);
      });
      return expensesInfoList;
    }
  }

  Future updateInfo(ExpenseInfo expensesInfo,String id) async {
    var reference = databaseRef.child('Students');
    await reference.child(id).update(expensesInfo.toJson());
    print("information updated");
  }

  Future deleteInfo(String id) async {
    var reference = databaseRef.child("Students");
    await reference.child(id).remove();
    print("information deleted");
  }
}
