import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:furniture_app/components/ChatandAddToChart.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/components/ProductPoster.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/PageKeranjang.dart';
import 'package:get/get.dart';

final CounterController controller = Get.put(CounterController());

class DetailPage extends StatelessWidget {
  final String id;
  DetailPage(this.id);

  @override
  Widget build(BuildContext context) {
    CollectionReference barang =
        FirebaseFirestore.instance.collection('Barang');
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        leading: IconButton(
          padding: EdgeInsets.only(left: kDefaultPadding),
          icon: SvgPicture.asset("assets/icons/back.svg"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Back".toUpperCase(),
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(Keranjang());
              },
              icon: SvgPicture.asset("assets/icons/cart_with_item.svg"))
        ],
      ),
      body: Obx(
        () => Container(
          color: controller.switchValue.value ? kPrimaryColor : kBlueColor,
          child: ListView(
            children: [
              Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: barang.doc(id).snapshots(),
                    builder: (_, snapshot) {
                      return (snapshot.hasData)
                          ? ProductPoster(
                              snapshot.data!.get('nama'),
                              snapshot.data!.get('harga'),
                              snapshot.data!.get('image'),
                              snapshot.data!.get('deskripsi'),
                            )
                          : Text('Loading...');
                    },
                  ),
                  ChatandAddToCart(id),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
