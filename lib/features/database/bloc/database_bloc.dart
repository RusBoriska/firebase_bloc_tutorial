import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_bloc_tutorial/models/entry_model.dart';
import 'package:firebase_bloc_tutorial/models/user_model.dart';
import 'package:firebase_bloc_tutorial/features/authentication/authentication_repository_impl.dart';
import '../database_repository_impl.dart';


part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  // Original
  // final DatabaseRepository _databaseRepository;
  // DatabaseBloc(this._databaseRepository) : super(DatabaseInitial()) {

    final AuthenticationRepository _authenticationRepository;
    final DatabaseRepository _databaseRepository;
    DatabaseBloc(this._authenticationRepository, this._databaseRepository) : super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
    on<EntrySelected>(_loadSelectedEntry);
    on<EntryDeleteRequest>(_deleteEntry);
  }

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
      // final UserModel user = await _authenticationRepository.getCurrentUser().first;
      // final String? userDiary = await _authenticationRepository.retrieveUserEmail(user);
      // List<UserModel> listofUserData = await _databaseRepository.retrieveUserData();
      // List<EntryModel> listOfEntryData = await _databaseRepository.retrieveEntryData(userDiary!);

      List<EntryModel> listOfEntryData = await _retrieveEntryData();
      List<UserModel> listofUserData = await _databaseRepository.retrieveUserData();

      // List<EntryModel> listOfEntryData = await _databaseRepository.retrieveEntryData();  // Original
      // List<EntryModel> listOfEntryData = await _databaseRepository.retrieveEntryData(event.user);
      emit(DatabaseSuccess(listofUserData, listOfEntryData, event.displayName));
      // emit(DatabaseSuccess(listofUserData, listOfEntryData, event.displayName, event.selectedIndex));
  }


  _loadSelectedEntry(EntrySelected event, Emitter<DatabaseState> emit) async {
    // final UserModel user = await _authenticationRepository.getCurrentUser().first;
    // final String? userDiary = await _authenticationRepository.retrieveUserEmail(user);
    // List<UserModel> listofUserData = await _databaseRepository.retrieveUserData();
    // List<EntryModel> listOfEntryData = await _databaseRepository.retrieveEntryData(userDiary!);

    List<EntryModel> listOfEntryData = await _retrieveEntryData();
    // List<UserModel> listofUserData = await _databaseRepository.retrieveUserData();

    // List<EntryModel> listOfEntryData = await _databaseRepository.retrieveEntryData(); // Original
    // List<EntryModel> listOfEntryData = await _databaseRepository.retrieveEntryData(event.user); //Error, I guess
    emit(SelectedEntryLoaded(listOfEntryData, event.selectedIndex));
    // emit(SelectedEntryLoaded(listofUserData, listOfEntryData, event.displayName, event.selectedIndex));
    // emit(DatabaseSuccess(listofUserData, listOfEntryData, event.displayName, event.selectedIndex));
  }


    Future<List<EntryModel>> _retrieveEntryData() async {
    // Future<List<EntryModel>> _retrieveUserAndEntryDate (event, Emitter<DatabaseState> emit) async {
    final UserModel user = await _authenticationRepository.getCurrentUser().first;
    final String? userDiary = await _authenticationRepository.retrieveUserEmail(user);
    List<EntryModel> listOfEntryData = await _databaseRepository.retrieveEntryData(userDiary!);
    return listOfEntryData;
}

    _deleteEntry(EntryDeleteRequest event, Emitter<DatabaseState> emit) async {
      List<EntryModel> listOfEntryData = await _retrieveEntryData();
      List<UserModel> listofUserData = await _databaseRepository.retrieveUserData();
      final UserModel user = await _authenticationRepository.getCurrentUser().first;
      final String? userDiary = await _authenticationRepository.retrieveUserEmail(user);
      await _databaseRepository.deleteEntryData(userDiary!, event.uid);
      emit(DatabaseSuccess(listofUserData, listOfEntryData, event.uid));
    }





}
