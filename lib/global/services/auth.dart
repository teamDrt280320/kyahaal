import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

//class AuthService {
final FirebaseAuth _auth = FirebaseAuth.instance;
String verificationId;

// create user obj based on firebase user
User _userFromFirebaseUser(User user) {
  return user;
}

// auth change user stream
Stream<User> get user {
  return _auth.authStateChanges().map(_userFromFirebaseUser);
}

signOut() {
  _auth.signOut();
}

class UserBloc {
  //String phone;

  final otpController = StreamController<bool>.broadcast();
  final verifyErrorController = StreamController<String>.broadcast();
  final loadController = StreamController<bool>.broadcast();

  signIn(String phone) async {
    if (phone.isEmpty || phone == null || phone.length != 10) {
      verifyErrorController.sink.add("Please Enter a valid Phone Number");
      loadController.sink.add(false);
    } else {
      verifyErrorController.sink.add("");
      loadController.add(true);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          preferences.setString("verificationId", credential.verificationId);
          verify(credential.smsCode);
          //loadController.add(false);
        },
        verificationFailed: (FirebaseAuthException e) {
          verifyErrorController.sink.add(e.code);
          loadController.sink.add(false);
        },
        codeSent: (String verificationId, int resendToken) {
          print("sent");
          otpController.sink.add(true);
          preferences.setString("verificationId", verificationId);
          preferences.setInt("resendToken", resendToken);
          loadController.sink.add(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  verify(String code) async {
    loadController.sink.add(true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String verificationId = preferences.getString("verificationId");
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    try {
      await _auth.signInWithCredential(phoneAuthCredential);
    } on FirebaseAuthException catch (e) {
      verifyErrorController.sink.add(e.code);
      loadController.sink.add(false);
    }
  }

  dispose() {
    otpController.close();
    verifyErrorController.close();
    loadController.close();
  }
}
