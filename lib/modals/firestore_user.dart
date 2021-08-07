import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreUser {
  final String phone;
  final String displayName;
  final String photoURL;
  final String status;
  final DocumentSnapshot? snapshot;
  final DocumentReference? reference;
  final String? documentID;

  FirestoreUser({
    required this.phone,
    required this.displayName,
    required this.photoURL,
    required this.status,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory FirestoreUser.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data();

    return FirestoreUser(
      phone: (map?['phone'] ?? '') as String,
      displayName: (map?['displayName'] ?? '') as String,
      photoURL: (map?['photoURL'] ?? '') as String,
      status: (map?['status'] ?? '') as String,
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory FirestoreUser.fromMap(Map<String, dynamic> map) {
    return FirestoreUser(
      phone: map['phone'] as String,
      displayName: map['displayName'] as String,
      photoURL: map['photoURL'] as String,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() => {
        'phone': phone,
        'displayName': displayName,
        'photoURL': photoURL,
        'status': status,
      };

  FirestoreUser copyWith({
    String? phone,
    String? displayName,
    String? photoURL,
    String? status,
  }) {
    return FirestoreUser(
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return '${phone.toString()}, ${displayName.toString()}, ${photoURL.toString()}, ${status.toString()}, ';
  }

  @override
  bool operator ==(Object other) =>
      other is FirestoreUser &&
      phone == other.phone &&
      status == other.status &&
      displayName == other.displayName &&
      photoURL == other.photoURL;

  @override
  int get hashCode => documentID.hashCode;
}
