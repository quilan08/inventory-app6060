import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/pages/LoginPage/AppLayout.dart';
import 'package:flutter_application_1/pages/LoginPage/loginwidget.dart';
import 'package:flutter_application_1/pages/tabs.dart';
import 'package:flutter_application_1/providers/auth.dart';
import 'package:flutter_application_1/utils/app_layout_styles.dart';
import 'package:gap/gap.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool isChecked = false;
  bool _isloading = false;
  late AnimationController controller;
  bool isValidEmail(String val) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(val);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);

    return Stack(children: [
      CircularProgressIndicator(
        value: controller.value,
        semanticsLabel: 'Circular progress indicator',
      ),
      Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 29, 41, 29),
              Color.fromARGB(255, 44, 136, 141)
            ],
          ),
        ),
      ),
      const Positioned(
          top: 220,
          left: 50,
          child: Text(
            'Create Account',
            style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: 48,
                fontFamily: 'Poppins-Medium',
                fontWeight: FontWeight.w500,
                color: Colors.white),
          )),
      Positioned(
          left: 0,
          bottom: 0,
          right: 0,
          child: Container(
            height: size.height * 0.65,
            decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 226, 246, 226),
                    Color.fromARGB(255, 231, 239, 240)
                  ],
                ),
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(50)),
                color:
                    const Color.fromARGB(255, 255, 254, 254).withOpacity(0.4)),
            child: Container(
              margin: const EdgeInsets.only(left: 20, top: 20),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(50))),
              child: Form(
                key: _form,
                child: ListView(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(44),
                      Padding(
                        padding: const EdgeInsets.only(left: 35),
                        child: Text(
                          "Email",
                          style: Styles.headline3.copyWith(
                              decoration: TextDecoration.none,
                              fontFamily: "Poppins-Medium"),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 35),
                          child: SizedBox(
                            width: 310,
                            child: Material(
                              color: Colors.transparent,
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    //check if the user has entered the correct
                                    return "Please enter correct email";
                                  } else if (!isValidEmail(value)) {
                                    return "Enter a valid email";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: const Icon(Icons.email_outlined,
                                      color: Color(0xffbfc205)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  filled: true,
                                  fillColor: const Color(0xfff4f6fd),
                                ),
                              ),
                            ),
                          )),
                      const Gap(10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Text(
                          "Password",
                          style: Styles.headline3.copyWith(
                              decoration: TextDecoration.none,
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Container(
                          width: 310,
                          child: Material(
                            color: Colors.transparent,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                } else if (value.length < 8) {
                                  return "Password must be atleast 8 characters long";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                prefixIcon: const Icon(Icons.lock_open_sharp,
                                    color: Color(0xffbfc205)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: const Color(0xfff4f6fd),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Text(
                          "Confirm Password",
                          style: Styles.headline3.copyWith(
                              decoration: TextDecoration.none,
                              fontFamily: "Poppins-Medium",
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: SizedBox(
                          width: 310,
                          child: Material(
                            color: Colors.transparent,
                            child: TextFormField(
                              controller: _confirmController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Re-Enter New Password";
                                } else if (value.length < 8) {
                                  return "Password must be atleast 8 characters long";
                                } else if (value != _passwordController.text) {
                                  return "Password must be same as above";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter Password',
                                prefixIcon: const Icon(Icons.lock_open_sharp,
                                    color: Color(0xffbfc205)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                filled: true,
                                fillColor: const Color(0xfff4f6fd),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Material(
                                  color: Colors.transparent,
                                  child: Checkbox(
                                    checkColor: Colors.black,
                                    activeColor: checkbox,
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      isChecked = value!;
                                    },
                                  ),
                                ),
                                const Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Remember Me',
                                    style: TextStyle(
                                        color: forgotPasswordText,
                                        fontSize: 16,
                                        fontFamily: 'Poppins-Medium',
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if (_form.currentState?.validate() ?? false) {
                                    setState(() {
                                      _isloading = true;
                                    });

                                    final message =
                                        await authService.registration(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );

                                    if (message!.contains("Success")) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => TabsPage(),
                                        ),
                                      );
                                    }

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(message),
                                      ),
                                    );

                                    setState(() {
                                      _isloading = false;
                                    });
                                  }
                                },
                                child: Container(
                                  width: 99,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: signInButton,
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.3),
                                            blurRadius: 3,
                                            spreadRadius: 3)
                                      ]),
                                  child: const Padding(
                                    padding: EdgeInsets.only(top: 6.0),
                                    child: Text(
                                      'Sign Up',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontFamily: 'Poppins-Medium',
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35.0, vertical: 16.0),
                        child: Divider(
                          color: Colors.grey, // Change the color of the divider
                          thickness: 2.0, // Set the thickness of the divider
                          height: 1.0, // Set the height of the divider
                        ),
                      ),
                      const Center(
                          child: Material(
                              child: Text("Already have an account?"))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                                color: Colors.transparent,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text("Login")))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 59,
                              height: 48,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: signInBox),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Image.asset(
                                'assets/images/icon_google.png',
                                width: 20,
                                height: 21,
                              ),
                            ),
                            const Text(
                              'or',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 18,
                                  fontFamily: 'Poppins-Regular',
                                  color: hintText),
                            ),
                            Container(
                              width: 59,
                              height: 48,
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(color: signInBox),
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20))),
                              child: Image.asset(
                                'assets/images/icon_apple.png',
                                width: 20,
                                height: 21,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          )),
      Visibility(
        visible: _isloading,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ]);
  }
}
