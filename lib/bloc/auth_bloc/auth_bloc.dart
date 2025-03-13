import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:koul_network/core/enums/app_pin_settting.dart';
import 'package:koul_network/core/enums/auth_type_enum.dart';
import 'package:koul_network/core/helpers/helper_functions/trim_phno.dart';
import 'package:koul_network/model/contact.dart';
import 'package:koul_network/model/rverify_response.dart';
import 'package:koul_network/model/signup_response.dart';
import 'package:koul_network/secrets/api.dart';
import 'package:koul_network/core/singleton/currentuser.dart';
import 'package:koul_network/model/user_info.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  // final url = "http://10.0.2.2:8000";
  final url = AUTH_ACCOUNT_API_URL;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  AuthBloc() : super(AuthInitial()) {
    on<SetStateToAuthInitialEvent>(
        _setstatetiinitial); //set state to AuthInitial
    on<SignUpRequestEvent>(_signupRequest); //signup req
    on<SignUpverifyEvent>(_signupverify); //verify vcode
    on<SaveUserInfoEvent>(
        _saveuserinfo); //save the user data on the device[userid//AuthToken]

    on<GetAppPINStatusEvent>(_getAppPINstatus);
    on<FetchUserInfoFromUserIdEvent>(
        _fetchuserInfo); //fetch user info using user id and in return gets[username,useremail,userid,phone no]
    on<SignInRequestEvent>(_signinRequest); //signin req
    on<AuthLogOutEvent>(_logoutuser); //user logout
    on<ForgetPasswordEvent>(_forgetpassword); //forget password
    on<ForgotVerifyEvent>(_forgetPasswordverify);
    on<GoogleSignAuthEvent>(_googleSignAuth); //signin/up with google
    on<GoogleLoginAuthEvent>(_googleLoginAuth); //login with google
    on<GoogleSignOutEvent>(_googleSiginOutAuth); //signOut google
    on<SecureSignUpEvent>(_secureSignUp); //create account using secure session
    on<SecureSignUpverifyEvent>(_secureSignUpVerify); //verify vcode
    on<SecureSignInEvent>(_secureSignIn);
    on<SecureSignInverifyEvent>(_secureSignInVerify);
    on<EnterAppPINEvent>(_enterappPIN); //enter app PIN
    on<AppPINOperationsEvent>(_createAppPIN); //handle [create, reset, delete]
  }
  //set state to AuthInitial
  void _setstatetiinitial(
      SetStateToAuthInitialEvent event, Emitter<AuthState> emit) {
    emit(AuthInitial());
    return;
  }

//signup req
  Future<void> _signupRequest(
      SignUpRequestEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final phone = trimPhone(event.phone);
      final signupRoute = Uri.parse("$url/signup");

      final response = await http.post(
        signupRoute,
        body: json.encode(
          {
            "useremail": event.userEmail.toLowerCase(),
            "username": event.userName.toLowerCase(),
            "password": event.password.trim(),
            "phone": phone,
          },
        ),
      );

      verifyData? signuprer;
      final bodyString = response.body.toString();
      List<String> errors = [
        "try another email",
        "email and username already exist",
        "username already exist",
        "email already exist",
        "email, username and phone no. already exist",
        "email and phone no. already exist",
        "phone no. and username already exist",
        "phone no. already exist",
      ];
      if (!errors.contains(bodyString)) {
        Map<String, dynamic> data = jsonDecode(response.body);
        signuprer = verifyData.fromJson(data);
      }

      if (errors.contains(bodyString)) {
        emit(AuthFaliueState(response.body));
        return;
      } else if (response.body.isNotEmpty) {
        emit(
          AuthSucessState(userId: signuprer!.userId),
        );
        return;
      }
    } catch (e) {
      emit(AuthFaliueState("error: ${e.toString()}"));
      return;
    }
  }

