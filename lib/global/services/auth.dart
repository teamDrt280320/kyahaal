import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kyahaal/global/helper/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

//class AuthService {
final FirebaseAuth _auth = FirebaseAuth.instance;
//final FirebaseDatabase _database = FirebaseDatabase.instance;
String verificationId;

// auth change user stream
Stream<User> get user {
  return _auth.authStateChanges();
}

signOut() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.clear();
  _auth.signOut();
}

class UserBloc {
  final otpController = StreamController<bool>.broadcast();
  final verifyErrorController = StreamController<String>.broadcast();
  final loadController = StreamController<bool>.broadcast();
  final setupController = StreamController<bool>.broadcast();

  getDataStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setupController.sink
        .add(preferences.getBool(KHStrings.isSetupComplete) ?? false);
  }

  signIn(String phone, String uname, File image) async {
    if (phone.isEmpty ||
        phone == null ||
        phone.length != 10 ||
        uname.isEmpty ||
        uname == null) {
      verifyErrorController.sink.add("Please Fill all Fields Correctly");
      loadController.sink.add(false);
    } else {
      verifyErrorController.sink.add("");
      loadController.add(true);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91' + phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          preferences.setString("verificationId", credential.verificationId);
          verify(credential.smsCode, uname, image);
        },
        verificationFailed: (FirebaseAuthException e) {
          verifyErrorController.sink.add(e.code);
          loadController.sink.add(false);
        },
        codeSent: (String verificationId, int resendToken) {
          otpController.sink.add(true);
          preferences.setString("verificationId", verificationId);
          preferences.setInt("resendToken", resendToken);
          loadController.sink.add(false);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  verify(String code, String uname, File image) async {
    loadController.sink.add(true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String verificationId = preferences.getString("verificationId");
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: code);
    try {
      await _auth.signInWithCredential(phoneAuthCredential).then(
            (value) => completeSetup(image, value.user, uname),
          );
    } on FirebaseAuthException catch (e) {
      verifyErrorController.sink.add(e.code);
      loadController.sink.add(false);
    }
  }

  completeSetup(File image, User user, String uname) async {
    setupController.sink.add(false);
    if (image != null) {
      String fileName = user.uid + ".jpg";
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("/profilePictures/$fileName");
      UploadTask uploadTask = firebaseStorageRef.putFile(image);
      uploadTask.whenComplete(() async {
        TaskSnapshot taskSnapshot = uploadTask.snapshot;
        String durl = await taskSnapshot.ref.getDownloadURL();
        await user.updateProfile(
          displayName: uname,
          photoURL: durl,
        );
        setupController.sink.add(true);
      });
    } else {
      await user.updateProfile(
        photoURL: null,
        displayName: uname,
      );
      setupController.sink.add(true);
    }
  }

  dispose() {
    otpController.close();
    verifyErrorController.close();
    loadController.close();
    setupController.close();
  }
}
