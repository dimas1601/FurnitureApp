import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/MainPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:path/path.dart';

class ProfilPage extends StatefulWidget {
  final String id;
  final String email;
  final String nama;
  final String nohp;
  final String password;
  final String alamat;
  final String image;
  ProfilPage(this.id, this.email, this.nama, this.password, this.alamat,
      this.nohp, this.image);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final CounterController myCounterController = Get.put(CounterController());
  bool isHiddenPassword = false;

  final namaCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final nohpCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  PlatformFile? pickedImage;

  // final FirebaseAuth _auth = FirebaseAuth.instance.c;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedImage = result.files.first;
    });
  }

  Future updateFotoUser(pickedImage, id) async {
    String url;
    final File imageFile = File(pickedImage!.path);
    String fileName = basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Users").child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);

    final CounterController control = Get.put(CounterController());

    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    url = await snapshot.ref.getDownloadURL();
    control.image.value = url;
    if (pickedImage != null) {
      DocumentSnapshot data = await users.doc(id).get();
      await FirebaseFirestore.instance.collection('Users').doc(id).update({
        "image": url,
      });
      final CounterController control = Get.put(CounterController());
      control.image.value = url;
      Reference storageReference =
          await FirebaseStorage.instance.refFromURL(data.get("image"));
      storageReference.fullPath;
      await storageReference.delete();

      pickedImage = null;
      // Get.to(MainPage());
    }
  }

  String _errorMessage = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: myCounterController.switchValue.value
              ? kPrimaryColor
              : kBlueColor,
        ),
        flexibleSpace: Obx(() => Container(
              color: myCounterController.switchValue.value
                  ? kPrimaryColor
                  : kBlueColor,
            )),
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Obx(
                    () => Container(
                      width: MediaQuery.of(context).size.width,
                      height: 110,
                      decoration: BoxDecoration(
                        color: myCounterController.switchValue.value
                            ? kPrimaryColor
                            : kBlueColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 4),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: NetworkImage(widget.image),
                                      fit: BoxFit.cover)),
                            ),
                            Positioned(
                                bottom: 8,
                                right: 10,
                                child: InkWell(
                                  onTap: (() {
                                    setState(() {
                                      selectFile();
                                    });
                                  }),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.teal),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(pickedImage != null ? "${pickedImage!.name}" : ""),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 20),
                child: Text(
                  "Your Name",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 64,
                child: TextFormField(
                  controller: namaCtrl,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12, left: 11),
                    hintText: "${widget.nama}",
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 35,
                ),
                child: Text(
                  "Password",
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 64,
                child: TextFormField(
                  controller: passwordCtrl,
                  obscureText: !isHiddenPassword,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12, left: 11),
                      hintText: "${widget.password}",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isHiddenPassword = !isHiddenPassword;
                          });
                        },
                        icon: isHiddenPassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off),
                      )),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35),
                child: Text(
                  "No Handphone",
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 64,
                child: TextFormField(
                  controller: nohpCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12, left: 11),
                    hintText: "${widget.nohp}",
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35),
                child: Text(
                  "Alamat",
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 84,
                child: TextFormField(
                  controller: alamatCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12, left: 11),
                    hintText: "${widget.alamat}",
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w400),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    final User? user = FirebaseAuth.instance.currentUser;
                    CollectionReference users =
                        await FirebaseFirestore.instance.collection('Users');

                    if (namaCtrl.text == "") {
                      myCounterController.nama.value = widget.nama;
                      users.doc(widget.id).update({"nama": widget.nama});
                    } else {
                      myCounterController.nama.value = namaCtrl.text;
                      users.doc(widget.id).update({"nama": namaCtrl.text});
                    }
                    if (nohpCtrl.text == "") {
                      myCounterController.nohp.value = widget.nohp;
                      users.doc(widget.id).update({"nohp": widget.nohp});
                    } else {
                      myCounterController.nohp.value = nohpCtrl.text;
                      users.doc(widget.id).update({"nohp": nohpCtrl.text});
                    }
                    if (alamatCtrl.text == "") {
                      myCounterController.alamat.value = widget.alamat;
                      users.doc(widget.id).update({"alamat": widget.alamat});
                    } else {
                      myCounterController.alamat.value = alamatCtrl.text;
                      users.doc(widget.id).update({"alamat": alamatCtrl.text});
                    }
                    // Get.to(MainPage());

                    if (passwordCtrl.text == "") {
                      await user!.updatePassword(widget.password).then((value) {
                        myCounterController.password.value = widget.password;
                        users
                            .doc(widget.id)
                            .update({"password": widget.password});
                        print("Succes");
                      }).catchError((onError) {
                        print(onError.toString());
                      });

                      //   print(error
                    } else {
                      await user!
                          .updatePassword(passwordCtrl.text)
                          .then((value) {
                        myCounterController.password.value = passwordCtrl.text;
                        users.doc(widget.id).update({
                          "password": passwordCtrl.text,
                        });
                        print("Berhasil");
                      }).catchError((onError) {
                        print("gagal");
                      });
                    }
                    updateFotoUser(pickedImage, widget.id);
                    updateUser(context);
                  },
                  child: Obx(
                    (() => Container(
                          width: 283,
                          height: 50,
                          margin: EdgeInsets.only(top: 40, bottom: 80),
                          decoration: BoxDecoration(
                              color: myCounterController.switchValue.value
                                  ? kPrimaryColor
                                  : kBlueColor,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(
                              "Update",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
        ],
      )),
    );
  }

  void updateUser(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: kSecondaryColor,
      title: Text("Success"),
      content: Container(
        child: Text("Update Data Berhasil"),
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15),
          child: ElevatedButton(
              style: TextButton.styleFrom(backgroundColor: kBlueColor),
              child: Text('Oke', style: GoogleFonts.poppins(fontSize: 15)),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: ((context) {
                  return MainPage();
                })));
              }),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alert);
    return;
  }
}