//Verify the Vcode
  Future<void> _signupverify(
      SignUpverifyEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final signupVerifyroute = Uri.parse("$url/verify");
      final response = await http.post(
        signupVerifyroute,
        body: json.encode(
          {"userid": event.userId, "vcode": event.vcode},
        ),
      );

      final data = jsonDecode(response.body);
      User user = User.fromJson(data);
      print(data);
      if (response.body.contains("invalid")) {
        emit(AuthInvalidVcodeState("Invaid verification code"));
        return;
      } else {
        emit(
          AuthHomeState(
            user.userId,
            user.authToken,
          ),
        );
        return;
      }
    } catch (e) {
      print(e.toString());
      emit(AuthInvalidVcodeState(e.toString()));
      return;
    }
  }

  Future<void> _saveuserinfo(
      SaveUserInfoEvent event, Emitter<AuthState> emit) async {
    try {
      final box = Hive.box("auth");
      await box.putAll({
        "uid": event.userId,
        "token": event.authToken,
        "authtype": event.authType.toString(),
      });
    } catch (_) {
      print("SAVE USER INFO ERROR");
    }
  }

  //Signin req

  Future<void> _signinRequest(
      SignInRequestEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final signinRoute = Uri.parse("$url/login");
      final response = await http.post(signinRoute,
          body: json.encode({
            "useremail": event.userEmail.toLowerCase(),
            "password": event.password.trim(),
          }));
      List<String> errors = [
        "no user found(middleware)",
        "wrong email or password",
        "invalid request",
        "try another email"
      ];

      if (!errors.contains(response.body) && response.body.isNotEmpty) {
        Map<String, dynamic> data = json.decode(response.body);
        User loginCred = User.fromJson(data);

        emit(
          AuthHomeState(
            loginCred.userId,
            loginCred.authToken,
          ),
        );
        return;
      }
      if (errors.contains(response.body)) {
        emit(AuthFaliueState("invalid email or password"));
        return;
      }
    } catch (_) {
      emit(AuthFaliueState("something went wrong"));
      return;
    }
  }

  //Logout user
  Future<void> _logoutuser(
      AuthLogOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      await Hive.box("auth").delete("uid");
      await Hive.box("auth").delete("token");

      await Hive.box("auth").delete("authtype");
      await Hive.box<UserContact>("contacts").clear();

      emit(AuthInitial());
      return;
    } catch (_) {
      emit(AuthFaliueState("something went wrong"));
      return;
    }
  }

////////////////////////////////////////////////////////////////////
  Future<void> _getAppPINstatus(
      GetAppPINStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final uexistroute = Uri.parse("$url/uexist");
      final wakeUpKoulServiceRoute = Uri.parse("$KOUL_SERVICE_API_URL/on");
      // final response = await http.post(uexistroute,
      //     body: json.encode({"userid": event.userid}));
      List<Response> response = await Future.wait([
        http.post(uexistroute,
            headers: {"Authorization": event.token},
            body: json.encode({"userid": event.userid})),
        http.get(wakeUpKoulServiceRoute),
      ]);

      final jsondata = jsonDecode(response[0].body);

      final userdata = GetUserData.fromJson(jsondata);

      print("FETCHING USER $jsondata");
      print("PIN VALUE ${userdata.pinIsOnOff}");
      CurrentUserSingleton(
        id: userdata.userId,
        name: userdata.userName,
        email: userdata.userEmail,
        phone: userdata.phone,
        authType: userdata.authType,
        authToken: event.token,
        appPINstatus: userdata.pinIsOnOff,
      );
      if (userdata.pinIsOnOff) {
        emit(EnterAppPINState());
      } else {
        emit(
          UserInfoState(
            userId: userdata.userId,
            userEmail: userdata.userEmail,
            userName: userdata.userName,
            authType: userdata.authType,
            phone: userdata.phone,
            pin: userdata.pinIsOnOff,
          ),
        );
      }
    } catch (e) {
      print("UID INAVLID ERROR ${e.toString()}");
      emit(AuthFaliueState("Invaild UID"));
      return;
    }
  }

