import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/LoginPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final namaLengkap = TextEditingController();
  final CounterController myCounterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40, bottom: 20),
                  child: Text(
                    "Welcome To \nFurniture App",
                    style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(left: 33, bottom: 60, right: 33, top: 30),
                  child: Text(
                    "Aplikasi Furnitur adalah aplikasi yang dapat digunakan untuk membeli barang-barang furnitur secara online seperti: Meja, Kursi, Lemari dll.",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                          image: AssetImage("assets/images/logo.webp"))),
                ),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  child: SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF0c3c78),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadowColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: ((context) {
                            return Login();
                          })));
                        }
                      },
                      child: Text(
                        "G E T   S T A R T",
                        style: TextStyle(
                          fontFamily: 'Bangers',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
