
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ProfilePage extends StatefulWidget {
  final String year;
  const ProfilePage({Key? key,required this.year}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfileState(year: year);
}

class _ProfileState extends State<ProfilePage> {

  bool examsNF = true;
final prefs = SharedPreferences.getInstance();
  late String year;
  Future<bool> getValue() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("exams")){
      prefs.setBool("exams",!prefs.getBool("exams")!);
      return prefs.getBool("key")??true;
    }else{
      prefs.setBool("exams", true);
      bool examsNF =  prefs.getBool("exams")??true;
      return examsNF;
    }
  }
  _ProfileState({required this.year});
  @override
  Widget build(BuildContext context)  {
    print(examsNF);
    return Scaffold(
      appBar: AppBar(title: Text("Profile"),),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height/3,
              width: MediaQuery.of(context).size.width,
              child: CircleAvatar(child: Icon(Icons.person_2),radius: 5,),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text("Exams"),
                      Switch(
                          value: true,
                          onChanged: (val)async {
                            final prefs = await SharedPreferences.getInstance();
                            setState(() {
                              prefs.setBool("exams", val);
                              examsNF = prefs.getBool("exams")!;
                              if(!prefs.getBool("exams")!){
                                print("heyy");
                                FirebaseMessaging.instance.unsubscribeFromTopic("$year-exams");
                              }
                            });
                            print(examsNF);
                          }
                      )
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}