import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/model/koul_account/account_balance.dart';

class AlertOnHighAmount extends StatefulWidget {
  final AccountBalance account;

  const AlertOnHighAmount({super.key, required this.account});

  @override
  State<AlertOnHighAmount> createState() => _AlertOnHighAmountState();
}

class _AlertOnHighAmountState extends State<AlertOnHighAmount> {
  bool _showSaveButton = false;
  bool _switchValue = false;
  final largeExpenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _switchValue = widget.account.accountLargeExpenseAlertIs;
    largeExpenseController.text =
        widget.account.accountLargeExpenseAmountAlert.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: EdgeInsets.all(screenSize.width * 0.015),
      child: Column(
        children: [
          ListTile(
            tileColor: const Color.fromARGB(255, 44, 43, 43),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.all(screenSize.width * 0.013),
            leading: const CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.outbond,
                color: Colors.white,
              ),
            ),
            title: Row(
              children: [
                Text(
                  "Large expense alert",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                SizedBox(width: screenSize.width * 0.030),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: screenSize.width * 0.045,
                  ),
                )
              ],
            ),
            subtitle: _switchValue
                ? SizedBox(
                    height: screenSize.width * 0.090,
                    child: Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {
                          _showSaveButton = hasFocus;
                        });
                      },
                      child: TextField(
                        controller: largeExpenseController,
                        decoration: InputDecoration(
                          hintText: "0.0",
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade700,
                            ),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                        ),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                : null,
            trailing: _showSaveButton
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        FocusManager.instance.primaryFocus!.unfocus();
                        _showSaveButton = false;
                        context.read<KoulAccountBloc>().add(UpdateTrackerEvent(
                            largeExpenseAlertIs: _switchValue,
                            largeExpenseAmount:
                                largeExpenseController.text.isEmpty
                                    ? 0.0
                                    : double.parse(
                                        largeExpenseController.text.trim()),
                            lowBalanceAlertIs:
                                widget.account.accountLowBalanceAlertIs,
                            lowBalanceAmount:
                                widget.account.accountLowBalanceAmountAlert));
                      });
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.black,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Switch(
                    activeColor: Colors.white,
                    activeTrackColor: Colors.black,
                    inactiveTrackColor: const Color.fromARGB(255, 72, 72, 72),
                    inactiveThumbColor: Colors.white,
                    trackOutlineColor: WidgetStateProperty.resolveWith(
                      (states) => Colors.transparent,
                    ),
                    value: _switchValue,
                    onChanged: (newvalue) {
                      setState(() {
                        _switchValue = newvalue;
                      });
                      context.read<KoulAccountBloc>().add(UpdateTrackerEvent(
                          largeExpenseAlertIs: _switchValue,
                          largeExpenseAmount: largeExpenseController
                                  .text.isEmpty
                              ? widget.account.accountLargeExpenseAmountAlert
                              : double.parse(
                                  largeExpenseController.text.trim()),
                          lowBalanceAlertIs:
                              widget.account.accountLowBalanceAlertIs,
                          lowBalanceAmount:
                              widget.account.accountLowBalanceAmountAlert));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
