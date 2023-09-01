import 'package:firebase_bloc_tutorial/models/user_model.dart';
import 'package:firebase_bloc_tutorial/models/entry_model.dart';

import 'database_service.dart';

abstract class DatabaseRepository {
  //For Users
  Future<void> saveUserData(UserModel user);
  Future<List<UserModel>> retrieveUserData();

  //For Diary entries

  // UserModel user as the first argument
  // Future<void> saveEntryData(UserModel user, EntryModel entry);

// Original
//   Future<void> saveEntryData(EntryModel entry);


    Future<void> saveEntryData(String userDiary, EntryModel entry);


    // Future<void> deleteEntryData(String userDiary, EntryModel entry);

    Future<void> deleteEntryData(String userDiary, String uid);





// Original
//   Future<List<EntryModel>> retrieveEntryData();


  Future<List<EntryModel>> retrieveEntryData(String userDiary);


}


class DatabaseRepositoryImpl implements DatabaseRepository {
  DatabaseService service = DatabaseService();

  //For Users
  @override
  Future<void> saveUserData(UserModel user) {
    return service.addUserData(user);
  }

  @override
  Future<List<UserModel>> retrieveUserData() {
    return service.retrieveUserData();
  }

  //For Diary entries

  // UserModel user as the first argument
  // @override
  // Future<void> saveEntryData(UserModel user, EntryModel entry) {
  //   return service.addEntryData(user, entry);
  // }


  @override
  Future<void> saveEntryData(String userDiary, EntryModel entry) {
    return service.addEntryData(userDiary, entry);
  }


  // @override
  // Future<void> deleteEntryData(String userDiary, EntryModel entry) {
  //   return service.deleteEntryData(userDiary, entry);
  // }


  @override
  Future<void> deleteEntryData(String userDiary, String uid) {
    return service.deleteEntryData(userDiary, uid);
  }





  @override
  Future<List<EntryModel>> retrieveEntryData(String userDiary) {
    return service.retrieveEntryData(userDiary);
  }

// Original
//   @override
//   Future<List<EntryModel>> retrieveEntryData() {
//     return service.retrieveEntryData();
//   }

}

