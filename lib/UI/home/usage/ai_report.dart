import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';

class AiReport extends StatefulWidget {
  static const routeName = "AiReport";
  const AiReport({super.key});

  @override
  State<AiReport> createState() => _AiReportState();
}

class _AiReportState extends State<AiReport> {
  @override
  void initState() {
    context.read<KoulAccountBloc>().add(AIGenratedReportEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "AI Generated Report",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: BlocConsumer<KoulAccountBloc, KoulAccountState>(
        listener: (context, state) {
          if (state is FailureState) {
            buildSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Generating Report...",
                    style: Theme.of(context).textTheme.titleSmall,
                  )
                ],
              ),
            );
          }
          if (state is AIReportState) {
            final title = state.report.split("\n")[0];
            final content = state.report.replaceAll(title, "");
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: title,
                          style: Theme.of(context).textTheme.titleSmall),
                      TextSpan(
                          text: content,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: Text("Something went wrong"),
          );
        },
      ),
    );
  }
}
