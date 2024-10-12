import 'package:flutter/material.dart';
import 'package:koul_network/UI/home/more/widget/build_tiles.dart';
import 'package:koul_network/UI/home/usage/screens/ai_report.dart';
import 'package:koul_network/UI/home/usage/screens/usage.dart';

class UsageTab extends StatelessWidget {
  const UsageTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Usage",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          buildTiles(
            context: context,
            text: "Usage",
            icon: Icons.data_usage,
            onTap: () {
              Navigator.of(context).pushNamed(UsageScreen.routeName);
            },
          ),
          buildTiles(
            context: context,
            text: "AI Report",
            icon: Icons.file_copy,
            onTap: () {
              Navigator.of(context).pushNamed(AiReport.routeName);
            },
          ),
          buildTiles(
            context: context,
            text: "Credit Score",
            icon: Icons.score,
            onTap: () {
              Navigator.of(context).pushNamed(AiReport.routeName);
            },
          ),
        ],
      ),
    );
  }
}
