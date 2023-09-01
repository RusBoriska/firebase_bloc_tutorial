import 'package:firebase_bloc_tutorial/features/database/bloc/database_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SelectedEntryView extends StatelessWidget {
  const SelectedEntryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DatabaseBloc, DatabaseState>(
      builder: (context, state) {
        if (state is SelectedEntryLoaded) {
          final int selectedIndex = state.selectedIndex;

          //TODO all our texts must be better
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Text(state.listOfEntryData[selectedIndex].title!,
                    style: const TextStyle(color: Colors.green,
                        fontSize: 26,
                        backgroundColor: Colors.black87)),
                  Text(state.listOfEntryData[selectedIndex].text!,
                      style: const TextStyle(fontSize: 20)),
                  Text(state.listOfEntryData[selectedIndex].date!)
                ],
              ),
            ),
          );

        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

