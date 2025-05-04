import 'dart:async';

import 'package:flutter/material.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:sim_card_info/sim_card_info.dart';
import 'package:sim_card_info/sim_info.dart';

//move from abc package to xyz
Future<List<SimInfo>> getSimCardsData(BuildContext context) async {
  final simCardInfoPlugin = SimCardInfo();

  List<SimInfo> simCardInfo = [];
  try {
    // SimInfo simInfo = await SimNumber.getSimData();
    List<SimInfo> simCardInfo = await simCardInfoPlugin.getSimInfo() ?? [];

    // for (var s in simInfo.cards) {
    //   // print('Serial number: ${s.slotIndex} ${s.phoneNumber}');
    //   simCardInfo.add(s);
    // }
    return simCardInfo;
  } catch (_) {
    // ignore: use_build_context_synchronously
    buildSnackBar(context, "unable to get sim info");
  }
  return simCardInfo;
}
