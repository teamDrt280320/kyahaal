import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';
import 'package:kyahaal/modals/message.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart' as encrypter;
import '../main.dart';

class ChatController extends GetxController {
  var scrollController = ScrollController();
  var firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  var messageController = TextEditingController();
  var privateKey;
  final uid = ''.obs;
  Rxn<QuerySnapshot> incomingMessages = Rxn<QuerySnapshot>();
  Rxn<QuerySnapshot> outgoingMessages = Rxn<QuerySnapshot>();

  sendMessage(MessageModal messageModal, String publicKey) async {
    if (messageModal.message.isEmpty) return;
    var ogmsg = messageModal.message;
    messageModal.message = encrypter.encrypt(
      messageModal.message,
      helper.parsePublicKeyFromPem(publicKey),
    );
    print(publicKey);
    var ts = Timestamp.now();
    messageModal.time = ts.millisecondsSinceEpoch;
    messageModal.sender = firebaseUser.value.uid;
    await firestore
        .collection(USERSENDPOINT)
        .doc(messageModal.receiver)
        .collection('chat')
        .doc(firebaseUser.value.uid)
        .collection(MESSAGEENDPOINT)
        .doc(ts.millisecondsSinceEpoch.toString())
        .set(
          messageModal.toMap(),
        )
        .then((value) => messageController.clear());
    messageModal.message = ogmsg;
    messageBox.add(messageModal);
  }

  handleChatUserChanges(String uid) {}

  handleOutgoingMessages(QuerySnapshot snapshot) async {
    for (var item in snapshot.docChanges) {
      var messageModal = MessageModal.fromMap(item.doc.data());
      var messageList = messageBox.values.toList();
      switch (item.type) {
        case DocumentChangeType.added:
          var index = messageList
              .indexWhere((element) => element.time == messageModal.time);
          if (index != -1) {
            var ogmsg = messageBox.getAt(index);
            messageModal.message = ogmsg.message;
            messageBox.putAt(index, messageModal);
          }
          if (messageModal.read) {
            var doc = firestore
                .collection(USERSENDPOINT)
                .doc(uid.value)
                .collection('chat')
                .doc(firebaseUser.value.uid)
                .collection(MESSAGEENDPOINT)
                .doc(messageModal.time.toString());
            if (await doc.get().then((value) => value.exists)) {
              doc.delete();
            }
          }
          break;
        case DocumentChangeType.modified:
          var index = messageList
              .indexWhere((element) => element.time == messageModal.time);
          if (index != -1) {
            var ogmsg = messageBox.getAt(index);
            messageModal.message = ogmsg.message;
            messageBox.putAt(index, messageModal);
          }
          if (messageModal.read) {
            var doc = firestore
                .collection(USERSENDPOINT)
                .doc(uid.value)
                .collection('chat')
                .doc(firebaseUser.value.uid)
                .collection(MESSAGEENDPOINT)
                .doc(messageModal.time.toString());
            if (await doc.get().then((value) => value.exists)) {
              doc.delete();
            }
          }
          break;
        default:
      }
    }
  }

  handleMessageChanges(QuerySnapshot snapshot) async {
    for (var item in snapshot.docChanges) {
      var messageModal = MessageModal.fromMap(item.doc.data());
      messageModal.message = encrypter.decrypt(
        messageModal.message,
        privateKey,
      );

      var messageList = messageBox.values.toList();
      switch (item.type) {
        case DocumentChangeType.added:
          var index = messageList
              .indexWhere((element) => element.time == messageModal.time);
          if (index == -1) {
            messageBox.add(messageModal);
          } else {
            messageBox.putAt(index, messageModal);
          }
          var doc = firestore
              .collection(USERSENDPOINT)
              .doc(firebaseUser.value.uid)
              .collection('chat')
              .doc(uid.value)
              .collection(MESSAGEENDPOINT)
              .doc(messageModal.time.toString());
          if (await doc.get().then((value) => value.exists)) {
            doc.update(
              {
                MessageModal.READ: true,
              },
            );
          }

          break;
        case DocumentChangeType.modified:
          var index = messageList
              .indexWhere((element) => element.time == messageModal.time);
          if (index == -1) {
            messageBox.add(messageModal);
          } else {
            messageBox.putAt(index, messageModal);
          }
          // var doc = firestore
          //     .collection(USERSENDPOINT)
          //     .doc(firebaseUser.value.uid)
          //     .collection('chat')
          //     .doc(uid.value)
          //     .collection(MESSAGEENDPOINT)
          //     .doc(messageModal.time.toString());
          // if (await doc.get().then((value) => value.exists)) {
          //   doc.update(
          //     {
          //       MessageModal.READ: true,
          //     },
          //   );
          // }
          break;
        default:
      }
    }
  }

  handleAuthChanged(_firebaseUser) async {
    if (_firebaseUser?.uid != null) {
      messageBox = await Hive.openBox('${_firebaseUser?.uid}message');
      incomingMessages.bindStream(streamIncomingMessages());
      outgoingMessages.bindStream(streamOutgoingMessages());
    }
  }

  @override
  Future<void> onInit() async {
    privateKey = localStorage.read('privateKey');
    ever(firebaseUser, handleAuthChanged);
    ever(uid, handleChatUserChanges);
    ever(incomingMessages, handleMessageChanges);
    ever(outgoingMessages, handleOutgoingMessages);
    firebaseUser.bindStream(auth.userChanges());
    privateKey = helper.parsePrivateKeyFromPem(localStorage.read('privateKey'));
    super.onInit();
  }

  Stream<QuerySnapshot> streamIncomingMessages() {
    return firestore
        .collection(USERSENDPOINT)
        .doc(firebaseUser.value.uid)
        .collection('chat')
        .doc(uid.value)
        .collection(MESSAGEENDPOINT)
        .snapshots();
  }

  Stream<QuerySnapshot> streamOutgoingMessages() {
    return firestore
        .collection(USERSENDPOINT)
        .doc(uid.value)
        .collection('chat')
        .doc(firebaseUser.value.uid)
        .collection(MESSAGEENDPOINT)
        .snapshots();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
