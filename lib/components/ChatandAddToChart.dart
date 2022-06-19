import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:get/get.dart';

class ChatandAddToCart extends StatelessWidget {
  final String id;
  ChatandAddToCart(this.id);
  final CounterController controller = Get.put(CounterController());
  final CounterController ctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    CollectionReference barang =
        FirebaseFirestore.instance.collection('Barang');
    User? user = FirebaseAuth.instance.currentUser;
    return GestureDetector(
      onTap: () async {
        DocumentSnapshot data = await barang.doc(id).get();

        controller.total.value += int.parse(data.get("harga"));
        await FirebaseFirestore.instance
            .collection("Total")
            .doc(ctrl.idTotal.value)
            .update({
          "userId": user?.uid,
          "total": controller.total.value,
        });
        await FirebaseFirestore.instance.collection('keranjang').doc().set({
          'idUser': user?.uid,
          "nama": data.get("nama"),
          "harga": data.get("harga"),
          "image": data.get("image"),
          "kategori": data.get("kategori"),
          "deskripsi": data.get("deskripsi"),
          'createdAt': Timestamp.now(),
        });
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: "Berhasil",
          text: "Barang berhasil dimasukkan ke Keranjang",
          confirmBtnText: 'OK',
        );
      },
      child: Obx(
        () => Container(
            width: 300,
            height: 50,
            margin: EdgeInsets.all(kDefaultPadding),
            padding: EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding / 2,
            ),
            decoration: BoxDecoration(
                color:
                    controller.switchValue.value ? kBlueColor : kPrimaryColor,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
              child: Text(
                "Add to Cart",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            )),
      ),
    );
  }
}
