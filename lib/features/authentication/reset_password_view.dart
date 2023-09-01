import 'package:firebase_bloc_tutorial/features/authentication/bloc/authentication_bloc.dart';
import 'package:firebase_bloc_tutorial/features/authentication/sign_in_view.dart';
import 'package:firebase_bloc_tutorial/features/database/home_view.dart';
import 'package:firebase_bloc_tutorial/features/form-validation/bloc/form_bloc.dart';
import 'package:firebase_bloc_tutorial/features/form-validation/sign_up_view.dart';
import 'package:firebase_bloc_tutorial/utils/constants.dart';
import 'package:firebase_bloc_tutorial/welcome_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

OutlineInputBorder border = const OutlineInputBorder(
    borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsValidate>(
          listener: (context, state) {
            print('state.isFormValidateFailed is ${state.isFormValidateFailed}');
            print('state.isFormValid is ${state.isFormValid}');
            print('state.isLoading is ${state.isLoading}');

            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(errorMessage: state.errorMessage));
            } else if (state.isFormValid && !state.isLoading && state.isEmailReset) {
              //TODO Use the event for reset
              // context.read<AuthenticationBloc>().add(AuthenticationStarted());
              // context.read<AuthenticationBloc>().add(PasswordReset('zizix@mail.ru'));
              context.read<AuthenticationBloc>().add(PasswordReset(state.email));
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(Constants.textResetSuccess)));
              // Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignInView()));
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(Constants.textFixIssues)));
              //TODO Delete later
              // context.read<AuthenticationBloc>().add(PasswordReset('zizix@mail.ru'));
              // context.read<AuthenticationBloc>().add(PasswordReset(state.email));
            }
          },
        ),
        //TODO If we need to send user to another screen
        // BlocListener<AuthenticationBloc, AuthenticationState>(
        //   listener: (context, state) {
        //     if (state is AuthenticationSuccess) {
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(builder: (context) => const HomeView()),
        //           (Route<dynamic> route) => false);
        //     }
        //   },
        // ),
      ],
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            systemOverlayStyle:
                const SystemUiOverlayStyle(statusBarColor: Colors.white),
          ),
          backgroundColor: Constants.kPrimaryColor,
          body: Center(
              child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset("assets/images/sign-in.png"),
              RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: Constants.textSignInTitle,
                        style: TextStyle(
                          color: Constants.kBlackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        )),
                  ])),
              SizedBox(height: size.height * 0.01),
              const Text(
                Constants.textSmallSignIn,
                style: TextStyle(color: Constants.kDarkGreyColor),
              ),
              Padding(padding: EdgeInsets.only(bottom: size.height * 0.02)),
              const _EmailField(),
              // SizedBox(height: size.height * 0.01),
              // const _PasswordField(),
              SizedBox(height: size.height * 0.01),
              const _ResetButton(),
              //     const _ResetPassword(),
              // const _SignInNavigate(),
            ]),
          ))),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
              onChanged: (value) {
                context.read<FormBloc>().add(EmailChanged(value));
              },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                helperText: 'A complete, valid email e.g. joe@gmail.com',
                errorText: !state.isEmailValid
                    ? 'Please ensure the email entered is valid'
                    : null,
                hintText: 'Email',
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 10.0),
                border: border,
              )),
        );
      },
    );
  }
}

// class _PasswordField extends StatelessWidget {
//   const _PasswordField({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return BlocBuilder<FormBloc, FormsValidate>(
//       builder: (context, state) {
//         return SizedBox(
//           width: size.width * 0.8,
//           child: TextFormField(
//             obscureText: true,
//             decoration: InputDecoration(
//               contentPadding:
//                   const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
//               border: border,
//               helperText:
//                   '''Password should be at least 8 characters with at least one letter and number''',
//               helperMaxLines: 2,
//               labelText: 'Password',
//               errorMaxLines: 2,
//               errorText: !state.isPasswordValid
//                   ? '''Password must be at least 8 characters and contain at least one letter and number'''
//                   : null,
//             ),
//             onChanged: (value) {
//               context.read<FormBloc>().add(PasswordChanged(value));
//             },
//           ),
//         );
//       },
//     );
//   }
// }


class _ResetButton extends StatelessWidget {
  const _ResetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
          width: size.width * 0.8,
          child: OutlinedButton(
            onPressed: !state.isFormValid
            //TODO An event for reset
                ? () => context
                .read<FormBloc>()
                // .add(const FormSubmitted(value: Status.signIn))
                .add(PasswordResetChanged(state.email))
                : null,
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    Constants.kPrimaryColor),
                backgroundColor: MaterialStateProperty.all<Color>(
                    Constants.kBlackColor),
                side: MaterialStateProperty.all<BorderSide>(
                    BorderSide.none)),
            child: const Text(Constants.textResetButton),
          ),
        );
      },
    );
  }
}




// class _SubmitButton extends StatelessWidget {
//   const _SubmitButton({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return BlocBuilder<FormBloc, FormsValidate>(
//       builder: (context, state) {
//         return state.isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : SizedBox(
//                 width: size.width * 0.8,
//                 child: OutlinedButton(
//                   onPressed: !state.isFormValid
//                       ? () => context
//                           .read<FormBloc>()
//                           .add(const FormSubmitted(value: Status.signIn))
//                       : null,
//                   style: ButtonStyle(
//                       foregroundColor: MaterialStateProperty.all<Color>(
//                           Constants.kPrimaryColor),
//                       backgroundColor: MaterialStateProperty.all<Color>(
//                           Constants.kBlackColor),
//                       side: MaterialStateProperty.all<BorderSide>(
//                           BorderSide.none)),
//                   child: const Text(Constants.textSignIn),
//                 ),
//               );
//       },
//     );
//   }
// }



// class _ResetPassword extends StatelessWidget {
//   const _ResetPassword({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return BlocBuilder<FormBloc, FormsValidate>(
//       builder: (context, state) {
//         return RichText(
//             textAlign: TextAlign.center,
//             text: TextSpan(children: <TextSpan>[
//               const TextSpan(
//                   text: Constants.textForgotten,
//                   style: TextStyle(
//                     color: Constants.kDarkGreyColor,
//                   )),
//               TextSpan(
//                   recognizer: TapGestureRecognizer()
//                     ..onTap = () => {
//
//                     //TODO Use that code from the site
//                       const _PasswordField(),
//                       const _SubmitButton(),
//
//
//                       // Navigator.of(context).pop(),
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => const SignUpView()),
//                       // )
//                     },
//                   text: Constants.textReset,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Constants.kDarkBlueColor,
//                   )),
//             ]));
//       },
//     );
//   }
// }


// class _SignInNavigate extends StatelessWidget {
//   const _SignInNavigate({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//         textAlign: TextAlign.center,
//         text: TextSpan(children: <TextSpan>[
//           const TextSpan(
//               text: Constants.textAcc,
//               style: TextStyle(
//                 color: Constants.kDarkGreyColor,
//               )),
//           TextSpan(
//               recognizer: TapGestureRecognizer()
//                 ..onTap = () => {
//                       Navigator.of(context).pop(),
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const SignUpView()),
//                       )
//                     },
//               text: Constants.textSignUp,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Constants.kDarkBlueColor,
//               )),
//         ]));
//   }
// }

class ErrorDialog extends StatelessWidget {
  final String? errorMessage;
  const ErrorDialog({Key? key, required this.errorMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Error"),
      content: Text(errorMessage!),
      actions: [
        TextButton(
          child: const Text("Ok"),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
