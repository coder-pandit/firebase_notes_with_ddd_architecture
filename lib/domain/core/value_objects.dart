import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';

import 'errors.dart';
import 'failures.dart';

@immutable
abstract class ValueObjects<T> {
  const ValueObjects();
  Either<ValueFailure<T>, T> get value;

  /// Throws [UnexpectedValueError] containing the [ValueFailure]
  // id = identity - same as writting (right) => right
  T getOrCrash() => value.fold((f) => throw UnexpectedValueError(f), id);

  bool isValid() => value.isRight();

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is ValueObjects<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Value(value: $value)';
}