/////////////////////////////////////////////////////////////////////////////
  Future<void> _fetchuserInfo(
      FetchUserInfoFromUserIdEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    print("EMIT Id ${event.userid}");
    try {
      final uexistroute = Uri.parse("$url/uexist");
      final wakeUpKoulServiceRoute = Uri.parse("$KOUL_SERVICE_API_URL/on");
      // final response = await http.post(uexistroute,
      //     body: json.encode({"userid": event.userid}));
      List<Response> response = await Future.wait([
        http.post(uexistroute,
            headers: {"Authorization": event.token},
            body: json.encode({"userid": event.userid})),
        http.get(wakeUpKoulServiceRoute),
      ]);

      final jsondata = jsonDecode(response[0].body);

      final userdata = GetUserData.fromJson(jsondata);

      print("FETCHING USER $jsondata");
      print("PIN VALUE ${userdata.pinIsOnOff}");

      CurrentUserSingleton(
        id: userdata.userId,
        name: userdata.userName,
        email: userdata.userEmail,
        phone: userdata.phone,
        authType: userdata.authType,
        authToken: event.token,
        appPINstatus: userdata.pinIsOnOff,
      );
      emit(
        UserInfoState(
          userId: userdata.userId,
          userEmail: userdata.userEmail,
          userName: userdata.userName,
          authType: userdata.authType,
          phone: userdata.phone,
          pin: userdata.pinIsOnOff,
        ),
      );
    } catch (e) {
      print("UID INAVLID ERROR ${e.toString()}");
      emit(AuthFaliueState("Invaild UID"));
      return;
    }
  }

  Future<void> _forgetpassword(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final forgetroute = Uri.parse("$url/reset");
      print("FORGOT PASSWORD ${event.password.trim()}");
      final response = await http.post(forgetroute,
          body: json.encode({
            "useremail": event.userEmail,
            "password": event.password.trim(),
          }));
      print("RESPONSE FORGOT :${response.body.toString()}");
      final responseBodyString = response.body.toString();
      verifyData? signuprer;
      print("RESPONSE FORGOT :${response.body.toString()}");

      if (!responseBodyString.contains("no user found(middleware)")) {
        Map<String, dynamic> data = jsonDecode(response.body);

        signuprer = verifyData.fromJson(data);
      }

      if (responseBodyString.contains("no user found(middleware)")) {
        emit(AuthFaliueState("no account found"));
        return;
      } else if (response.body.isNotEmpty) {
        emit(
          AuthSucessState(userId: signuprer!.userId),
        );
        return;
      }
    } catch (_) {
      emit(AuthFaliueState("no account found"));
      return;
    }
  }

  //Verify the Vcode
  Future<void> _forgetPasswordverify(
      ForgotVerifyEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      print("Reset taped");
      final signupVerifyroute = Uri.parse("$url/rverify");
      print("userId ${event.userId} ---vcode ${event.vcode}");
      final response = await http.patch(
        signupVerifyroute,
        body: json.encode(
          {"userid": event.userId, "vcode": event.vcode},
        ),
      );

      final data = json.decode(response.body.toString());
      Ruser user = Ruser.fromJson(data);

      if (response.body.contains("invalid")) {
        emit(AuthInvalidVcodeState("Invaid verification code"));
        return;
      } else {
        emit(
          AuthHomeState(
            user.userId,
            user.authToken,
          ),
        );
        return;
      }
    } catch (e) {
      emit(AuthInvalidVcodeState(e.toString()));
      return;
    }
  }

