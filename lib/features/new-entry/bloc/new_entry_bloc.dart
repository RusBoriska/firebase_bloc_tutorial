import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_bloc_tutorial/features/authentication/authentication_repository_impl.dart';
import 'package:firebase_bloc_tutorial/features/database/database_repository_impl.dart';
import 'package:firebase_bloc_tutorial/models/entry_model.dart';
import '../../../models/user_model.dart';

part 'new_entry_event.dart';
part 'new_entry_state.dart';

class NewEntryBloc extends Bloc<NewEntryEvent, NewEntryValidate> {
  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository;
  NewEntryBloc(this._authenticationRepository, this._databaseRepository)
      : super(const NewEntryValidate(
            title: "",
            text: "",
            isTitleValid: false,
            isTextValid: false,
            isNewEntryValid: false,
            isLoading: false,
            isNewEntryValidateFailed: false)) {

    on<TitleChanged>(_onTitleChanged);
    on<TextChanged>(_onTextChanged);
    on<NewEntrySubmitted>(_onNewEntrySubmitted);
    on<NewEntrySucceeded>(_onNewEntrySucceeded);
  }

  
  bool _isTitleValid(String title) {
    return title.isNotEmpty;
  }

  bool _isTextValid(String text) {
    return text.isNotEmpty;
  }


  _onTitleChanged(TitleChanged event, Emitter<NewEntryValidate> emit) {
    emit(state.copyWith(
      isNewEntrySuccessful: false,
      isNewEntryValidateFailed: false,
      errorMessage: "",
      title: event.title,
      isTitleValid: _isTitleValid(event.title),
    ));
  }

  _onTextChanged(TextChanged event, Emitter<NewEntryValidate> emit) {
    emit(state.copyWith(
      isNewEntrySuccessful: false,
      isNewEntryValidateFailed: false,
      errorMessage: "",
      text: event.text,
      isTextValid: _isTextValid(event.text),
    ));
  }
  
  _onNewEntrySubmitted(NewEntrySubmitted event, Emitter<NewEntryValidate> emit) async {
    // UserModel user as the first argument
    // UserModel user = state.user;
    // UserModel user = _authenticationRepository.getCurrentUser().first as UserModel;

    final UserModel user = await _authenticationRepository.getCurrentUser().first;
    final String? userDiary = await _authenticationRepository.retrieveUserEmail(user);


    EntryModel entry = EntryModel(
        date: DateTime.now().toString().substring(0, 19), //19 because we don't need milliseconds
        title: state.title,
        text: state.text);

          await _addEntryAndShow(event, emit, userDiary, entry);
      // await _addEntryAndShow(event, emit, entry); // Original
        // await _addEntryAndShow(event, emit, user, entry); // UserModel user as the first argument

  }

  _addEntryAndShow(
      // NewEntrySubmitted event, Emitter<NewEntryValidate> emit, EntryModel entry) async { //Original
      NewEntrySubmitted event, Emitter<NewEntryValidate> emit, userDiary, EntryModel entry) async {
      // NewEntrySubmitted event, Emitter<NewEntryValidate> emit, UserModel user, EntryModel entry) async { // UserModel user as the first argument
    emit(
      state.copyWith(errorMessage: "",
        isNewEntryValid: _isTitleValid(state.title) && _isTextValid(state.text),
        isLoading: true));
    if (state.isNewEntryValid) {
      try {
        await _databaseRepository.saveEntryData(userDiary, entry);
        // await _databaseRepository.saveEntryData(entry); // Original
        // await _databaseRepository.saveEntryData(user, entry); // UserModel user as the first argument
        // await _databaseRepository.retrieveEntryData(); // Delete most likely
        emit(state.copyWith(
            title: "",
            text: "",
            isNewEntrySuccessful: true,
            // isNewEntrySuccessful: false,
            isLoading: false,
            isNewEntryValid: false,

            // title: "",
            // text: "",
            // isTitleValid: false,
            // isTextValid: false,
            // isNewEntryValid: false,
            // isLoading: false,
            isNewEntryValidateFailed: false
        ));

      } on StateError catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isNewEntryValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isNewEntryValid: false, isNewEntryValidateFailed: true));
    }
  }


  _onNewEntrySucceeded(NewEntrySucceeded event, Emitter<NewEntryValidate> emit) {
    emit(state.copyWith(isNewEntrySuccessful: true));
  }
}
