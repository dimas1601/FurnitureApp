import 'package:flutter/material.dart';
import 'package:furniture_app/data/constant.dart';

class ProductPoster extends StatelessWidget {
  final String deskripsi;
  final String image;
  final String nama;
  final String harga;
  ProductPoster(this.nama, this.harga, this.image, this.deskripsi);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // buat background warna putih
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        color: kBackgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
              height: size.width * 0.8,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // buat lingkaran di belakang gambar
                  Container(
                    height: size.width * 0.7,
                    width: size.width * 0.7,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                  ),
                  Image.network(
                    image,
                    height: size.width * 0.75,
                    width: size.width * 0.75,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: Text("$nama", style: TextStyle(fontSize: 18)),
          ),
          Text(
            "\$$harga",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kPrimaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: Text(
              "$deskripsi",
              style: TextStyle(color: kTextLightColor),
            ),
          ),
          SizedBox(
            height: kDefaultPadding,
          )
        ],
      ),
    );
  }
}
