import 'package:dartz/dartz.dart';
import 'package:naturix/core/errors/failure.dart';
import 'package:naturix/features/auth/domain/model/user_model.dart';

abstract class AuthRepo {

  Future<Either<Failure,UserModel>> signIn({required String email,required String password});

  Future<Either<Failure,UserModel>> register({required String email,required String password,required String username,required String phoneNumber});

  Future<Either<Failure,void>> selectWhoAmI({required String id,required String whoAmI});

  Future<Either<Failure,void>> resetPassword({required String email,});

  Future<Either<Failure,UserModel?>> getUser();

  Future<Either<Failure,void>> deleteUser();

  Future<Either<Failure,void>> setUser({required UserModel userModel,});

}