import 'dart:async';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:expensify/Services/FirebaseAnalytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expensify/ShowExpensesDetails/show_expenses_details.dart';

import 'AddExpenses/page/add_expenses_page.dart';
import 'package:flutter/material.dart';
import 'ViewExpenses/modal/page/view_expense_page.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runZonedGuarded(() {
    runApp(MyApp());
  }, FirebaseCrashlytics.instance.recordError);
}




class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[FirebaseAnalyticsHelper.observer],
        home: WalkThroughPage(),
        routes: {
          HomePage.route: (context) => HomePage(),
          AddExpensesPage.route: (context) => AddExpensesPage(),
          ViewExpensesPage.route: (context) => ViewExpensesPage(),
          ShowExpensesDetails.route: (context) => ShowExpensesDetails(),
        });
  }
}

class WalkThroughPage extends StatefulWidget {
   WalkThroughPage();

  @override
  _WalkThroughPageState createState() => _WalkThroughPageState();
}

class _WalkThroughPageState extends State<WalkThroughPage> {
  Future<void> _initializeFlutterFireFuture;
  LocalAuthentication auth = LocalAuthentication();
  bool isAuth = false;
  bool isAuthorized = false;

  @override
  void initState() {
    _checkBiometric();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isAuth == true
        ? Container()
        : Scaffold(
            backgroundColor: Colors.black,
            body: Center(
                child: InkWell(
              onTap: () {
                _checkBiometric();
              },
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2.5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.fingerprint,
                      color: Colors.blueAccent,
                    ),
                    Text(
                      "Login with Fingerprint",
                      style: TextStyle(color: Colors.blueAccent),
                    )
                  ],
                ),
              ),
            )),
          );
  }

  void _checkBiometric() async {
    setState(() {
      isAuth = true;
    });

    // authenticate with biometrics
    bool authenticated = false;
    try {
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Touch your finger on the sensor to login',
          useErrorDialogs: true,
          stickyAuth: false,
          androidAuthStrings:
              AndroidAuthMessages(signInTitle: "Login to HomePage"));
      setState(() {
        isAuthorized = authenticated;
        if (isAuthorized) {
          Navigator.pushNamed(context, HomePage.route);
          // sendAnalytics();
          // FirebaseCrashlytics.instance.crash();
        }
      });
    } catch (e) {
      setState(() {
        isAuth = false;
      });
      print("error using biometric auth: $e");
    }
    setState(() {
      isAuth = authenticated ? true : false;
    });
  }
}

class HomePage extends StatefulWidget {
  static final String route = "homePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  List<Widget> tabsListPage = [
    ViewExpensesPage(),
    AddExpensesPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    // var height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        iconSize: 24,
        itemCornerRadius: 24,
        curve: Curves.bounceIn,
        onItemSelected: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.view_agenda_outlined),
            title: Text(
              "View Expenses",
              style: TextStyle(fontSize: 16),
            ),
            textAlign: TextAlign.center,
            activeColor: Colors.blue,
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.add),
            title: Text("Add Expenses"),
            textAlign: TextAlign.center,
            activeColor: Colors.blue,
          ),
        ],
      ),
      appBar: AppBar(
        title: Text("Daily Expenses"),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
      body: tabsListPage[currentIndex],
    );
  }
}
