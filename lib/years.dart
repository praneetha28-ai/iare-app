import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:iare/main.dart';

import 'admin.dart';
import 'categories.dart';
class Years extends StatefulWidget {
  const Years({Key? key}) : super(key: key);

  @override
  State<Years> createState() => _YearsState();
}

class _YearsState extends State<Years> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      // backgroundColor: Color(0xffECF2FF),
      appBar: AppBar(
        title: Text("Years"),
        flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: <Color>[Color(0xffD0DDFF),
                Color(0xffF0F4FF),]),
        ),
      ),

        automaticallyImplyLeading: false,
        leading: IconButton(
          icon:Icon( Icons.arrow_back_ios_new),
          onPressed: (){
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyHomePage()));
        },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xffD0DDFF),
                  Color(0xffF0F4FF),
                ]
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryScreen(year: "year_1")));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff2B3467),
                      ),
                      width: MediaQuery.of(context).size.width/2.5,
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(child:Text("1st Year",style: TextStyle(color: Colors.white),)),
                    ),
                  ),InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryScreen(year: "year_2")));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff2B3467),
                      ),
                      width: MediaQuery.of(context).size.width/2.5,
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(child:Text("2nd Year",style: TextStyle(color: Colors.white),)),
                    ),
                  ),

                ],
              ),
            ),Container(
              // color: Colors.yellow,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryScreen(year: "year_3")));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff2B3467),
                      ),
                      width: MediaQuery.of(context).size.width/2.5,
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(child:Text("3rd Year",style: TextStyle(color: Colors.white),)),
                    ),
                  ),InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoryScreen(year: "year_4")));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color(0xff2B3467),
                      ),
                      width: MediaQuery.of(context).size.width/2.5,
                      height: MediaQuery.of(context).size.height/4,
                      child: Center(child:Text("4th Year",style: TextStyle(color: Colors.white),)),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Admin()));
              },
              child: Container(
                height: MediaQuery.of(context).size.height/12,
                width: MediaQuery.of(context).size.width/2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xff2B3467),
                ),
                // color: Color(0xff2B3467),
                child: Center(child: Text("Post Data",style: TextStyle(color: Colors.white),)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
