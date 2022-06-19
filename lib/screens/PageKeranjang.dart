import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Animasi.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';

import '../data/constant.dart';

class Keranjang extends StatefulWidget {
  const Keranjang({Key? key}) : super(key: key);

  @override
  State<Keranjang> createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  List<String> items = ['COD', 'TRANSFER BANK'];
  String? selectedItem = 'COD';
  CollectionReference keranjang =
      FirebaseFirestore.instance.collection("keranjang");
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final myCounterController = Get.put(CounterController());
    final CounterController total = Get.find();
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Obx(() => Container(
                color: myCounterController.switchValue.value
                    ? kPrimaryColor
                    : kBlueColor,
              )),
          elevation: 0.0,
          backgroundColor: Color(0xFF0C3C78),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 35,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            Container(
                margin: EdgeInsets.only(top: 10, bottom: 10, right: 20),
                child: Text(
                  "${myCounterController.nama.toUpperCase()}",
                  style: TextStyle(fontSize: 18),
                ))
          ],
        ),
        body: Obx(
          () => Container(
            color: myCounterController.switchValue.value
                ? kPrimaryColor
                : kBlueColor,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Text(
                        "Cart Item",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                          fontSize: 21.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        )),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: keranjang
                          .where("idUser", isEqualTo: "${user!.uid}")
                          .snapshots(),
                      builder: (_, snapshot) {
                        return (snapshot.hasData)
                            ? Column(
                                children: snapshot.data!.docs
                                    .map(
                                      (e) => CardItem(
                                        e.get('nama'),
                                        e.get('image'),
                                        e.get('harga'),
                                        onDelete: () async {
                                          myCounterController.total.value -=
                                              int.parse(e.get("harga"));

                                          await FirebaseFirestore.instance
                                              .collection("Total")
                                              .doc(total.idTotal.value)
                                              .update({
                                            "total":
                                                myCounterController.total.value,
                                          });
                                          FirebaseFirestore.instance
                                              .collection("keranjang")
                                              .doc(e.id)
                                              .delete();
                                          Reference storageReference =
                                              await FirebaseStorage.instance
                                                  .refFromURL(e.get("image"));
                                          storageReference.fullPath;
                                          await storageReference.delete();
                                          final mySnackBar = SnackBar(
                                            content: Text(
                                              "Hapus Data Berhasil",
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
                                        },
                                      ),
                                    )
                                    .toList(),
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              );
                      },
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Total :",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              )),
                          SizedBox(
                            width: 40,
                          ),
                          Text("\$${total.total.value}",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Payment Method:",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedItem,
                                iconSize: 30,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                // isExpanded: true,
                                items: items
                                    .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        )))
                                    .toList(),
                                onChanged: (item) =>
                                    setState(() => selectedItem = item),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 60),
                      child: MaterialButton(
                        onPressed: () async {
                          var kode = randomAlpha(10);
                          CollectionReference pesanan = await FirebaseFirestore
                              .instance
                              .collection("Pesanan");

                          var result = await keranjang
                              .where("idUser", isEqualTo: "${user.uid}")
                              .get();

                          if (result.docs.length != 0) {
                            result.docs.forEach((element) {
                              pesanan.add({
                                "kodePesanan": kode,
                                "UserID": user.uid,
                                "nama": element.get("nama"),
                                "harga": element.get("harga"),
                                "image": element.get("image"),
                                "kategori": element.get("kategori"),
                                "deskripsi": element.get("deskripsi"),
                                'createdAt': Timestamp.now(),
                              });
                            });

                            await FirebaseFirestore.instance
                                .collection("Transaksi")
                                .doc()
                                .set({
                              "KodeTransaksi": kode,
                              "UserID": user.uid,
                              "Total": total.total.value.toString(),
                              "Jumlah": result.docs.length.toString(),
                              "Tanggal": Timestamp.now()
                            });
                            selectedItem == "COD"
                                ? myCounterController.metodePembayaran.value =
                                    "COD"
                                : myCounterController.metodePembayaran.value =
                                    "Transfer Bank";

                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: ((context) {
                              return Delivery();
                            })));
                          } else {
                            final mySnackBar = SnackBar(
                              content: Text(
                                "Data Keranjang Kosong!",
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
                        color: myCounterController.switchValue.value
                            ? kBlueColor
                            : kPrimaryColor,
                        height: 50.0,
                        minWidth: double.infinity,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Text("CHECKOUT AND BUY",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 18.0,
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

class CardItem extends StatelessWidget {
  final String nama;
  Function? onDelete;
  final String image;
  final String harga;

  CardItem(this.nama, this.image, this.harga, {this.onDelete});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.only(bottom: 20, left: 25),
      child: Row(
        children: [
          Container(
            width: 80.0,
            height: 80.0,
            decoration: BoxDecoration(
              color: kSecondaryColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: NetworkImage(image),
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                nama,
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                )),
              ),
              Text(
                "\$${harga}",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.black,
                )),
              ),
            ],
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(bottom: 10, right: 10),
            child: IconButton(
                onPressed: () {
                  AlertDialog alert = AlertDialog(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    title: Text(
                      "Batalkan Pesanan",
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      child: Text(
                        "Yakin ingin batal?",
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
                            onTap: () {
                              if (onDelete != null) onDelete!();
                              Get.back();
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
                            highlightColor: Colors.grey,
                            child: Center(
                              child: Text('Cancel',
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                            onTap: () {
                              Get.back();
                            }),
                      )
                    ],
                  );

                  showDialog(context: context, builder: (context) => alert);
                  return;
                },
                icon: Icon(
                  Icons.delete,
                  color: kPrimaryColor,
                  size: 40,
                )),
          ),
        ],
      ),
    );
  }
}
