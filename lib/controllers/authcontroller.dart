import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kyahaal/modals/user.dart';
import 'package:kyahaal/utility/pages.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:kyahaal/views/views.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';

class AuthController extends GetxController {
  Rxn<User> firebaseUser = Rxn<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreUser = Rxn<UserModal>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final userName = TextEditingController();
  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance;
  var messaging = FirebaseMessaging.instance;
  var storage = FirebaseStorage.instance;
  final remoteConfig = RemoteConfig.instance;
  var localStorage = GetStorage('preferences');
  Rxn<String> tokeStream = Rxn<String>();
  Rxn<Uint8List> image = Rxn<Uint8List>();
  var helper = RsaKeyHelper();

  final codeSent = false.obs;
  final signingIn = false.obs;
  final verificationId = ''.obs;
  final resendToken = 0.obs;
  final setupComplte = false.obs;

  @override
  void onReady() {
    ///Run [EVERY] time [AuthState] changes
    ever(firebaseUser, handleAuthChanged);
    ever(tokeStream, handleTokenChanges);
    ever(firestoreUser, handleUserChanges);
    firebaseUser.bindStream(_auth.userChanges());
    tokeStream.bindStream(messaging.onTokenRefresh);
    super.onReady();
  }

  handleAuthChanged(_firebaseUser) async {
    //get firebaseUser data from firestore
    if (_firebaseUser?.uid != null) {
      firestoreUser.bindStream(getData());
    }

    if (_firebaseUser == null) {
      Get.offAll(() => AuthorizationPage());
    } else {
      Get.offAll(() => HomePage());
    }
  }

  ///[Send OTP]
  sendOtp() async {
    signingIn.value = true;
    try {
      if (kIsWeb) {
        var result = await auth.signInWithPhoneNumber(
          "+91" + phoneController.text,
        );
        verificationId.value = result.verificationId;
      } else {
        print(phoneController.text);
        await auth.verifyPhoneNumber(
          phoneNumber: "+91" + phoneController.text,
          verificationCompleted: (credential) async {
            await auth.currentUser.linkWithCredential(credential);
          },
          verificationFailed: (e) {
            print(e.message);
            print(e.code);
            Get.snackbar(
              'Error Occured',
              e.message,
            );
          },
          codeSent: (verificationId, resendToken) {
            print('codesent');
            codeSent.value = true;
            signingIn.value = false;
            this.verificationId.value = verificationId;
            this.resendToken.value = resendToken;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            this.verificationId.value = verificationId;
          },
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///[Verify] phone number
  Future<void> linkWithCredential() async {
    signingIn.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: otpController.text,
      );
      await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        Get.snackbar(
          'Error Occurred',
          'Account allready contains a phone number',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-credential') {
        Get.snackbar(
          'Error Occurred',
          'Provided credential is not vallid',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'credential-already-in-use') {
        Get.snackbar(
          'Error Occurred',
          'Provided phone number is already in use',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-verification-code') {
        Get.snackbar(
          'Error Occurred',
          'Provided Verification Code is not valid',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (e.code == 'invalid-verification-code') {
        Get.snackbar(
          'Error Occurred',
          'Provided Verification Code is not valid',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      var pairKey = await getKeyPair();
      await localStorage.write(
          'privateKey', helper.encodePrivateKeyToPemPKCS1(pairKey.privateKey));
      if (firestoreUser.value.initialSetupDone)
        await firestore.collection('users').doc(firebaseUser.value.uid).update({
          'publicKey': helper.encodePublicKeyToPemPKCS1(
            pairKey.publicKey,
          )
        });
      phoneController.text = '';
      otpController.text = '';
      codeSent.value = false;
      verificationId.value = '';
      resendToken.value = 0;
      signingIn.value = false;
    }
  }

  Stream<UserModal> getData() {
    return firestore
        .collection('users')
        .doc(firebaseUser.value.uid)
        .snapshots()
        .map(
          (event) => UserModal.fromJson(
            event.data(),
          ),
        );
  }

  handleTokenChanges(token) async {
    if (firebaseUser.value != null) {
      await firestore
          .collection('users')
          .doc(firebaseUser.value.uid)
          .update({'tokenId': token});
    }
  }

  handleUserChanges(UserModal userModal) async {
    if (!userModal.initialSetupDone && firestoreUser.value != null) {
      Get.offAllNamed(RoutesName.COMPLETESETUPPAGE);
    }
  }

  completeSetup(String status) async {
    try {
      var durl;
      signingIn.value = true;
      if (image.value != null) {
        TaskSnapshot task;
        task = await storage
            .ref('users')
            .child('profile_images')
            .child(firebaseUser.value.uid + ".jpg")
            .putData(image.value, SettableMetadata(contentType: 'image/jpeg'));
        durl = await task.ref.getDownloadURL();
      } else {
        durl = '';
      }

      // ignore: todo
      ///TODO : Add cehck for documents existence so as to decide whether to set or update the data
      await firestore
          .collection('users')
          .doc(firebaseUser.value.uid)
          .set(
            new UserModal(
              publicKey: helper.encodePublicKeyToPemPKCS1(
                (await getKeyPair()).publicKey,
              ),
              uName: userName.text,
              imgUrl: durl,
              status: status,
              initialSetupDone: true,
              token: await messaging.getToken(),
            ).toJson(),
          )
          .then((value) async {
        await firebaseUser.value.updateProfile(
          photoURL: durl,
          displayName: userName.text,
        );
        signingIn.value = false;
        Get.offAllNamed(RoutesName.HOMEPAGE);
      });
    } catch (e) {
      print(e.toString());
    } finally {
      signingIn.value = false;
    }
  }

  signOut() {
    signingIn.value = false;
    phoneController.clear();
    otpController.clear();
    userName.clear();
    image.value = null;
    auth.signOut();
  }
}
