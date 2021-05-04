import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:kyahaal/modals/contact.dart';
import 'package:kyahaal/utility/utility.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsController extends GetxController {
  var firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Rxn<QuerySnapshot> firebaseUsers = Rxn<QuerySnapshot>();
  Rxn<User> firebaseUser = Rxn<User>();
  Box<ContactsModal> friendsBox;
  final fetching = false.obs;
  @override
  Future<void> onInit() async {
    friendsBox = await Hive.openBox<ContactsModal>('friends');
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    ever(firebaseUsers, handleUsersChanges);
    ever(firebaseUser, handleAuthChanged);
    firebaseUser.bindStream(_auth.userChanges());
    super.onReady();
  }

  handleAuthChanged(_firebaseUser) async {
    if (_firebaseUser?.uid != null) {
      firebaseUsers.bindStream(streamUsers());
    }
  }

  handleUsersChanges(QuerySnapshot snapshot) async {
    if (await Permission.contacts.request().isGranted) {
      fetching.value = true;
      var contacts = <ContactsModal>[];
      var response = await http.get(Uri.parse(CONTACTAPI), headers: headers);
      jsonDecode(response.body).forEach(
        (v) => contacts.add(
          new ContactsModal.fromJson(
            Map<String, dynamic>.from(v),
          ),
        ),
      );
      for (var item in snapshot.docChanges) {
        switch (item.type) {
          case DocumentChangeType.added:
            for (var item in contacts) {
              var contact =
                  (await ContactsService.getContactsForPhone(item.number))
                      .toList();
              if (contact != null && contact.length > 0) {
                var index = friendsBox.values.toList().indexWhere(
                      (element) => contact[0].phones.toList().any(
                            (element2) =>
                                element.number ==
                                element2.value
                                    .replaceAll(' ', '')
                                    .replaceAll('-', ''),
                          ),
                    );
                item.contactName = contact[0].displayName;
                if (index == -1) {
                  friendsBox.add(item);
                } else {
                  friendsBox.putAt(index, item);
                }
              }
            }
            break;
          case DocumentChangeType.modified:
            for (var item in contacts) {
              var contact =
                  (await ContactsService.getContactsForPhone(item.number))
                      .toList();
              if (contact != null && contact.length > 0) {
                var index = friendsBox.values.toList().indexWhere(
                      (element) => contact[0].phones.toList().any(
                            (element2) =>
                                element.number ==
                                element2.value
                                    .replaceAll(' ', '')
                                    .replaceAll('-', ''),
                          ),
                    );
                item.contactName = contact[0].displayName;
                if (index == -1) {
                  friendsBox.add(item);
                } else {
                  friendsBox.putAt(index, item);
                }
              }
            }
            break;
          default:
            for (var item in contacts) {
              var contact =
                  (await ContactsService.getContactsForPhone(item.number))
                      .toList();
              if (contact != null && contact.length > 0) {
                var index = friendsBox.values.toList().indexWhere(
                      (element) => contact[0].phones.toList().any(
                            (element2) =>
                                element.number ==
                                element2.value
                                    .replaceAll(' ', '')
                                    .replaceAll('-', ''),
                          ),
                    );
                if (index == -1) {
                } else {
                  friendsBox.deleteAt(index);
                }
              }
            }
            break;
        }
      }
      fetching.value = false;
    }
  }

  Stream<QuerySnapshot> streamUsers() {
    return firestore.collection('users').snapshots();
  }
}
