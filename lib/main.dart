import 'package:file_rename/bloc/file_rename_cubit.dart';
import 'package:file_rename/bloc/option_cubit.dart';
import 'package:file_rename/ui/pick_file_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<FileRenameCubit>(
            create: (context) => FileRenameCubit(),
          ),
          BlocProvider<OptionCubit>(
            create: (context) => OptionCubit(),
          ),
        ],
        child: PickFilePage(),
      ),
    );
  }
}
