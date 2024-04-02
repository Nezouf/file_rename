import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_rename/config/config.dart';
import 'package:meta/meta.dart';

part 'option_state.dart';

enum OptionType { actor, studio }

class OptionCubit extends Cubit<OptionState> {
  OptionCubit() : super(OptionInitial());

  List<String> actorList = [];
  List<String> studioList = [];

  void loadOptionsFromFiles() async {
    emit(LoadingOption());
    actorList = File(actorListPath).readAsLinesSync();
    studioList = File(studioListPath).readAsLinesSync();
    emit(OptionLoaded());
  }

  List<String> getOptionList(OptionType optionType) {
    switch (optionType) {
      case OptionType.actor:
        return actorList;
      case OptionType.studio:
        return studioList;
    }
  }
}
