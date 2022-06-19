import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:get/get.dart';

import 'MainPage.dart';

class StrukPage extends StatelessWidget {
  const StrukPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myCounterController = Get.put(CounterController());
    final CounterController control = Get.find();
    CollectionReference keranjang =
        FirebaseFirestore.instance.collection("keranjang");

    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Obx(
        () => Container(
          color: myCounterController.switchValue.value
              ? kPrimaryColor
              : kBlueColor,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30, left: 20),
                child: Center(
                    child: Text(
                  "THANKS FOR YOUR ORDER!",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
              ),
              Container(
                margin: EdgeInsets.only(left: 30, top: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello, ${myCounterController.nama}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Status: Paid",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.all(20),
                height: 550,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 15,
                      offset: Offset(0, 1),
                    )
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 30, top: 30),
                        child: Text(
                          "Payment Summary",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        indent: 29,
                        endIndent: 30,
                        thickness: 2,
                      ),
                      SizedBox(height: 15),
                      StreamBuilder<QuerySnapshot>(
                        stream: keranjang
                            .where("idUser", isEqualTo: "${user!.uid}")
                            .snapshots(),
                        builder: (_, snapshot) {
                          return (snapshot.hasData)
                              ? Column(
                                  children: snapshot.data!.docs
                                      .map(
                                        (e) => ItemStruk(
                                          e.get('nama'),
                                          e.get('image'),
                                          e.get('harga'),
                                        ),
                                      )
                                      .toList(),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                );
                        },
                      ),
                      SizedBox(height: 15),
                      Divider(
                        color: Colors.black,
                        indent: 29,
                        endIndent: 30,
                        thickness: 2,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              "\$${control.total.value}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        margin: EdgeInsets.only(left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Payment Method:",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              "${control.metodePembayaran.value}",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 40, bottom: 80),
                        alignment: Alignment.center,
                        child: ElevatedButton(
                          onPressed: () async {
                            var result = await keranjang
                                .where("idUser", isEqualTo: "${user.uid}")
                                .get();
                            if (result.docs.length != 0) {
                              result.docs.forEach((element) {
                                element.reference.delete();
                              });
                              myCounterController.total.value = 0;

                              await FirebaseFirestore.instance
                                  .collection("Total")
                                  .doc(control.idTotal.value)
                                  .update({"total": 0});
                              final mySnackBar = SnackBar(
                                content: Text(
                                  "Download Struk Berhasil!",
                                  style: TextStyle(
                                      fontSize: 14,
                                      // fontFamily: "Lobster",
                                      color: Colors.black),
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: kSecondaryColor,
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mySnackBar);
                              Get.to(MainPage());
                            } else {
                              final mySnackBar = SnackBar(
                                content: Text(
                                  "Data Struk Kosong!",
                                  style: TextStyle(
                                      fontSize: 14,
                                      // fontFamily: "Lobster",
                                      color: Colors.black),
                                ),
                                duration: Duration(seconds: 3),
                                backgroundColor: kSecondaryColor,
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mySnackBar);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: kSecondaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            height: 50,
                            width: 150,
                            alignment: Alignment.center,
                            child: Text(
                              "Download",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ItemStruk extends StatelessWidget {
  final String name;
  final String image;
  final String price;
  ItemStruk(this.name, this.image, this.price);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(image),
              ),
            ),
          ),
          Text(
            name,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
          Text(
            "\$${price}",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}
