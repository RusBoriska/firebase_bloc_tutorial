part of 'database_bloc.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();
  
  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseSuccess extends DatabaseState {
  final List<UserModel> listOfUserData;
  final List<EntryModel> listOfEntryData;
  final String? displayName;

  const DatabaseSuccess(this.listOfUserData, this.listOfEntryData, this.displayName);

  @override
  List<Object?> get props => [listOfUserData, listOfEntryData, displayName];
}


class SelectedEntryLoaded extends DatabaseState {
  final List<EntryModel> listOfEntryData;
  final int selectedIndex;

  const SelectedEntryLoaded(this.listOfEntryData, this.selectedIndex);

  @override
  List<Object?> get props => [listOfEntryData, selectedIndex];

}






// class DatabaseSuccess extends DatabaseState {
//   final List<UserModel> listOfUserData;
//   final List<EntryModel> listOfEntryData;
//   final String? displayName;
//   final int selectedIndex;
//
//   const DatabaseSuccess(this.listOfUserData, this.listOfEntryData, this.displayName, this.selectedIndex);
//
//   @override
//   List<Object?> get props => [listOfUserData, listOfEntryData, displayName, selectedIndex];
// }




class DatabaseError extends DatabaseState {
      @override
  List<Object?> get props => [];
}
