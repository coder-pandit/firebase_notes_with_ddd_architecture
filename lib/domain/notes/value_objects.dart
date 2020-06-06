import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:kt_dart/kt.dart';

import '../core/failures.dart';
import '../core/value_objects.dart';
import '../core/value_transformers.dart';
import '../core/value_validators.dart';

class NoteBody extends ValueObjects<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 1000;

  factory NoteBody(String input) {
    // note body should be non-null
    assert(input != null);
    // validate max note length & note body should not be empty
    return NoteBody._(validateMaxStringLength(input, maxLength)
        .flatMap(validateStringNotEmpty));
  }

  const NoteBody._(this.value);
}

class TodoName extends ValueObjects<String> {
  @override
  final Either<ValueFailure<String>, String> value;

  static const maxLength = 30;

  factory TodoName(String input) {
    // \todo name should be non-null
    assert(input != null);
    // validate max todo length, todo should not be empty
    // & todo should also be single line
    return TodoName._(validateMaxStringLength(input, maxLength)
        .flatMap(validateStringNotEmpty)
        .flatMap(validateSingleLine));
  }

  const TodoName._(this.value);
}

class List3<T> extends ValueObjects<KtList<T>> {
  @override
  final Either<ValueFailure<KtList<T>>, KtList<T>> value;

  static const maxLength = 3;

  factory List3(KtList<T> input) {
    assert(input != null);
    // validate max number of todos allowed
    return List3._(validateMaxListLength(input, maxLength));
  }

  const List3._(this.value);

  // get length of todo list
  int get length => value.getOrElse(() => emptyList()).size;

  // get if todo list is already full i.e. max todos has been added
  bool get isFull => length == maxLength;
}

class NoteColor extends ValueObjects<Color> {
  @override
  final Either<ValueFailure<Color>, Color> value;

  static const List<Color> predefinedColors = [
    Color(0xfffafafa), // canvas
    Color(0xfffa8072), // solomon
    Color(0xfffedc56), // mustard
    Color(0xffd0f0c0), // tea
    Color(0xfffca3b7), // flamingo
    Color(0xff997950), // tortilla
    Color(0xfffffdd0), // cream
  ];

  factory NoteColor(Color input) {
    // color should be non-null
    assert(input != null);
    // remove transparancy from color & make it opaque
    return NoteColor._(right(makeColorOpaque(input)));
  }

  const NoteColor._(this.value);
}
