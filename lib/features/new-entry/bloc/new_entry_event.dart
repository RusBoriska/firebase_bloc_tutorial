part of 'new_entry_bloc.dart';

abstract class NewEntryEvent extends Equatable {
  const NewEntryEvent();

  @override
  List<Object> get props => [];
}

class TitleChanged extends NewEntryEvent {
  final String title;
  const TitleChanged(this.title);

  @override
  List<Object> get props => [title];
}

class TextChanged extends NewEntryEvent {
  final String text;
  const TextChanged(this.text);

  @override
  List<Object> get props => [text];
}

class NewEntrySubmitted extends NewEntryEvent {
  const NewEntrySubmitted();

  @override
  List<Object> get props => [];
}

class NewEntrySucceeded extends NewEntryEvent {
  const NewEntrySucceeded();

  @override
  List<Object> get props => [];
}
