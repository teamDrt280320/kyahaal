class UserModal {
  dynamic imgUrl;
  dynamic status;
  dynamic uName;
  bool initialSetupDone;

  UserModal();
  UserModal.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      imgUrl = json['imgUrl'];
      status = json['status'];
      uName = json['uName'];
      initialSetupDone = json['initialSetupDone'];
    } else {
      imgUrl = '';
      status = '';
      uName = '';
      initialSetupDone = false;
    }
  }
}
