import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:iare/adminLogin.dart';
import 'package:iare/years.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'categories.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    "high_importance_channel", 'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final year = prefs.getString('year') ?? "year_1";
  final uname = prefs.getString('uName') ?? '';
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);


  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    year: year,
    uName: uname,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String year;
  final String uName;
  const MyApp(
      {super.key,
      required this.isLoggedIn,
      required this.year,
      required this.uName});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);

    // print(isLoggedIn);
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      title: 'IARE',
      theme: ThemeData(
        primaryColor: Color(0xff2B3467),
        // primarySwatch: Colors.blue,
      ),
      // home: !isLoggedIn
      //     ? MyHomePage()
      //     : HomeScreen(year: year, uName: uName)
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if (snapshot.hasError){
            return Text(snapshot.error.toString());
          }
          if (snapshot.connectionState==ConnectionState.active){
            if (snapshot.data==null){
              return MyHomePage();
            }
            else{
              String rollNum = FirebaseAuth.instance.currentUser!.email!.split('@')[0];
              String name = FirebaseAuth.instance.currentUser!.displayName!;
                if (rollNum.startsWith('20951a')) {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => HomeScreen(
                  //           year: "year_4",
                  //           uName: name,
                  //         )));
                  return HomeScreen(year: "year_4", uName: name,firebaseAnalytics: analytics,firebaseAnalyticsObserver: observer,);
                }
                if (rollNum.startsWith('21951a')) {

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => HomeScreen(
                  //           year: "year_3",
                  //           uName: name,
                  //         )));
                  return HomeScreen(year: "year_3", uName: name,firebaseAnalytics: analytics,firebaseAnalyticsObserver: observer,);
                }
                if (rollNum.startsWith('23951a')) {

                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => HomeScreen(
                  //           year: "year_1",
                  //           uName: name,
                  //         )));
                  return HomeScreen(year: "year_1", uName: name,firebaseAnalytics: analytics,firebaseAnalyticsObserver: observer,);
                }
                if (rollNum.startsWith('22951a')) {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => HomeScreen(
                  //       year: "year_3",
                  //       uName: name,
                  //     )));
                  return HomeScreen(year: "year_2", uName: name,firebaseAnalytics: analytics,firebaseAnalyticsObserver: observer,);
                }
            // return   Text("");
            }
          }
          print(FirebaseAuth.instance.currentUser!.email!);
            return Center(child: CircularProgressIndicator(),);
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();

  static GlobalKey<_MyHomePageState> createKey() =>
      GlobalKey<_MyHomePageState>();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(channel.id, channel.name,
                  channelDescription: channel.description,
                  color: Colors.blue,
                  playSound: true,
                  icon: '@mipmap/ic_launcher'),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new message ');
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     Navigator.of(context).push(
    //         MaterialPageRoute(
    //         builder: (context) => HomeScreen(
    //             year: "year_1",
    //             uName: "20951A6633",
    //         )
    //     )
    //     );
    //   }
    });
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwdController = TextEditingController();

  void login(String uname) async {
    // final prefs = await SharedPreferences.getInstance();
    // prefs.setString('uName', uname);
    // if (uname.startsWith('20951A')) {
    //   prefs.setBool('isLoggedIn', true);
    //   prefs.setString('year', 'year_3');
    //
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => HomeScreen(
    //             year: "year_3",
    //             uName: usernameController.text,
    //           )));
    // }
    // if (uname.startsWith('21951A')) {
    //   prefs.setBool('isLoggedIn', true);
    //   prefs.setString('year', 'year_2');
    //
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => HomeScreen(
    //             year: "year_2",
    //             uName: usernameController.text,
    //           )));
    // }
    // if (uname.startsWith('19951A')) {
    //   prefs.setBool('isLoggedIn', true);
    //   prefs.setString('year', 'year_4');
    //
    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
    //       builder: (context) => HomeScreen(
    //             year: "year_4",
    //             uName: usernameController.text,
    //           )));
    // }
    // if (uname.startsWith('22951A')) {
    //   prefs.setBool('isLoggedIn', true);
    //   prefs.setString('year', 'year_1');
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => HomeScreen(
    //                 year: "year_1",
    //                 uName: usernameController.text,
    //               )));
    // }
    // if(uname.startsWith('IARE')){
    //   prefs.setBool('isLoggedIn', true);
    //   // prefs.setString('year', 'year_1');
    //   Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => Years()
    //       )
    //   );
    // }
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(authCredential);


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
//           alignment: Alignment.center,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xffD0DDFF),
                Color(0xffFFFFFF),
              ],
            )),
            child: Container(
                margin: EdgeInsets.only(top: 100, left: 42),
                height: MediaQuery.of(context).size.height ,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 45, backgroundColor: Colors.white,
                        child: Image.asset('assets/images/logo_1.jpg',fit:BoxFit.fill,height: 60,width: 60,),
                      ),
                      SizedBox(height: 10),
                      Text("THE ALL NEW",
                          style: TextStyle(
                              color: Color(0xff6A7EC3),
                              fontSize: 20,
                              letterSpacing: 1.5)
                      ),
                      SizedBox(height: 5),
                      Text("IARE App",
                          style: TextStyle(
                              color: Color(0xff6A7EC3),
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5)),
                      SizedBox(height: MediaQuery.of(context).size.height/3.8),
                      Container(
                        height: 200,
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            GestureDetector(
                              onTap: (){
                                login(usernameController.text);
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
                                width: MediaQuery.of(context).size.width/1.5,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                      style: TextStyle(
                                          color: Color(0xff6A7EC3),
                                          fontSize: 20,
                                        fontWeight: FontWeight.w600
                                          )
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 150,
                              child:  GestureDetector(
                                onTap: (){
                                  login(usernameController.text.toUpperCase());
                                },
                                child: Container(
                                  height: 190,
                                  width: 190,
                                  child: Image.asset(
                                    'assets/images/boy.png',
                                    fit: BoxFit.contain,
                                    // height: double.infinity,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AdminLogin()));
                        },
                          child: Center(child: Text("Login as Administrator ?",
                            style: GoogleFonts.plusJakartaSans(fontSize: 15,color: Color(0xff6A7EC3)),)))
                    ]
                )
            )
        ),
      ),
    );
  }
}
