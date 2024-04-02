part of 'file_rename_cubit.dart';

@immutable
sealed class FileRenameState {}

final class FilesPickInitial extends FileRenameState {}

final class FilesPicked extends FileRenameState {
  final List<FilmFile> filmFiles;

  FilesPicked(this.filmFiles);
}

final class LoadingFiles extends FileRenameState {}
