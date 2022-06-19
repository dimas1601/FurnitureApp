import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:furniture_app/data/constant.dart';
import 'package:furniture_app/screens/LoginPage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:path/path.dart';
import 'dart:io';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var id = 0;
  bool isHiddenPassword = false;
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final namaCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final nohpCtrl = TextEditingController();
  final alamatCtrl = TextEditingController();
  String _errorMessage = '';

  @override
  PlatformFile? pickedImage;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedImage = result.files.first;
    });
  }

  Future uploadFile(pickedImage) async {
    String url;
    final File imageFile = File(pickedImage!.path);
    String fileName = basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("Users").child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask.whenComplete(() => null);
    url = await snapshot.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('Users').doc().set({
      "email": emailCtrl.text,
      "password": passwordCtrl.text,
      "nama": namaCtrl.text,
      "alamat": alamatCtrl.text,
      "nohp": nohpCtrl.text,
      "image": url,
      'createdAt': Timestamp.now(),
    });
    await FirebaseFirestore.instance.collection('Total').doc().set({
      "userId": "",
      "email": emailCtrl.text,
      "total": 0,
      'createdAt': Timestamp.now(),
    });
    emailCtrl.text = "";
    namaCtrl.text = "";
    passwordCtrl.text = "";
    nohpCtrl.text = "";
    alamatCtrl.text = "";
    pickedImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 35, top: 28),
                  child: Text("Create Account",
                      style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w500)),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, top: 5),
                  child: Text(
                    "Become a member now!",
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, top: 35),
                  child: Text(
                    "Your Name",
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                  height: 64,
                  child: TextFormField(
                    controller: namaCtrl,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12, left: 11),
                      hintText: "Contoh: user",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 35,
                  ),
                  child: Text(
                    "Email",
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                  height: 64,
                  child: Stack(
                    children: [
                      TextFormField(
                        controller: emailCtrl,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "";
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
                    left: 35,
                  ),
                  child: Text(
                    "Password",
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                  height: 64,
                  child: TextFormField(
                    controller: passwordCtrl,
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
                Container(
                  margin: EdgeInsets.only(left: 35),
                  child: Text(
                    "No Handphone",
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                  height: 64,
                  child: TextFormField(
                    controller: nohpCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12, left: 11),
                      hintText: "Contoh: 0822********",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nomor handphone tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35),
                  child: Text(
                    "Alamat",
                    style: GoogleFonts.poppins(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, top: 5, right: 43),
                  height: 84,
                  child: TextFormField(
                    controller: alamatCtrl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 12, left: 11),
                      hintText: "Contoh: Jl. Perjuangan 7",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Alamat tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    selectFile();
                  },
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, top: 10, right: 5),
                      width: 120,
                      height: 35,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(
                          "Select Image",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(
                          pickedImage != null ? "${pickedImage!.name}" : "",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Checkbox(
                          value: isChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              isChecked = value!;
                            });
                          }),
                      Text(
                        "I agree to the terms and conditions",
                        style: GoogleFonts.poppins(
                            fontSize: 13, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 35, right: 32, top: 23),
                  width: MediaQuery.of(context).size.width - 32,
                  height: 40,
                  child: ElevatedButton(
                    style: TextButton.styleFrom(backgroundColor: kBlueColor),
                    onPressed: () async {
                      // setState(() {
                      if (pickedImage == null) {
                        print("Please pick an image");
                      } else {
                        if (_formKey.currentState!.validate()) {
                          try {
                            final mySnackBar = SnackBar(
                              content: Text("Register Berhasil",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.black)),
                              duration: Duration(seconds: 3),
                              backgroundColor: kSecondaryColor,
                            );
                            return await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailCtrl.text,
                                    password: passwordCtrl.text)
                                .then((value) => {
                                      uploadFile(pickedImage),
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(mySnackBar),
                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(
                                              builder: ((context) {
                                        return Login();
                                      })))
                                    });
                          } catch (e) {
                            final mySnackBar = SnackBar(
                              content: Text("Register Gagal ${e.toString()}",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, color: Colors.black)
                                  //
                                  ),
                              duration: Duration(seconds: 3),
                              backgroundColor: kSecondaryColor,
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(mySnackBar);
                          }
                        } else {
                          final mySnackBar = SnackBar(
                            content: Text(
                              "Lengkapi Data Terlebih Dahulu!",
                              style: TextStyle(
                                  fontSize: 14,
                                  // fontFamily: "Lobster",
                                  color: Colors.black),
                            ),
                            duration: Duration(seconds: 3),
                            backgroundColor: kSecondaryColor,
                          );

                          ScaffoldMessenger.of(context)
                              .showSnackBar(mySnackBar);
                        }
                      }
                      // });
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return Login();
                            }),
                          );
                        });
                      },
                      child: Text(
                        "Log In",
                        style: GoogleFonts.poppins(
                            color: Color(0xffc70039),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          )
        ],
      ),
    );
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
