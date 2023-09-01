import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_bloc_tutorial/features/authentication/authenticate_service.dart';
import 'package:firebase_bloc_tutorial/features/database/database_service.dart';

import '../../models/user_model.dart';

abstract class AuthenticationRepository {
  Stream<UserModel> getCurrentUser();
  Future<UserCredential?> signUp(UserModel user);
  Future<UserCredential?> signIn(UserModel user);
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<String?> retrieveUserName(UserModel user);
  Future<String?> retrieveUserEmail(UserModel user);
}


class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationService service = AuthenticationService();
  DatabaseService dbService = DatabaseService();

  @override
  Stream<UserModel> getCurrentUser() {
    return service.retrieveCurrentUser();
  }

  @override
  Future<UserCredential?> signUp(UserModel user) {
    try {
      return service.signUp(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(UserModel user) {
    try {
      return service.signIn(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signOut() {
    return service.signOut();
  }

  @override
  Future<void> resetPassword(String email) async {
    await service.resetPassword(email);
  }

  @override
  Future<String?> retrieveUserName(UserModel user) {
    return dbService.retrieveUserName(user);
  }

  @override
  Future<String?> retrieveUserEmail(UserModel user) {
    return dbService.retrieveUserEmail(user);
  }

}


