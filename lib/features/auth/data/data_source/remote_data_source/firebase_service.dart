import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naturix/core/errors/exception.dart';
import '../../../domain/model/user_model.dart';

class FirebaseService {

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<UserModel> signInWithEmailAndPassword(
      {required String email,required String password}) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return UserModel.fromFirebase(userCredential.user);
    } catch (e) {
      throw RemoteDataException(e.toString());
    }
  }

  Future<UserModel> signUpWithEmailAndPassword({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if(userCredential.user?.uid != null) {
        await FirebaseFirestore.instance.collection('users').doc().set({
          'username': username,
          'phoneNumber': phoneNumber,
        });
      }

      if(userCredential.user != null && !userCredential.user!.emailVerified){
        await userCredential.user?.sendEmailVerification();
      }

      return UserModel.fromFirebase(userCredential.user);

    } catch (e) {
      throw RemoteDataException(e.toString());
    }
  }


  Future<void> selectWhoAmI({
    required String id,
    required String whoAmI,
  }) async {
    try {

      await FirebaseFirestore.instance.collection('users').doc(id).set({
        'whoAmI': whoAmI,
      });

    } catch (e) {
      throw RemoteDataException(e.toString());
    }
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    } catch (e) {
      throw RemoteDataException(e.toString());
    }
  }

}