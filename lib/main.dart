import 'package:down/cubit/cubit/get_data_cubit.dart';
import 'package:down/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetDataCubit>(
          create: (context) => GetDataCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'YouTube to Audio Downloader',
        theme: ThemeData(),
        home: HomePageScreen(),
      ),
    );
  }
}

Future<void> requestPermissions() async {
  // Check the current status of the permissions
  Map<Permission, PermissionStatus> statuses = await [
    Permission.storage,
    Permission.manageExternalStorage, // For API level 30 and above
  ].request();

  // Check if the permissions are granted
  if (statuses[Permission.storage]!.isGranted &&
      statuses[Permission.manageExternalStorage]!.isGranted) {
    print("Permissions granted");
  } else {
    print("Permissions denied. Requesting permissions...");
    // Request permissions again
    statuses = await [
      Permission.storage,
      Permission.manageExternalStorage,
    ].request();
  }
}
