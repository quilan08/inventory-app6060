import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/providers/connections.dart';
import 'package:flutter_application_1/providers/database.dart';

final AuthProvider authService = AuthProvider();
 final ConnectionStatusSingleton connectionStatusSingleton = ConnectionStatusSingleton.getInstance();

class AuthProvider{
  final FirebaseAuth auth = FirebaseAuth.instance;
  late FirebaseFirestore _db;
  

  AuthProvider(){
    _db = dbService.firedb;
  }
Future<String?> handlelogin({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }


  Future<bool> checkEmail(String? email) async{
    try{
      DocumentSnapshot employee = await _db.collection('employees').doc(email).get();
      return employee.exists;
    } catch(e){
      throw(e);
    }
  }
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
}

Future<void> logout() async{
  if(connectionStatusSingleton.hasConnection){
    try {
      return await auth.signOut();
    }
    catch(e){
      throw e;
    }
  } else{
    throw Exception("No Internet");
  }
}

}
