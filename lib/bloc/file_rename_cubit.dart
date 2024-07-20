import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_rename/models/film_file.dart';
import 'package:file_rename/utils/file_extension.dart';
import 'package:flutter/foundation.dart';

part 'file_rename_state.dart';

class FileRenameCubit extends Cubit<FileRenameState> {
  FileRenameCubit() : super(FilesPickInitial());

  List<FilmFile> filmFiles = [];

  void pickFiles() async {
    emit(LoadingFiles());
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, allowCompression: false);
    if (result != null) {
      var files = result.paths.map((path) => File(path!)).toList();
      filmFiles = files.map((file) => FilmFile.fromFile(file)).toList();
      emit(FilesPicked(filmFiles));
    }
  }

  renameFiles(List<FilmFile> filmFiles, String studio) {
    for (var filmFile in filmFiles) {
      var newFileName = studio;
      if (filmFile.filmName.isNotEmpty) {
        newFileName += ' - ${filmFile.filmName}';
      }
      if (filmFile.actorList.isNotEmpty) {
        newFileName += ' - ${filmFile.actorList.join(", ")}';
      }
      filmFile.file
          .renameSync('${filmFile.file.pathWithoutFileName}$newFileName.${filmFile.file.fileExtention}');
    }
    filmFiles.clear();
    emit(FilesPickInitial());
  }
}
