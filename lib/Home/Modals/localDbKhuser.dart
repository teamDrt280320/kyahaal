class LocalKhUser {
  String number;
  String dpurl;
  String uid;
  String khname;
  String devicename;

  LocalKhUser(
      {this.number, this.dpurl, this.uid, this.khname, this.devicename});

  LocalKhUser.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    dpurl = json['dpurl'];
    uid = json['uid'];
    khname = json['khname'];
    devicename = json['devicename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['dpurl'] = this.dpurl;
    data['uid'] = this.uid;
    data['khname'] = this.khname;
    data['devicename'] = this.devicename;
    return data;
  }
}
