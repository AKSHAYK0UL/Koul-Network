import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/check_balance/screens/checkbalance.dart';
import 'package:koul_network/bloc/auth_bloc/auth_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/core/helpers/helper_functions/phone_formatter.dart';
import 'package:koul_network/core/singleton/currentuser.dart';

AccountBalanceState? accountBalance;

class YourCard extends StatefulWidget {
  final UserInfoState state;

  const YourCard(this.state, {super.key});

  @override
  State<YourCard> createState() => _YourCardState();
}

class _YourCardState extends State<YourCard>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;
  AnimationStatus animationStatus = AnimationStatus.dismissed;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    animation = Tween<double>(end: 1.0, begin: 0.0).animate(animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        animationStatus = status;
      });
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final currentState = context.read<KoulAccountBloc>().state;
    return GestureDetector(
      onTap: () {
        if (animationStatus == AnimationStatus.dismissed) {
          if (currentState.runtimeType != AccountBalanceState) {
            context.read<KoulAccountBloc>().add(AccountBalanceEvent());
          }
          animationController.forward();
        } else {
          animationController.reverse();
        }
      },
      child: Transform(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..setEntry(2, 1, 0.0015)
          ..rotateY(pi * animationController.value),
        child: animationController.value <= 0.5
            ? buildUserCardFront(context, widget.state, screenSize)
            : Transform(
                alignment: FractionalOffset.center,
                transform: Matrix4.identity()..rotateY(pi),
                child: buildUserCardBack(context, widget.state, screenSize),
              ),
      ),
    );
  }
}

Widget buildUserCardFront(
    BuildContext context, UserInfoState userData, Size screenSize) {
  return SizedBox(
    width: double.infinity,
    child: Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/card.jpg",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: screenSize.width * 0.038,
            left: screenSize.width * 0.045,
            child: Text(
              "KOUL NETWORK",
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
          Positioned(
            top: screenSize.width * 0.038,
            right: screenSize.width * 0.045,
            child: Column(
              children: [
                Text(
                  "Powered By",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  "Koul",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: screenSize.width * 0.158,
            left: screenSize.width * 0.045,
            right: screenSize.width * 0.045,
            child: SizedBox(
              width: screenSize.width * 0.90,
              child: FittedBox(
                child: Text(
                  userData.userId,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontSize: screenSize.height * 0.033,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.visible,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenSize.width * 0.038,
            left: screenSize.width * 0.045,
            child: SizedBox(
              width: screenSize.width * 0.66,
              child: Text(
                userData.userName.replaceFirst(
                    userData.userName[0], userData.userName[0].toUpperCase()),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildUserCardBack(
    BuildContext context, UserInfoState userData, Size screenSize) {
  return SizedBox(
    width: double.infinity,
    child: Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              "assets/cardback.png",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: BlocConsumer<KoulAccountBloc, KoulAccountState>(
              listener: (context, state) {
                if (state is KoulAccountInitial) {
                  context.read<KoulAccountBloc>().add(AccountBalanceEvent());
                }
              },
              builder: (context, state) {
                if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                if (state is FailureState &&
                    state.error == "Can't pay to your own account") {
                  return buildCardBackInfo(
                      context, accountBalance!, screenSize);
                }
                if (state is FailureState) {
                  return Center(
                    child: Text(state.error),
                  );
                }
                if (state is AccountBalanceState) {
                  accountBalance = state;
                  return buildCardBackInfo(context, state, screenSize);
                }
                return buildCardBackInfo(context, accountBalance!, screenSize);
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildCardBackInfo(
    BuildContext context, AccountBalanceState state, Size screenSize) {
  final currentPhone = CurrentUserSingleton.getCurrentUserInstance().phone;

  return Container(
    margin: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.01775,
        horizontal: screenSize.height * 0.0263),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Total Balance",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: const Color.fromARGB(234, 255, 255, 255)),
            ),
            Column(
              children: [
                Text(
                  "Powered By",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.white),
                ),
                Text(
                  "Koul",
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: screenSize.height * 0.0028,
        ),
        Text(
          "₹${state.accountBalance.accountCurrentBalance.toStringAsFixed(2)}",
          style: Theme.of(context).textTheme.headlineMedium!,
        ),
        SizedBox(
          height: screenSize.height * 0.0368,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Color.fromARGB(234, 255, 255, 255),
                ),
                Text(
                  " +91 ${formatPhoneNumber(currentPhone)}",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              height: screenSize.height * 0.0263,
              child: const VerticalDivider(
                color: Colors.white,
                thickness: 1,
              ),
            ),
            Row(
              children: [
                Text(
                  "Valid  ",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: const Color.fromARGB(234, 255, 255, 255)),
                ),
                Text("12/27", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ],
        ),
        SizedBox(
          height: screenSize.height * 0.0262,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                context.read<KoulAccountBloc>().add(AccountBalanceEvent());
              },
              label: Text(
                "Refresh",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              icon: const Icon(
                Icons.refresh,
                color: Color.fromARGB(209, 255, 255, 255),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.black),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CheckbalanceScreen.routeName,
                );
              },
              label: Text(
                "Setting",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              icon: const Icon(
                Icons.settings,
                color: Color.fromARGB(209, 255, 255, 255),
              ),
              style: TextButton.styleFrom(backgroundColor: Colors.black),
            ),
          ],
        )
      ],
    ),
  );
}
