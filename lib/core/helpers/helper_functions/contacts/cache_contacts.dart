import 'package:hive/hive.dart';
import 'package:koul_network/model/contact.dart';

Future<void> cacheContactsToHive(List<UserContact> contacts) async {
  final contactsBox = Hive.box<UserContact>("contacts");
  await contactsBox.clear(); // Clear previous data
  await contactsBox.addAll(contacts); // Save new data
}
