import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';
import 'package:my_notes/domain/notes/note.dart';
import 'package:my_notes/domain/notes/note_failure.dart';

abstract class INoteRepository {
  /// watch notes
  Stream<Either<NoteFailure, KtList<Note>>> watchAll();

  /// watch uncompleted notes
  Stream<Either<NoteFailure, KtList<Note>>> watchUncompleted();

  /// create a new [Note]
  Future<Either<NoteFailure, Unit>> create(Note note);

  /// update an existing [Note]
  Future<Either<NoteFailure, Unit>> update(Note note);

  /// delete an existing [Note]
  Future<Either<NoteFailure, Unit>> delete(Note note);
}
