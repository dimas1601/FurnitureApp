import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniture_app/components/Controller.dart';
import 'package:furniture_app/components/Animasi.dart';
import 'package:furniture_app/components/ForgotPassword.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/RegisterPage.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final myCounterController = Get.put(CounterController());
  bool isHiddenPassword = false;
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final pass = TextEditingController();
  String _errorMessage = '';

  User? userAuth = FirebaseAuth.instance.currentUser;

  CollectionReference user = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 29, top: 67),
                      child: Text("Hello! Welcome back!",
                          style: GoogleFonts.poppins(
                              fontSize: 24, fontWeight: FontWeight.w400)),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 67),
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/icons/icons8-hand-48.png"))),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 29, top: 9),
                  child: Text("Hello again, You’ve been missed!",
                      style: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w400)),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 39,
                    left: 29,
                  ),
                  child: Text(
                    "Email",
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
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
                Container(
                  margin: EdgeInsets.only(
                    top: 10,
                    left: 29,
                  ),
                  child: Text(
                    "Password",
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 29, top: 5, right: 43),
                  height: 70,
                  child: TextFormField(
                    controller: pass,
                    obscureText: !isHiddenPassword,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(top: 12, left: 11),
                        hintText: "Password",
                        hintStyle: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w400),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isHiddenPassword = !isHiddenPassword;
                            });
                          },
                          icon: isHiddenPassword
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off),
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Container(
                  margin: EdgeInsets.only(left: 29),
                  child: Row(
                    children: [
                      Text(
                        "Belum punya akun?",
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w400),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return LupaPassword();
                            })));
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 40),
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.poppins(
                                color: Color(0xffc70039),
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 29,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        email.text = "";
                        pass.text = "";
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return Register();
                          }),
                        );
                      });
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                          color: Colors.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 32, top: 35),
                  width: MediaQuery.of(context).size.width - 32,
                  height: 40,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: kBlueColor),
                    onPressed: () {
                      setState(() async {
                        if (_formKey.currentState!.validate()) {
                          if (email.text == "admin@gmail.com" &&
                              pass.text == "000000") {
                            try {
                              final mySnackBar = SnackBar(
                                content: Text("Login Berhasil",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black)),
                                duration: Duration(seconds: 3),
                                backgroundColor: kSecondaryColor,
                              );
                              return await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text, password: pass.text)
                                  .then((value) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(mySnackBar);
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: ((context) {
                                  return LoadingAdmin();
                                })));
                                email.text = "";
                                pass.text = "";
                              });
                            } catch (e) {
                              final mySnackBar = SnackBar(
                                content: Text("Login Gagal ${e.toString()}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black)),
                                duration: Duration(seconds: 3),
                                backgroundColor: kSecondaryColor,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mySnackBar);
                            }
                          } else {
                            // text in form is  valid
                            try {
                              final mySnackBar = SnackBar(
                                content: Text("Login Berhasil",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black)),
                                duration: Duration(seconds: 3),
                                backgroundColor: kSecondaryColor,
                              );
                              return await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text, password: pass.text)
                                  .then((value) async {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(mySnackBar);
                                User? userAuth =
                                    FirebaseAuth.instance.currentUser;
                                final CounterController control =
                                    Get.put(CounterController());

                                CollectionReference user = FirebaseFirestore
                                    .instance
                                    .collection('Users');

                                final data = await user
                                    .where("email",
                                        isEqualTo: "${userAuth?.email}")
                                    .get();
                                data.docs.forEach((element) {
                                  control.id.value = element.id;
                                  control.nama.value = element.get("nama");
                                  control.email.value = element.get("email");
                                  control.image.value = element.get("image");
                                  control.alamat.value = element.get("alamat");
                                  control.password.value =
                                      element.get("password");
                                  control.nohp.value = element.get("nohp");
                                });
                                //
                                final total = await FirebaseFirestore.instance
                                    .collection('Total')
                                    .where("email",
                                        isEqualTo: "${userAuth!.email}")
                                    .get();
                                total.docs.forEach((element) {
                                  control.total.value = element.get("total");
                                  control.idTotal.value = element.id;
                                });
                                email.text = "";
                                pass.text = "";
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: ((context) {
                                  return LoadingUser();
                                })));
                              });
                            } catch (e) {
                              final mySnackBar = SnackBar(
                                content: Text("Login Gagal ${e.toString()}",
                                    style: GoogleFonts.poppins(
                                        fontSize: 14, color: Colors.black)),
                                duration: Duration(seconds: 3),
                                backgroundColor: kSecondaryColor,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(mySnackBar);
                            }
                          }
                        } else {
                          final mySnackBar = SnackBar(
                            content: Text("Lengkapi Username atau Password!",
                                style: GoogleFonts.poppins(
                                    fontSize: 14, color: Colors.black)),
                            duration: Duration(seconds: 3),
                            backgroundColor: kSecondaryColor,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(mySnackBar);
                        }
                      });
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
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
