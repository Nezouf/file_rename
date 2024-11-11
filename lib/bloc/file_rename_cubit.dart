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
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, allowCompression: false);
    if (result != null) {
      var files = result.paths.map((path) => File(path!)).toList();
      filmFiles = files.map((file) => FilmFile.fromFile(file)).toList();
      emit(FilesPicked(filmFiles));
    } else {
      emit(FilesPickInitial());
    }
  }

  renameFiles(List<FilmFile> filmFiles, String studio) {
    for (var filmFile in filmFiles) {
      var newFileName = '[$studio]';
      if (filmFile.filmName.isNotEmpty) {
        newFileName += ' ${filmFile.filmName}';
      }
      if (filmFile.actorList.isNotEmpty) {
        newFileName += ' - ${filmFile.actorList.join(", ")}';
      }
      filmFile.file.renameSync('${filmFile.file.pathWithoutFileName}$newFileName.${filmFile.file.fileExtention}');
    }
    filmFiles.clear();
    emit(FilesPickInitial());
  }

  generateXmlFile(List<File> files) {
    RegExp regExp = RegExp(r'\[(.*?)\]\s*(.*?)\s*-\s*(.*)');
    for (var file in files) {
      RegExpMatch? match = regExp.firstMatch(file.fileNameWithoutExtension);
      if (match != null) {
        final studio = match.group(1) ?? '';
        final film = match.group(2) ?? '';
        final acteursString = match.group(3) ?? '';
        List<String> acteurs = acteursString.split(RegExp(r',\s*|\s+and\s+')).map((acteur) => acteur.trim()).toList();
        var xml = '';
        xml += '<movie>\n';
        xml += '  <title>${film}</title>\n';
        xml += '  <originaltitle></originaltitle>\n';
        xml += '  <sorttitle></sorttitle>\n';
        xml += '  <set></set>\n';
        xml += '  <rating></rating>\n';
        xml += '  <releasedate>2000-06-15</releasedate>\n';
        xml += '  <plot></plot>\n';
        xml += '  <tagline></tagline>\n';
        xml += '  <mpaa></mpaa>\n';
        xml += '  <genre></genre>\n';
        xml += '  <writer></writer>\n';
        xml += '  <studio>$studio</studio>\n';
        xml += '  <director></director>\n';
        for (var actor in acteurs) {
          xml += '  <actor>\n';
          xml += '    <name>$actor</name>\n';
          xml += '    <role></role>\n';
          xml += '    <thumb></thumb>\n';
          xml += '  </actor>\n';
        }
        xml += '</movie>\n';
        File('${file.pathWithoutFileName}${file.fileNameWithoutExtension}.xml').writeAsStringSync(xml);
      }
    }
  }
}
