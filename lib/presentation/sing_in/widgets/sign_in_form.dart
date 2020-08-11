import 'package:auto_route/auto_route.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/auth/auth_bloc.dart';
import '../../../application/auth/sign_in_form/sign_in_form_bloc.dart';
import '../../routes/router.gr.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {
        // check for auth failed or succed
        state.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold((f) {
            // show snackbar on auth failure
            FlushbarHelper.createError(
                message: f.map(
              cancelledByUser: (_) => 'Cancelled',
              serverError: (_) => 'Server Error',
              emailAlreadyInUse: (_) => 'Email already in use',
              invalidEmailAndPassword: (_) =>
                  'Invalid email & password combination',
            )).show(context);
          }, (_) {
            ExtendedNavigator.of(context).replace(Routes.notesOverviewPage);
            context.bloc<AuthBloc>().add(const AuthEvent.authCheckRequested());
          }),
        );
      },
      builder: (context, state) {
        return Form(
          autovalidate: state.showErrorMessages,
          child: ListView(
            padding: const EdgeInsets.all(8),
            children: [
              // notes icon on top
              const Text(
                '📝',
                style: TextStyle(fontSize: 130),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // email text field
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
                autocorrect: false,
                // on text change update email value in bloc
                onChanged: (value) => context
                    .bloc<SignInFormBloc>()
                    .add(SignInFormEvent.emailChanged(value)),
                // validate email using bloc
                validator: (_) => context
                    .bloc<SignInFormBloc>()
                    .state
                    .emailAddress
                    .value
                    .fold(
                      (f) => f.maybeMap(
                        invalidEmail: (_) => 'Invalid Email',
                        orElse: () => null,
                      ),
                      (r) => null,
                    ),
              ),
              const SizedBox(height: 8),
              // password text field
              TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  labelText: 'Password',
                ),
                autocorrect: false,
                obscureText: true,
                // on text change update password value in bloc
                onChanged: (value) => context
                    .bloc<SignInFormBloc>()
                    .add(SignInFormEvent.passwordChanged(value)),
                // validate password for shortPassword using bloc
                validator: (_) =>
                    context.bloc<SignInFormBloc>().state.password.value.fold(
                          (f) => f.maybeMap(
                            shortPassword: (_) => 'Short Password',
                            orElse: () => null,
                          ),
                          (r) => null,
                        ),
              ),
              const SizedBox(height: 8),
              // sign in & register buttons
              Row(
                children: [
                  // sign in button
                  Expanded(
                    child: FlatButton(
                      // sign in user using bloc
                      onPressed: state.isSubmitting == true
                          // if form is submitting disable button
                          ? null
                          : () {
                              context.bloc<SignInFormBloc>().add(
                                  const SignInFormEvent
                                      .signInWithEmailPressed());
                            },
                      child: const Text('SIGN IN'),
                    ),
                  ),
                  // register button
                  Expanded(
                    child: FlatButton(
                      // register user using bloc
                      onPressed: state.isSubmitting == true
                          ? null
                          : () {
                              context.bloc<SignInFormBloc>().add(
                                  const SignInFormEvent
                                      .registerWithEmailPressed());
                            },
                      child: const Text('REGISTER'),
                    ),
                  ),
                ],
              ),
              // google login button
              RaisedButton(
                // authenticate user by google using bloc
                onPressed: state.isSubmitting == true
                    ? null
                    : () {
                        context.bloc<SignInFormBloc>().add(
                            const SignInFormEvent.signInWithGooglePressed());
                      },
                color: Colors.lightBlue,
                child: const Text(
                  'SIGN IN WITH GOOGLE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // while submitting show linear progressbar
              if (state.isSubmitting) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ]
            ],
          ),
        );
      },
    );
  }
}
