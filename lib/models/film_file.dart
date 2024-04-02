import 'dart:io';

import 'package:file_rename/utils/file_extension.dart';

class FilmFile {
  final File file;

  String filmName;
  List<String> actorList;

  FilmFile(
      {required this.file, required this.filmName, required this.actorList});
  FilmFile.fromFile(File file)
      : this(
            file: file, filmName: file.fileNameWithoutExtension, actorList: []);
}
