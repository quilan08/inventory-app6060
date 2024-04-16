import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/userUpdateInfo.dart';
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
  Future<User?> handleSign({String? email, String? password}) async{
    if (connectionStatusSingleton.hasConnection) {
    bool  emailexits = await checkEmail(email);
    if(emailexits){
      try{
        return (await auth.signInWithEmailAndPassword(
          email:email!, 
         password: password!)).user;
         
      } catch(e){
        throw(e);
      }
    } else{
      throw Exception("Not Registered");
    }
    } else{
      throw Exception("No Internet");
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

Future<User?> handleRegister ( {required String? email, required String? password, required String? username})async{
  if(connectionStatusSingleton.hasConnection){
    try{
      final User? user = (await auth.createUserWithEmailAndPassword(email: email!, password: password!)).user;

      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = username;
      user!.updateDisplayName(info.displayName);
      return user;
    } catch(e){
      throw e;
    }
  } else {
    throw Exception("No Internet");
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