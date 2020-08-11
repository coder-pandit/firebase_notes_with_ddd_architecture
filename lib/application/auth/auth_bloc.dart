import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../domain/auth/i_auth_facade.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthFacade _authFacade;

  AuthBloc(this._authFacade) : super(const AuthState.initial());

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    yield* event.map(
      authCheckRequested: (e) async* {
        // get signed in user
        final userOption = await _authFacade.getSignedInUser();
        yield userOption.fold(
          // is it returns none set state unauthenticated
          () => const AuthState.unauthenticated(),
          // if it returns some set state authenticated
          (_) => const AuthState.authenticated(),
        );
      },
      signedOut: (e) async* {
        // sign out user first
        await _authFacade.signOut();
        // set state to unauthenticated
        yield const AuthState.unauthenticated();
      },
    );
  }
}
