import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/AdminPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final CounterController control = Get.put(CounterController());

class Barang extends StatelessWidget {
  final String deskripsi;

  final Function? onDelete;
  final String image;
  final String id;
  final String nama;
  final String harga;
  final String kategori;
  Barang(
    this.id,
    this.nama,
    this.harga,
    this.deskripsi,
    this.kategori,
    this.image, {
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 160,
          width: 250,
          margin: EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Obx(
                () => Container(
                  height: 116,
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
                top: 0,
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
                left: -10,
                child: Container(
                  height: 136,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: ((context) {
                  return EditProduct(
                      id: id,
                      nama: nama,
                      harga: harga,
                      deskripsi: deskripsi,
                      kategori: kategori,
                      image: image);
                })));
              },
              child: Container(
                margin: EdgeInsets.only(right: 15, top: 50),
                width: 50,
                height: 60,
                child: Icon(
                  Icons.edit,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 5),
            GestureDetector(
              onTap: () {
                AlertDialog alert = AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(
                    "Hapus Data",
                    textAlign: TextAlign.center,
                  ),
                  content: Container(
                    child: Text(
                      "Yakin ingin hapus?",
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
              child: Container(
                margin: EdgeInsets.only(right: 15),
                width: 50,
                height: 60,
                child: Icon(
                  Icons.delete_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
