import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/LoginPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LupaPassword extends StatefulWidget {
  const LupaPassword({Key? key}) : super(key: key);

  @override
  State<LupaPassword> createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  String _errorMessage = "";

  final email = TextEditingController();
  final myCounterController = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Obx(() => Container(
                color: myCounterController.switchValue.value
                    ? kPrimaryColor
                    : kBlueColor,
              )),
          centerTitle: true,
          title: Text("Reset Password"),
        ),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    top: 20,
                    left: 30,
                  ),
                  child: Text(
                    "Masukkan Email",
                    style: GoogleFonts.poppins(
                        fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 29, top: 5, right: 43),
                  height: 70,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Email Tidak Boleh Kosong";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(top: 12, left: 11),
                          hintText: "Contoh: user@gmail.com",
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w400),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                        onChanged: (val) {
                          validateEmail(val);
                        },
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 13, top: 50),
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                    child: Obx(() => ElevatedButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                myCounterController.switchValue.value
                                    ? kPrimaryColor
                                    : kBlueColor),
                        onPressed: () async {
                          if (email.text != "" &&
                              GetUtils.isEmail(email.text)) {
                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AlertDialog alert = AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                title: Text(
                                  "Forgot Password",
                                  textAlign: TextAlign.center,
                                ),
                                content: Container(
                                  child: Text(
                                    "Kami telah mengirimkan reset password ke email ${email.text}",
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
                                          child: Obx((() => Text('OK',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: kBlueColor,
                                                fontWeight: FontWeight.bold,
                                              )))),
                                        ),
                                        onTap: () {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: ((context) {
                                            return Login();
                                          })));
                                        }),
                                  ),
                                ],
                              );

                              showDialog(
                                  context: context,
                                  builder: (context) => alert);
                              return;
                            } catch (e) {
                              final mySnackBar = SnackBar(
                                content: Text("Email Tidak Terdaftar",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black)),
                                duration: Duration(seconds: 3),
                                backgroundColor: kSecondaryColor,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mySnackBar);

                              print("Email tidak valid");
                            }
                          } else {
                            print("Email tidak valid");
                          }
                        },
                        child: Text("Send", style: TextStyle(fontSize: 16)))))
              ],
            )
          ],
        ));
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = "";
      });
    }
  }
}
