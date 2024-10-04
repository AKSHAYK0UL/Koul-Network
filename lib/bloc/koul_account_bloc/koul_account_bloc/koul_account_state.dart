part of 'koul_account_bloc.dart';

sealed class KoulAccountState {}

final class KoulAccountInitial extends KoulAccountState {}

final class LoadingState extends KoulAccountState {}

final class PayToKoulIdLoadingState extends KoulAccountState {}

final class FailureState extends KoulAccountState {
  final String error;
  FailureState(this.error);
}

//when koul id is found this state will emitted
final class KoulIdSuccessState extends KoulAccountState {
  final ToKoulId TokoulAccountInfo;

  KoulIdSuccessState({required this.TokoulAccountInfo});
}

final class AccountBalanceState extends KoulAccountState {
  final AccountBalance accountBalance;

  AccountBalanceState({required this.accountBalance});
}

final class TranactionSuccessfullState extends KoulAccountState {
  final Transaction transactionDoneData;

  TranactionSuccessfullState({required this.transactionDoneData});
}

final class AccountTransactionListState extends KoulAccountState {
  List<Transaction> transactionList = [];
  AccountTransactionListState({required this.transactionList});
}

final class UpdateTrackerState extends KoulAccountState {}

final class TransactionPinUpdatedState extends KoulAccountState {}

final class IncorrectTransactionPinState extends KoulAccountState {}

final class InvalidPhoneNoState extends KoulAccountState {}

final class AllTransactionsListState extends KoulAccountState {
  List<Transaction> transactions = [];
  AllTransactionsListState({required this.transactions});
}

final class AllContactsListState extends KoulAccountState {
  List<UserContact> contacts = [];
  AllContactsListState({required this.contacts});
}

final class AIReportState extends KoulAccountState {
  final String report;

  AIReportState({required this.report});
}
