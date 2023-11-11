import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iare/dataContainer.dart';

class Star extends StatefulWidget {
  // final String year;
  final String uName;
  final String year;
  const Star({Key? key,required this.uName,required this.year}) : super(key: key);
  @override
  State<Star> createState() => _StarState(uName: uName,year: year);
}

class _StarState extends State<Star> {
  late String uName;
  late String year;
  _StarState({required this.uName,required this.year});
  @override
  Widget build(BuildContext context) {
    print(uName);
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: Text("Starred Messages"),backgroundColor: Color(0xff2B3467),),
      body: Container(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection(uName).doc(
              'starred').collection(
              "notifications")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator(color: Color(0xff2B3467),));
            return Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              child: ListView.builder(
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data?.size,
                  itemBuilder: (context, i) {
                    QueryDocumentSnapshot value = snapshot.data!.docs[i];
                    return DataContainer(
                        time: value["date"], title: value["title"], text: value["message"],
                        url: value["url"],
                         isStarred: value["starred"],starId: value.id,year: year,
                    );
                  }),
            );
          },
        )
      ),
    );
  }
}
