import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class FirebaseAnalyticsHelper {

 static FirebaseAnalytics analytics = FirebaseAnalytics();
 static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  FirebaseAnalyticsHelper._privateConstructor();

  static final FirebaseAnalyticsHelper _instance = FirebaseAnalyticsHelper._privateConstructor();

  factory FirebaseAnalyticsHelper() {
    return _instance;
  }

Future analyticsDemo(String screenName)async{
  await analytics.setCurrentScreen(screenName: screenName,);
}
Future setEvent(String eventName)async{
  await analytics.logEvent(name: eventName);
}
}