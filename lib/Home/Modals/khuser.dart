class KHUser {
  String number;
  String photo;
  String uid;
  String username;

  KHUser({this.number, this.photo, this.uid, this.username});

  KHUser.fromJson(Map<String, dynamic> json) {
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
