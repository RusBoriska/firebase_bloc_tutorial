part of 'database_bloc.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}


class DatabaseFetched extends DatabaseEvent {
  final String? displayName;
  const DatabaseFetched(this.displayName);
  @override
  List<Object?> get props => [displayName];
}


class EntrySelected extends DatabaseEvent {
  final int selectedIndex;
  const EntrySelected(this.selectedIndex);
  @override
  List<Object?> get props => [selectedIndex];
}

// EntryModel as deletedEntry
// class EntryDeleteRequest extends DatabaseEvent {
//   final EntryModel deletedEntry;
//   const EntryDeleteRequest(this.deletedEntry);
//   @override
//   List<Object?> get props => [deletedEntry];
// }



class EntryDeleteRequest extends DatabaseEvent {
  final String uid;
  const EntryDeleteRequest(this.uid);
  @override
  List<Object?> get props => [uid];
}