part of 'stripe_bloc.dart';

sealed class StripeEvent {}

final class AddFundEvent extends StripeEvent {
  final int amount;
  AddFundEvent({required this.amount});
}

final class PaymentSheetEvent extends StripeEvent {
  final String clientId;

  PaymentSheetEvent({required this.clientId});
}

final class ProcessPaymentStateEvent extends StripeEvent {}
