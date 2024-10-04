part of 'koul_account_bloc.dart';

sealed class KoulAccountEvent {}

final class SetStateToInitial extends KoulAccountEvent {}

final class AccountBalanceEvent extends KoulAccountEvent {}

final class KoulAccountExistEvent extends KoulAccountEvent {
  final String toKoulId;

  KoulAccountExistEvent({required this.toKoulId});
}

final class PayToKoulIdEvent extends KoulAccountEvent {
  final BuildContext contex;
  final String toKoulId;
  final double amount;
  final String toName;
  final String transactionPin;

  PayToKoulIdEvent(
      {required this.contex,
      required this.toKoulId,
      required this.amount,
      required this.toName,
      required this.transactionPin});
}

final class GetTransactionListEvent extends KoulAccountEvent {
  final String koulId;

  GetTransactionListEvent({required this.koulId});
}

final class UpdateTrackerEvent extends KoulAccountEvent {
  final bool largeExpenseAlertIs;
  final double largeExpenseAmount;
  final bool lowBalanceAlertIs;
  final double lowBalanceAmount;

  UpdateTrackerEvent(
      {required this.largeExpenseAlertIs,
      required this.largeExpenseAmount,
      required this.lowBalanceAlertIs,
      required this.lowBalanceAmount});
}

final class CreateTransactionPinEvent extends KoulAccountEvent {
  final BuildContext context;
  final String transactionPin;

  CreateTransactionPinEvent(
      {required this.context, required this.transactionPin});
}

final class PayToPhoneNoEvent extends KoulAccountEvent {
  final String phoneNo;

  PayToPhoneNoEvent({required this.phoneNo});
}

final class GetAllTransactionsListEvent extends KoulAccountEvent {}

final class GetContactsEvent extends KoulAccountEvent {}

final class GetCachedContactsEvent extends KoulAccountEvent {
  List<UserContact> contacts = [];
  GetCachedContactsEvent({required this.contacts});
}

final class ClearContactsEvent extends KoulAccountEvent {}

final class AIGenratedReportEvent extends KoulAccountEvent {}
