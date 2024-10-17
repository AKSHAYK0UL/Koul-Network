import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/home/usage/screens/usage_detail/recent_txn.dart';
import 'package:koul_network/UI/home/usage/screens/usage_detail/usage.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';

class Tabcontroller extends StatefulWidget {
  static const routeName = "tabcontroller";
  const Tabcontroller({super.key});

  @override
  State<Tabcontroller> createState() => _TabcontrollerState();
}

class _TabcontrollerState extends State<Tabcontroller> {
  @override
  void initState() {
    super.initState();
    context.read<KoulAccountBloc>().add(GetChartDataEvent());
  }

  late ChartDataState copyState;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  ColoredBox(
                    color: Theme.of(context).canvasColor,
                    child: TabBar(
                      overlayColor: WidgetStateProperty.resolveWith(
                          (states) => Theme.of(context).canvasColor),
                      indicatorPadding: const EdgeInsets.all(5),
                      labelPadding: const EdgeInsets.all(2),
                      labelColor: Colors.white,
                      unselectedLabelColor:
                          const Color.fromARGB(205, 158, 158, 158),
                      indicatorColor: Colors.white,
                      splashBorderRadius: BorderRadius.circular(5),
                      dividerColor: Theme.of(context).canvasColor,
                      labelStyle: Theme.of(context).textTheme.titleSmall,
                      unselectedLabelStyle: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      tabs: const [
                        Tab(
                          icon: Icon(Icons.data_usage),
                          text: 'Usage Chart',
                        ),
                        Tab(
                          icon: Icon(Icons.money),
                          text: 'Recent TXN',
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ),
                    color: Colors.white,
                  ),
                ],
              ),
              BlocBuilder<KoulAccountBloc, KoulAccountState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (state is ChartDataState) {
                    copyState = state; //save the state
                    return Expanded(
                      child: TabBarView(
                        children: [
                          UsageScreen(
                            state: state,
                          ),
                          RecentTxn(
                            state: state,
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is AIReportState) {
                    return Expanded(
                      child: TabBarView(
                        children: [
                          UsageScreen(
                            state: copyState,
                          ),
                          RecentTxn(
                            state: copyState,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
