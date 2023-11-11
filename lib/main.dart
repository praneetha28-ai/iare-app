import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:iare/years.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'categories.dart';
import 'home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    print(isLoggedIn);
    return MaterialApp(
      title: 'IARE',
      theme: ThemeData(
        primaryColor: Color(0xff2B3467),
        // primarySwatch: Colors.blue,
      ),
      home: !isLoggedIn
          ? MyHomePage()
          : HomeScreen(year: year, uName: uName)
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
      print('A new message ');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        // showDialog(context: context,
        //     builder: (_){
        //   return AlertDialog(
        //     title: Text("Yooooo"),
        //     content: SingleChildScrollView(
        //       child: Column(
        //         children: [
        //           Text("You are in the app")
        //         ],
        //       ),
        //     ),
        //   );
        //     });
        Navigator.of(context).push(
            MaterialPageRoute(
            builder: (context) => HomeScreen(
                year: "year_1",
                uName: "20951A6633",
            )
        )
        );
      }
    });
  }

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwdController = TextEditingController();

  void login(String uname) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uName', uname);
    if (uname.startsWith('20951A')) {
      prefs.setBool('isLoggedIn', true);
      prefs.setString('year', 'year_3');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                year: "year_3",
                uName: usernameController.text,
              )));
    }
    if (uname.startsWith('21951A')) {
      prefs.setBool('isLoggedIn', true);
      prefs.setString('year', 'year_2');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                year: "year_2",
                uName: usernameController.text,
              )));
    }
    if (uname.startsWith('19951A')) {
      prefs.setBool('isLoggedIn', true);
      prefs.setString('year', 'year_4');

      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(
                year: "year_4",
                uName: usernameController.text,
              )));
    }
    if (uname.startsWith('22951A')) {
      prefs.setBool('isLoggedIn', true);
      prefs.setString('year', 'year_1');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen(
                    year: "year_1",
                    uName: usernameController.text,
                  )));
    }
    if(uname.startsWith('IARE')){
      prefs.setBool('isLoggedIn', true);
      // prefs.setString('year', 'year_1');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Years()
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    // Firebase.initializeApp();
    // print(FirebaseFirestore.instance.collection('users').snapshots().length);
    // return Scaffold(
    //   backgroundColor: Colors.grey[300],
    //   appBar: AppBar(elevation: 0,backgroundColor: Color(0xff2B3467),
    //     title: Text("IARE"),automaticallyImplyLeading: false,
    //   ),
    //   body: SingleChildScrollView(
    //     physics: ScrollPhysics(),
    //     child: Container(
    //       margin: EdgeInsets.only(top: 65,left: 30,right: 30),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: <Widget>[
    //           CircleAvatar(
    //             radius: 50,
    //             child: Image.asset(
    //                 'assets/images/logo.jfif',fit: BoxFit.fill,
    //             ),),
    //           Container(
    //             height: MediaQuery.of(context).size.height/12,
    //             // color: Colors.grey,
    //             decoration:BoxDecoration(
    //               borderRadius: BorderRadius.circular(15),
    //               color: Colors.white60
    //             ),
    //             margin: EdgeInsets.only(top: 80,left: 10,right: 10,bottom: 25),
    //             child:
    //                 TextField(
    //                   controller: usernameController,
    //                   cursorColor: Color(0xff2B3467),
    //                   decoration: InputDecoration(
    //                     prefixIcon: Icon(Icons.person,color: Color(0xff2B3467),),
    //                   labelText: "Enter username",
    //                   hintText: "Ex : 20951A6633",
    //                   labelStyle: TextStyle(color: Color(0xff2B3467)),
    //                   border: InputBorder.none
    //                 ),
    //                 ),
    //
    //           ),
    //           Container(
    //             height: MediaQuery.of(context).size.height/12,
    //             // color: Colors.grey,
    //             decoration:BoxDecoration(
    //                 borderRadius: BorderRadius.circular(15),
    //                 color: Colors.white60
    //             ),
    //             margin: EdgeInsets.symmetric(horizontal: 10),
    //             child:
    //             TextField(
    //               controller: passwdController,
    //               obscureText: true,
    //               obscuringCharacter: '*',
    //               cursorColor: Color(0xff2B3467),
    //               decoration: InputDecoration(
    //                 fillColor: Color(0xff2B3467),
    //                   prefixIcon: Icon(Icons.password,color: Color(0xff2B3467),),
    //                   labelText: "Enter password",
    //                   labelStyle: TextStyle(color: Color(0xff2B3467)),
    //
    //                   border: InputBorder.none
    //               ),
    //             ),
    //           ),
    //
    //           Container(
    //             margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/8),
    //             width: MediaQuery.of(context).size.width/3,
    //             height: MediaQuery.of(context).size.height/10,
    //             decoration: BoxDecoration(
    //               // shape: BoxShape.circle,
    //               // borderRadius: BorderRadius.circular(20)
    //               borderRadius: BorderRadius.circular(25),
    //               border: Border.all(color: Color(0xff2B3467))
    //             ),
    //             child: ElevatedButton(
    //               style: ElevatedButton.styleFrom(
    //                 maximumSize: Size(MediaQuery.of(context).size.width/1.5, MediaQuery.of(context).size.height/10),
    //                 backgroundColor: Color(0xff2B3467),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(25)
    //                   )),
    //               onPressed: (){login(usernameController.text);},
    //               child: Icon(Icons.arrow_forward_rounded,color: Colors.grey[200],size: 30,),
    //             ),
    //           )
    //         ],
    //       ),
    //     ),
    //   ), // This trailing comma makes auto-formatting nicer for build methods.
    // );
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
                              letterSpacing: 1.5)),
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
                            Container(

                              margin: EdgeInsets.all(8),
                              width: MediaQuery.of(context).size.width/1.5,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: TextField(
                                controller: usernameController,
                                decoration: InputDecoration(
                                  hintText: 'Login',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: 32),
                                ),
                                onSubmitted: (text){
                                 login(usernameController.text.toUpperCase());
                                },
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
//     Positioned(
//       right: 8,
//       child:OverflowBox(
//          maxWidth: double.infinity,
//         child: Image.network(
//         "https://media.istockphoto.com/id/1313326843/photo/3d-illustration-of-smiling-man-with-laptop-sitting-on-the-floor-in-yoga-lotus-position.jpg?s=2048x2048&w=is&k=20&c=M1IanrN_mSgebSq6rrw2kAfdMxs__t3_O0RJF3PiHRg=",
//         width: 150,
//         height: 150,
//       ),
//       ),
//     ),
                          ],
                        ),
                      )

                    ]
                )
            )
        ),
      ),
    );
  }
}
