import 'dart:core';
import 'dart:ffi';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkwell/linkwell.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:open_file/open_file.dart';

import 'constants.dart';
class DataContainerAdmin extends StatelessWidget {
  final Timestamp time;
  final String title;
  final String text;
  final List<dynamic> url;
  final int? index;
  final String? id;
  final bool isStarred;
  final String? year;
  final String? uName;
  final String? starId;

  DataContainerAdmin({Key? key, required this.time, required this.title,
    required this.text, required this.url,   this.index,
    this.id, required this.isStarred, this.year,this.uName,this.starId}) : super(key: key);

  List<Tab> tabs = <Tab>[
    Tab(text: "Exams",),
    Tab(text: 'Bus'),
    Tab(text: 'Events'),
    Tab(text: 'Placements'),
    Tab(text: 'Others'),

  ];
  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
    required String yearPost
  }) async {
    // await FirebaseMessaging.instance.subscribeToTopic(year).whenComplete(() => print("subscribed"));
    print(yearPost);
    String dataNotifications = '{ '
        ' "to" : "/topics/${yearPost}" , '
        ' "notification" : {'
        ' "title":"$title" , '
        ' "body":"$body" '
        ' } '
        ' } ';

    var response = await http.post(
      Uri.parse(Constants.BASE_URL),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key= ${Constants.KEY_SERVER}',
      },
      body: dataNotifications,
    );
    print(response.body.toString());
    return true;
  }
  editText(BuildContext context) {
    TextEditingController editedText = TextEditingController(text: text);

    // Create button
    Widget okButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xff282c79)
      ),
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
        FirebaseFirestore
            .instance.collection(year!)
            .doc(tabs[index!].text!.toLowerCase())
            .collection("notifications").doc(id).update({"message":editedText.text}).then((value) => print("edited"));
        pushNotificationsAllUsers(title: title, body: editedText.text, yearPost: year!);

      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color(0xffECF2FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text("Edit Text"),
      content:TextFormField(
        cursorColor: Color(0xff282c79),

        maxLines: null,
        // initialValue: text,
        autocorrect: true,
        // onChanged: editedText.text=text,
        controller: editedText,
      ),
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
      child: Text("Delete"),
      onPressed:  () {

        Navigator.of(context).pop();
        FirebaseFirestore
            .instance.collection(year!)
            .doc(tabs[index!].text!.toLowerCase())
            .collection("notifications").doc(id).delete().whenComplete(() =>print("deleted"));
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
  @override
  Widget build(BuildContext context) {
    final timestamp1 = time.millisecondsSinceEpoch;
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp1);

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
            child: InkWell(
              onTap: ()async{
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
                // color:pdf?Color(0xff655DBB): Colors.grey,
                height: pdf?MediaQuery.of(context).size.height/12:MediaQuery.of(context).size.height/6,
                width: MediaQuery.of(context).size.width/1.5,
                decoration: BoxDecoration(
                    color: pdf?Color(0xffECF2FF):Color(0xff655DBB),
                    border: Border.all(
                      color: pdf?Color(0xffECF2FF):Color(0xff655DBB),
                    ),
                    borderRadius: BorderRadius.circular(20)
                ),
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10,vertical: 10),
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
                    Image.network(link,fit: BoxFit.fill,)
                ),
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
          height: MediaQuery.of(context).size.height/2.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 30),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width:MediaQuery.of(context).size.width/2.5,
                        margin: EdgeInsets.all(10),
                        child: Text(title,maxLines:3,textAlign:TextAlign.start,softWrap: true,
                          style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: ()async{
                                editText(context);
                              }, icon: Icon(Icons.edit,color: isStarred?Colors.yellow:Colors.white,)
                          ),
                          IconButton(
                              onPressed: ()async{
                                showAlertDialog(context);
                              }, icon: Icon(Icons.delete,color: isStarred?Colors.yellow:Colors.white,)
                          ),
                        ],
                      )
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
                            style: TextStyle(color: Colors.white,fontSize: 18),
                          )
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
                        margin: EdgeInsets.only(left: 30,right: 30,top: 5),
                        height: MediaQuery.of(context).size.height/30,
                        child: SingleChildScrollView(
                            child: LinkWell(
                              text,maxLines: null,softWrap: true,
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width:MediaQuery.of(context).size.width/2.5,
                        child: Text(title,maxLines: 3,textAlign:TextAlign.start,
                          style: TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w600),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () async {
                                editText(context);
                                // print(delete);
                                // FirebaseFirestore.instance.runTransaction((transaction) async =>
                                // await transaction.delete(ref)).then((value) => print("deleted ${id}"));

                              }, icon: Icon(Icons.edit,color: Colors.white,)
                          ),
                          IconButton(
                              onPressed: () async {
                                showAlertDialog(context);
                                // print(delete);
                                // FirebaseFirestore.instance.runTransaction((transaction) async =>
                                // await transaction.delete(ref)).then((value) => print("deleted ${id}"));

                              }, icon: Icon(Icons.delete,color: Colors.white,)
                          ),
                        ],
                      )
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
                        child: Text(text,maxLines: null,
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
                            child: SelectableText(
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
