import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/pay_screen.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/widgets/previous_transaction.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/enums/route_path.dart';
import 'package:koul_network/enums/show_phone.dart';
import 'package:koul_network/helpers/helper_functions/currentuser_koulaccount/getcurrentuser_koulaccount.dart';
import 'package:koul_network/helpers/helper_functions/phone_formatter.dart';
import 'package:koul_network/helpers/utc_to_ist.dart';
import 'package:koul_network/model/contact.dart';
import 'package:koul_network/singleton/currentuser.dart';

class PreviousTransactionsScreen extends StatefulWidget {
  static const routeName = "PreviousTransactionsScreen";
  const PreviousTransactionsScreen({super.key});

  @override
  State<PreviousTransactionsScreen> createState() =>
      _PreviousTransactionsScreenState();
}

class _PreviousTransactionsScreenState
    extends State<PreviousTransactionsScreen> {
  KoulIdSuccessState? currentState;
  void loadData() {
    currentState = context.read<KoulAccountBloc>().state as KoulIdSuccessState;

    context.read<KoulAccountBloc>().add(GetTransactionListEvent(
        koulId: currentState!.TokoulAccountInfo.userId));
    final currentUserId = CurrentUserSingleton.getCurrentUserInstance().id;

    getCurrentuserKoulAccountDatail(currentUserId);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final routeData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final route = routeData["route"] as RoutePath;
    final phoneNoVisibility = routeData["showphone"] as ShowPhone;

    final payToInfo = currentState!.TokoulAccountInfo;

    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          titleSpacing: 0,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: const Color.fromARGB(135, 15, 14, 14),
              child: Text(
                payToInfo.userName.toString().toUpperCase()[0],
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            title: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                "${payToInfo.userName.toString().replaceFirst(payToInfo.userName[0], payToInfo.userName[0].toUpperCase())}    ",
                style: Theme.of(context).textTheme.titleMedium,
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
            subtitle: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                "${phoneNoVisibility == ShowPhone.phoneNotVisible ? formatPhoneNumber(payToInfo.phone) : payToInfo.phone}  ",
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.visible,
                maxLines: 1,
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<KoulAccountBloc, KoulAccountState>(
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
                if (state is AccountTransactionListState) {
                  return state.transactionList.isEmpty
                      ? const Center(
                          child: Text("No transaction done yet"),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                            reverse: true,
                            child: Column(
                              children: [
                                if (state.transactionList.isNotEmpty)
                                  Chip(
                                    backgroundColor: Colors.grey.shade800,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    label: Text(
                                      utcToIst(
                                        state.transactionList[0].date
                                            .toString(),
                                      ),
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: state.transactionList.length,
                                  itemBuilder: (context, index) {
                                    final data = state.transactionList[index];
                                    final previousDate = state
                                        .transactionList[
                                            index > 0 ? index - 1 : index - 0]
                                        .date;
                                    return buildPreviousTranactionCard(
                                      phoneVisibility: phoneNoVisibility,
                                      context: context,
                                      transactionData: data,
                                      previousTransactionDate: previousDate,
                                      phone: payToInfo.phone,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
        persistentFooterAlignment: AlignmentDirectional.centerEnd,
        persistentFooterButtons: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.height * 0.004,
            ),
            child: SizedBox(
              width: double.infinity,
              height: screenSize.height * 0.071,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    PayScreen.routeName,
                    arguments: {
                      "tokoulid": currentState!.TokoulAccountInfo.userId,
                      "toname": currentState!.TokoulAccountInfo.userName,
                      "phone": payToInfo.phone,
                      "phonevisibility": phoneNoVisibility,
                    },
                  );
                },
                icon: const Icon(Icons.payment),
                label: const Text("pay"),
              ),
            ),
          ),
        ],
      ),
      onPopInvoked: (didPop) {
        if (route == RoutePath.payKoulId ||
            route == RoutePath.payToPhone ||
            route == RoutePath.payToQRCode) {
          context.read<KoulAccountBloc>().add(SetStateToInitial());
        } else {
          final contactsBox = Hive.box<UserContact>('contacts');
          final cachedContacts = contactsBox.values.toList();
          if (cachedContacts.isNotEmpty) {
            context
                .read<KoulAccountBloc>()
                .add(GetCachedContactsEvent(contacts: cachedContacts));
          } else {
            context.read<KoulAccountBloc>().add(GetContactsEvent());
          }
        }
        // context.read<KoulAccountBloc>().add(SetStateToInitial());
        // context.read<KoulAccountBloc>().add(GetAllTransactionsListEvent());
      },
    );
  }
}
