part of 'sign_in_form_bloc.dart';

@freezed
abstract class SignInFormEvent with _$SignInFormEvent {
  const factory SignInFormEvent.emailChanged(String emailStr) = EmailChanged;
  const factory SignInFormEvent.passwordChanged(String passwordStr) =
      PasswordChanged;

  const factory SignInFormEvent.registerWithEmailPressed() =
      RegisterWithEmailPressed;
  const factory SignInFormEvent.signInWithEmailPressed() =
      SignInWithEmailPressed;
  const factory SignInFormEvent.signInWithGooglePressed() =
      SignInWithGooglePressed;
}
