import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:koul_network/helpers/get_contacts.dart';
import 'package:koul_network/helpers/helper_functions/contacts/cache_contacts.dart';
import 'package:koul_network/helpers/helper_functions/sim_info.dart';
import 'package:koul_network/helpers/helper_functions/trim_phno.dart';
import 'package:koul_network/model/contact.dart';
import 'package:koul_network/model/koul_account/account_balance.dart';
import 'package:koul_network/model/koul_account/koulid.dart';
import 'package:koul_network/model/koul_account/transaction.dart';
import 'package:koul_network/secrets/api.dart';
import 'package:koul_network/singleton/currentuser.dart';
import 'package:simnumber/siminfo.dart';
part 'koul_account_event.dart';
part 'koul_account_state.dart';

class KoulAccountBloc extends Bloc<KoulAccountEvent, KoulAccountState> {
  //koul account

  // final url = "http://10.0.2.2:8000";

  final url = KOUL_SERVICE_API_URL;

  KoulAccountBloc() : super(KoulAccountInitial()) {
    on<SetStateToInitial>(_setStateToKoulAccountInitial);
    on<AccountBalanceEvent>(_getAccountBalance);
    on<KoulAccountExistEvent>(_koulAccountExist);
    on<PayToKoulIdEvent>(_payToKoulId);
    on<GetTransactionListEvent>(_getTransactionList);
    on<UpdateTrackerEvent>(_updateTracker);
    on<CreateTransactionPinEvent>(_createtransactionPin);
    on<PayToPhoneNoEvent>(_payToPhoneNo);
    on<GetAllTransactionsListEvent>(_getAlltransactions);
    on<GetContactsEvent>(_getContacts);
    on<GetCachedContactsEvent>(_loadCachedContacts);
    on<AIGenratedReportEvent>(_aiGenratedReport);
  }

  void _setStateToKoulAccountInitial(
      SetStateToInitial event, Emitter<KoulAccountState> emit) {
    emit(KoulAccountInitial());
  }

