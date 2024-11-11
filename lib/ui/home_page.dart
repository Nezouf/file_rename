import 'package:file_rename/bloc/file_rename_cubit.dart';
import 'package:file_rename/bloc/option_cubit.dart';
import 'package:file_rename/ui/pick_file_page.dart';
import 'package:file_rename/ui/xml_generator_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('File Rename'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: const Text('File Rename'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<FileRenameCubit>(create: (context) => FileRenameCubit()),
                          BlocProvider<OptionCubit>(create: (context) => OptionCubit()),
                        ],
                        child: PickFilePage(),
                      ),
                    ),
                  );
                }),
            SizedBox(height: 20),
            ElevatedButton(
                child: const Text('XML Generator'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider<FileRenameCubit>(create: (context) => FileRenameCubit()),
                        ],
                        child: XmlGeneratorPage(),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
