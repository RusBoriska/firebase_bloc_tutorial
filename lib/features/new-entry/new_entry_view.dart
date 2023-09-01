import 'package:firebase_bloc_tutorial/features/authentication/bloc/authentication_bloc.dart';
import 'package:firebase_bloc_tutorial/features/database/home_view.dart';
import 'package:firebase_bloc_tutorial/features/form-validation/bloc/form_bloc.dart';
import 'package:firebase_bloc_tutorial/utils/constants.dart';
import 'package:firebase_bloc_tutorial/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/new_entry_bloc.dart';
import 'package:firebase_bloc_tutorial/features/database/bloc/database_bloc.dart';
import 'package:flutter/services.dart';



OutlineInputBorder border = const OutlineInputBorder(
    borderSide: BorderSide(color: Constants.kBorderColor, width: 3.0));

class NewEntryView extends StatelessWidget {
  const NewEntryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
        listeners: [
          BlocListener<NewEntryBloc, NewEntryValidate>(
            listener: (context, state) {
              if (state.errorMessage.isNotEmpty) {
                showDialog(
                    context: context,
                    builder: (context) =>
                        ErrorDialog(errorMessage: state.errorMessage));
              } else if (state.isNewEntryValid && !state.isLoading) {
                // context.read<AuthenticationBloc>().add(AuthenticationStarted());
                // context.read<FormBloc>().add(const FormSucceeded());

                // String? displayName = (context.read<AuthenticationBloc>().state
                // as AuthenticationSuccess)
                //     .displayName;
                // context.read<DatabaseBloc>().add(DatabaseFetched(displayName));
              } else if (state.isNewEntryValidateFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(Constants.textFixIssues)));
              }
            },
          ),
          BlocListener<NewEntryBloc, NewEntryValidate>(
            listener: (context, state) {
              // if (state is AuthenticationSuccess) {
              // if (state.isNewEntrySuccessful && state.isLoading) {
              if (state.isNewEntryValid && state.isLoading) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeView()),
                    (Route<dynamic> route) => false);
              }
            },
          ),
        ],
        child: Scaffold(
            backgroundColor: Constants.kPrimaryColor,
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/sign-in.png"),
                      const Text("Write your entries",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Constants.kBlackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                          )),
                      Padding(
                          padding: EdgeInsets.only(bottom: size.height * 0.02)),
                      const _TitleField(),
                      SizedBox(height: size.height * 0.01),
                      const _TextField(),
                      SizedBox(height: size.height * 0.01),
                      const _SubmitButton()
                    ]),
              ),
            )));
  }
}



class _TitleField extends StatelessWidget {
  const _TitleField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NewEntryBloc, NewEntryValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: border,
              helperText: '''Title must be valid!''',
              helperMaxLines: 2,
              labelText: 'Title',
              errorMaxLines: 2,
              errorText:
                  !state.isTitleValid ? '''Title cannot be empty!''' : null,
            ),
            onChanged: (value) {
              context.read<NewEntryBloc>().add(TitleChanged(value));
            },
          ),
        );
      },
    );
  }
}


class _TextField extends StatelessWidget {
  const _TextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NewEntryBloc, NewEntryValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
              border: border,
              helperText: '''Text must be valid!''',
              helperMaxLines: 2,
              labelText: 'Text',
              errorMaxLines: 2,
              errorText:
              !state.isTextValid ? '''Text cannot be empty!''' : null,
            ),
            maxLines: 3,
            onChanged: (value) {
              context.read<NewEntryBloc>().add(TextChanged(value));
            },
          ),
        );
      },
    );
  }
}


class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NewEntryBloc, NewEntryValidate>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SizedBox(
                width: size.width * 0.8,
                child: OutlinedButton(
                    // (state.isNewEntryValidateFailed)
                  //   onPressed: !state.isNewEntryValid
                  //   // onPressed: (state.isNewEntryValidateFailed == false)
                  // // onPressed: (state.isNewEntryValid == true)
                  //     ? () => context
                  //         .read<NewEntryBloc>()
                  //         .add(const NewEntrySubmitted())
                  //     : null,
                  //
                  onPressed: () {
                    if (!state.isNewEntryValidateFailed) {
                      context.read<NewEntryBloc>().add(const NewEntrySubmitted());
                      String? displayName = (context.read<AuthenticationBloc>().state
                      as AuthenticationSuccess).displayName;
                      context.read<DatabaseBloc>().add(DatabaseFetched(displayName)); // Original
                      // context.read<DatabaseBloc>().add(DatabaseFetched(displayName, state.user));
                    }
                  },
                  // onPressed: () => context
                  //     .read<NewEntryBloc>()
                  //     .add(const NewEntrySubmitted())
                  //     ,
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Constants.kPrimaryColor),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.kBlackColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none)),
                  child: const Text("Send"),
                ),
              );
      },
    );
  }
}

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
