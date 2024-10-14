part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthSucessState extends AuthState {
  final String userId;

  AuthSucessState({
    required this.userId,
  });
}

final class AuthLoadingState extends AuthState {}

final class AuthFaliueState extends AuthState {
  final String error;
  AuthFaliueState(this.error);
}

final class AuthGoogleLoginFaliueState extends AuthState {
  final String error;
  AuthGoogleLoginFaliueState(this.error);
}

final class AuthInvalidVcodeState extends AuthState {
  final String error;

  AuthInvalidVcodeState(this.error);
}

final class AuthHomeState extends AuthState {
  final String userId;
  final String authToken;

  AuthHomeState(
    this.userId,
    this.authToken,
  );
}

final class UserInfoState extends AuthState {
  final String userId;
  final String userEmail;
  final String userName;
  final String authType;
  final String phone;
  final bool pin;

  UserInfoState({
    required this.userId,
    required this.userEmail,
    required this.userName,
    required this.authType,
    required this.phone,
    required this.pin,
  });
}

final class VerifyAppPINSucessState extends AuthState {}

final class EnterAppPINState extends AuthState {}

final class VerifyAppPINFailureState extends AuthState {
  final String errorMessage;
  VerifyAppPINFailureState({required this.errorMessage});
}

final class EnterPINLoadingState extends AuthState {}

final class AppPINCreatedState extends AuthState {}

final class ForgotAppPINSuccessState extends AuthState {}

final class AppPINCreationFailedState extends AuthState {
  final String error;
  AppPINCreationFailedState({required this.error});
}
