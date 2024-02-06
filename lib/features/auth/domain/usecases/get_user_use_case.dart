import 'package:dartz/dartz.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/features/auth/domain/model/user_model.dart';
import 'package:naturix/features/auth/domain/repo/auth_repo.dart';

import '../../../../core/errors/failure.dart';

class GetUserUseCase {

  AuthRepo repo = getIt<AuthRepo>();

  Future<Either<Failure, UserModel?>> call() async {
    return await repo.getUser();
  }

}