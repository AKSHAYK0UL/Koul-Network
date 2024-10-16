import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

class UsageScreen extends StatefulWidget {
  static const routeName = "usagescreen";
  const UsageScreen({super.key});

  @override
  State<UsageScreen> createState() => _UsageScreenState();
}

class _UsageScreenState extends State<UsageScreen> {
  late ChartDataState copyState;

  @override
  void initState() {
    super.initState();
    context.read<KoulAccountBloc>().add(GetChartDataEvent());
  }

  //pie chart widget
  Widget buildPieChart(Map<String, double> dataMap) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.sizeOf(context).width / 1.38,
      initialAngleInDegree: 0,
      chartType: ChartType.disc,
      legendOptions: const LegendOptions(
        showLegendsInRow: true,
        legendPosition: LegendPosition.bottom,
        showLegends: true,
        legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "Usage Chart",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: BlocBuilder<KoulAccountBloc, KoulAccountState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          }

          if (state is ChartDataState) {
            copyState = state; // Save the state
            Map<String, double> dataMap = {
              "creditAmount": state.chartdata.creditAmount,
              "debitAmount": state.chartdata.debitAmount,
              "PaidTo": state.chartdata.largeAmountPaidTo.amount,
              "ReceivedFrom": state.chartdata.largeAmountReceivedFrom.amount,
            };
            return Column(
              children: [
                buildPieChart(dataMap),
              ],
            );
          }

          if (state is AIReportState) {
            Map<String, double> dataMap = {
              "creditAmount": copyState.chartdata.creditAmount,
              "debitAmount": copyState.chartdata.debitAmount,
              "PaidTo": copyState.chartdata.largeAmountPaidTo.amount,
              "ReceivedFrom":
                  copyState.chartdata.largeAmountReceivedFrom.amount,
            };
            return Column(
              children: [
                buildPieChart(dataMap),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
