class Messages {
  String pushId;
  String message;
  String sentBy;
  String sentTo;
  dynamic timeStamp;
  dynamic read;

  Messages({
    this.pushId,
    this.message,
    this.sentBy,
    this.sentTo,
    this.timeStamp,
    this.read,
  });

  Messages.fromJson(Map<String, dynamic> json) {
    pushId = json['pushId'];
    message = json['message'];
    sentBy = json['sentBy'];
    sentTo = json['sentTo'];
    timeStamp = json['timeStamp'];
    read = json['read'];
  }

  ///Returns Messages as json to be added to the local database or upload to the firebase

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pushId'] = this.pushId;
    data['message'] = this.message;
    data['sentBy'] = this.sentBy;
    data['sentTo'] = this.sentTo;
    data['timeStamp'] = this.timeStamp;
    data['read'] = this.read;
    return data;
  }
}
