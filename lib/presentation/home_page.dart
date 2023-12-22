import 'package:data_mates/presentation/info/view/info_card.dart';
import 'package:data_mates/presentation/location/view/location_screen.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
        child: Stack(
      children: [
        LocationScreen(),
        Positioned(
          bottom: 0,
            left: 0,
            right: 0,
            child: InfoCard(
                appUsage: "App Usage Data",
                serverStatus: "Server Status",
                workerStatus: "Worker Status"))
      ],
    ));
  }
}
