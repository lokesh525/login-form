import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addData extends StatefulWidget {
  const addData({super.key});

  @override
  State<addData> createState() => _addDataState();
}

class _addDataState extends State<addData> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  AddData(String title, String desc)async{
    if(title == "" && desc ==""){
      log("Enter the required field");
    }
    else{
      FirebaseFirestore.instance.collection("Users").doc(title).set({
        "Title":title,
        "Description":desc,
      }).then((value) {
        log("Data Inserted");
      });

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Collection'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: "Enter title",
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25)
                )
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextField(
              controller: descController,
              decoration: InputDecoration(
                  hintText: "Enter descriptiopn",
                  prefixIcon: Icon(Icons.description_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)
                  )
              ),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            AddData(titleController.text.toString(), descController.text.toString());
          }, child: Text("Save Data"))
          
        ],
      )


    );
  }
}
