import 'package:get_it/get_it.dart';
import 'package:naturix/features/auth/data/data_source/local_data_soucre/auth_local_data_source.dart';
import 'package:naturix/features/auth/data/repo/auth_repo_impl.dart';
import 'package:naturix/features/auth/domain/repo/auth_repo.dart';
import 'package:naturix/features/auth/domain/usecases/delete_user_use_case.dart';
import 'package:naturix/features/auth/domain/usecases/get_user_use_case.dart';
import 'package:naturix/features/auth/domain/usecases/register_use_case.dart';
import 'package:naturix/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:naturix/features/auth/domain/usecases/select_who_am_i_use_case.dart';
import 'package:naturix/features/auth/domain/usecases/set_user_use_case.dart';
import 'package:naturix/features/auth/domain/usecases/sign_in_use_case.dart';
import '../../features/auth/data/data_source/remote_data_source/firebase_service.dart';
import '../infrastructure/services/network_service.dart';

final GetIt getIt = GetIt.instance;

abstract class AppModule {

  static void setup() {

    //services
    getIt.registerSingleton<NetworkService>(NetworkServiceImpl());

    //data source
    getIt.registerSingleton<FirebaseService>(FirebaseService());
    getIt.registerSingleton<AuthLocalDataSource>(AuthLocalDataSourceImpl());
    getIt<AuthLocalDataSource>().initHive();

    //repos
    getIt.registerSingleton<AuthRepo>(AuthRepoImpl());

    //use case
    getIt.registerSingleton<GetUserUseCase>(GetUserUseCase());
    getIt.registerSingleton<SetUserUseCase>(SetUserUseCase());
    getIt.registerSingleton<DeleteUserUseCase>(DeleteUserUseCase());

    getIt.registerSingleton<SignInUseCase>(SignInUseCase());
    getIt.registerSingleton<RegisterUseCase>(RegisterUseCase());
    getIt.registerSingleton<ResetPasswordUseCase>(ResetPasswordUseCase());
    getIt.registerSingleton<SelectWhoAmIUseCase>(SelectWhoAmIUseCase());




  }


}

