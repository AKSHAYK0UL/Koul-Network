import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/bloc/stripe_bloc/bloc/stripe_bloc.dart';
import 'package:koul_network/helpers/utc_to_ist.dart';

class FundTxn extends StatefulWidget {
  static const routeName = "/fundtxn";
  const FundTxn({super.key});

  @override
  State<FundTxn> createState() => _FundTxnState();
}

class _FundTxnState extends State<FundTxn> {
  @override
  void initState() {
    context.read<StripeBloc>().add(GetFundsTXNList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          titleSpacing: 0,
          title: Text(
            "Funds Transactions",
            style: Theme.of(context).textTheme.titleMedium,
          )),
      body: BlocBuilder<StripeBloc, StripeState>(
        builder: (context, state) {
          if (state is FundTXNState) {
            return ListView.builder(
              itemCount: state.fundTxnList.length,
              itemBuilder: (context, index) {
                final fundData = state.fundTxnList[index];
                return ListTile(
                  tileColor: const Color.fromARGB(255, 40, 39, 39),
                  title: Text(
                    fundData.from.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  subtitle: Text(
                    timeFormaterFull(fundData.date.toString()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: Text("₹${fundData.amount.toString()}",
                      style: Theme.of(context).textTheme.bodyMedium),
                );
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
