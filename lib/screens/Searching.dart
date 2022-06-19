import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/components/Drawer.dart';
import 'package:furniture_app/components/Kategori.dart';
import 'package:furniture_app/components/SearchBox.dart';
import 'package:furniture_app/components/product_card.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:get/get.dart';

class Searching extends StatelessWidget {
  final String nama;
  Searching({Key? key, required this.nama}) : super(key: key);
  final myCounterController = Get.put(CounterController());
  final CounterController controller = Get.find();

  CollectionReference barang = FirebaseFirestore.instance.collection('Barang');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        flexibleSpace: Obx(() => Container(
              color: myCounterController.switchValue.value
                  ? kPrimaryColor
                  : kBlueColor,
            )),
        actions: [
          Obx(
            () => Switch(
              activeColor: Colors.white,
              value: myCounterController.switchValue.value,
              onChanged: (newValue) {
                myCounterController.switchValue.value = newValue;
              },
            ),
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Obx(
          () => Container(
            color: myCounterController.switchValue.value
                ? kPrimaryColor
                : kBlueColor,
            child: Column(
              children: [
                // searching
                SearchBox(onChanged: (value) {}),
                Kategori("0"),

                SizedBox(height: kDefaultPadding / 2),
                // Background putih
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 70),
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      // tampilin data
                      ListView(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: barang
                                .where("nama", isEqualTo: nama)
                                .snapshots(),
                            builder: (_, snapshot) {
                              return (snapshot.hasData)
                                  ? Column(
                                      children: snapshot.data!.docs
                                          .map(
                                            (e) => ProductCard(
                                              e.id,
                                              e.get('nama'),
                                              e.get('harga'),
                                              e.get('deskripsi'),
                                              e.get('image'),
                                            ),
                                          )
                                          .toList(),
                                    )
                                  : Center(child: CircularProgressIndicator());
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageKursi extends StatelessWidget {
  PageKursi({Key? key}) : super(key: key);
  final myCounterController = Get.put(CounterController());
  final CounterController controller = Get.find();

  CollectionReference barang = FirebaseFirestore.instance.collection('Barang');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        flexibleSpace: Obx(() => Container(
              color: myCounterController.switchValue.value
                  ? kPrimaryColor
                  : kBlueColor,
            )),
        actions: [
          Obx(
            () => Switch(
              activeColor: Colors.white,
              value: myCounterController.switchValue.value,
              onChanged: (newValue) {
                myCounterController.switchValue.value = newValue;
              },
            ),
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Obx(
          () => Container(
            color: myCounterController.switchValue.value
                ? kPrimaryColor
                : kBlueColor,
            child: Column(
              children: [
                // searching
                SearchBox(onChanged: (value) {}),
                Kategori("1"),
                SizedBox(height: kDefaultPadding / 2),

                // Background putih
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 70),
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      // tampilin data
                      ListView(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: barang
                                .where("kategori", isEqualTo: "Kursi")
                                .snapshots(),
                            builder: (_, snapshot) {
                              return (snapshot.hasData)
                                  ? Column(
                                      children: snapshot.data!.docs
                                          .map(
                                            (e) => ProductCard(
                                              e.id,
                                              e.get('nama'),
                                              e.get('harga'),
                                              e.get('deskripsi'),
                                              e.get('image'),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageMeja extends StatelessWidget {
  PageMeja({Key? key}) : super(key: key);
  final myCounterController = Get.put(CounterController());
  final CounterController controller = Get.find();

  CollectionReference barang = FirebaseFirestore.instance.collection('Barang');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        flexibleSpace: Obx(() => Container(
              color: myCounterController.switchValue.value
                  ? kPrimaryColor
                  : kBlueColor,
            )),
        actions: [
          Obx(
            () => Switch(
              activeColor: Colors.white,
              value: myCounterController.switchValue.value,
              onChanged: (newValue) {
                myCounterController.switchValue.value = newValue;
              },
            ),
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Obx(
          () => Container(
            color: myCounterController.switchValue.value
                ? kPrimaryColor
                : kBlueColor,
            child: Column(
              children: [
                // searching

                SearchBox(onChanged: (value) {}),

                Kategori("2"),
                SizedBox(height: kDefaultPadding / 2),

                // Background putih
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 70),
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      // tampilin data
                      ListView(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: barang
                                .where("kategori", isEqualTo: "Meja")
                                .snapshots(),
                            builder: (_, snapshot) {
                              return (snapshot.hasData)
                                  ? Column(
                                      children: snapshot.data!.docs
                                          .map(
                                            (e) => ProductCard(
                                              e.id,
                                              e.get('nama'),
                                              e.get('harga'),
                                              e.get('deskripsi'),
                                              e.get('image'),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PageLemari extends StatelessWidget {
  PageLemari({Key? key}) : super(key: key);
  final myCounterController = Get.put(CounterController());
  final CounterController controller = Get.find();

  CollectionReference barang = FirebaseFirestore.instance.collection('Barang');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        flexibleSpace: Obx(() => Container(
              color: myCounterController.switchValue.value
                  ? kPrimaryColor
                  : kBlueColor,
            )),
        actions: [
          Obx(
            () => Switch(
              activeColor: Colors.white,
              value: myCounterController.switchValue.value,
              onChanged: (newValue) {
                myCounterController.switchValue.value = newValue;
              },
            ),
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: Obx(
          () => Container(
            color: myCounterController.switchValue.value
                ? kPrimaryColor
                : kBlueColor,
            child: Column(
              children: [
                // searching
                SearchBox(onChanged: (value) {}),
                Kategori("3"),
                SizedBox(height: kDefaultPadding / 2),

                // Background putih
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 70),
                        decoration: BoxDecoration(
                          color: kBackgroundColor,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      // tampilin data
                      ListView(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: barang
                                .where("kategori", isEqualTo: "Lemari")
                                .snapshots(),
                            builder: (_, snapshot) {
                              return (snapshot.hasData)
                                  ? Column(
                                      children: snapshot.data!.docs
                                          .map(
                                            (e) => ProductCard(
                                              e.id,
                                              e.get('nama'),
                                              e.get('harga'),
                                              e.get('deskripsi'),
                                              e.get('image'),
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
