part of 'stripe_bloc.dart';

sealed class StripeState {}

final class StripeInitial extends StripeState {}

final class LoadingState extends StripeState {}

final class ErrorState extends StripeState {
  final String errorMessage;
  ErrorState({required this.errorMessage});
}

final class SuccessState extends StripeState {
  final String clientId;
  SuccessState({required this.clientId});
}

final class TransactionDoneState extends StripeState {
  final double amount;
  final String txnId;

  TransactionDoneState({required this.txnId, required this.amount});
}
