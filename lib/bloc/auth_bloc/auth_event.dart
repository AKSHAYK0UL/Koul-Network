part of 'auth_bloc.dart';

sealed class AuthEvent {}

//will set from any state to AuthInitial state
final class SetStateToAuthInitialEvent extends AuthEvent {}

//signup request data
final class SignUpRequestEvent extends AuthEvent {
  final String userName;
  final String userEmail;
  final String password;
  String phone;

  SignUpRequestEvent({
    required this.userName,
    required this.userEmail,
    required this.password,
    required this.phone,
  });
}

//Verify the vcode
final class SignUpverifyEvent extends AuthEvent {
  final String userId;
  final String vcode;

  SignUpverifyEvent({
    required this.userId,
    required this.vcode,
  });
}

//Save the user info on device
final class SaveUserInfoEvent extends AuthEvent {
  final String userId;

  final String authToken;
  final AuthType authType;

  SaveUserInfoEvent(
      {required this.authToken, required this.authType, required this.userId});
}

//SignIn request data
final class SignInRequestEvent extends AuthEvent {
  final String userEmail;
  final String password;

  SignInRequestEvent({
    required this.userEmail,
    required this.password,
  });
}

final class GetAppPINStatusEvent extends AuthEvent {
  final String userid;
  final String token;
  GetAppPINStatusEvent({required this.userid, required this.token});
}

final class FetchUserInfoFromUserIdEvent extends AuthEvent {
  final String userid;
  final String token;

  FetchUserInfoFromUserIdEvent({required this.userid, required this.token});
}

final class AuthLogOutEvent extends AuthEvent {}

final class ForgetPasswordEvent extends AuthEvent {
  final String userEmail;
  final String password;

  ForgetPasswordEvent({required this.userEmail, required this.password});
}

final class ForgotVerifyEvent extends AuthEvent {
  final String userId;
  final String vcode;

  ForgotVerifyEvent({required this.userId, required this.vcode});
}

final class GoogleSignInSilentlyEvent extends AuthEvent {}

final class GoogleSignAuthEvent extends AuthEvent {
  final String phone;
  GoogleSignAuthEvent(this.phone);
}

final class GoogleSignOutEvent extends AuthEvent {}

final class SaveGoogleUserEvent extends AuthEvent {
  final String userId;
  final String userName;
  final String userEmail;

  SaveGoogleUserEvent(
      {required this.userId, required this.userName, required this.userEmail});
}

final class GoogleLoginAuthEvent extends AuthEvent {}

final class SecureSignUpEvent extends AuthEvent {
  final String userName;
  final String userEmail;
  String phone;

  SecureSignUpEvent(
      {required this.userName, required this.userEmail, required this.phone});
}

final class SecureSignUpverifyEvent extends AuthEvent {
  final String userId;
  final String vcode;

  SecureSignUpverifyEvent({
    required this.userId,
    required this.vcode,
  });
}

final class SecureSignInEvent extends AuthEvent {
  final String userName;
  final String userEmail;

  SecureSignInEvent({required this.userName, required this.userEmail});
}

final class SecureSignInverifyEvent extends AuthEvent {
  final String userId;
  final String vcode;

  SecureSignInverifyEvent({
    required this.userId,
    required this.vcode,
  });
}

final class EnterAppPINEvent extends AuthEvent {
  final String appPIN;
  EnterAppPINEvent({required this.appPIN});
}
