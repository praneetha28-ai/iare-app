import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eraser/eraser.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in/widgets.dart';
import 'package:iare/admin.dart';
import 'package:iare/adminLogin.dart';
import 'package:iare/detailedPost.dart';
import 'package:iare/main.dart';
import 'package:linkwell/linkwell.dart';
import 'constants.dart';
import 'dataContainer.dart';
import 'package:intl/intl.dart';
import 'package:firebase_analytics/observer.dart';


class HomeScreen extends StatefulWidget {
  // String year;
  // String uType;
  // String category;
  String year;
  String uName;
  FirebaseAnalytics firebaseAnalytics;
  FirebaseAnalyticsObserver firebaseAnalyticsObserver;
  HomeScreen({Key? key,required this.year,required this.uName,required this.firebaseAnalytics,required this.firebaseAnalyticsObserver}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState(year,uName,firebaseAnalytics,firebaseAnalyticsObserver);
}

class _HomeScreenState extends State<HomeScreen> {
  // late String year;
  // late String uType;
  // late String category;
  String year;
  String uName;
  FirebaseAnalytics firebaseAnalytics;
  FirebaseAnalyticsObserver firebaseAnalyticsObserver;
  _HomeScreenState(this.year,this.uName,this.firebaseAnalytics,this.firebaseAnalyticsObserver);
  String head = "Exams";

  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .subscribeToTopic("${year}-exams")
        .whenComplete(() => print("Subscription successful"));
    FirebaseMessaging.instance
        .subscribeToTopic("${year}-placements")
        .whenComplete(() => print("Subscription successful"));
    FirebaseMessaging.instance
        .subscribeToTopic("${year}-events")
        .whenComplete(() => print("Subscription successful"));
    FirebaseMessaging.instance
        .subscribeToTopic("${year}-others")
        .whenComplete(() => print("Subscription successful"));
    FirebaseMessaging.instance
        .subscribeToTopic("all")
        .whenComplete(() => print("Subscription successful"));
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
      // print('A new message ');
      // RemoteNotification? notification = message.notification;
      // AndroidNotification? android = message.notification?.android;
      // if (notification != null && android != null) {
      //   Navigator.of(context).push(MaterialPageRoute(
      //       builder: (context) => HomeScreen(
      //         year: year,
      //         uName: uName,
      //
      //       )));
      // }
      Eraser.clearAllAppNotifications();

    });
  }
  void logCategorySelectionEvent(String categoryName) {
    firebaseAnalytics.logEvent(
      name: 'category_selection',
      parameters: {
        'category_name': categoryName,
        'user_id': uName,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  Widget CategoriesScroll() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Container(
                margin: EdgeInsets.all(8),
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("Exams",style: GoogleFonts.plusJakartaSans(color: textcolor),)),
              ),
              onTap: (){
                setState(() {
                  head="exams";
                  logCategorySelectionEvent("Exams");
                });
              },
            ),
            InkWell(

              child: Container(
                margin: EdgeInsets.all(8),
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("Bus",style: GoogleFonts.plusJakartaSans(color: textcolor),)),
              ),
              onTap: (){
                setState(() {
                  head="bus";
                  logCategorySelectionEvent("Bus");
                });
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(8),
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("Events",style: GoogleFonts.plusJakartaSans(color: textcolor),)),
              ),
              onTap: (){
                setState(() {
                  head="events";
                  logCategorySelectionEvent("Events");
                });
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(8),
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("Misc",style: GoogleFonts.plusJakartaSans(color: textcolor),)),
              ),
              onTap: (){
                setState(() {
                  head="misc";
                  logCategorySelectionEvent("Misc");
                });
              },
            ),
            InkWell(
              child: Container(
                margin: EdgeInsets.all(8),
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(child: Text("Placements",style: GoogleFonts.plusJakartaSans(color: textcolor),)),
              ),
              onTap: (){
                setState(() {
                  head="placements";
                  logCategorySelectionEvent("Placements");
                });
              },
            ),
          ],
        ),
      ),
    );
}
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signOut() async {
    try {
      await _googleSignIn.signOut(); // Sign out from Google
      await _auth.signOut(); // Sign out from Firebase
      print("User signed out");
    } catch (e) {
      print("Error signing out: $e");
    }
  }

