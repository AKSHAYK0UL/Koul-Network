import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/add_fund/screen/other_account.dart';
import 'package:koul_network/UI/add_fund/screen/fund_transfer.dart';
import 'package:koul_network/UI/global_widget/build_dialogbox.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/pay_to_contacts/screen/contacts_list.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/pay_koulid.dart';
import 'package:koul_network/UI/home/pay_to_phone/pay_to_phone.dart';
import 'package:koul_network/UI/home/widgets/menu_options.dart';
import 'package:koul_network/UI/home/widgets/user_card.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/core/helpers/helper_functions/greeting.dart';
import 'package:koul_network/model/koul_account/from_to.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final state = context.read<AuthBloc>().state as UserInfoState;

    return ColoredBox(
      color: const Color.fromARGB(255, 44, 43, 43),
      child: SafeArea(
        minimum: EdgeInsets.only(top: screenSize.width * 0.0470),
        child: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 44, 43, 43),
            title: ListTile(
              tileColor: const Color.fromARGB(255, 44, 43, 43),
              contentPadding: EdgeInsets.zero,
              title: greeting(context),
              subtitle: Text(
                state.userName.replaceFirst(
                    state.userName[0], state.userName[0].toUpperCase()),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(screenSize.width * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: screenSize.width * 0.0200,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.0256),
                  child: Text(
                    "Your Card",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: screenSize.height * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                SizedBox(
                  height: screenSize.width * 0.0050,
                ),
                SizedBox(
                  height: screenSize.width * 0.612,
                  width: double.infinity,
                  child: YourCard(state),
                ),
                SizedBox(
                  height: screenSize.width * 0.0200,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.0256),
                  child: Text(
                    "Quick Pay",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontSize: screenSize.height * 0.035,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                SizedBox(
                  height: screenSize.width * 0.0100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildMenuOptions(
                        context: context,
                        icon: Icons.pentagon,
                        text: "Pay to\nKoul ID",
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(PayToKoulId.routeName);
                        }),
                    buildMenuOptions(
                        context: context,
                        icon: Icons.contact_page,
                        text: "Pay to\nContacts",
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ContactsList.routeName);
                        }),
                    buildMenuOptions(
                        context: context,
                        icon: Icons.phone_android,
                        text: "Pay to\nPhone no",
                        onTap: () {
                          Navigator.of(context).pushNamed(PayToPhone.routeName);
                        }),
                    buildMenuOptions(
                      context: context,
                      icon: Icons.qr_code,
                      text: "Show\nQR code",
                      onTap: () {
                        buildDialogBox(
                          context: context,
                          title: "QR code ",
                          clipboardtext: "",
                          content: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: screenSize.height * 0.007,
                              ),
                            ),
                            width: screenSize.height * 0.3554,
                            child: PrettyQrView.data(
                              data: state.userId,
                              decoration: const PrettyQrDecoration(
                                background: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.width * 0.0240,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          TransferFund.routeName,
                          arguments: FromTo(
                              koulId: state.userId, name: state.userName),
                        );
                      },
                      icon: Icon(Icons.loop),
                      label: Text("Self Transfer"),
                      style: TextButton.styleFrom(
                          fixedSize: Size(screenSize.height * 0.225,
                              screenSize.height * 0.0620)),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(OtherAccount.routeName);
                      },
                      icon: Icon(Icons.account_balance),
                      label: Text("Other Account"),
                      style: TextButton.styleFrom(
                          fixedSize: Size(screenSize.height * 0.225,
                              screenSize.height * 0.0620)),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.width * 0.0467,
                ),
                Center(
                  child: Chip(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: const Color.fromARGB(255, 50, 50, 50),
                    label: SizedBox(
                      height: screenSize.width * 0.0562,
                      width: screenSize.width * 0.4800,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Koul ID: ",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Colors.white,
                                      fontSize: screenSize.width * 0.0395,
                                      fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: state.userId,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: Colors.white,
                                    fontSize: screenSize.width * 0.0395,
                                  ),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    deleteIcon: const Icon(
                      Icons.copy,
                      color: Colors.white,
                    ),
                    onDeleted: () {
                      Clipboard.setData(ClipboardData(text: state.userId));
                      buildSnackBar(context, "Copied to clipboard");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
