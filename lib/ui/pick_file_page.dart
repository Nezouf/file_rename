import 'package:file_rename/bloc/file_rename_cubit.dart';
import 'package:file_rename/bloc/option_cubit.dart';
import 'package:file_rename/models/film_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'component/film_tile.dart';

class PickFilePage extends StatelessWidget {
  PickFilePage({super.key});

  var studio = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('File Rename'),
      ),
      body: _buildBlocListener(
        context: context,
        child: BlocBuilder<FileRenameCubit, FileRenameState>(
          builder: (context, state) {
            switch (state) {
              case FilesPickInitial _:
                return _buildBodyPickFiles(context);
              case LoadingFiles _:
                return _buildBodyLoadingFiles();
              case FilesPicked filesPicked:
                return _buildBodyFilesPicked(context, filesPicked.filmFiles);
              default:
                return const SizedBox();
            }
          },
        ),
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

  Widget _buildBodyFilesPicked(
          BuildContext context, List<FilmFile> filmFiles) =>
      Column(children: [
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.read<FileRenameCubit>().pickFiles();
          },
          child: const Text('Pick another file'),
        ),
        const SizedBox(height: 20),
        _buildAutocomplete(
          context: context,
          optionType: OptionType.studio,
          onChange: (String option) {
            studio = option;
          },
        ),
        const SizedBox(height: 20),
        ..._buildFilmFileList(context: context, filmFiles: filmFiles),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (!context
                .read<OptionCubit>()
                .getOptionList(OptionType.studio)
                .any((String element) =>
                    element.toLowerCase().contains(studio))) {
              context
                  .read<OptionCubit>()
                  .createOption(studio, OptionType.studio);
            }
            context.read<FileRenameCubit>().renameFiles(filmFiles, studio);
          },
          child: const Text('Validate'),
        ),
      ]);

  List<Widget> _buildFilmFileList(
          {required BuildContext context, required List<FilmFile> filmFiles}) =>
      [
        for (final filmFile in filmFiles)
          FilmTile(
            filmFile: filmFile,
          )
      ];

  Widget _buildBlocListener(
          {required BuildContext context, required Widget child}) =>
      BlocListener<FileRenameCubit, FileRenameState>(
        listener: (context, state) {
          if (state is FilesPicked) {
            context.read<OptionCubit>().loadOptionsFromFiles();
          }
        },
        child: child,
      );

  Widget _buildAutocomplete(
          {required BuildContext context,
          required OptionType optionType,
          required Function(String) onChange}) =>
      SizedBox(
        width: 300,
        child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            final optionList =
                context.read<OptionCubit>().getOptionList(optionType);
            return optionList.where((option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            }).toList();
          },
          fieldViewBuilder: (BuildContext context,
              TextEditingController fieldTextEditingController,
              FocusNode fieldFocusNode,
              VoidCallback onFieldSubmitted) {
            // Implement the text field UI
            return TextField(
              controller: fieldTextEditingController,
              focusNode: fieldFocusNode,
              decoration: InputDecoration(
                labelText: optionType.name,
              ),
              onChanged: onChange,
              onSubmitted: (String value) {
                onFieldSubmitted();
              },
            );
          },
          onSelected: onChange,
        ),
      );
}
