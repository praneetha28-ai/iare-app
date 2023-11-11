import 'dart:convert';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'constants.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

class Admin extends StatefulWidget {

  const Admin({Key? key}) : super(key: key,);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  // late String year;
  // _AdminState({required this.year});
  // final MyHomePage  home = MyHomePage();
  TextEditingController msgController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController catController = TextEditingController();
  bool pressedYear = false;
  bool pressedCat = false;
  File? file;
  late List<File> files;
  late String url ;
  late Future<List<String>> uploadUrls;
  bool added = false;
  List<String> urls=[];

  _getFile() async{

    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        allowedExtensions: ['pdf','png','jpeg',''
            ''],
        type: FileType.custom,
      onFileLoading: (val){print(val.name);}
    );
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      files.forEach((element) {
        setState(() {
          file=File(element.path);
          _uploadFile(file,urls);
        });
      });
      if(urls.length>0){
        setState(() {
          added = true;
        });
      }
      return urls;
    } else {

    }
  }
  _uploadFile(File? file,List<String> urls) async{
    // CollectionReference reference = FirebaseFirestore.instance.collection(yearController.text).doc(catController.text).collection("notifications");
    var split = file!.path.toString().split("/");
    var fileName = split[split.length-1];
    var imageFile = FirebaseStorage.instance.ref().child(fileName);

    UploadTask task = imageFile.putFile(file);
    TaskSnapshot snapshot = await task;
    url =  await snapshot.ref.getDownloadURL();
    urls.add(url);
  }

  void PostData(String year,String category,String title,String message,List<String> urlsToUpload)async {
    print(Timestamp.fromDate(DateTime.now()).toString());
    if(year=="all"){
      CollectionReference ref1 = FirebaseFirestore.instance.collection("year_1").doc(category).collection("notifications");
      CollectionReference ref2 = FirebaseFirestore.instance.collection("year_2").doc(category).collection("notifications");
      CollectionReference ref3 = FirebaseFirestore.instance.collection("year_3").doc(category).collection("notifications");
      CollectionReference ref4 = FirebaseFirestore.instance.collection("year_4").doc(category).collection("notifications");
      ref1.add({
        "message":message,
        "title":title,
        "date":Timestamp.fromDate(DateTime.now()),
        "url":FieldValue.arrayUnion(urls),
        "starred":false,
      }).whenComplete(() {
        // pushNotificationsAllUsers(title:title,body:message);
        titleController.clear();
        msgController.clear();
        yearController.clear();
        catController.clear();
        urls.clear();
        // Navigator.of(context).pop();
        // setState(() {
        //   pressedCat=false;
        //   pressedYear=false;
        // });
      });
      ref2.add({
        "message":message,
        "title":title,
        "date":Timestamp.fromDate(DateTime.now()),
        "url":FieldValue.arrayUnion(urls),
        "starred":false,
      }).whenComplete(() {
        // pushNotificationsAllUsers(title:title,body:message);
        titleController.clear();
        msgController.clear();
        yearController.clear();
        catController.clear();
        urls.clear();
        // Navigator.of(context).pop();
        // setState(() {
        //   pressedCat=false;
        //   pressedYear=false;
        // });
      });
      ref3.add({
        "message":message,
        "title":title,
        "date":Timestamp.fromDate(DateTime.now()),
        "url":FieldValue.arrayUnion(urls),
        "starred":false,
      }).whenComplete(() {
        // pushNotificationsAllUsers(title:title,body:message);
        titleController.clear();
        msgController.clear();
        yearController.clear();
        catController.clear();
        urls.clear();
        // Navigator.of(context).pop();
        // setState(() {
        //   pressedCat=false;
        //   pressedYear=false;
        // });
      });
      ref4.add({
        "message":message,
        "title":title,
        "date":Timestamp.fromDate(DateTime.now()),
        "url":FieldValue.arrayUnion(urls),
        "starred":false,
      }).whenComplete(() {
        // pushNotificationsAllUsers(title:title,body:message);
        titleController.clear();
        msgController.clear();
        yearController.clear();
        catController.clear();
        urls.clear();

      });
      Navigator.of(context).pop();
      setState(() {
        pressedCat=false;
        pressedYear=false;
      });
      pushNotificationsAllUsers(title:title,body:message,yearPost: "all",category:category);
    }
    else{
      CollectionReference ref = FirebaseFirestore.instance.collection(yearController.text).doc(category).collection("notifications");
      ref.add({
        "message":message,
        "title":title,
        "date":Timestamp.fromDate(DateTime.now()),
        "url":FieldValue.arrayUnion(urls),
        "starred":false,
      }).whenComplete(() {

        pushNotificationsAllUsers(title:title,body:message,yearPost:yearController.text,category:category);
        titleController.clear();
        msgController.clear();
        yearController.clear();
        catController.clear();
        urls.clear();
        Navigator.of(context).pop();
        setState(() {
          pressedCat=false;
          pressedYear=false;
        });
      });
    }

  }
  bool check() {
    if (titleController.text.isNotEmpty && msgController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<bool> pushNotificationsAllUsers({
    required String title,
    required String body,
    required String yearPost,
    required String category
  }) async {
    // await FirebaseMessaging.instance.subscribeToTopic(year).whenComplete(() => print("subscribed"));
    print(yearPost);
    String dataNotifications = '{ '
        ' "to" : "/topics/$yearPost-$category" , '
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
  showAlertDialogYear(BuildContext context) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: Row(
        children: [
          Text("1st Year",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.looks_one_rounded,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          yearController.text="year_1";
        });
      },
    );
    Widget optionTwo = SimpleDialogOption(
      child: Row(
        children: [
          Text("2nd Year",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.looks_two_rounded,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          yearController.text="year_2";
        });
      },
    );
    Widget optionThree = SimpleDialogOption(
      child: Row(
        children: [
          Text("3rd Year",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.three_g_mobiledata,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          yearController.text="year_3";
        });
      },
    );
    Widget optionFour = SimpleDialogOption(
      child: Row(
        children: [
          Text("4th Year",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.four_g_mobiledata_sharp,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          yearController.text="year_4";
        });
      },
    );
    Widget optionFive = SimpleDialogOption(
      child: Row(
        children: [
          Text("All Years",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.all_inclusive,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          yearController.text="all";
        });
      },
    );
    Widget divide = SimpleDialogOption(
      child: Divider(color: Colors.white,),
    );
    // set up the SimpleDialog
    AlertDialog dialog =AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        backgroundColor: Color(0xff655DBB),
        title: const Text('Choose any Year',
          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),textAlign:TextAlign.center,),
        content:Container(
            height: MediaQuery.of(context).size.height/2,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                optionOne,
                divide,
                optionTwo,
                divide,
                optionThree,
                divide,
                optionFour,
                divide,
                optionFive
              ],
            )
        )
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
  showAlertDialogCat(BuildContext context) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: Row(
        children: [
          Text("Exams",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.directions_bus_filled_sharp,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          catController.text="exams";
        });
      },
    );
    Widget optionTwo = SimpleDialogOption(
      child: Row(
        children: [
          Text("Bus",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.book_outlined,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          catController.text="bus";
        });
      },
    );
    Widget optionThree = SimpleDialogOption(
      child: Row(
        children: [
          Text("Events",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.ac_unit,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          catController.text="events";
        });
      },
    );
    Widget optionFour = SimpleDialogOption(
      child: Row(
        children: [
          Text("Placements",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.event_available,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          catController.text="placements";
        });
      },
    );
    Widget optionFive = SimpleDialogOption(
      child: Row(
        children: [
          Text("Others",style: TextStyle(color: Colors.white,fontSize: 20),),
          Spacer(),
          Icon(Icons.align_horizontal_left_outlined,color: Colors.white,)
        ],
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          catController.text="others";
        });
      },
    );
    Widget divide = SimpleDialogOption(
      child: Divider(color: Colors.white,),
    );
    // set up the SimpleDialog
    AlertDialog dialog = AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        backgroundColor: Color(0xff655DBB),
        title: const Text('Choose any Category',
          style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),textAlign:TextAlign.center,),
        content:Container(
            height: MediaQuery.of(context).size.height/2,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                optionOne,
                divide,
                optionTwo,
                divide,
                optionThree,
                divide,
                optionFour,
                divide,
                optionFive
              ],
            )
        )
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){},icon: Icon(Icons.arrow_back_ios_new),color: Color(0xff2B3467),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[Color(0xffD0DDFF),
                  Color(0xffF0F4FF),]),
          ),
        ),
        title: Text("Create Post",
          style: TextStyle(fontSize: 18,color: Color(0xff2B3467),fontWeight: FontWeight.w500),),
        // backgroundColor: Color(0xff2B3467),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xffD0DDFF),
                    Color(0xffF0F4FF),
                  ]
              )
          ),
          // margin: EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                // color: Colors.white54,
                decoration: BoxDecoration(
                    border: Border.all(
                      color:Color(0xff2B3467),
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                height: MediaQuery.of(context).size.height/8,
                child: TextField(
                  maxLength: 50,
                  onSubmitted: (val){
                    titleController.text = val;
                  },
                  controller: titleController,
                  autocorrect: true,
                  cursorColor: Color(0xff2B3467),
                  decoration: InputDecoration(
                      border:InputBorder.none,
                      labelText: "Title",
                      labelStyle: TextStyle(color: Color(0xff2B3467))
                  ),
                  maxLines: null,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                // color: Colors.white54,
                decoration: BoxDecoration(
                    border: Border.all(
                      color:Color(0xff655DBB),
                    ),
                    borderRadius: BorderRadius.circular(10)
                ),
                height: MediaQuery.of(context).size.height/2.5,
                child: TextField(
                  onSubmitted: (val){
                    msgController.text = val;
                  },
                  controller: msgController,
                  autocorrect: true,
                  cursorColor: Color(0xff2B3467),
                  decoration: InputDecoration(
                      border:InputBorder.none,
                      labelText: "Message",
                      labelStyle: TextStyle(color: Color(0xff2B3467))
                  ),
                  maxLines: null,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Color(0xff2B3467)
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // color: Colors.blue,
                ),
                width: MediaQuery.of(context).size.width/2.0,
                margin: EdgeInsets.only(right: 5),
                child: TextButton(
                  onPressed: (){
                    _getFile();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Upload Files",
                        style: TextStyle(color: Color(0xff2B3467),fontSize: 18),),
                      Icon(added?Icons.verified :Icons.upload,color: Color(0xff2B3467),)
                    ],
                  ),
                  // controller: yearController,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xff2B3467),
                    ),
                    width: MediaQuery.of(context).size.width/2.5,
                    margin: EdgeInsets.only(right: 5),
                    child: TextButton(
                      onPressed: (){
                        showAlertDialogYear(context);
                      },
                      child: Text(yearController.text!=""?yearController.text:"Year",
                        style: TextStyle(color: Colors.white,fontSize: 16),),
                      // controller: yearController,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // shape: BoxShape.circle,
                        color: Color(0xff2B3467)
                    ),
                    width: MediaQuery.of(context).size.width/2.5,
                    margin: EdgeInsets.only(right: 5,top: 18,bottom: 20),
                    // color: Colors.teal,
                    child: TextButton(
                      onPressed: (){
                        showAlertDialogCat(context);
                      },
                      child: Text(catController.text!=""?catController.text:"Category",
                        style: TextStyle(color: Colors.white,fontSize: 16),),
                      // controller: yearController,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 28,left: 20,right: 20),
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff2B3467)
                    ),
                    onPressed: () {
                      PostData(yearController.text,
                          catController.text,
                          titleController.text,
                          msgController.text,
                          urls
                      );

                    },

                    child: Text("Post",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}