import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/notes/i_note_repository.dart';
import '../../domain/notes/note.dart';
import '../../domain/notes/note_failure.dart';
import '../core/firestore_helpers.dart';
import '../notes/note_dtos.dart';

@LazySingleton(as: INoteRepository)
class NoteRepository implements INoteRepository {
  final Firestore _firestore;

  NoteRepository(this._firestore);

  @override
  Future<Either<NoteFailure, Unit>> create(Note note) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> delete(Note note) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<NoteFailure, Unit>> update(Note note) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchAll() async* {
    // get userDocument using extension function we defined
    final userDoc = await _firestore.userDocument();
    // get noteCollection using extension function
    yield* userDoc.noteCollection
        // order them in descending order of time (latest first)
        .orderBy('serverTimeStamp', descending: true)
        // get snapshots
        .snapshots()
        // map through each snapshot which is always a success case
        .map((snapshot) => right<NoteFailure, KtList<Note>>(
              // get documents for each snapshot
              snapshot.documents
                  // map through each document & return NoteDto
                  .map((doc) => NoteDto.fromFirestore(doc).toDonaim())
                  // convert this iterable to KtList
                  .toImmutableList(),
            ))
        // catch error & return the failure
        .onErrorReturnWith((e) {
      if (e is PlatformException && e.message.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }

  @override
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted() async* {
    // get userDocument using extension function we defined
    final userDoc = await _firestore.userDocument();
    // get noteCollection using extension function
    yield* userDoc.noteCollection
        // order them in descending order of time (latest first)
        .orderBy('serverTimeStamp', descending: true)
        // get snapshots
        .snapshots()
        // map through each snapshot which is always a success case
        .map((snapshot) =>
            // get documents for each snapshot
            snapshot.documents
                // map through each document & return NoteDto
                .map((doc) => NoteDto.fromFirestore(doc).toDonaim()))
        // map through each note entity from previous map
        .map(
          // return right as its always success not failure
          (notes) => right<NoteFailure, KtList<Note>>(
            // filter notes which are not complete i.e. not done
            notes
                .where((note) =>
                    // get each note & get todos for that
                    // if any todo is not done filter it out
                    note.todos.getOrCrash().any((todoItem) => !todoItem.done))
                // convert from iterable to KtList
                .toImmutableList(),
          ),
        )
        // catch error & return the failure
        .onErrorReturnWith((e) {
      if (e is PlatformException && e.message.contains('PERMISSION_DENIED')) {
        return left(const NoteFailure.insufficientPermission());
      } else {
        return left(const NoteFailure.unexpected());
      }
    });
  }
}
