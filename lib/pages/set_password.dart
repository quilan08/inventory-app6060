
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth.dart';
import 'package:shimmer/shimmer.dart';

/*class SetPasswordPage extends StatelessWidget {
  final String email;

  SetPasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: SetPasswordForm(
          email: email,
        ),
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.5, 0.7, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.indigo[50]!,
              Colors.indigo[100]!,
              Colors.indigo[200]!,
              Colors.indigo[100]!,
            ],
          ),
        ),
      ),
    );
  }
}

class SetPasswordForm extends StatefulWidget {
  final String email;

  SetPasswordForm({required this.email});

  @override
  _SetPasswordFormState createState() => _SetPasswordFormState();
}

class _SetPasswordFormState extends State<SetPasswordForm> {
  bool _loading = false;
  final _setPasswordFormKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Form(
        key: _setPasswordFormKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 200.0,
              height: 100.0,
              child: Shimmer.fromColors(
                baseColor: Theme.of(context).primaryColor,
                highlightColor: Colors.yellow,
                child: const Text(
                  'INVENTORY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.person,
                  ),
                  border: InputBorder.none,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please add email';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                 
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(


Icons.lock,
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please add password';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
               
                  onPressed: _loading
                      ? null
                      : () async {
                          if (_setPasswordFormKey.currentState!.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            authService
                                .registration(
                                    email: widget.email,
                                    password: _passwordController.text,
                                    username: _nameController.text
                                    )
                                .then((user) {
                              user!.sendEmailVerification().then((_) {
                                setState(() {
                                  _loading = false;
                                });
                      const  snackbar = SnackBar(
                      content: Text("we sent you a verification email"),
                      backgroundColor: Colors.grey,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                      duration: Durations.short3,);
                       ScaffoldMessenger.of(context).showSnackBar(snackbar);
                      if(snackbar.action!.disabledBackgroundColor == true ){
                        Navigator.popAndPushNamed(context, "/verify");
                      }
                           
                              });
                            }).catchError((error) {
                              setState(() {
                                _loading = false;
                              });
                              print(error);
                              if (error.toString().contains("NOINTERNET")) {
                      const snackbar =  SnackBar(
                      content: Text("No internet connections"),
                      backgroundColor: Colors.grey,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                      duration: Durations.short3,
                );  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              } else if (error.message
                                  .contains("ERROR_EMAIL_ALREADY_IN_USE")) {
                                   const snackbar =  SnackBar(
                      content: Text("Already existing email "),
                      backgroundColor: Colors.grey,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                      duration: Durations.short3,
                );  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              } else if (error.message
                                  .contains("ERROR_WEAK_PASSWORD")) {
                                  const snackbar =  SnackBar(
                      content: Text("Weak Passowrd "),
                      backgroundColor: Colors.grey,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                      duration: Durations.short3,
                );  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              } else {
                           const snackbar =  SnackBar(
                      content: Text("Hey there please contact the adminstrator !!"),
                      backgroundColor: Colors.grey,
                      elevation: 10,
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(5),
                      duration: Durations.short3,
                );  ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              }
                            });
                          }
                        },
               
                  child: Text(
                    'COMPLETE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
*/