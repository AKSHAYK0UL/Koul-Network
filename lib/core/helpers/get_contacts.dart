import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:koul_network/model/contact.dart';

String formatPhoneNumber(String phoneNumber) {
  // Remove all non-digit characters
  final digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

  // Extract the last 10 digits
  final last10Digits = digitsOnly.length > 10
      ? digitsOnly.substring(digitsOnly.length - 10)
      : digitsOnly;

  return last10Digits;
}

Future<List<UserContact>> getUserContacts() async {
  try {
    final bool permissionGranted =
        await FlutterContacts.requestPermission(readonly: true);

    if (!permissionGranted) {
      print('Permission denied');
      return [];
    }

    final List<Contact> contacts = await FlutterContacts.getContacts(
        withProperties: true,
        sorted: true,
        deduplicateProperties: false,
        withAccounts: true);

    if (contacts.isEmpty) {
      print('No contacts found');
      return [UserContact(displayName: "empty", phone: "empty")];
    }

    FlutterContacts.config.returnUnifiedContacts = false;

    final userContactslist = contacts
        .where((contact) => contact.phones.isNotEmpty)
        .map((contact) => UserContact(
              displayName: contact.displayName,
              phone: formatPhoneNumber(contact.phones.first.number),
            ))
        .toList();

    return userContactslist;
  } catch (e) {
    print('Error fetching contacts: $e');
    return [UserContact(displayName: "error", phone: "error")];
  }
}
