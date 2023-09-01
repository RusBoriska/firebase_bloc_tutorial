part of 'new_entry_bloc.dart';

abstract class NewEntryState extends Equatable {
  const NewEntryState();
}

class NewEntryInitial extends NewEntryState {
  @override
  List<Object?> get props => [];
}

class NewEntryValidate extends NewEntryState {
  const NewEntryValidate(
      {required this.title,
      required this.text,
      required this.isTitleValid,
      required this.isTextValid,
      required this.isNewEntryValid,
      required this.isLoading,
      this.errorMessage = "",
      required this.isNewEntryValidateFailed,
      this.isNewEntrySuccessful = false});

  final String title;
  final String text;
  final bool isTitleValid;
  final bool isTextValid;
  final bool isNewEntryValid;
  final bool isNewEntryValidateFailed;
  final bool isLoading;
  final String errorMessage;
  final bool isNewEntrySuccessful;

  NewEntryValidate copyWith(
      {String? title,
      String? text,
      bool? isTitleValid,
      bool? isTextValid,
      bool? isNewEntryValid,
      bool? isLoading,
      String? errorMessage,
      bool? isNewEntryValidateFailed,
      bool? isNewEntrySuccessful}) {
    return NewEntryValidate(
        title: title ?? this.title,
        text: text ?? this.text,
        isTitleValid: isTitleValid ?? this.isTitleValid,
        isTextValid: isTextValid ?? this.isTextValid,
        isNewEntryValid: isNewEntryValid ?? this.isNewEntryValid,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isNewEntryValidateFailed: isNewEntryValidateFailed ?? this.isNewEntryValidateFailed,
        isNewEntrySuccessful: isNewEntrySuccessful ?? this.isNewEntrySuccessful);
  }

  @override
  List<Object?> get props => [
        title,
        text,
        isTitleValid,
        isTextValid,
        isNewEntryValid,
        isLoading,
        errorMessage,
        isNewEntryValidateFailed,
        isNewEntrySuccessful
      ];
}
