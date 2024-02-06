import 'package:dartz/dartz.dart';
import 'package:naturix/core/di/app_module.dart';
import 'package:naturix/features/auth/domain/repo/auth_repo.dart';

import '../../../../core/errors/failure.dart';

class DeleteUserUseCase {

  AuthRepo repo = getIt<AuthRepo>();

  Future<Either<Failure, void>> call(String email,String password) async {
    return await repo.deleteUser();
  }

}