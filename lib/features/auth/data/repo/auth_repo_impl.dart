import 'package:dartz/dartz.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/core/errors/failure.dart';
import 'package:naturix/core/infrastructure/services/network_service.dart';
import 'package:naturix/features/auth/data/data_source/local_data_soucre/auth_local_data_source.dart';
import 'package:naturix/features/auth/data/data_source/remote_data_source/firebase_service.dart';
import 'package:naturix/features/auth/domain/model/user_model.dart';
import 'package:naturix/features/auth/domain/repo/auth_repo.dart';

import '../../../../core/errors/exception.dart';

class AuthRepoImpl implements AuthRepo {

  NetworkService networkService = getIt<NetworkService>();
  FirebaseService remoteDataSource = getIt<FirebaseService>();
  AuthLocalDataSource localDataSource = getIt<AuthLocalDataSource>();


  @override
  Future<Either<Failure,UserModel>> register({required String email,required String password,required String username,required String phoneNumber}) async {
    try{

      if(!await networkService.isConnected){
        return left(ServiceFailure(
            "Please check your internet connection",
            failureCode: 0
        ));
      }

      UserModel user = await remoteDataSource.signUpWithEmailAndPassword(
          email: email,
          password: password,
          username: username,
          phoneNumber: phoneNumber
      );

      if(user.id == null){
        return left(RemoteDataFailure(
            "Failed to sign up, please try again later",
            failureCode: 1
        ));
      }

      return right(user);

    } on RemoteDataException catch (e){
      return left(RemoteDataFailure(e.message, failureCode: 2));

    } on ServiceException catch (e){
      return left(ServiceFailure(e.message,failureCode: 3));

    } catch (e) {
      return left(InternalFailure(e.toString(),failureCode: 4));
    }
  }

  @override
  Future<Either<Failure,UserModel>> signIn({required String email, required String password}) async {
    try{

      if(!await networkService.isConnected){
        return left(ServiceFailure(
            "Please check your internet connection",
            failureCode: 0
        ));
      }

      UserModel user = await remoteDataSource.signInWithEmailAndPassword(email:email, password:password);

      if(user.id == null){
        return left(RemoteDataFailure(
            "Failed to sign in, please try again later",
            failureCode: 1
        ));
      }

      return right(user);

    }on RemoteDataException catch (e){
      return left(RemoteDataFailure(e.message, failureCode: 2));

    } on ServiceException catch (e){
      return left(ServiceFailure(e.message,failureCode: 3));

    } catch (e) {
      return left(InternalFailure(e.toString(),failureCode: 4));
    }

  }

  @override
  Future<Either<Failure, void>> resetPassword({required String email,}) async {
    try{

      if(!await networkService.isConnected){
        return left(ServiceFailure(
            "Please check your internet connection",
            failureCode: 0
        ));
      }

      await remoteDataSource.resetPassword(email:email);

      return right(null);

    }on RemoteDataException catch (e){
      return left(RemoteDataFailure(e.message, failureCode: 2));

    } on ServiceException catch (e){
      return left(ServiceFailure(e.message,failureCode: 3));

    } catch (e) {
      return left(InternalFailure(e.toString(),failureCode: 4));
    }
  }

  @override
  Future<Either<Failure, void>> selectWhoAmI({required String id, required String whoAmI}) async {
    try{

      if(!await networkService.isConnected){
        return left(ServiceFailure(
            "Please check your internet connection",
            failureCode: 0
        ));
      }

      await remoteDataSource.selectWhoAmI(id: id, whoAmI: whoAmI);

      return right(null);

    }on RemoteDataException catch (e){
      return left(RemoteDataFailure(e.message, failureCode: 2));

    } on ServiceException catch (e){
      return left(ServiceFailure(e.message,failureCode: 3));

    } catch (e) {
      return left(InternalFailure(e.toString(),failureCode: 4));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser() async {
    try{

      await localDataSource.deleteUserDetails();
      return right(null);

    }on LocalDataException catch (e){
      return left(RemoteDataFailure(e.message, failureCode: 2));

    } on ServiceException catch (e){
      return left(ServiceFailure(e.message,failureCode: 3));

    } catch (e) {
      return left(InternalFailure(e.toString(),failureCode: 4));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getUser() async {
    try{

      var user = await localDataSource.getUserDetails();

      return right(user);

    }on LocalDataException catch (e){
      return left(RemoteDataFailure(e.message, failureCode: 2));

    } on ServiceException catch (e){
      return left(ServiceFailure(e.message,failureCode: 3));

    } catch (e) {
      return left(InternalFailure(e.toString(),failureCode: 4));
    }
  }

  @override
  Future<Either<Failure, void>> setUser({required UserModel userModel}) async{
    try{
      await localDataSource.setUserDetails(userModel);

      return right(null);

    }on LocalDataException catch (e){
      return left(RemoteDataFailure(e.message, failureCode: 2));

    } on ServiceException catch (e){
      return left(ServiceFailure(e.message,failureCode: 3));

    } catch (e) {
      return left(InternalFailure(e.toString(),failureCode: 4));
    }
  }
}