import 'package:hive/hive.dart';
part 'contact.g.dart';

@HiveType(typeId: 0)
class ContactsModal {
  @HiveField(0)
  String number;
  @HiveField(1)
  String photo;
  @HiveField(2)
  String uid;
  @HiveField(3)
  String username;
  @HiveField(4)
  String contactName;
  @HiveField(5)
  String publicKey;

  ContactsModal({
    this.number,
    this.photo,
    this.uid,
    this.username,
    this.contactName,
    this.publicKey,
  });

  ContactsModal.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    photo = json['photo'];
    uid = json['uid'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['photo'] = this.photo;
    data['uid'] = this.uid;
    data['username'] = this.username;
    return data;
  }
}
