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
  }

  Future<void> _addFund(AddFundEvent event, Emitter<StripeState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    try {
      final paymentIntentRoute = Uri.parse("$url/create-payment-Intent");
      final response = await http.post(
        paymentIntentRoute,
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id,
            "amount": event.amount,
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok) {
        emit(SuccessState(clientId: response.body));
      } else {
        emit(ErrorState(errorMessage: response.body));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _paymentSheet(
      PaymentSheetEvent event, Emitter<StripeState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();
    emit(LoadingState());
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: event.clientId,
          merchantDisplayName: "Koul Network",
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      final paymentIntent =
          await Stripe.instance.retrievePaymentIntent(event.clientId);

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        print("Amount ${paymentIntent.amount}");
        final updateAccountUrl = Uri.parse("$url/update-kaccount");
        final result = await http.post(
          updateAccountUrl,
          headers: {"Authorization": currentUser.authToken},
          body: json.encode(
            {
              "userid": currentUser.id,
              "txn_id": paymentIntent.id,
              "amount": paymentIntent.amount,
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
        if (result.statusCode == HttpStatus.ok) {
          emit(TransactionDoneState(
              txnId: paymentIntent.id,
              amount: (paymentIntent.amount / 100).toDouble()));
        } else {
          emit(ErrorState(
              errorMessage: "Unable to update account: ${result.body}"));
        }
      } else {
        emit(ErrorState(
            errorMessage:
                "Payment was not successful: ${paymentIntent.status}"));
      }
    } on StripeException catch (e) {
      if (e.error.code.name == "Canceled") {
        print("Payment sheet closed by the user.");
        emit(StripeInitial());
      } else {
        emit(ErrorState(errorMessage: e.error.message ?? "An error occurred."));
      }
    } catch (e) {
      emit(ErrorState(errorMessage: e.toString()));
    }
  }
}
