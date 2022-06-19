import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/screens/PageStruk.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/MainPage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../screens/AdminPage.dart';

class LoadingAdmin extends StatefulWidget {
  const LoadingAdmin({Key? key}) : super(key: key);

  @override
  State<LoadingAdmin> createState() => _LoadingAdminState();
}

class _LoadingAdminState extends State<LoadingAdmin> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return DataProduct();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/animasi/loading.json",
        ),
      ),
    );
  }
}

class LoadingUser extends StatefulWidget {
  const LoadingUser({Key? key}) : super(key: key);

  @override
  State<LoadingUser> createState() => _LoadingUserState();
}

class _LoadingUserState extends State<LoadingUser> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () async {
      CounterController control = Get.put(CounterController());
      User? userAuth = FirebaseAuth.instance.currentUser;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return MainPage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/animasi/loading.json",
        ),
      ),
    );
  }
}

class Delivery extends StatefulWidget {
  Delivery({Key? key}) : super(key: key);

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  final myCounterController = Get.put(CounterController());
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          return StrukPage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
          color: myCounterController.switchValue.value
              ? kPrimaryColor
              : kBlueColor,
          child: Container(
            margin: EdgeInsets.only(right: 50),
            child: OverflowBox(
              maxHeight: 650,
              maxWidth: 650,
              child: Lottie.asset("assets/animasi/delivery2.json"),
            ),
          ),
        ),
      ),
    );
  }
}
