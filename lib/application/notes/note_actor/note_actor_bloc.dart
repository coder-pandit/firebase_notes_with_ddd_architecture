import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../domain/notes/i_note_repository.dart';
import '../../../domain/notes/note.dart';
import '../../../domain/notes/note_failure.dart';

part 'note_actor_bloc.freezed.dart';
part 'note_actor_event.dart';
part 'note_actor_state.dart';

@injectable
class NoteActorBloc extends Bloc<NoteActorEvent, NoteActorState> {
  final INoteRepository _noteRepository;

  NoteActorBloc(this._noteRepository) : super(const NoteActorState.initial());

  @override
  Stream<NoteActorState> mapEventToState(
    NoteActorEvent event,
  ) async* {
    // this bloc has just one event so we don't have to use events.map
    // instead we just start mapping our event directly

    // yield actionInProgress state
    yield const NoteActorState.actionInProgress();
    // delete the note from repository
    final possibleFailure = await _noteRepository.delete(event.note);
    // yield deleteFailure state in case of deletion failure
    // in case of success yield deleteSuccess state
    yield possibleFailure.fold(
      (f) => NoteActorState.deleteFailure(f),
      (r) => const NoteActorState.deleteSuccess(),
    );
  }
}
