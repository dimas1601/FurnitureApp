import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/DetailPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final CounterController control = Get.put(CounterController());

class ProductCard extends StatelessWidget {
  final String nama;
  final String harga;
  final String deksripsi;
  final String image;
  final String id;
  ProductCard(this.id, this.nama, this.harga, this.deksripsi, this.image);
  @override
  Widget build(BuildContext context) {
    User? userAuth = FirebaseAuth.instance.currentUser;
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(DetailPage(id));
      },
      child: Container(
        height: 160,
        margin: EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Obx(
              () => Container(
                height: 136,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: control.switchValue.value ? kBlueColor : kPrimaryColor,
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
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                height: 160,
                width: 200,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 136,
                width: size.width - 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Text(
                        "$nama",
                        style: Theme.of(context).textTheme.button,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 1.5,
                        vertical: kDefaultPadding / 4,
                      ),
                      decoration: BoxDecoration(
                          color: kSecondaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          )),
                      child: Text(
                        "\$$harga",
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
