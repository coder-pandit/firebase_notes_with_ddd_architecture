import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_notes/domain/auth/i_auth_facade.dart';
import 'package:my_notes/domain/core/errors.dart';
import 'package:my_notes/injection.dart';

extension FirestoreX on Firestore {
  Future<DocumentReference> userDocument() async {
    final useerOption = await getIt<IAuthFacade>().getSignedInUser();
    final user = useerOption.getOrElse(() => throw NotAuthenticatedError());
    return Firestore.instance
        .collection('users')
        .document(user.id.getOrCrash());
  }
}

extension DocumentReferenceX on DocumentReference {
  CollectionReference get noteCollection => collection('notes');
}