// save G_user
  Future<User> _saveguser({
    required String userId,
    required String userName,
    required String userEmail,
    required String phone,
  }) async {
    try {
      final phoneNo = trimPhone(phone);

      final googleuserRoute = Uri.parse("$url/saveguser");
      final response = await http.post(
        googleuserRoute,
        body: json.encode(
          {
            "userid": userId,
            "username": userName,
            "useremail": userEmail,
            "phone": phoneNo,
          },
        ),
      );
      print("SAVE G USER : ${response.body.toString()}");
      final data = json.decode(response.body.toString());
      print("GUSER DATA $data");

      final guserInfo = User.fromJson(data);
      return guserInfo;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _googleSignAuth(
      GoogleSignAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    print("_googleSignAuth");
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
      }
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUserData = await googleSignIn.signIn();
      if (googleUserData == null) {
        emit(AuthInitial()); //state indicating no action taken
        return;
      }
      print("**************googleUserData.displayName************");
      final saveGdata = await _saveguser(
        userId: googleUserData.id,
        userName: googleUserData.displayName!,
        userEmail: googleUserData.email,
        phone: event.phone,
      );
      print("SAVE G USER TOKEN : ${saveGdata.authToken}");

      emit(AuthHomeState(
        saveGdata.userId,
        saveGdata.authToken,
      ));
      return;
    } catch (e) {
      List<String> errors = [
        "email and phone no. already in use",
        "phone no. already in use",
        "email already in use"
      ];
      print("Error ${e.toString()}");
      final err = e.toString().contains(errors[0])
          ? errors[0]
          : e.toString().contains(errors[1])
              ? errors[1]
              : errors[2];
      emit(AuthFaliueState(err));
      return;
    }
  }

  Future<void> _googleLoginAuth(
      GoogleLoginAuthEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      final uexistroute = Uri.parse("$url/guexist");

      final GoogleSignIn googleSignIn = GoogleSignIn();

      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
      }
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUserData = await googleSignIn.signIn();

      if (googleUserData == null) {
        emit(AuthInitial()); //state indicating no action taken
        return;
      }

      final response = await http.post(uexistroute,
          body: json.encode({"useremail": googleUserData.email}));

      final jsondata = jsonDecode(response.body);

      final userdata = User.fromJson(jsondata);

      emit(AuthHomeState(
        userdata.userId,
        userdata.authToken,
      ));
    } catch (e) {
      print("Invalid user id: ${e.toString()}");
      emit(AuthGoogleLoginFaliueState("No account found"));
    }
  }

  Future<void> _googleSiginOutAuth(
      GoogleSignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    try {
      await _googleSignIn.disconnect();
      await Hive.box<UserContact>("contacts").clear();
      return;
    } catch (_) {
      emit(AuthFaliueState("something went wrong"));
      return;
    }
  }

