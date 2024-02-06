import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:naturix/core/config/app_consts.dart';
import 'package:naturix/core/errors/exception.dart';
import 'package:naturix/features/auth/domain/model/user_model.dart';

abstract class AuthLocalDataSource {

  Future<UserModel?> getUserDetails();

  Future<void> setUserDetails(UserModel userModel);

  Future<void> deleteUserDetails();

  Future<void> initHive();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {

  Future<Box> get box async {
    return await Hive.openBox(AppConsts.boxName);
  }

  @override
  Future<void> initHive() async {
    final documentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(documentDirectory.path);
    Hive.registerAdapter(UserModelAdapter());
  }

  @override
  Future<void> deleteUserDetails() async {
    try{
      await box.then((value) => value.delete(
        AppConsts.userKey,
      ));
    }catch(e){
      throw LocalDataException(e.toString());
    }

  }

  @override
  Future<UserModel?> getUserDetails() async {
    try {
      return box.then((value) => value.get(
        AppConsts.userKey,
      ));
    } catch (e) {
      throw LocalDataException(e.toString());
    }
  }

  @override
  Future<void> setUserDetails(UserModel userModel) async {
    try {
      await box.then((value) {
        value.put(
            AppConsts.userKey,
            userModel
        );
        value.flush();
      });
    } catch (e) {
      throw LocalDataException(e.toString());
    }
  }


}