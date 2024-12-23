import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import "package:http/http.dart" as http;
import 'package:koul_network/secrets/api.dart';
import 'package:koul_network/singleton/currentuser.dart';

part 'stripe_event.dart';
part 'stripe_state.dart';

class StripeBloc extends Bloc<StripeEvent, StripeState> {
  // final url = "http://10.0.2.2:8000";
  final url = KOUL_SERVICE_API_URL;

  StripeBloc() : super(StripeInitial()) {
    on<AddFundEvent>(_addFund);
    on<PaymentSheetEvent>(_paymentSheet);
    on<ProcessPaymentStateEvent>(_processPayment);
  }
  Future<void> _addFund(AddFundEvent event, Emitter<StripeState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    try {
      final getAllTransactionsRoute = Uri.parse("$url/create-payment-Intent");
      final resposne = await http.post(
        getAllTransactionsRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id,
            "amount": event.amount,
          },
        ),
      );
      if (resposne.statusCode == HttpStatus.ok) {
        emit(SuccessState(clientId: resposne.body));
      } else {
        emit(ErrorState(errorMessage: resposne.body));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _paymentSheet(
      PaymentSheetEvent event, Emitter<StripeState> emit) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: event.clientId,
          merchantDisplayName: "Koul Network",
        ),
      );
      add(ProcessPaymentStateEvent());
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _processPayment(
      ProcessPaymentStateEvent event, Emitter<StripeState> emit) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }
}
