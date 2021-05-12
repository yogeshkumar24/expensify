import 'dart:io';

import 'package:expensify/AddExpenses/model/expense_info.dart';
import 'package:expensify/AddExpenses/viewModel/add_expenses_viewmodel.dart';
import 'package:expensify/Services/FirebaseAnalytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class AddExpensesPage extends StatefulWidget {
  static final String route = "addExpensesPage";

  @override
  AddExpensesPageState createState() => AddExpensesPageState();
}

class AddExpensesPageState extends State<AddExpensesPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  File _image;
  bool isUpload = false;
  AddExpensesViewModel viewModel;
  ExpenseInfo expenseInfo;
  String url;

  @override
  void initState() {
    viewModel = AddExpensesViewModel();
    FirebaseAnalyticsHelper().analyticsDemo("AddExpenses");
    super.initState();
    
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  getArgs() {
    Map arguments = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    if (arguments != null) {
      expenseInfo = arguments["expenseInfo"];
      url = expenseInfo.imageUrl;
      _titleController.text = expenseInfo.title;
      _quantityController.text = expenseInfo.quantity.toString();
      _priceController.text = expenseInfo.price.toString();
      _descriptionController.text = expenseInfo.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (expenseInfo == null) {
      getArgs();
    }
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return ScopedModel<AddExpensesViewModel>(
      model: viewModel,
      child: ScopedModelDescendant<AddExpensesViewModel>(
        builder: (context, child, viewModel) {
          return Scaffold(
              body: SingleChildScrollView(
                // physics: NeverScrollableScrollPhysics(),
                child: Form(
                  key: formKey,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: isUpload
                          ? Container(
                          width: width,
                          height: height,
                          child: Center(child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 8,),
                              Text("Please Wait While Uploading Image...")
                            ],
                          )))
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 24,
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: _image == null
                                ?
                              Icon(Icons.image,size: height * 0.2,color: Colors.grey,)
                                : Image.file(
                              _image,
                              height: height * 0.2,
                              width: width * 0.8,
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          textFormField(
                              _titleController, "Enter Title", Icons.title),
                          SizedBox(
                            height: 8,
                          ),
                          textFormField(_quantityController, "Enter Quantity",
                              Icon(Icons.plus_one),
                              isNumber: true),
                          SizedBox(
                            height: 8,
                          ),
                          textFormField(_priceController, "Enter Price",
                              Icon(Icons.monetization_on_sharp),
                              isNumber: true),
                          SizedBox(
                            height: 8,
                          ),
                          textFormField(_descriptionController,
                              "Enter Description",
                              Icon(Icons.description),
                              isDes: true,
                          isLast:true),
                          SizedBox(
                            height: 16,
                          ),
                          RawMaterialButton(
                            fillColor: Theme
                                .of(context)
                                .accentColor,
                            child: Icon(
                              Icons.add_photo_alternate_rounded,
                              color: Colors.white,
                            ),
                            elevation: 8,
                            onPressed: () {
                              getImage();
                            },
                            padding: EdgeInsets.all(15),
                            shape: CircleBorder(),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              expenseInfo == null
                                  ? getButton("Save", saveData)
                                  : Container(),
                              expenseInfo != null
                                  ? getButton("Update", () {
                                updateExpensesInfo(expenseInfo.id);
                              })
                                  : Container()
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }

  void clearTextField() {
    _titleController.text = "";
    _descriptionController.text = "";
    _priceController.text = "";
    _quantityController.text = "";
  }

  Future saveData() async {
    if (formKey.currentState.validate()) {
      FirebaseAnalyticsHelper().setEvent("Save button clicked");
      ExpenseInfo expensesInfo = gettingTextValues();
      await viewModel.saveExpenses(expensesInfo);
      FirebaseAnalyticsHelper().setEvent("save response came");
      clearTextField();
    }
  }

  Future updateExpensesInfo(String id) async {
    if (formKey.currentState.validate()) {
      ExpenseInfo expenseInfo = gettingTextValues();
      await viewModel
          .editExpenses(expenseInfo, id)
          .whenComplete(() => Navigator.pop(context));
      clearTextField();
    }
  }

  ExpenseInfo gettingTextValues() {
    var title = _titleController.text;
    var desc = _descriptionController.text;
    var quantity = int.parse(_quantityController.text);
    var price = int.parse(_priceController.text);
    int totalPrice = quantity * price;


    ExpenseInfo expensesInfo = ExpenseInfo(
        title: title,
        description: desc,
        quantity: quantity,
        price: totalPrice,
        date: int.parse(DateTime
            .now()
            .microsecondsSinceEpoch
            .toString()),
        imageUrl: url);
    return expensesInfo;
  }

  Widget getButton(String name, Function callback) {
    return RaisedButton(
      padding: EdgeInsets.all(16),
      color: Colors.purple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        callback();
      },
    );
  }

  Future getImage() async {
    setState(() {
      isUpload = true;
    });
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile =
    await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      viewModel.uploadImage(_image).then((value) {
        setState(() {
          url = value;
          isUpload = false;
        });
        print(url);
      });
    } else {
      print("image not selected");
    }
  }

  Widget textFormField(controller, hintText, icon,
      {isDes = false, isNumber = false,isLast = false}) {
    return TextFormField(
      validator: (value) {
        if (value.isNotEmpty) {
          return null;
        } else {
          return "Please fill all field";
        }
      },
      textInputAction: isLast ==false ?TextInputAction.next:TextInputAction.done,
      maxLines: isDes == true ? 3 : 1,
      keyboardType:
      isNumber == true ? TextInputType.number : TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        // prefixIcon: icon,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))),
    );
  }
}
