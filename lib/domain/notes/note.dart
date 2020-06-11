import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../core/failures.dart';
import '../core/value_objects.dart';
import 'todo_item.dart';
import 'value_objects.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();

  const factory Note({
    @required UniqueId id,
    @required NoteBody body,
    @required NoteColor color,
    @required List3<TodoItem> todos,
  }) = _Note;

  /// return empty [Note] with initial note properties
  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors[0]),
        todos: List3(emptyList()),
      );

  /// failure getter for [Note] entity
  /// return [some] with failed value in case of failure
  /// return [none] in case of no failure
  Option<ValueFailure<dynamic>> get failureOption {
    // only body & todos can fail in this entity
    // as UniqueId is never failing i.e. never returning left value
    // NoteColor is also never failing i.e. never returning left value

    // return body failure if exist
    return body.failureOrUnit
        // if body is not failed check for todos failure
        .andThen(todos.failureOrUnit)
        // if todos not failed check for each todo failure
        // this time getOrCrash won't return crash as we already checked todos didn't failed
        .andThen(
          todos
              // get all todos as it's not going to crash
              .getOrCrash()
              // map each todoItem to their failure value (if exists)
              .map((todoItem) => todoItem.failureOption)
              // filter those todos which has some failure
              .filter((o) => o.isSome())
              // if we can't get 0th element, the filtered list is empty.
              // So all todos are valid return none
              .getOrElse(0, (_) => none())
              // if none => no failure found return right value with unit
              // if some => some failure found return left with failed value
              .fold(() => right(unit), (f) => left(f)),
        )
        // return some with failed value in case of failure
        // return none in case of no failure
        .fold((f) => some(f), (_) => none());
  }
}
