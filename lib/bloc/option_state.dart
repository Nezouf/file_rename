part of 'option_cubit.dart';

@immutable
sealed class OptionState {}

final class OptionInitial extends OptionState {}

final class OptionLoaded extends OptionState {
  OptionLoaded();
}

final class LoadingOption extends OptionState {}
