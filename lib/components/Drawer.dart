import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/screens/PageKeranjang.dart';
import 'package:furniture_app/components/Profil.dart';
import 'package:furniture_app/components/settings_page.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/LoginPage.dart';
import 'package:furniture_app/screens/MainPage.dart';
import 'package:furniture_app/screens/PageRiwayatPesanan.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final CounterController myCounterController = Get.find();

  final CounterController control = Get.put(CounterController());

  User? userAuth = FirebaseAuth.instance.currentUser;

  CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    void initState() {
      myCounterController.onInit();
      control.onInit();
      super.initState();
    }

    void dispose() {
      control.dispose();
      myCounterController.dispose();
      super.dispose();
    }

    return Drawer(
      child: ListView(
        children: [
          Column(
            children: [
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30),
                  color: control.switchValue.value ? kPrimaryColor : kBlueColor,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    "${myCounterController.image}"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(
                          () => Text(
                            "${myCounterController.nama}",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Text(
                          "${myCounterController.email}",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  setState(() {
                    Get.to(MainPage());
                  });
                },
                leading: Icon(Icons.home),
                title: Text(
                  "Home Page",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) {
                    return Profil(
                        "${myCounterController.id}",
                        "${myCounterController.email}",
                        "${myCounterController.nama}",
                        "${myCounterController.password}",
                        "${myCounterController.alamat}",
                        "${myCounterController.nohp}",
                        "${myCounterController.image}");
                  })));
                },
                leading: Icon(Icons.account_circle),
                title: Text(
                  "Profile",
                  style: TextStyle(fontSize: 17),
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(Keranjang());
                },
                leading: Icon(Icons.shopping_cart),
                title: Text("Cart",
                    style: TextStyle(
                      fontSize: 17,
                    )),
              ),
              ListTile(
                onTap: () {
                  Get.to(RiwayatPesanan());
                },
                leading: Icon(Icons.history),
                title: Text("Riwayat",
                    style: TextStyle(
                      fontSize: 17,
                    )),
              ),
              ListTile(
                onTap: () {
                  Get.to(SettingsPage());
                },
                leading: Icon(Icons.settings),
                title: Text("Settings",
                    style: TextStyle(
                      fontSize: 17,
                    )),
              ),
              ListTile(
                  leading: Icon(Icons.arrow_back),
                  title: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  onTap: () {
                    setState(() {
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
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}