//Session reg
  Future<void> _secureSignUp(
      SecureSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final phone = trimPhone(event.phone);
      final signupRoute = Uri.parse("$url/securesignup");

      final response = await http.post(
        signupRoute,
        body: json.encode(
          {
            "useremail": event.userEmail.toLowerCase(),
            "username": event.userName.toLowerCase(),
            "phone": phone,
          },
        ),
      );

      verifyData? signuprer;
      final bodyString = response.body.toString();
      List<String> errors = [
        "try another email",
        "email and username already exist",
        "username already exist",
        "email already exist",
        "email, username and phone no. already exist",
        "email and phone no. already exist",
        "phone no. and username already exist",
        "phone no. already exist",
      ];
      if (!errors.contains(bodyString)) {
        Map<String, dynamic> data = jsonDecode(response.body);
        signuprer = verifyData.fromJson(data);
      }

      if (errors.contains(bodyString)) {
        emit(AuthFaliueState(response.body));
        return;
      } else if (response.body.isNotEmpty) {
        emit(
          AuthSucessState(userId: signuprer!.userId),
        );
        return;
      }
    } catch (e) {
      emit(AuthFaliueState("something went wrong"));
      return;
    }
  }

  Future<void> _secureSignUpVerify(
      SecureSignUpverifyEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final signupVerifyroute = Uri.parse("$url/secureverify");
      final response = await http.post(
        signupVerifyroute,
        body: json.encode(
          {"userid": event.userId, "vcode": event.vcode},
        ),
      );

      final data = jsonDecode(response.body);
      User user = User.fromJson(data);

      if (response.body.contains("invalid")) {
        emit(AuthInvalidVcodeState("Invaid verification code"));
        return;
      } else {
        emit(
          AuthHomeState(
            user.userId,
            user.authToken,
          ),
        );
        return;
      }
    } catch (e) {
      print(e.toString());
      emit(AuthInvalidVcodeState(e.toString()));
      return;
    }
  }

  Future<void> _secureSignIn(
      SecureSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final signupRoute = Uri.parse("$url/securelogin");

      final response = await http.post(
        signupRoute,
        body: json.encode(
          {
            "useremail": event.userEmail.toLowerCase(),
            "username": event.userName.toLowerCase(),
          },
        ),
      );

      verifyData? signuprer;
      final bodyString = response.body.toString();
      List<String> errors = [
        "try another email",
        "email and username already exist",
        "username already exist",
        "email already exist",
        "email, username and phone no. already exist",
        "email and phone no. already exist",
        "phone no. and username already exist",
        "phone no. already exist",
      ];
      if (!errors.contains(bodyString)) {
        Map<String, dynamic> data = jsonDecode(response.body);
        signuprer = verifyData.fromJson(data);
      }

      if (errors.contains(bodyString)) {
        emit(AuthFaliueState(response.body));
        return;
      } else if (response.body.isNotEmpty) {
        emit(
          AuthSucessState(userId: signuprer!.userId),
        );
        return;
      }
    } catch (e) {
      emit(AuthFaliueState("invalid username or email"));
      return;
    }
  }

  Future<void> _secureSignInVerify(
      SecureSignInverifyEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final signupVerifyroute = Uri.parse("$url/secureloginverify");
      final response = await http.post(
        signupVerifyroute,
        body: json.encode(
          {"userid": event.userId, "vcode": event.vcode},
        ),
      );

      final data = jsonDecode(response.body);
      User user = User.fromJson(data);
      if (response.body.contains("invalid")) {
        emit(AuthInvalidVcodeState("Invaid verification code"));
        return;
      } else {
        emit(
          AuthHomeState(
            user.userId,
            user.authToken,
          ),
        );
        return;
      }
    } catch (e) {
      emit(AuthInvalidVcodeState(e.toString()));
      return;
    }
  }

  Future<void> _enterappPIN(
      EnterAppPINEvent event, Emitter<AuthState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();

    emit(EnterPINLoadingState());
    final routeEnterAppPin = "$url/verifyapppin";
    try {
      final response = await http.post(
        Uri.parse(routeEnterAppPin),
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id,
            "app_pin": event.appPIN,
          },
        ),
      );
      if (response.statusCode == HttpStatus.ok &&
          response.body.toString() == "done") {
        print(response.body.toString());
        add(FetchUserInfoFromUserIdEvent(
            userid: currentUser.id, token: currentUser.authToken));
        emit(VerifyAppPINSucessState());
        return;
      } else {
        emit(VerifyAppPINFailureState(errorMessage: response.body.toString()));
        return;
      }
    } catch (e) {
      emit(VerifyAppPINFailureState(errorMessage: e.toString()));
    }
  }

  Future<void> _createAppPIN(
      AppPINOperationsEvent event, Emitter<AuthState> emit) async {
    final currentUser = CurrentUserSingleton.getCurrentUserInstance();

    emit(EnterPINLoadingState());
    final routeValue = event.route == AppPINSettingRoute.delete
        ? "deleteapppin"
        : "createapppin";
    final createAppPINroute = "$url/$routeValue";
    try {
      final response = await http.post(
        Uri.parse(createAppPINroute),
        headers: {"Authorization": currentUser.authToken},
        body: json.encode(
          {
            "userid": currentUser.id,
            "app_pin": event.appPIN,
          },
        ),
      );
      //http status
      //'created 201' for reset and create PIN
      //'ok 200' for delete
      if ((response.statusCode == HttpStatus.created ||
              response.statusCode == HttpStatus.ok) &&
          response.body.toString() == "done") {
        await Future.delayed(event.route == AppPINSettingRoute.delete
            ? const Duration(milliseconds: 1500)
            : const Duration(milliseconds: 5000));
        if (!emit.isDone) {
          if (event.route == AppPINSettingRoute.forgot) {
            emit(ForgotAppPINSuccessState());
          } else {
            emit(AppPINCreatedState());
          }
        }
      } else {
        emit(AppPINCreationFailedState(error: response.body.toString()));
      }
    } catch (e) {
      emit(AppPINCreationFailedState(error: e.toString()));
    }
  }
}
