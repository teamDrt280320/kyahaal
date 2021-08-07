import 'package:another_flushbar/flushbar_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:kyahaal/modals/firestore_user.dart';
import 'package:kyahaal/utils/routes.dart';
import 'package:simpler_login/simpler_login.dart';

class AuthController extends GetxController {
  final SimplerLogin simplerLogin = SimplerLogin.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late TextEditingController phoneController,
      otpController,
      displayNameController;

  ///Streams
  RxnString error = RxnString();
  Rxn<User> userStream = Rxn<User>();
  RxBool otpSent = RxBool(false);
  RxBool authProcessing = RxBool(false);
  Rxn<FirestoreUser> currentUserData = Rxn<FirestoreUser>();

  ///Getters
  bool get hasAuthError => error.value?.isNotEmpty ?? false;
  User? get currentUser => userStream.value;
  bool get isLoggedIn => currentUser != null;
  bool get isOtpSent => otpSent.value;

  CollectionReference<Map<String, dynamic>> get userCollection =>
      _firestore.collection('users');

  Future<void> sendOtp() async {
    authProcessing.value = true;
    await simplerLogin.verifyPhoneNumber(
      phoneNumber: '+91${phoneController.text}',
      otpController: otpController,
      timeout: const Duration(seconds: 30),
      signInOnAutoRetrival: false,
    );
    authProcessing.value = false;
  }

  Future<void> resendOtp() async {
    await simplerLogin.verifyPhoneNumber(
      phoneNumber: '+91${phoneController.text}',
      otpController: otpController,
      forceResendingToken: simplerLogin.forceResendingToken,
      timeout: const Duration(seconds: 60),
      signInOnAutoRetrival: false,
    );
  }

  Future<void> verifyOtp() async {
    await simplerLogin
        .verifyOtp(
      smsCode: otpController.text,
      updateProfile: true,
      displayName: displayNameController.text,
    )
        .then(
      (creds) {
        if (creds?.user != null) {
          userCollection.doc(creds!.user!.uid).set(FirestoreUser(
                phone: phoneController.text,
                displayName: displayNameController.text,
                photoURL: '',
                status: '',
              ).toMap());
          FlushbarHelper.createSuccess(message: 'Welcome to KyaHaal!')
              .show(Get.context!);

          flush();
        }
      },
    );
  }

  Future<void> signOut() async {
    await simplerLogin.signOut();
  }

  Stream<FirestoreUser> get streamCurrentUserData => userCollection
      .doc(currentUser!.uid)
      .snapshots()
      .map((snapshot) => FirestoreUser.fromFirestore(snapshot));

  void flush() {
    phoneController.clear();
    otpController.clear();
    displayNameController.clear();
    error.value = null;
    otpSent.value = false;
  }

  void _handleAuthStateChange(User? user) {
    if (user?.uid != null) {
      currentUserData.bindStream(streamCurrentUserData);
      Get.toNamed(Routes.home);
    } else {
      Get.toNamed(Routes.login);
    }
  }

  void _handleErrorChanges(String? error) {
    if (error != null && Get.context != null) {
      FlushbarHelper.createError(message: error).show(Get.context!);
    }
  }

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    otpController = TextEditingController();
    displayNameController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    ever(userStream, _handleAuthStateChange);
    ever(error, _handleErrorChanges);
    otpSent.bindStream(simplerLogin.otpSent);
    userStream.bindStream(simplerLogin.userStream);
    error.bindStream(simplerLogin.errorStream);
  }
}
