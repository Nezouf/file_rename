import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_rename/config/config.dart';
import 'package:flutter/material.dart';

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

  void createOption(String option, OptionType optionType){
    File(getOptionPath(optionType)).writeAsStringSync(Platform.lineTerminator + option, mode: FileMode.append);
  }

  List<String> getOptionList(OptionType optionType) {
    switch (optionType) {
      case OptionType.actor:
        return actorList;
      case OptionType.studio:
        return studioList;
    }
  }

  String getOptionPath(OptionType optionType) => switch(optionType) {
    OptionType.actor => actorListPath,
    OptionType.studio => studioListPath
  };
}
