import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';

class BackPressWrapper extends StatelessWidget {
  final Widget child;

  const BackPressWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (_) {
        context.read<KoulAccountBloc>().add(SetStateToInitial());
        debugPrint(
            "Current state BACk press wrapper ${context.read<KoulAccountBloc>().state}");
      },
      child: child,
    );
  }
}
