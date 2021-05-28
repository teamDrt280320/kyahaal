import 'package:hive/hive.dart';
part 'message.g.dart';

@HiveType(typeId: 1)
class MessageModal {
  static const String MESSAGE = 'message';
  static const String TYPE = 'type';
  static const String TS = 'time';
  static const String READ = 'read';
  static const String SENDER = 'sender';
  static const String RECEIVER = 'receiver';

  static const String SENT = 'sent';
  static const String DEIVERED = 'delivered';

  @HiveField(0)
  String message;
  @HiveField(1)
  String type;
  @HiveField(2)
  String sender;
  @HiveField(3)
  String receiver;
  @HiveField(4)
  int time;
  @HiveField(5)
  bool read;
  @HiveField(6)
  bool sent;
  @HiveField(7)
  bool delivered;

  MessageModal({
    this.message,
    this.read,
    this.receiver,
    this.sender,
    this.time,
    this.type,
    this.delivered,
    this.sent,
  });

  MessageModal.fromMap(Map<String, dynamic> json) {
    message = json[MESSAGE];
    type = json[TYPE];
    time = json[TS];
    read = json[READ];
    sender = json[SENDER];
    receiver = json[RECEIVER];
    sent = json[SENT];
    delivered = json[DEIVERED];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map[MESSAGE] = this.message;
    map[TYPE] = this.type;
    map[READ] = this.read;
    map[SENDER] = this.sender;
    map[RECEIVER] = this.receiver;
    map[TS] = this.time;
    map[DEIVERED] = this.delivered;
    map[SENT] = this.sent;
    return map;
  }
}
