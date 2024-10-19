import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/previous_transactions_screen.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/widgets/textfield.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/enums/route_path.dart';
import 'package:koul_network/enums/show_phone.dart';
import 'package:koul_network/helpers/search.dart';
import 'package:koul_network/model/contact.dart';

class ContactsList extends StatefulWidget {
  static const routeName = "ContactsList";
  const ContactsList({super.key});

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  List<UserContact> _filteredContacts = [];
  List<UserContact> _allContacts = [];

  void loadContactsFromHive() {
    final contactsBox = Hive.box<UserContact>('contacts');
    final List<UserContact> cachedContacts = contactsBox.values.toList();

    if (cachedContacts.isNotEmpty) {
      context
          .read<KoulAccountBloc>()
          .add(GetCachedContactsEvent(contacts: cachedContacts));
    } else {
      context.read<KoulAccountBloc>().add(GetContactsEvent());
    }
  }

  @override
  void initState() {
    super.initState();
    loadContactsFromHive();
  }

  void updateContacts(List<UserContact> contacts, String searchKeywords) {
    setState(() {
      _filteredContacts = searchContacts(contacts, searchKeywords);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Text(
          "Pay to Contacts",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<KoulAccountBloc>().add(GetContactsEvent());
        },
        color: Colors.white,
        child: BlocConsumer<KoulAccountBloc, KoulAccountState>(
          listener: (context, state) {
            debugPrint("PAY TO CONTACTS STATE : $state");

            if (state is KoulIdSuccessState) {
              Navigator.of(context).pushNamed(
                PreviousTransactionsScreen.routeName,
                arguments: {
                  "showphone": ShowPhone.phoneVisible,
                  "route": RoutePath.payToContact,
                },
              );
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (state is FailureState) {
              return Center(
                child: Text(state.error),
              );
            }
            if (state is AllContactsListState) {
              if (_allContacts.isEmpty) {
                _allContacts = state.contacts;
                _filteredContacts = _allContacts;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KoulTextField(
                    autoFocus: false,
                    onTextChanged: (searchKeywords) {
                      updateContacts(_allContacts, searchKeywords);
                    },
                    labelText: "Enter Name or Phone no.",
                    keyBoardType: TextInputType.text,
                    prefixValue: "",
                    maxLength: 0,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenSize.height * 0.0265,
                        top: screenSize.height * 0.0133,
                        bottom: screenSize.height * 0.0200),
                    child: Text(
                      "All people on KOUL Network",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: _filteredContacts.isEmpty
                        ? Center(
                            child: Text(
                              "No Contact Found!",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _filteredContacts.length,
                            itemBuilder: (context, index) {
                              final contactInfo = _filteredContacts[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.height * 0.008,
                                    vertical: screenSize.height * 0.004),
                                child: ListTile(
                                  onTap: () {
                                    context.read<KoulAccountBloc>().add(
                                          PayToPhoneNoEvent(
                                            phoneNo: contactInfo.phone,
                                          ),
                                        );
                                    updateContacts(_allContacts, "");
                                  },
                                  minTileHeight: screenSize.height * 0.105,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  tileColor:
                                      const Color.fromARGB(255, 40, 39, 39),
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundColor:
                                        const Color.fromARGB(255, 22, 22, 22),
                                    child: Text(
                                      contactInfo.displayName[0].toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  title: Text(
                                    contactInfo.displayName.replaceFirst(
                                      contactInfo.displayName[0],
                                      contactInfo.displayName[0].toUpperCase(),
                                    ),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    contactInfo.phone,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                KoulTextField(
                  autoFocus: false,
                  onTextChanged: (searchKeywords) {
                    updateContacts(_allContacts, searchKeywords);
                  },
                  labelText: "Enter Name or Phone no.",
                  keyBoardType: TextInputType.text,
                  prefixValue: "",
                  maxLength: 0,
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: screenSize.height * 0.0265,
                      top: screenSize.height * 0.0133,
                      bottom: screenSize.height * 0.0200),
                  child: Text(
                    "All people on KOUL Network",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                Expanded(
                  child: _filteredContacts.isEmpty
                      ? Center(
                          child: Text(
                            "No Contact Found!",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredContacts.length,
                          itemBuilder: (context, index) {
                            final contactInfo = _filteredContacts[index];
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenSize.height * 0.008,
                                  vertical: screenSize.height * 0.004),
                              child: ListTile(
                                onTap: () {
                                  context.read<KoulAccountBloc>().add(
                                        PayToPhoneNoEvent(
                                          phoneNo: contactInfo.phone,
                                        ),
                                      );
                                  updateContacts(_allContacts, "");
                                },
                                minTileHeight: screenSize.height * 0.105,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                tileColor:
                                    const Color.fromARGB(255, 40, 39, 39),
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundColor:
                                      const Color.fromARGB(255, 22, 22, 22),
                                  child: Text(
                                    contactInfo.displayName[0].toUpperCase(),
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                title: Text(
                                  contactInfo.displayName.replaceFirst(
                                    contactInfo.displayName[0],
                                    contactInfo.displayName[0].toUpperCase(),
                                  ),
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                subtitle: Text(
                                  contactInfo.phone,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
            // return const SizedBox();
          },
        ),
      ),
    );
  }
}
