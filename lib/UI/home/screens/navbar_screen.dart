import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/more/screen/more_tab.dart';
import 'package:koul_network/UI/home/qr/screen/scanner.dart';
import 'package:koul_network/UI/home/screens/home.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:koul_network/UI/home/screens/transactions.dart';
import 'package:koul_network/UI/home/usage/usage_tab.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  final List<Widget> screens = [
    const Home(),
    const Transactions(),
    const UsageTab(),
    const MoreTab(),
  ];

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final currentState = context.read<KoulAccountBloc>().state;
    print("STATE IS $currentState");

    if (_currentIndex == 1 &&
        currentState.runtimeType != AllTransactionsListState) {
      context.read<KoulAccountBloc>().add(GetAllTransactionsListEvent());
    }

    final screenSize = MediaQuery.sizeOf(context);
    return PopScope(
      canPop: _currentIndex != 0 ? false : true, //when to pop and when not
      child: Scaffold(
        backgroundColor: Theme.of(context).canvasColor,
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: CustomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 44, 43, 43),
          isFloating: false,
          bubbleCurve: Curves.easeInOut,
          scaleCurve: Curves.easeInOut,
          borderRadius: Radius.zero,
          elevation: 1,
          unSelectedColor: Colors.white60,
          selectedColor: Colors.white,
          strokeColor: Colors.white,
          iconSize: screenSize.width * 0.0600,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            CustomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                selectedTitle: Text(
                  "Home",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: screenSize.height * 0.025,
                        color: Colors.white,
                      ),
                ),
                title: Text(
                  "Home",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: screenSize.height * 0.025,
                        color: Colors.white60,
                      ),
                ),
                badgeCount: 0),
            CustomNavigationBarItem(
                icon: const Icon(Icons.settings_backup_restore_outlined),
                selectedIcon: const Icon(Icons.settings_backup_restore_rounded),
                selectedTitle: Text(
                  "Ledger",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: screenSize.height * 0.025,
                        color: Colors.white,
                      ),
                ),
                title: Text(
                  "Ledger",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: screenSize.height * 0.025,
                        color: Colors.white60,
                      ),
                ),
                badgeCount: 1),
            CustomNavigationBarItem(
                icon: const Icon(Icons.pie_chart_outline),
                selectedIcon: const Icon(Icons.pie_chart),
                selectedTitle: Text(
                  "Usage",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontSize: screenSize.height * 0.025,
                        color: Colors.white,
                      ),
                ),
                title: Text(
                  "Usage",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: screenSize.height * 0.025,
                        color: Colors.white60,
                      ),
                ),
                badgeCount: 2),
            CustomNavigationBarItem(
              icon: const Icon(Icons.menu_outlined),
              selectedIcon: const Icon(Icons.menu_open_outlined),
              selectedTitle: Text(
                "More",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontSize: screenSize.height * 0.025,
                      color: Colors.white,
                    ),
              ),
              title: Text(
                "More",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: screenSize.height * 0.025,
                      color: Colors.white60,
                    ),
              ),
              badgeCount: 3,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SizedBox(
          height: screenSize.width * 0.1300,
          width: screenSize.width * 0.1300,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 90, 90, 90),
            onPressed: () {
              Navigator.of(context).pushNamed(QRScanner.routeName);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.qr_code_scanner,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onPopInvoked: (_) {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
    );
  }
}
