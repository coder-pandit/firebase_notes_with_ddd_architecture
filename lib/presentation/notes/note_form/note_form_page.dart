import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/notes/note_form/note_form_bloc.dart';
import '../../../domain/notes/note.dart';
import '../../../injection.dart';
import '../../routes/router.gr.dart';
import 'widgets/notr_form_page_scaffold.dart';
import 'widgets/saving_in_progress_overlay.dart';

class NoteFormPage extends StatelessWidget {
  final Note edittedNote;

  const NoteFormPage({
    Key key,
    @required this.edittedNote,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(edittedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (p, c) =>
            p.saveFailureOrSuccessOption != c.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.fold(
            () {},
            (either) => either.fold(
              (f) => FlushbarHelper.createError(
                message: f.map(
                  insufficientPermission: (_) => 'Insufficient Permission ❌',
                  unableToUpdate: (_) =>
                      "Couldn't update the note. Was it deleted from another computer",
                  unexpected: (_) =>
                      'Unexpected error occured, please contact support.',
                ),
              ).show(context),
              (_) => ExtendedNavigator.of(context).popUntil(
                (route) => route.settings.name == Routes.notesOverviewPage,
              ),
            ),
          );
        },
        buildWhen: (p, c) => p.isSaving != c.isSaving,
        builder: (context, state) {
          return Stack(
            children: [
              const NoteFormPageScaffold(),
              SavingInProgressOverlay(isSaving: state.isSaving),
            ],
          );
        },
      ),
    );
  }
}
