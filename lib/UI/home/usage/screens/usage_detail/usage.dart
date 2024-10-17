import 'package:flutter/material.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:pie_chart/pie_chart.dart';

class UsageScreen extends StatelessWidget {
  final ChartDataState state;
  const UsageScreen({required this.state, super.key});

  //pie chart widget
  Widget buildPieChart(BuildContext context, Map<String, double> dataMap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.sizeOf(context).width / 1.38,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        legendOptions: LegendOptions(
          legendShape: BoxShape.circle,
          showLegendsInRow: true,
          legendPosition: LegendPosition.bottom,
          showLegends: true,
          legendTextStyle: Theme.of(context).textTheme.titleSmall!,
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Total Credit TXN Amount in Rupees": state.chartdata.creditAmount,
      "Total Debit TXN Amount in Rupees": state.chartdata.debitAmount,
      "Max Payment To ${state.chartdata.largeAmountPaidTo.name}":
          state.chartdata.largeAmountPaidTo.amount,
      "Max Receipt From ${state.chartdata.largeAmountReceivedFrom.name}":
          state.chartdata.largeAmountReceivedFrom.amount,
    };
    return Column(
      children: [
        Text(
          "Note: This chart displays data for ${state.chartdata.month} month only.",
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.normal,
                color: Colors.red,
              ),
        ),
        buildPieChart(context, dataMap),
      ],
    );
  }
}
