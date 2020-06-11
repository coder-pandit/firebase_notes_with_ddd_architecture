import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/failures.dart';
import '../core/value_objects.dart';
import 'value_objects.dart';

part 'todo_item.freezed.dart';

@freezed
abstract class TodoItem implements _$TodoItem {
  const TodoItem._();

  const factory TodoItem({
    @required UniqueId id,
    @required TodoName name,
    @required bool done,
  }) = _TodoItem;

  /// return empty [TodoItem] with initial TodoItem properties
  factory TodoItem.empty() => TodoItem(
        id: UniqueId(),
        name: TodoName(''),
        done: false,
      );

  /// failure getter for [TodoItem] entity
  /// return [some] with failed value in case of failure
  /// return [none] in case of no failure
  Option<ValueFailure<dynamic>> get failureOption =>
      // only todo name can fail in this entity
      // as UniqueId is never failing i.e. never returning left value
      // done is a bool value which can't fail
      name.value.fold((f) => some(f), (_) => none());
}
