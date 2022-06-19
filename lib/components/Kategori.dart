import "package:flutter/material.dart";
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/MainPage.dart';
import 'package:get/get.dart';

class Kategori extends StatefulWidget {
  final String indeks;
  Kategori(this.indeks);

  @override
  State<Kategori> createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  @override
  Widget build(BuildContext context) {
    final control = Get.put(CounterController());
    int selectedIndex = 0;
    List categories = ["All", "Kursi", "Meja", "Lemari", "Lampu"];
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 30,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = int.parse(widget.indeks);
              selectedIndex = index;
              if (categories[index] == "All") {
                setState(() {
                  Get.to(MainPage());
                });
              }
              if (categories[index] == "Kursi") {
                Get.to(PageKursi());
              }
              if (categories[index] == "Meja") {
                Get.to(PageMeja());
              }
              if (categories[index] == "Lemari") {
                Get.to(PageLemari());
              }
              if (categories[index] == "Lampu") {
                Get.to(PageLampu());
              }

              // Ge
              // Get.to(HomePage());
            });
          },
          child: Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              left: kDefaultPadding,
              right: index == categories.length - 1 ? kDefaultPadding : 0,
            ),
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            decoration: BoxDecoration(
                color: index == int.parse(widget.indeks)
                    ? kSecondaryColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(6)),
            child: Text(
              categories[index],
              style: TextStyle(
                  color: index == int.parse(widget.indeks)
                      ? Colors.white
                      : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
