import 'package:hive/hive.dart';
part 'contact.g.dart';

@HiveType(typeId: 0)
class UserContact {
  @HiveField(0)
  String displayName;
  @HiveField(1)
  String phone;
  UserContact({
    required this.displayName,
    required this.phone,
  });
//json to Object
  factory UserContact.fromJson(Map<String, dynamic> json) {
    return UserContact(displayName: json['username']!, phone: json['phone']!);
  }

  // Convert UserContact to a map
  Map<String, dynamic> toJson() {
    return {
      'username': displayName,
      'phone': phone,
    };
  }
}
