import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';

class PostDetail extends StatefulWidget {
  final QueryDocumentSnapshot details;
  const PostDetail({Key? key,required this.details}) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState(details: details);
}

class _PostDetailState extends State<PostDetail> {

  late QueryDocumentSnapshot details;
  _PostDetailState({required this.details});



  Widget ImagesRow(){
    List<Widget> imgWidget = [];
    List<Widget> pdfWidget = [];

    for(String link in details['url']){
      late File Pfile;
      var name = (link.split('/').sublist(7).toString().split('?')[0].substring(1));
      if(link.contains('.png') || link.contains('.jpg')||link.contains('.jpeg')) {
        imgWidget.add(
            InkWell(
              onTap: () async {
                final response = await http.get(Uri.parse(link));
                final bytes = response.bodyBytes;
                final filename = basename(link);
                final dir = await getApplicationDocumentsDirectory();
                var path = '${dir.path}/$filename';
                var file = File('${dir.path}/$filename');
                await file.writeAsBytes(bytes, flush: true);
                // Pfile = file;
                // print(Pfile);
                final result = OpenFile.open(path, type: "image/jpeg");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(width: 250,
                  height: 250,
                  link, fit: BoxFit.fitWidth,),
              ),
            )
        );
      }
      if(link.contains('.pdf')||link.contains('.docx')||link.contains('.doc') ){
        print("he");
        pdfWidget.add(
            InkWell(
              onTap: () async{
                final response = await http.get(Uri.parse(link));
                final bytes = response.bodyBytes;
                final filename = basename(link);
                final dir = await getApplicationDocumentsDirectory();
                var path = '${dir.path}/$filename';
                var file = File('${dir.path}/$filename');
                await file.writeAsBytes(bytes, flush: true);
                print((filename));
                String? type = lookupMimeType(filename.split('?')[0]);
                Pfile = file;
                print(type);
                final result =await OpenFile.open(path,type: type);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  link.contains('pdf')?Icon(Icons.file_present_rounded,color: Colors.red,size: 30,):link.contains('.docx')?
                  Icon(Icons.document_scanner,color: Colors.blueAccent,):Icon(Icons.file_copy),
                  SizedBox(width: 10,),
                  Flexible(
                    child: Text(name,
                      style: TextStyle(color: (Color(0xff655DBB)),fontSize: 18,fontWeight: FontWeight.w600),
                      maxLines: 1,overflow: TextOverflow.ellipsis,),
                  ),
          ],
                ),
              ),
            )
        );
      }
    }
   // imgWidget.addAll(pdfWidget);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: imgWidget,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: pdfWidget,
          ),
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(onPressed: (){Navigator.of(context).pop();},icon: Icon(Icons.arrow_back_ios_new),),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[Color(0xffD0DDFF),
                  Color(0xffF0F4FF),]),
          ),
        ),
        // title: Text(details['title']),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration:const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color(0xffD0DDFF),
                    Color(0xffF0F4FF),
                  ]
              )
          ),

          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 40,vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new)),
                  Text("Admin",style: TextStyle(fontSize: 24),),
                  SizedBox(height: 10,),
                  Text(details['title'],style: TextStyle(fontSize: 20),),
                  SizedBox(height: 10,),
                  Text(details['message']),
                  SizedBox(height: 10,),
                  if(details['url'].length>=1)
                     ImagesRow(),
                ],
              )
          ),
        ),
      ),
    );
  }
}
