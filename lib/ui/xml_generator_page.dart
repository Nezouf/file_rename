import 'package:file_rename/bloc/file_rename_cubit.dart';
import 'package:file_rename/models/film_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class XmlGeneratorPage extends StatelessWidget {
  const XmlGeneratorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('XML Generator'),
      ),
      body: BlocBuilder<FileRenameCubit, FileRenameState>(
        builder: (context, state) {
          return switch (state) {
            FilesPickInitial() => _buildBodyPickFiles(context),
            LoadingFiles() => _buildBodyLoadingFiles(),
            FilesPicked filesPicked => _buildBodyFilesPicked(context, filesPicked.filmFiles),
            _ => const SizedBox(),
          };
        },
      ),
    );
  }

  Widget _buildBodyPickFiles(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Please pick a file to rename:'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<FileRenameCubit>().pickFiles();
              },
              child: const Text('Pick a file'),
            ),
          ],
        ),
      );

  Widget _buildBodyLoadingFiles() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget _buildBodyFilesPicked(BuildContext context, List<FilmFile> filmFiles) => Column(
        children: [
          for (var filmFile in filmFiles) Text(filmFile.filmName),
          ElevatedButton(
            onPressed: () {
              context.read<FileRenameCubit>().generateXmlFile(filmFiles.map((e) => e.file).toList());
            },
            child: const Text('Generate XML'),
          ),
        ],
      );
}
