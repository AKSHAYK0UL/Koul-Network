part of 'stripe_bloc.dart';

sealed class StripeEvent {}

final class AddFundEvent extends StripeEvent {
  final int amount;
  AddFundEvent({required this.amount});
}

final class PaymentSheetEvent extends StripeEvent {
  final String toName;
  final String toKoulId;
  final String clientId;

  PaymentSheetEvent(
      {required this.clientId, required this.toName, required this.toKoulId});
}

final class ProcessPaymentStateEvent extends StripeEvent {}

final class PayeesDetailEvent extends StripeEvent {
  final String payeeKoulId;

  PayeesDetailEvent({required this.payeeKoulId});
}

final class GetFundsTXNList extends StripeEvent {}
