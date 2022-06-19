import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final CounterController control = Get.put(CounterController());

class UpdateBarang extends StatelessWidget {
  final String deskripsi;
  final String image;
  final String nama;
  final String harga;
  final String kategori;
  final String id;
  UpdateBarang(this.id, this.nama, this.harga, this.deskripsi, this.image,
      this.kategori);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container g ad warnanya
        Container(
          height: 250,
          width: 320,
          margin: EdgeInsets.symmetric(
              horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // container warna merah
              Obx(
                () => Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color:
                        control.switchValue.value ? kBlueColor : kPrimaryColor,
                    boxShadow: [kDefaultShadow],
                  ),
                  // container warna putih
                  child: Container(
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),
              // gaambar
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
