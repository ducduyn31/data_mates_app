import 'package:app_usage/app_usage.dart';
import 'package:data_mates/domain/model/info_status.dart';
import 'package:data_mates/presentation/info/bloc/status_cubit.dart';
import 'package:data_mates/utils/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfoCard extends StatefulWidget {
  final String appUsage;
  final String serverStatus;
  final String workerStatus;

  const InfoCard({
    Key? key,
    required this.appUsage,
    required this.serverStatus,
    required this.workerStatus,
  }) : super(key: key);

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(const Duration(hours: 1));
      await AppUsage().getAppUsage(startDate, endDate);
    } on AppUsageException catch (exception) {
      DMLogger().e(exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'App Usage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<StatusCubit, InfoStatus>(builder: (context, status) {
              if (!status.serverStatus) {
                return const CupertinoButton(
                  onPressed: null,
                  child: Text("Network Error"),
                );
              }
              if (!status.workerStatus) {
                return CupertinoButton(
                  onPressed: () {
                    _getUsageStats();
                    RepositoryProvider.of<StatusCubit>(context)
                        .updateStatus();
                  },
                  color: Colors.blue,
                  child: const Text('Start'),
                );
              }
              return CupertinoButton(
                onPressed: () {
                  _getUsageStats();
                },
                color: Colors.blue,
                child: const Text('Tracking'),
              );
            }),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Row(
                  children: [
                    const Text(
                      'Server Status: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    BlocBuilder<StatusCubit, InfoStatus>(
                        builder: (context, status) {
                      return FadeTransition(
                          opacity: _animation,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: status.serverStatus
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ));
                    })
                  ],
                ),
                const Spacer(
                  flex: 2,
                ),
                Row(
                  children: [
                    const Text(
                      'Worker Status: ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    BlocBuilder<StatusCubit, InfoStatus>(
                        builder: (context, status) {
                      return FadeTransition(
                          opacity: _animation,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: status.workerStatus
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ));
                    })
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
