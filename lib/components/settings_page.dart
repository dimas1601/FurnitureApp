import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/screens/LoginPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/constant.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myCounterController = Get.put(CounterController());
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
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Pengaturan(
                  judul: "Account",
                  ikon: Icons.person,
                ),
                SizedBox(height: 10),
                Pengaturan(
                  judul: "Notifications",
                  ikon: Icons.notifications,
                ),
                SizedBox(height: 10),
                Pengaturan(
                  judul: "Privacy & Security",
                  ikon: Icons.security_rounded,
                ),
                SizedBox(height: 10),
                Pengaturan(
                  judul: "Theme",
                  ikon: Icons.palette_rounded,
                ),
                SizedBox(height: 10),
                Pengaturan(
                  judul: "Language",
                  ikon: Icons.language_rounded,
                ),
                SizedBox(height: 10),
                Pengaturan(
                  judul: "Help",
                  ikon: Icons.help_rounded,
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 30, right: 30, left: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      AlertDialog alert = AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          "Logout",
                          textAlign: TextAlign.center,
                        ),
                        content: Container(
                          child: Text(
                            "Yakin ingin logout?",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        actions: [
                          Divider(
                            height: 1,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 40,
                            child: InkWell(
                                highlightColor: Colors.grey,
                                child: Center(
                                  child: Text('Yes',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: kBlueColor,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                                onTap: () async {
                                  await FirebaseAuth.instance.signOut();

                                  Get.to(Login());
                                }),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 15),
                            height: 40,
                            child: InkWell(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15.0),
                                  bottomRight: Radius.circular(15.0),
                                ),
                                // style: TextButton.styleFrom(
                                //     backgroundColor: kBlueColor),
                                highlightColor: Colors.grey,
                                child: Center(
                                  child: Text('Cancel',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                      )),
                                ),
                                onTap: () async {
                                  Get.back();
                                }),
                          )
                        ],
                      );

                      showDialog(context: context, builder: (context) => alert);
                      return;
                    },
                    child: Container(
                      width: 350,
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        "Log Out",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: myCounterController.switchValue.value
                            ? kPrimaryColor
                            : kBlueColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Pengaturan extends StatelessWidget {
  const Pengaturan({
    Key? key,
    required this.judul,
    required this.ikon,
  }) : super(key: key);

  final String judul;
  final ikon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.only(top: 15, left: 5, right: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1, color: Colors.black),
      ),
      child: Row(
        children: [
          SizedBox(width: 15),
          Icon(
            ikon,
            color: Colors.black,
            size: 25.0,
          ),
          SizedBox(width: 10),
          Text(
            judul,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
