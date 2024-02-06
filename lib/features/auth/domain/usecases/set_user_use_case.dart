import 'package:dartz/dartz.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/features/auth/domain/model/user_model.dart';
import 'package:naturix/features/auth/domain/repo/auth_repo.dart';

import '../../../../core/errors/failure.dart';

class SetUserUseCase {

  AuthRepo repo = getIt<AuthRepo>();

  Future<Either<Failure, void>> call(UserModel userModel) async {
    return await repo.setUser(userModel: userModel);
  }

}