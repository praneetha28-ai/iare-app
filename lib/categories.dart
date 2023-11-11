import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dataContainer.dart';
import 'dataContainerAdmin.dart';


class CategoryScreen extends StatefulWidget {
  String year;
  // String uName;
  CategoryScreen({Key? key, required this.year})
      : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryState(year);
}

class _CategoryState extends State<CategoryScreen> {
  late String year;
  var height = 2.0;
  bool isStarred = false;
  // late String uName;
  _CategoryState(this.year);
  var newDate;
  DateTime? pickedDate;
  DateTime? pickedDate2;
  TextEditingController searchController = TextEditingController();
  late String category;
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .subscribeToTopic("admin")
        .whenComplete(() => print("Subscription successful"));
    // FirebaseMessaging.instance
    //     .subscribeToTopic(year)
    //     .whenComplete(() => print("Subscription successful"));
    // FirebaseMessaging.instance
    //     .subscribeToTopic("all")
    //     .whenComplete(() => print("Subscription successful"));
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(channel.id, channel.name,
    //               channelDescription: channel.description,
    //               color: Colors.blue,
    //               playSound: true,
    //               icon: '@mipmap/ic_launcher'),
    //         ));
    //   }
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   print('A new message ');
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     Navigator.of(context).push(MaterialPageRoute(
    //         builder: (context) => HomeScreen(
    //             year: "year_1",
    //             uType: "student",
    //             category: message.data['title'])));
    //   }
    // });
  }



  List<Tab> tabs = <Tab>[
    Tab(
      text: "Exams",
    ),
    Tab(text: 'Bus'),
    Tab(text: 'Events'),
    Tab(text: 'Placements'),
    Tab(text: 'Others'),
  ];
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {
            print(tabs.length);
            if (!tabController.indexIsChanging) {
              setState(() {
                category = tabs[tabController.index].text!;
              });
            }
          });
          return Scaffold(
            backgroundColor: Color(0xffECF2FF),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: IconButton(onPressed: (){
                Navigator.of(context).pop();
              },icon: Icon(Icons.arrow_back_ios_new),),
              elevation: 0,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: <Color>[Color(0xffD0DDFF),
                        Color(0xffF0F4FF),]),
                ),
              ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                labelColor: Color(0xff282c79),
                labelPadding: EdgeInsets.symmetric(horizontal: 25),
                labelStyle: TextStyle(fontSize: 16, wordSpacing: 10),
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5),
                automaticIndicatorColorAdjustment: true,
                isScrollable: true,
                tabs: tabs,
              ),
              // leading: IconButton(
              //   onPressed: () {
              //     Navigator.of(context).push(
              //         MaterialPageRoute(builder: (context) => MyHomePage()));
              //   },
              //   icon: Icon(Icons.logout),
              // ),
              title: Text(
                "Announcements             Year  -  ${year.split('_')[1]}",
                style: TextStyle(fontSize: 18),
              ),
            ),
            body:  TabBarView(
                children: tabs.map((Tab tab) {
                  print(tabs[tabController.index].text);
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection(year)
                        .doc(tabs[tabController.index].text?.toLowerCase())
                        .collection("notifications")
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData)
                        return Center(child: CircularProgressIndicator());
                      if(snapshot.data!.size==0)
                        return Center(child: Text("No data posted"),);
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            physics: ScrollPhysics(),
                            itemCount: snapshot.data?.size,
                            itemBuilder: (context, i) {
                              QueryDocumentSnapshot value =
                              snapshot.data!.docs[i];
                              // print(value["url"]);
                              final timestamp1 = value['date'].millisecondsSinceEpoch;
                              var date = DateTime.fromMillisecondsSinceEpoch(timestamp1);
                              var today = DateTime.now();
                              var d1 = DateTime.parse(date.toString());
                              var d2 = DateTime.parse(today.toString());
                              var dd1 =d1.toString().split(" ")[0];
                              var dd2 =d2.toString().split(" ")[0];
                              var out_date;
                              if(d2.difference(d1).inDays==1)
                                out_date="Yesterday";
                              else if (dd1!=dd2)
                                out_date = date.toString().split(" ")[0].split('-').reversed.join("-");
                              else{
                                out_date="Today";
                              }
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

                                      showAlertDialog(BuildContext context) {
                                        // set up the buttons
                                        Widget cancelButton = ElevatedButton(

                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xffECF2FF),
                                              elevation: null,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          ),
                                          child: Text("Cancel",style: TextStyle(color: Color(0xff282c79)),),
                                          onPressed:  () {

                                            Navigator.of(context).pop();
                                            // Navigator.of(context).pop();
                                          },
                                        );
                                        Widget continueButton = ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xff282c79),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10)
                                              )
                                          ),
                                          child: Text("Delete",style: TextStyle(color: Colors.white),),
                                          onPressed:  () {
                                            print(value.id);
                                            print(year);
                                            Navigator.of(context).pop();
                                            FirebaseFirestore
                                                .instance.collection(year)
                                                .doc(tabs[tabController.index].text!.toLowerCase())
                                                .collection("notifications").doc(value.id).delete().whenComplete(() =>print("deleted"));
                                          },
                                        );
                                        // set up the AlertDialog
                                        AlertDialog alert = AlertDialog(
                                          backgroundColor: Color(0xffECF2FF),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          title: Text("Confirm Delete"),
                                          content: Text("Would you like to delete this message ?"),
                                          actions: [
                                            cancelButton,
                                            continueButton,
                                          ],
                                        );
                                        // show the dialog
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },
                                        );
                                      }
                                      showAlertDialog(context);
                                    },
                                    // trailing: Text(out_date),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Admin',maxLines: 1,style: TextStyle(fontWeight: FontWeight.w600),),
                                        Text(out_date,style: TextStyle(fontSize: 12),),

                                      ],
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(value['title'],maxLines: 1,style: TextStyle(fontWeight: FontWeight.w400),),
                                        Text(value['message'],maxLines: 1,style: TextStyle(fontWeight: FontWeight.w300),),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    },
                  );
                }).toList()),
          );
        },
      ),
    );
  }
}