Widget Header(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
            onTap: (){
            _signOut();
            },
            child: CircleAvatar(radius: 30,backgroundColor: Colors.white,
              child: Image.asset("assets/images/logo_1.jpg",width: 35,height: 35,),)
        ),
        if (year=='year_1')
          Text("I B.TECH",style: GoogleFonts.plusJakartaSans(fontSize: 20),)
        else if (year=='year_2')
          Text("II B.TECH",style: GoogleFonts.plusJakartaSans(fontSize: 20),)
        else if (year=='year_3')
            Text("III B.TECH",style: GoogleFonts.plusJakartaSans(fontSize: 20),)
          else if(year=='year_4')
              Text("IV B.TECH",style: GoogleFonts.plusJakartaSans(fontSize: 20),)
        ,
        InkWell(
            // onTap: (){
            //   Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage()));
            // },
            child: Container(
                decoration:const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color(0xffD0DDFF),
                      Color(0xffF0F4FF),
                    ]
                  )
                ),
            )
        ),
      ],
    );
}


  @override
  Widget build(BuildContext context) {
    print("helloo");
    // print(FirebaseFirestore.instance.collection("year_1").doc().collection("bus").doc().path);
    firebaseAnalytics.logEvent(
        name: 'screen_view',
        parameters: {
      'screen_name': 'home',
          'user':uName
    });
   return Scaffold(
     body: SingleChildScrollView(
       physics: ScrollPhysics(),
       child: Container(
         decoration:const BoxDecoration(
           gradient: LinearGradient(
             colors: [
               Color(0xffD0DDFF),
               Color(0xffF0F4FF),
             ]
           )
         ),
         child: Container(
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
           margin: EdgeInsets.only(left: 10,right:10,top: 30),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Header(),
               CategoriesScroll(),
               Padding(
                 padding: const EdgeInsets.only(top: 8.0,left: 15),
                 child: Text(head.toUpperCase(),
                   style: GoogleFonts.plusJakartaSans(color: textcolor,
                       fontSize: 35,letterSpacing: 1.5,
                       fontWeight: FontWeight.bold),textAlign:TextAlign.left,),
               ),
               Container(
                 height: MediaQuery.of(context).size.height/1.5,
                 child: StreamBuilder(

                   stream: FirebaseFirestore.instance
                       .collection(year)
                       .doc(head.toLowerCase()=="misc"?"others":head.toLowerCase())
                       .collection("notifications")
                       .orderBy("date", descending: true)
                       .snapshots(),
                     builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                       if (!snapshot.hasData) {
                         return const Center(
                             child: CircularProgressIndicator(
                               color: Color(0xff13005A),
                             )
                         );
                       }
                         return snapshot.data?.size==0?
                         Center(child: Text("No data posted"),):
                         Column(
                           children: [
                             Expanded(
                               child: Container(
                                 height: MediaQuery.of(context).size.height*(2),
                                 width: MediaQuery.of(context).size.width,
                                 child: ListView.builder(
                                     physics: ScrollPhysics(),
                                     itemCount: snapshot.data?.size,
                                     itemBuilder: (context, i) {
                                       QueryDocumentSnapshot value =
                                       snapshot.data!.docs[i];
                                       final timestamp1 = value['date'].millisecondsSinceEpoch;
                                       var date = DateTime.fromMillisecondsSinceEpoch(timestamp1);
                                       DateTime currentDate = DateTime.now();
                                       String formattedDate;
                                       String formattedTime = DateFormat.jm().format(date);

// Now you can use 'formattedTime' to display the time
                                       print(formattedTime);
                                       String time="${date.hour}:${date.minute}";
                                       if (date.year == currentDate.year &&
                                           date.month == currentDate.month &&
                                           date.day == currentDate.day) {
                                         formattedDate = "Today";
                                       } else if (date.year == currentDate.year &&
                                           date.month == currentDate.month &&
                                           date.day == currentDate.day - 1) {
                                         formattedDate = "Yesterday";
                                       } else {
                                         formattedDate = "${date.day}-${date.month}-${date.year}";

                                       }
                                       // print(formattedDate);
                                       return Card(
                                         elevation: 5,
                                         margin: EdgeInsets.all(8),
                                         child: Container(
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.all(Radius.circular(8)),
                                             color: Colors.white,
                                           ),
                                           child: ListTile(
                                             onTap: (){
                                               Navigator.of(context).push(MaterialPageRoute(builder: (context)=>PostDetail(details: value)));
                                             },
                                             // trailing: Text(out_date),
                                             title: Row(
                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                               children: [
                                                 Text('Admin',maxLines: 1,style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),),
                                                   Row(
                                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                     children: [
                                                       value['url'].length>0?Icon(Icons.attachment):Text(""),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8.0),
                                                          child: Text(formattedDate,style: GoogleFonts.plusJakartaSans(fontSize: 12),),
                                                        ),
                                                     ],
                                                   )
                                               ],
                                             ),
                                             subtitle: Column(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                 Text(value['title'],maxLines: 1,style: TextStyle(fontWeight: FontWeight.w400),),
                                                 Row(
                                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                   children: [
                                                     Flexible(
                                                         child: Text(value['message'],maxLines: 1,
                                                           style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w300),overflow: TextOverflow.ellipsis,)
                                                     ),
                                                     Text(formattedTime,style: GoogleFonts.plusJakartaSans(fontSize: 12),)
                                                   ],
                                                 ),
                                               ],
                                             ),
                                           ),
                                         ),
                                       );
                                     }
                                     ),
                               ),
                             ),
                           ],
                         );
                       }
                       ),
               ),
               SizedBox(height: 10,)
                   ]
           ),
         ),
       ),
     ),
   );
  }
}

class DataBox extends StatelessWidget{
  final Timestamp time;
  final String title;
  final String text;
  final List<dynamic> url;
  // final int? index;
  final String? id;
  final bool isStarred;
  final String? year;
  final String? uName;
  final String? starId;
  DataBox({Key? key, required this.time, required this.title,
    required this.text, required this.url,
    this.id, required this.isStarred, this.year,this.uName,this.starId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/4,
      margin: EdgeInsets.symmetric(horizontal: 3,vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20,left: 20),
            child: ExpandableText(
              animation: true,
              collapseOnTextTap: true,
              title,style: TextStyle(color: Color(0xff5A5A5A),fontSize: 20,fontWeight: FontWeight.bold),maxLines: 1,
              expandText: '...',),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 5),
            child: Container(
              height: MediaQuery.of(context).size.height/6,
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: LinkWell(text,style: TextStyle(color: Color(0xff636363),fontSize: 15),),
              ),
            )
          )
        ],
      ),
    );
  }
}