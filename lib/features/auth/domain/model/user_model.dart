import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? email;

  @HiveField(2)
  String? name;

  @HiveField(3)
  String? urlPhoto;

  @HiveField(4)
  String? phoneNumber;

  @HiveField(5)
  bool? isVerified;

  UserModel(this.id,this.email, this.name, this.urlPhoto, this.phoneNumber);

  UserModel.fromFirebase(User? user){
    id = user?.uid;
    email = user?.email ;
    name = user?.displayName;
    urlPhoto = user?.photoURL;
    phoneNumber = user?.phoneNumber;
    isVerified = user?.emailVerified;
  }



}