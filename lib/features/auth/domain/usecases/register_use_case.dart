import 'package:dartz/dartz.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/features/auth/domain/model/user_model.dart';
import 'package:naturix/features/auth/domain/repo/auth_repo.dart';

import '../../../../core/errors/failure.dart';

class RegisterUseCase {

  AuthRepo repo = getIt<AuthRepo>();

  Future<Either<Failure, UserModel>> call(String email,String password,String username,String phoneNumber) async {
    return await repo.register(email: email, password: password, username: username, phoneNumber: phoneNumber);
  }

}