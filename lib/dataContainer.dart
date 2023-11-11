import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:linkwell/linkwell.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:open_file/open_file.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DataContainer extends StatelessWidget {
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

  DataContainer({Key? key, required this.time, required this.title,
    required this.text, required this.url,
    this.id, required this.isStarred, this.year,this.uName,this.starId}) : super(key: key);

  final List<Tab> tabs = <Tab>[
    Tab(text: "Exams",),
    Tab(text: 'Bus'),
    Tab(text: 'Events'),
    Tab(text: 'Placements'),
    Tab(text: 'Others'),

  ];


  premium(BuildContext context) {
    TextEditingController editedText = TextEditingController(text: text);

    // Create button
    print("premium");
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff282c79)
      ),
      child: Text("OK"),
      onPressed: () {
       Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffECF2FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Premium"),
      content:Text("To get access to this exclusive feature contribute 200/- (Gpay) to 9573118693.After payment send payment screenshot with your roll number"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    final timestamp1 = time.millisecondsSinceEpoch;
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp1);
    //hello please work properly no I dont you to work slowly
    List<Widget> imgWidget = [];
    if(url.length>=1){
      for(String link in url){
        bool pdf = false;
        var name = (link.split('/').sublist(7).toString().split('?')[0].substring(1));
        if(link.contains('.pdf')){
          pdf=true;
        }
        late File Pfile;
            imgWidget.add(
              InkWell(
                onTap: () async{
                  final response = await http.get(Uri.parse(link));
                  final bytes = response.bodyBytes;
                  final filename = basename(link);
                  final dir = await getApplicationDocumentsDirectory();
                  var path = '${dir.path}/$filename';
                  var file = File('${dir.path}/$filename');
                  await file.writeAsBytes(bytes, flush: true);
                  Pfile = file;
                  print(Pfile);
                  final result =await pdf? OpenFile.open(path,type: "application/pdf"):OpenFile.open(path,type: "image/jpeg");

                },
                child: Container(
                  height: pdf?MediaQuery.of(context).size.height/12:MediaQuery.of(context).size.height/6,
                  width: MediaQuery.of(context).size.width/1.5,
                  decoration: BoxDecoration(
                      color: pdf?Color(0xffECF2FF):Color(0xff282c79),
                      border: Border.all(
                        color: pdf?Color(0xffECF2FF):Color(0xff282c79),
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10,vertical: 5),
                    child: InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 3,
                        child: pdf?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_present_rounded,color: Colors.red,size: 30,),
                            SizedBox(width: 10,),
                            Text(name,style: TextStyle(color: (Color(0xff655DBB)),fontSize: 18,fontWeight: FontWeight.w600),),
                          ],
                        ):
                        Image.network(link,)
                    ),
                  ),
              ),
            );
      }
    }
    if(text.length<=200) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        elevation: 3,
        color: Color(0xff282c79),
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height/2.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 30,),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin:EdgeInsets.all(4),
                        child: Container(
                          margin:EdgeInsets.all(2),
                          width: MediaQuery.of(context).size.width/2,
                          child: Text(title,maxLines:2,textAlign:TextAlign.center,
                            style: TextStyle(fontSize: 18,
                                color: Colors.white,fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      // IconButton(onPressed: (){
                      //   // print(uName!);
                      //   // isStarred = !isStarred;
                      //   // if(!isStarred) {
                      //   //   CollectionReference reference = FirebaseFirestore
                      //   //       .instance.collection(uName!)
                      //   //       .doc("starred")
                      //   //       .collection("notifications");
                      //   //   reference.add({
                      //   //     "date": time,
                      //   //     "message": text,
                      //   //     "title": title,
                      //   //     "url": url,
                      //   //     "starred": true
                      //   //   });
                      //   // }else{
                      //   //   var ref = FirebaseFirestore
                      //   //       .instance.collection("20951A6633")
                      //   //       .doc("starred")
                      //   //       .collection("notifications").doc(starId);
                      //   //   FirebaseFirestore.instance.runTransaction((transaction) async =>
                      //   //   await transaction.delete(ref)).then((value) => print("deleted ${starId}"));
                      //   //
                      //   // }
                      //   // var ref = FirebaseFirestore.instance.collection(year!).doc(
                      //   //     tabs[index!].text?.toLowerCase()).collection(
                      //   //     "notifications").doc(id).update({"starred":!isStarred});
                      //   premium(context);
                      //
                      // }, icon: Icon(Icons.star,color: isStarred?Colors.yellow:Colors.white,))
                    ],
                  )
              ),
              Divider(indent: 30,thickness: 2,endIndent: 30,color: Colors.white,),
              if(text=="")
                 SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                   child: Row(
                      children: imgWidget,
                    ),
                 ),

              if(url.length<1)
                Container(
                  child:  Container(
                      margin: EdgeInsets.only(left: 30,right: 20),
                      height: MediaQuery.of(context).size.height/6,
                      child: SingleChildScrollView(
                          child: LinkWell(
                            text,maxLines: null,
                            // autofocus: true,
                            style: TextStyle(color: Colors.white,fontSize: 18),)
                      )
                  ),

                ),
              if(url.length>=1 && text!="")
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: imgWidget,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                        height: MediaQuery.of(context).size.height/20,
                        child: SingleChildScrollView(
                            child: LinkWell(text,maxLines: null,softWrap: true,
                              style: TextStyle(color: Colors.white,fontSize: 16),)
                        )
                    ),

                  ],
                ),
              Divider(indent: 30,endIndent: 30,thickness: 2,color: Colors.white,),
              Container(
                // margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(date.toString().split(" ")[0],style:
                      TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,),
                      Text(date.toString().split(" ")[1].substring(0,5),style:
                      TextStyle(color: Colors.white,fontSize: 15),textAlign: TextAlign.center,)
                    ],
                  )
              ),
            ],
          ),
        ),
      );
    }else{
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        elevation: 3,
        color: Color(0xff282c79),
        shape:RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20)
          ),
          height: MediaQuery.of(context).size.height/1.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        margin:EdgeInsets.all(8),
                          width: MediaQuery.of(context).size.width/2,
                          child: Text(title,maxLines: 2,textAlign:TextAlign.start,overflow: TextOverflow.ellipsis,softWrap: true,
                            style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),)),
                      // IconButton(onPressed: (){
                      //   // var ref = FirebaseFirestore.instance.collection(year!).doc(
                      //   //     tabs[index!].text?.toLowerCase()).collection(
                      //   //     "notifications").doc(id).update({"starred":true});
                      //   premium(context);
                      // }, icon: Icon(Icons.star,color: isStarred?Colors.yellow:Colors.white,))
                    ],
                  )
              ),
              Divider(indent: 30,thickness: 2,endIndent: 30,color: Colors.white,),
              if(text=="")
                Container(
                  height: MediaQuery.of(context).size.height/3,
                  width: MediaQuery.of(context).size.width/2,
                  color: Colors.grey,
                ),
              if(url.length<1)
               Container(
                      margin: EdgeInsets.only(left: 30,right: 30),
                      height: MediaQuery.of(context).size.height/2.2,
                      child: SingleChildScrollView(
                          child: LinkWell(text,maxLines: null,
                            style: TextStyle(color: Colors.white,fontSize: 18),)
                      )
                  ),
              if(url.length>=1 && text!="")
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: imgWidget
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 30,top: 20,right: 30),
                        height: MediaQuery.of(context).size.height/5,
                        child: SingleChildScrollView(
                            child: LinkWell(
                              text,maxLines: null,
                                style: TextStyle(color: Colors.white,fontSize: 16),
                            )
                        )
                    ),
                  ],
                ),
              Divider(indent: 30,endIndent: 30,thickness: 2,color: Colors.white,),
              Container(
                // margin: EdgeInsets.only(left: MediaQuery.of(context).size.width/4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(date.toString().split(" ")[0],style:
                      TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.center,),
                      Text(date.toString().split(" ")[1].substring(0,5),style:
                      TextStyle(color: Colors.white,fontSize: 16),textAlign: TextAlign.center,)
                    ],
                  )
              ),
            ],
          ),
        ),
      );
    }
  }
}