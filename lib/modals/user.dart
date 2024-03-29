import 'package:kyahaal/utility/utility.dart';

class UserModal {
  dynamic imgUrl;
  dynamic status;
  dynamic uName;
  bool initialSetupDone;
  String token;
  String publicKey;

  UserModal({
    this.imgUrl,
    this.initialSetupDone,
    this.status,
    this.uName,
    this.token,
    this.publicKey,
  });
  UserModal.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      token = json['tokenId'];
      imgUrl = json['imgUrl'];
      status = json['status'];
      uName = json['uName'];
      initialSetupDone = json['initialSetupDone'];
      publicKey = json['publicKey'];
    } else {
      imgUrl = '';
      status = statusList[0];
      uName = '';
      initialSetupDone = false;
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = Map<String, dynamic>();
    data['imgUrl'] = imgUrl;
    data['status'] = status;
    data['uName'] = uName;
    data['tokenId'] = token;
    data['initialSetupDone'] = initialSetupDone;
    data['publicKey'] = publicKey;
    return data;
  }
}
