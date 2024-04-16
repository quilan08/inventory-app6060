
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/auth.dart';
import 'package:shimmer/shimmer.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
 
   final _loginFormKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _loading = false;
    @override
    void dispose(){
      _emailController.dispose();
      _passwordController.dispose();
      super.dispose();
    }
  @override
  Widget build(BuildContext context) {
     Color baseColor = Theme.of(context).primaryColor;
     Color highlightColor = Colors.yellow;
    return Padding(padding: const EdgeInsets.only(top: 100.0),
    child: Form(
      key: _loginFormKey, child: ListView(
        children:<Widget> [
          SizedBox(
            width: 200.0,
            height: 100.0,
            child: Shimmer.fromColors(
              baseColor: baseColor , highlightColor:highlightColor,
              child: const Text("Arturo's", textAlign: TextAlign.center, style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),) ),
          ),
           Padding(padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child:  TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "email",
              hintFadeDuration: Duration(microseconds: 80),
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              floatingLabelStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.email,), border: InputBorder.none,
            ), style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
            ),
            validator: (value){
              if(value!.isEmpty){
                return "Please add email.";
              }
              return null;
            },
          ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextFormField(
              autocorrect:true,
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: "Password",
                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(Icons.lock_open,)
          , border: UnderlineInputBorder()
              ),
              validator: (value)  {
                if(value!.isEmpty){
                  return "Please Enter Password";
                }
                return null;
              },
              ),
            ),

            Padding(padding: 
             const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(width: double.infinity, height: 20.0,
            child: TextButton(child: const Text("Don't have an Account", style: TextStyle(color: Colors.red),),
             onPressed: (){
              Navigator.pushNamed(context, '/register');
            },
            
            ),
            ),
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(width:double.minPositive, height: 50.0, 
            child: ElevatedButton(onPressed:_loading ? null:(){
              if(_loginFormKey.currentState!.validate()){
                setState(() {
                  _loading = true;
                });
                authService.handleSign(
                  email: _emailController.text,
                  password: _passwordController.text
                
                ).then((user){
                  setState(() {
                    _loading = false;
                  });
                  if(user!.emailVerified){
                    Navigator.pushReplacementNamed(context, "/home");
                  } else{
                    Navigator.pushReplacementNamed(context, "/verify");
                  }
                }).catchError((onError)
                {
                  setState(() {
                    _loading = false;
                  });
                  if(onError.toString().contains("No Internet")){
                   const snackbar = SnackBar(
                        content: Text("You dont have Internet Connection"),
                        backgroundColor: Colors.grey,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                        duration: Durations.short3,
                       
                     ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  
                  } else if(
                    onError.toString().contains("Not Registered")
                  ){
                     const snackbar = SnackBar(
                        content: Text("You dont have an Account"),
                        backgroundColor: Colors.grey,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                        duration: Durations.short3,
                       
                     ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  } 
                  else if(onError.toString().contains("ERROR_WRONG_PASSWORD")){
                     const snackbar = SnackBar(
                        content: Text("You entered Wrong password"),
                        backgroundColor: Colors.grey,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                        duration: Durations.short3,
                       
                     ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                  else{
                     const snackbar = SnackBar(
                        content: Text("There is a problem please again later"),
                        backgroundColor: Colors.grey,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                        duration: Durations.short3,
                       
                     ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
                  }
                });
              }else{
                 const snackbar = SnackBar(
                        content: Text("Please input is valid data"),
                        backgroundColor: Colors.grey,
                        elevation: 10,
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.all(5),
                        duration: Durations.short3,
                       
                     ); ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },child:Text("Login"),
            )
             ,),
            )
        ],
        ),),
    );
   
  }
}