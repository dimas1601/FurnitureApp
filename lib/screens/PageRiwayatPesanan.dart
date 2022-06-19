import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/Controller.dart';

class RiwayatPesanan extends StatelessWidget {
  const RiwayatPesanan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final myCounterController = Get.put(CounterController());
    User? user = FirebaseAuth.instance.currentUser;
    CollectionReference transaksi =
        FirebaseFirestore.instance.collection("Transaksi");
    return Scaffold(
        body: Obx(
      () => Container(
        color:
            myCounterController.switchValue.value ? kPrimaryColor : kBlueColor,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, bottom: 20),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 80),
                    child: Text(
                      "Riwayat Pesanan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: transaksi
                  .where("UserID", isEqualTo: "${user!.uid}")
                  .snapshots(),
              builder: (_, snapshot) {
                return (snapshot.hasData)
                    ? Column(
                        children: snapshot.data!.docs
                            .map(
                              (e) => ItemTransaksi(
                                  e.get('Total'),
                                  e.get('Jumlah'),
                                  e.get('Tanggal'),
                                  e.get("KodeTransaksi")),
                            )
                            .toList(),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          ],
        ),
      ),
    ));
  }
}

class ItemTransaksi extends StatelessWidget {
  final String kode;
  final String total;
  final Timestamp tanggal;
  final String jumlah;
  ItemTransaksi(this.total, this.jumlah, this.tanggal, this.kode);

  @override
  Widget build(BuildContext context) {
    DateTime waktu = tanggal.toDate();

    var tgl = DateFormat.yMMMd().add_jm().format(waktu);
    return Column(children: [
      GestureDetector(
        onTap: () {
          Get.to(DataPesanan(kode));
        },
        child: Container(
          margin: EdgeInsets.only(top: 10, left: 20, right: 20),
          // width: 40,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.chair_rounded,
                  size: 50,
                  color: kSecondaryColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 16, left: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${jumlah} Product",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "\$${total}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "${tgl}",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: Color.fromARGB(255, 103, 102, 102),
                      ),
                    )
                  ],
                ),
              ),
              // SizedBox(width: 60),
              Spacer(),
              Container(
                margin: EdgeInsets.only(right: 20),
                width: 80,
                height: 30,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 37, 183, 42),
                  borderRadius: BorderRadius.circular(5),
                ),
                alignment: Alignment.center,
                child: Text("Succes",
                    style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      ),
      SizedBox(
        height: 5,
      ),
      Divider(
        color: Colors.white,
        indent: 20,
        endIndent: 20,
        thickness: 2,
      ),
    ]);
  }
}

class DataPesanan extends StatelessWidget {
  final String kode;
  DataPesanan(this.kode);

  @override
  Widget build(BuildContext context) {
    final myCounterController = Get.put(CounterController());
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
        body: Obx(
      () => Container(
        color:
            myCounterController.switchValue.value ? kPrimaryColor : kBlueColor,
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30, left: 20, bottom: 10),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 90),
                    child: Text(
                      "Data Pesanan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Pesanan")
                  .where("kodePesanan", isEqualTo: "${kode}")
                  .snapshots(),
              builder: (_, snapshot) {
                return (snapshot.hasData)
                    ? Column(
                        children: snapshot.data!.docs
                            .map(
                              (e) => Pesanan(
                                e.get("nama"),
                                e.get("harga"),
                                e.get("deskripsi"),
                                e.get("image"),
                                e.get("kategori"),
                              ),
                            )
                            .toList(),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      );
              },
            ),
          ],
        ),
      ),
    ));
  }
}

class Pesanan extends StatelessWidget {
  final String deskripsi;
  final String image;
  final String nama;
  final String harga;
  final String kategori;
  Pesanan(this.nama, this.harga, this.deskripsi, this.image, this.kategori);

  @override
  Widget build(BuildContext context) {
    final CounterController control = Get.put(CounterController());
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 250,
          width: 320,
          margin: EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Obx(
                () => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color:
                        control.switchValue.value ? kBlueColor : kPrimaryColor,
                    boxShadow: [kDefaultShadow],
                  ),
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 5,
                left: -10,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 85,
                    width: 120,
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                top: 70,
                left: 5,
                child: Container(
                  height: 206,
                  width: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding),
                          child: Text("Nama : $nama",
                              style: GoogleFonts.poppins(
                                  fontSize: 15, color: Colors.black)),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                          "Harga : \$$harga",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                          "Deskripsi : $deskripsi",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding),
                        child: Text(
                          "Kategori : $kategori",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
