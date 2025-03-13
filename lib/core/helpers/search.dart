import 'package:koul_network/model/contact.dart';

List<UserContact> searchContacts(
    List<UserContact> contacts, String searchKeywords) {
  List<UserContact> contactsList = contacts;
  if (searchKeywords.isEmpty) {
    return contactsList;
  } else {
    List<UserContact> filterContacts = contactsList
        .where(
          (cont) =>
              cont.displayName.toLowerCase().contains(searchKeywords) ||
              cont.phone.toLowerCase().contains(searchKeywords),
        )
        .toList();
    return filterContacts;
  }
}
