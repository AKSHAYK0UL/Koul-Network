import 'package:flutter/material.dart';
import 'package:koul_network/UI/auth/widgets/bottom_sheet_googlesignup.dart';
import 'package:koul_network/UI/auth/widgets/widget_for_model_sheet.dart';
import 'package:koul_network/model/auth_request_signup.dart';
import 'package:simnumber/siminfo.dart';

void buildBottomSheet(BuildContext context, SignUpClass authobj,
    List<SimCard> simInfo, String screenRoute) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return BuildBottomSheet(authobj, simInfo, screenRoute);
      });
}

void buildGoogleSignUpBottomSheet(BuildContext context, List<SimCard> simInfo) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return BuildGoogleSignUpBottomSheet(simInfo);
      });
}
