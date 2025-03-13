import 'dart:async';

import 'package:flutter/material.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:simnumber/sim_number.dart';
import 'package:simnumber/siminfo.dart';

Future<List<SimCard>> getSimCardsData(BuildContext context) async {
  List<SimCard> simCardInfo = [];
  try {
    SimInfo simInfo = await SimNumber.getSimData();
    for (var s in simInfo.cards) {
      // print('Serial number: ${s.slotIndex} ${s.phoneNumber}');
      simCardInfo.add(s);
    }
    return simCardInfo;
  } catch (_) {
    // ignore: use_build_context_synchronously
    buildSnackBar(context, "unable to get sim info");
  }
  return simCardInfo;
}
