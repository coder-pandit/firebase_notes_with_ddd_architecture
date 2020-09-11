import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/auth/user.dart';
import '../../domain/core/value_objects.dart';

// create extension functions for FirebaseUser
extension FirebaseUserDomainX on firebase.User {
  // to domain convert uid string to User object
  User toDomain() => User(id: UniqueId.fromUniqueString(uid));
}
