import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbse1/uiHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? pickedImage;
  signUp(String email, String password) async {
    if (email == "" && password == "" && pickedImage == null) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Enter required field"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"))
              ],
            );
          });
    } else {
      UserCredential? usercredential;
      try {
        usercredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) {
              uploadData();
        });
      } on FirebaseAuthException catch (ex) {
        log(ex.code.toString());
      }
    }
  }
  uploadData()async{
    UploadTask uploadTask = FirebaseStorage.instance.ref("Profile Pics").child(emailController.text.toString()).putFile(pickedImage!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageurl = await taskSnapshot.ref.getDownloadURL();
    FirebaseFirestore.instance.collection("Users").doc(emailController.text.toString()).set({
      "Email" : emailController.text.toString(),
      "Image" :imageurl
    }).then((value) {
      log("User Uploaded");
    });
  }

  showAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Pick Image from"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.camera),
                  title: Text("Camera"),
                ),
                ListTile(
                  onTap: () {
                    pickImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                  leading: Icon(Icons.image),
                  title: Text("Gallery"),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign page"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                showAlertBox();
              },
              child: pickedImage != null
                  ? CircleAvatar(
                      radius: 80,
                      backgroundImage: FileImage(pickedImage!),
                    )
                  : CircleAvatar(
                      radius: 80,
                      child: Icon(
                        Icons.person,
                        size: 80,
                      ),
                    )),
          UiHelper.customTextField(
              controller: emailController,
              text: "Email",
              toHide: false,
              iconData: Icons.mail),
          UiHelper.customTextField(
              controller: passwordController,
              text: "Password",
              toHide: true,
              iconData: Icons.password),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(onPressed: () {
            signUp(emailController.text.toString(), passwordController.text.toString());
          }, child: Text("Sign Up"))
        ],
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });
    } catch (ex) {
      log(ex.toString());
    }
  }
}