  Future<void> _getAccountBalance(
      AccountBalanceEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    try {
      final accountBalanceRoute = Uri.parse("$url/account_balance");
      print("USER ID ${currentUser.id}");
      print("TOKEN BALACNE ${currentUser.authToken}}");
      final response = await http.post(
        accountBalanceRoute,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": currentUser.authToken,
        },
        body: json.encode(
          {
            "userid": currentUser.id,
          },
        ),
      );
      print("RESPONE ${response.body.toString()}");
      if (response.statusCode == HttpStatus.accepted) {
        final AccountBalance kAccount =
            AccountBalance.fromJson(jsonDecode(response.body));
        emit(AccountBalanceState(accountBalance: kAccount));
      } else {
        emit(FailureState("unable to fetching account balance"));
      }
      print("kAccount.accountHolderName");
    } catch (error) {
      print(error.toString());
      emit(FailureState("unable to fetching account balance"));
    }
  }

  Future<void> _koulAccountExist(
      KoulAccountExistEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    if (event.toKoulId == currentUser.id) {
      emit(FailureState("Can't pay to your own account"));
      return;
    }
    try {
      final payToKoulIdRoute = Uri.parse("$url/koulid_exist");
      final respone = await http.post(
        payToKoulIdRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id,
            "koulid": event.toKoulId,
          },
        ),
      );
      if (respone.statusCode == HttpStatus.ok) {
        final koulAccountData = ToKoulId.fromJson(jsonDecode(respone.body));
        emit(KoulIdSuccessState(TokoulAccountInfo: koulAccountData));
      } else {
        emit(FailureState(respone.body.toString()));
        return;
      }
    } catch (e) {
      print(e.toString());
      emit(FailureState(e.toString()));
    }
  }

  Future<void> _payToKoulId(
      PayToKoulIdEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(PayToKoulIdLoadingState());

    try {
      final List<SimCard> simCardNumber = await getSimCardsData(event.contex);
      final List<String> Phones =
          simCardNumber.map((e) => trimPhone(e.phoneNumber ??= "")).toList();
      print("SIM CARD DATA ${Phones}");
      final getPhone = Phones.firstWhere((pno) => pno == currentUser.phone);
      if (getPhone.isEmpty) {
        emit(FailureState("Invalid Phone number"));
        return;
      }
      final payToKoulIdRoute = Uri.parse("$url/pay_to_koul_id");
      final response = await http.post(
        payToKoulIdRoute,
        headers: {
          'Content-Type': 'application/json',
          "Authorization": currentUser.authToken,
        },
        body: json.encode(
          {
            "current_koul_id": currentUser.id,
            "account_holder_phone": getPhone,
            "transaction_pin": event.transactionPin,
            "amount": event.amount,
            "to": {
              "name": event.toName,
              "koul_id": event.toKoulId,
            },
            "from": {
              "name": currentUser.name,
              "koul_id": currentUser.id,
            }
          },
        ),
      );

      print(response.body.toString());

      if (response.statusCode == HttpStatus.ok) {
        final transactionDoneData =
            Transaction.fromJson(jsonDecode(response.body));

        emit(TranactionSuccessfullState(
            transactionDoneData: transactionDoneData));
      } else if (response.statusCode == HttpStatus.expectationFailed) {
        if (response.body.toString() == "incorrect pin") {
          emit(IncorrectTransactionPinState());
        } else {
          emit(FailureState(response.body.toString()));
        }
      }
    } catch (e) {
      print("Error :$e.toString()");
      emit(FailureState("An unknown error occurred"));
    }
  }

  Future<void> _getTransactionList(
      GetTransactionListEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    try {
      final transactionlistRoute = Uri.parse("$url/transaction_list");
      final response = await http.post(
        transactionlistRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id, //koul id
            "koulid": event.koulId, //koul id
          },
        ),
      );
      print("Transaction LIST${response.body.toString()}");
      if (response.statusCode == HttpStatus.ok) {
        final List<dynamic> transactionData = json.decode(response.body);
        final List<Transaction> transactions =
            transactionData.map((t) => Transaction.fromJson(t)).toList();
        emit(
          AccountTransactionListState(transactionList: transactions),
        );
      }
    } catch (e) {
      emit(FailureState("error occurred ${e.toString()}"));
    }
  }

  Future<void> _updateTracker(
      UpdateTrackerEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();

    emit(LoadingState());
    try {
      final trackerUrl = Uri.parse("$url/updatetrackers");
      final response = await http.post(
        trackerUrl,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "koul_id": currentUser.id,
            "low_balance_alert_is": event.lowBalanceAlertIs,
            "low_balance_amount": event.lowBalanceAmount,
            "large_expense_alert_is": event.largeExpenseAlertIs,
            "large_expense_amount": event.largeExpenseAmount,
          },
        ),
      );
      if (response.statusCode == HttpStatus.accepted) {
        add(AccountBalanceEvent());
        emit(UpdateTrackerState());
      } else {
        emit(FailureState("unable to upadate"));
      }
    } catch (_) {
      emit(FailureState("unable to upadate"));
    }
  }

  ///
  /////
  ///
  Future<void> _createtransactionPin(
      CreateTransactionPinEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());

    try {
      final List<SimCard> simCardNumber = await getSimCardsData(event.context);
      final List<String> Phones =
          simCardNumber.map((e) => trimPhone(e.phoneNumber ??= "")).toList();
      final getPhone = Phones.firstWhere((pno) => pno == currentUser.phone);
      if (getPhone.isEmpty) {
        emit(FailureState("Invalid Phone number"));
        return;
      }
      final createPinRoute = Uri.parse("$url/createtransactionpin");
      final reponse = await http.post(
        createPinRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "account_holder_phone": getPhone,
            "current_koul_id": currentUser.id,
            "transaction_pin": event.transactionPin,
          },
        ),
      );

      if (reponse.statusCode == HttpStatus.accepted) {
        await Future.delayed(const Duration(milliseconds: 6000));
        if (!emit.isDone) {
          emit(TransactionPinUpdatedState());
        }
      } else if (reponse.body.toString() == "invalid phone number") {
        emit(FailureState("Invalid Phone number"));
      } else {
        emit(FailureState("unable to create Koul pin"));
      }
    } catch (e) {
      emit(FailureState("unable to create Koul pin"));
    }
  }

  Future<void> _payToPhoneNo(
      PayToPhoneNoEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    try {
      final payToPhoneNoRoute = Uri.parse("$url/paytophone");
      final response = await http.post(
        payToPhoneNoRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id, //koul id
            "phone": event.phoneNo.trim(),
          },
        ),
      );
      if (response.statusCode == HttpStatus.accepted) {
        add(KoulAccountExistEvent(toKoulId: response.body.toString()));
      } else {
        emit(FailureState(response.body.toString()));
      }
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  //Get all transaction list
  Future<void> _getAlltransactions(
      GetAllTransactionsListEvent event, Emitter<KoulAccountState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    try {
      final getAllTransactionsRoute = Uri.parse("$url/gettransactionlist");
      final resposne = await http.post(
        getAllTransactionsRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id,
          },
        ),
      );
      if (resposne.statusCode == HttpStatus.accepted) {
        List<dynamic> rawTransactionsData = json.decode(resposne.body);
        final List<Transaction> transactions =
            rawTransactionsData.map((t) => Transaction.fromJson(t)).toList();
        emit(AllTransactionsListState(transactions: transactions));
      } else {
        emit(FailureState(resposne.body.toString()));
      }
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }

  Future<void> _getContacts(
      GetContactsEvent event, Emitter<KoulAccountState> emit) async {
    final currentUserPhone =
        CurrentUserSingleton.getCurrentUserInstance().phone;

    emit(LoadingState());
    try {
      final getContactsRoute = Uri.parse("$url/getcontacts");

      final userContacts = await getUserContacts();

      if (userContacts.isEmpty) {
        emit(FailureState("Permission denied"));
      } else if (userContacts.first.displayName == "empty" &&
          userContacts.first.phone == "empty") {
        emit(FailureState("No contacts Found"));
      } else if (userContacts.first.displayName == "error" &&
          userContacts.first.phone == "error") {
        emit(FailureState("Error fetching contacts"));
      } else {
        final contactsJson = await Isolate.run(() {
          final x = userContacts.map((contact) => contact.toJson()).toList();
          return x;
        });
        // final contactsJson =
        //     userContacts.map((contact) => contact.toJson()).toList();

        final response =
            await http.post(getContactsRoute, body: json.encode(contactsJson));
        print("CONTACT RESPONSE ${response.body.toString()}");

        if (response.statusCode == HttpStatus.ok) {
          List<dynamic> rawContacts = json.decode(response.body);
          // List<UserContact> contacts = rawContacts
          //     .map((rawContacts) => UserContact.fromJson(rawContacts))
          //     .toList();
          List<UserContact> contacts = rawContacts
              .map((rawContact) => UserContact.fromJson(rawContact))
              .where((contact) => contact.phone != currentUserPhone)
              .toList();
          await cacheContactsToHive(contacts);
          emit(AllContactsListState(contacts: contacts));
        }
      }
    } catch (e) {
      print("Error fetching contacts koul $e");
      emit(FailureState("Error fetching contacts"));
    }
  }

  void _loadCachedContacts(
      GetCachedContactsEvent event, Emitter<KoulAccountState> emit) {
    emit(LoadingState());
    emit(AllContactsListState(contacts: event.contacts));
  }

  Future<void> _aiGenratedReport(
      AIGenratedReportEvent event, Emitter<KoulAccountState> emit) async {
    emit(LoadingState());
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    List<dynamic> rawTransactionsData = [];
    try {
      final getAllTransactionsRoute = Uri.parse("$url/gettransactionlist");
      final resposne = await http.post(
        getAllTransactionsRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id,
          },
        ),
      );
      if (resposne.statusCode == HttpStatus.accepted) {
        rawTransactionsData = json.decode(resposne.body);
        final model =
            GenerativeModel(model: 'gemini-1.5-flash', apiKey: GEMINI_API_KEY);
        final content = [
          Content.text(
              "This is the transactions data $rawTransactionsData and use this template and put all the names first letter captial. Finance Report: [Start Date] to [End Date] This report provides a detailed summary of the financial transactions for the period from [Start Date] to [End Date], covering the last month. During this period, a total of ₹[Total Credit Amount] was credited to [Account Holder Name's] account. The primary sources of these credits include significant contributions from [Source 1] and [Source 2], reflecting regular income, transfers, or other credits that bolstered the account balance throughout the month. [Account Holder Name] made total debit transactions amounting to ₹[Total Debit Amount] during the same period. The majority of these debits were directed towards [Recipient 1], followed by smaller amounts sent to [Recipient 2], covering various categories such as utilities, purchases, transfers, or other expenses. Notable transactions during this period include a substantial debit of ₹[Large Debit Amount] on [MMM-DD] from [Account Holder Name's] account to [Recipient Name's] account, multiple debit transactions totaling ₹[Total Amount] on [MMM-DD] to a newly established account with the Koul ID [Koul ID], and a series of smaller debit transactions between [MMM-DD to MMM-DD], amounting to ₹[Total Amount], directed to [Recipient Name's] account. The financial activity during this period shows a balanced pattern of credits and debits, reflecting [Account Holder Name's] financial management strategies. The credits were primarily driven by consistent income or transfers from key sources, ensuring a healthy cash flow, while the debits, although significant, were largely controlled and directed towards essential or planned expenses. Given the current financial trajectory, it is advisable to continue monitoring large debit transactions to ensure they align with long-term financial goals. Additionally, the establishment of new accounts and recurring payments suggests a diversification of financial activities, which can be beneficial if managed effectively. Regular reviews of these transactions will help maintain financial stability and support future planning in bonus give a finance tip for the future.. NOTE: The Amount data ypu show in the report should be correct.")
        ];
        final geminiresponse = await model.generateContent(content);
        print(geminiresponse.text!);
        emit(AIReportState(report: geminiresponse.text!));
      } else {
        emit(FailureState(resposne.body.toString()));
      }
    } catch (e) {
      emit(FailureState(e.toString()));
    }
  }
}
