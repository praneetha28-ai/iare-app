import 'package:flutter/material.dart';
import 'package:iare/years.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController adminName = TextEditingController();
  TextEditingController adminPass = TextEditingController();

  adminLog(String aName,String aPass){
    if(aName.startsWith("IARE") ){

      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Years()));
      adminName.clear()
      ;
    }else{
      print("You are not an administrator");
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2B3467),
        title: Text("Administrator Login",style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0xffECF2FF),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height/12,
                // color: Colors.grey,
                decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white60
                ),
                margin: EdgeInsets.only(top: 80,left: 20,right: 20,bottom: 25),
                child:
                TextField(
                  controller: adminName,
                  cursorColor: Color(0xff2B3467),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person,color: Color(0xff2B3467),),
                      labelText: "Enter username",

                      labelStyle: TextStyle(color: Color(0xff2B3467)),
                      border: InputBorder.none
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height/12,
                // color: Colors.grey,
                decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white60
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child:
                TextField(
                  controller: adminPass,
                  obscureText: true,
                  obscuringCharacter: '*',
                  cursorColor: Color(0xff2B3467),
                  decoration: InputDecoration(
                      fillColor: Color(0xff2B3467),
                      prefixIcon: Icon(Icons.password,color: Color(0xff2B3467),),
                      labelText: "Enter password",
                      labelStyle: TextStyle(color: Color(0xff2B3467)),
                      border: InputBorder.none
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.height/8),
                width: MediaQuery.of(context).size.width/3,
                height: MediaQuery.of(context).size.height/10,
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  // borderRadius: BorderRadius.circular(20)
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Color(0xff2B3467))
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      maximumSize: Size(MediaQuery.of(context).size.width/1.5, MediaQuery.of(context).size.height/10),
                      backgroundColor: Color(0xff2B3467),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      )),
                  onPressed: (){adminLog(adminName.text,adminPass.text);},
                  child: Text("Login",style: TextStyle(fontSize: 16,color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
