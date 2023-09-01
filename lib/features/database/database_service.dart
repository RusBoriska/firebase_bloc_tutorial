import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_bloc_tutorial/models/user_model.dart';
import 'package:firebase_bloc_tutorial/models/entry_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // For Users
    addUserData(UserModel userData) async {
    await _db.collection("Users").doc(userData.uid).set(userData.toMap());
  }

    Future<List<UserModel>> retrieveUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
    }

        Future<String> retrieveUserName(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user.uid).get();
    return snapshot.data()!["displayName"];
    }

        Future<String> retrieveUserEmail(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Users").doc(user.uid).get();
    return snapshot.data()!["email"];
  }


  // For Diary entries

  //UserModel user as the first argument
  // Future<void> addEntryData(UserModel user, EntryModel entryData) async {
  //     final userDiary = retrieveUserEmail(user);
  //     await _db.collection(userDiary as String).doc(entryData.uid).set(entryData.toMap());
  // }


  // String as the first argument
  addEntryData(String userDiary, EntryModel entryData) async {
    await _db.collection(userDiary).doc(entryData.uid).set(entryData.toMap());
  }

  // EntryModel as entryData
  // deleteEntryData(String userDiary, EntryModel entryData) async {
  //   await _db.collection(userDiary).doc(entryData.uid).delete();
  // }


  deleteEntryData(String userDiary, String uid) async {
    await _db.collection(userDiary).doc(uid).delete();
  }


  // Original
  // addEntryData(EntryModel entryData) async {
  //   await _db.collection("Diaries").doc(entryData.uid).set(entryData.toMap());
  // }

  // Original
  // Future<List<EntryModel>> retrieveEntryData() async {
  //   QuerySnapshot<Map<String, dynamic>> snapshot =
  //   // await _db.collection("Diaries").get();
  //   await _db.collection("Diaries").orderBy("date").get();
  //   return snapshot.docs
  //       .map((docSnapshot) => EntryModel.fromDocumentSnapshot(docSnapshot))
  //       .toList();
  // }


  // String as an argument
  Future<List<EntryModel>> retrieveEntryData(String userDiary) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(userDiary).orderBy("date").get();
    return snapshot.docs
        .map((docSnapshot) => EntryModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  // Retrieve first 10 entries
  Future<List<EntryModel>> retrieveEntryDataFirst(String userDiary) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection(userDiary).orderBy("date").limit(10).get();
    return snapshot.docs
        .map((docSnapshot) => EntryModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }


  // Retrieve next 10 entries
  Future<List<EntryModel>> retrieveEntryDataNext(String userDiary) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection(userDiary).orderBy("date").startAfter([10]).limit(10).get();
    // final lastVisible = documentSnapshots.docs[documentSnapshots.size - 1];
    // await _db.collection(userDiary).orderBy("date").startAfter([lastVisible]).limit(10).get(); // Original
    return snapshot.docs
        .map((docSnapshot) => EntryModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }




}
