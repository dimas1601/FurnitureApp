import "package:flutter/material.dart";
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/Searching.dart';
import 'package:get/get.dart';

class SearchBox extends StatelessWidget {
  SearchBox({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final ValueChanged onChanged;

  @override
  Widget build(BuildContext context) {
    final namaCtrl = TextEditingController();
    return Container(
      margin: EdgeInsets.all(kDefaultPadding),
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20)),
      child: TextFormField(
        controller: namaCtrl,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () {
                Get.to(Searching(
                  nama: namaCtrl.text,
                ));
              },
              icon: Icon(
                Icons.search,
                size: 28,
                color: Colors.white,
              ),
            ),
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }
}
