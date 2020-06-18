import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:meta/meta.dart';

import '../../../domain/notes/i_note_repository.dart';
import '../../../domain/notes/note.dart';
import '../../../domain/notes/note_failure.dart';

part 'note_watcher_bloc.freezed.dart';
part 'note_watcher_event.dart';
part 'note_watcher_state.dart';

@injectable
class NoteWatcherBloc extends Bloc<NoteWatcherEvent, NoteWatcherState> {
  final INoteRepository _noteRepository;

  NoteWatcherBloc(this._noteRepository);

  StreamSubscription<Either<NoteFailure, KtList<Note>>> _noteStreamSubscription;

  @override
  NoteWatcherState get initialState => const NoteWatcherState.initial();

  @override
  Stream<NoteWatcherState> mapEventToState(
    NoteWatcherEvent event,
  ) async* {
    yield* event.map(
      // handle watchAll notes event
      watchAllStarted: (e) async* {
        // yield loadInProgress state
        yield const NoteWatcherState.loadInProgress();
        // cancel listening to previous streamSubscriptions
        await _noteStreamSubscription?.cancel();
        // watchAll notes & listen for failureOrNotes
        // when received failureOrNotes add new event notesReceived
        _noteStreamSubscription =
            _noteRepository.watchAll().listen((failureOrNotes) => add(
                  NoteWatcherEvent.notesReceived(failureOrNotes),
                ));
      },
      // handle watchUncompleted notes event
      watchUncompletedStarted: (e) async* {
        // yield loadInProgress state
        yield const NoteWatcherState.loadInProgress();
        // cancel listening to previous streamSubscriptions
        await _noteStreamSubscription?.cancel();
        // watchUncompleted notes & listen for failureOrNotes
        // when received failureOrNotes add new event notesReceived
        _noteStreamSubscription =
            _noteRepository.watchUncompleted().listen((failureOrNotes) => add(
                  NoteWatcherEvent.notesReceived(failureOrNotes),
                ));
      },
      // handle notesReceived event
      notesReceived: (e) async* {
        // yield loadFailure state in case of failure
        // yield loadSuccess state in case of success
        yield e.failureOrNotes.fold(
          (f) => NoteWatcherState.loadFailure(f),
          (notes) => NoteWatcherState.loadSuccess(notes),
        );
      },
    );
  }

  @override
  Future<void> close() async {
    // cancel listening to previous streamSubscriptions
    await _noteStreamSubscription?.cancel();
    return super.close();
  }
}
