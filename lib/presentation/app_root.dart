import 'package:data_mates/data/location_repository_impl.dart';
import 'package:data_mates/data/status_repository_impl.dart';
import 'package:data_mates/domain/repository/location_repository.dart';
import 'package:data_mates/domain/repository/status_repository.dart';
import 'package:data_mates/presentation/home_page.dart';
import 'package:data_mates/presentation/info/bloc/status_cubit.dart';
import 'package:data_mates/presentation/location/bloc/location_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<LocationRepository>(
              create: (context) => LocationRepositoryImpl()),
          RepositoryProvider<StatusRepository>(
              create: (context) => StatusRepositoryImpl()),
          BlocProvider<LocationCubit>(
              create: (context) => LocationCubit(
                  RepositoryProvider.of<LocationRepository>(context))),
          BlocProvider<StatusCubit>(
              create: (context) => StatusCubit(
                RepositoryProvider.of<StatusRepository>(context)
              )),
        ],
        child: const CupertinoApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
        ));
  }
}
