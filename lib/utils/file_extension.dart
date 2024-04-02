import 'dart:io';

extension FileExtension on File {
  String get fileName => path.split('\\').last;

  String get fileExtention => fileName.split('.').last;

  String get fileNameWithoutExtension =>
      fileName.substring(0, fileName.length - fileExtention.length - 1);
  String get pathWithoutFileName =>
      path.substring(0, path.length - fileName.length);
}
