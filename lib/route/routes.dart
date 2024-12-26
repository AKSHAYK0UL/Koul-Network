import 'package:flutter/material.dart';
import 'package:koul_network/UI/add_fund/other_account.dart';
import 'package:koul_network/UI/add_fund/screen/fund_added_success.dart';
import 'package:koul_network/UI/add_fund/screen/paymentgataway.dart';
import 'package:koul_network/UI/add_fund/screen/self_transfer.dart';
import 'package:koul_network/UI/auth/screens/forgot_password.dart';
import 'package:koul_network/UI/auth/screens/onsignup_with_google.dart';
import 'package:koul_network/UI/auth/screens/secure_signin.dart';
import 'package:koul_network/UI/auth/screens/secure_signup_auth.dart';
import 'package:koul_network/UI/auth/screens/signIn_email_or_oauth.dart';
import 'package:koul_network/UI/auth/screens/signin.dart';
import 'package:koul_network/UI/auth/screens/signup.dart';
import 'package:koul_network/UI/auth/screens/signup_email_or_oauth.dart';
import 'package:koul_network/UI/auth/screens/verification_code_signup.dart';
import 'package:koul_network/UI/home/check_balance/screens/checkbalance.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/processing_screen.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/setup_transaction_pin.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/transaction_failed.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/transaction_pin.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/updating_creating_transactionpin.dart';
import 'package:koul_network/UI/home/cross%20screen/transaction_detail.dart';
import 'package:koul_network/UI/home/more/screen/AppPinkeypad.dart';
import 'package:koul_network/UI/home/more/screen/account_info.dart';
import 'package:koul_network/UI/home/more/screen/account_setting.dart';
import 'package:koul_network/UI/home/more/screen/account_setting/reset_password.dart';
import 'package:koul_network/UI/home/more/screen/app_pin_setting/app_pin_setting.dart';
import 'package:koul_network/UI/home/more/screen/app_pin_setting/processing/loading.dart';
import 'package:koul_network/UI/home/more/screen/privacy.dart';
import 'package:koul_network/UI/home/pay_to_contacts/screen/contacts_list.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/pay_koulid.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/pay_screen.dart';
import 'package:koul_network/UI/home/pay_to_phone/pay_to_phone.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/previous_transactions_screen.dart';
import 'package:koul_network/UI/home/qr/screen/scanner.dart';
import 'package:koul_network/UI/home/screens/home_screen.dart';
import 'package:koul_network/UI/home/cross%20screen/screen/tranaction_done.dart';
import 'package:koul_network/UI/home/screens/navbar_screen.dart';
import 'package:koul_network/UI/home/screens/transactions.dart';
import 'package:koul_network/UI/home/usage/screens/ai_report.dart';
import 'package:koul_network/UI/home/usage/screens/usage_detail/tabcontroller.dart';

//routes table
Map<String, WidgetBuilder> routeTable = {
  SignInEmailOrOauth.routeName: (context) => const SignInEmailOrOauth(),
  SignUpEmailOrOauth.routeName: (context) => const SignUpEmailOrOauth(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  SecureSignUpScreen.routeName: (context) => const SecureSignUpScreen(),
  SecureSignInScreen.routeName: (context) => const SecureSignInScreen(),
  VcodeSignupScreen.routeName: (context) => const VcodeSignupScreen(),
  HomeScreen.routeName: (context) => const HomeScreen(),
  ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
  OnSignUpWithGoogle.routeName: (context) => const OnSignUpWithGoogle(),
  CheckbalanceScreen.routeName: (context) => const CheckbalanceScreen(),
  PayToKoulId.routeName: (context) => const PayToKoulId(),
  PreviousTransactionsScreen.routeName: (context) =>
      const PreviousTransactionsScreen(),
  TranactionDoneScreen.routeName: (context) => const TranactionDoneScreen(),
  PayScreen.routeName: (context) => const PayScreen(),
  TransactionDetailScreen.routeName: (context) =>
      const TransactionDetailScreen(),
  ProcessingScreen.routeName: (context) => const ProcessingScreen(),
  TransactionFailedScreen.routeName: (context) =>
      const TransactionFailedScreen(),
  TransactionPin.routeName: (context) => const TransactionPin(),
  SetupTransactionPin.routeName: (context) => const SetupTransactionPin(),
  UpdatingCreatingTransactionpin.routeName: (context) =>
      const UpdatingCreatingTransactionpin(),
  PayToPhone.routeName: (context) => const PayToPhone(),
  Transactions.routeName: (context) => const Transactions(),
  QRScanner.routeName: (context) => const QRScanner(),
  ContactsList.routeName: (context) => const ContactsList(),
  AccountInfo.routeName: (context) => const AccountInfo(),
  Privacy.routeName: (context) => const Privacy(),
  AccountSetting.routeName: (context) => const AccountSetting(),
  ResetPasswordScreen.routeName: (context) => const ResetPasswordScreen(),
  AiReport.routeName: (context) => const AiReport(),
  NavbarScreen.routeName: (context) => const NavbarScreen(),
  AppPinSetting.routeName: (context) => const AppPinSetting(),
  AppPINKeypad.routeName: (context) => const AppPINKeypad(),
  Loading.routeName: (context) => const Loading(),
  Tabcontroller.routeName: (context) => const Tabcontroller(),
  SelfTransfer.routeName: (context) => const SelfTransfer(),
  FundAddedSuccess.routeName: (context) => const FundAddedSuccess(),
  Paymentgataway.routeName: (context) => const Paymentgataway(),
  OtherAccount.routeName: (context) => const OtherAccount(),
};
