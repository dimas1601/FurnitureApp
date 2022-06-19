import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/screens/MainPage.dart';
import 'package:furniture_app/screens/ProfilPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../data/constant.dart';

class Profil extends StatefulWidget {
  final String id;
  final String email;
  final String nama;
  final String nohp;
  final String password;
  final String alamat;
  final String image;
  Profil(this.id, this.email, this.nama, this.password, this.alamat, this.nohp,
      this.image);

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool isHiddenPassword = false;

  final User? user = FirebaseAuth.instance.currentUser;
  PlatformFile? pickedImage;

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final myCounterController = Get.put(CounterController());
    final namaCtrl = TextEditingController(text: "${widget.nama}");
    final passwordCtrl = TextEditingController(text: "${widget.password}");
    final emailCtrl = TextEditingController(text: "${widget.email}");
    final nohpCtrl = TextEditingController(text: "${widget.nohp}");
    final alamatCtrl = TextEditingController(text: "${widget.alamat}");
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Obx(() => Container(
              color: myCounterController.switchValue.value
                  ? kPrimaryColor
                  : kBlueColor,
            )),
        elevation: 0,
        leading: IconButton(
            padding: EdgeInsets.only(left: 20),
            onPressed: () {
              Get.to(MainPage());
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              padding: EdgeInsets.only(right: 20),
              onPressed: () async {
                await Share.share(
                  "Profile\nNama: ${widget.nama}\nFoto Profil: ${widget.image}",
                );
              },
              icon: Icon(Icons.share_outlined))
        ],
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 110,
                    decoration: BoxDecoration(
                      color: myCounterController.switchValue.value
                          ? kPrimaryColor
                          : kBlueColor,
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
                          ],
                        ),
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
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12, left: 11),
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
                  "Email",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 64,
                child: TextFormField(
                  controller: emailCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12, left: 11),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: 35,
                ),
                child: Text(
                  "Password",
                  style: GoogleFonts.poppins(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 64,
                child: TextFormField(
                  controller: passwordCtrl,
                  obscureText: !isHiddenPassword,
                  readOnly: true,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12, left: 11),
                      hintText: "Password",
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
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 64,
                child: TextFormField(
                  controller: nohpCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12, left: 11),
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
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                height: 84,
                child: TextFormField(
                  controller: alamatCtrl,
                  maxLines: 3,
                  readOnly: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 12, left: 11),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return ProfilPage(
                          widget.id,
                          widget.email,
                          widget.nama,
                          widget.password,
                          widget.alamat,
                          widget.nohp,
                          widget.image);
                    })));
                  },
                  child: Container(
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
                          "Edit Profil",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                ),
              )
            ],
          ),
        ],
      )),
    );
  }
}
