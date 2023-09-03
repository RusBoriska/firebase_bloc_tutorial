import 'package:firebase_bloc_tutorial/features/database/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import 'package:firebase_ui_firestore/firebase_ui_firestore.dart'; // For lazy loading/pagination
import 'package:cloud_firestore/cloud_firestore.dart'; // For my attempt for pagination


import 'package:firebase_bloc_tutorial/features/authentication/bloc/authentication_bloc.dart';
import 'package:firebase_bloc_tutorial/features/database/bloc/database_bloc.dart';
import 'package:firebase_bloc_tutorial/features/database/selected_entry_view.dart';
import 'package:firebase_bloc_tutorial/features/new-entry/new_entry_view.dart';
import 'package:firebase_bloc_tutorial/utils/constants.dart';
import 'package:firebase_bloc_tutorial/welcome_view.dart';


class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationFailure) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const WelcomeView()),
              (Route<dynamic> route) => false);
        }
      },
      buildWhen: ((previous, current) {
        if (current is AuthenticationFailure) {
          return false;
        }
        return true;
      }),
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      context
                          .read<AuthenticationBloc>()
                          .add(AuthenticationSignedOut());
                    }),
                IconButton(
                    icon: const Icon(
                      Icons.update,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      String? displayName = (context.read<AuthenticationBloc>().state
                      as AuthenticationSuccess)
                          .displayName;
                      context.read<DatabaseBloc>().add(DatabaseFetched(displayName));
                    })
              ],
              systemOverlayStyle:
                  const SystemUiOverlayStyle(statusBarColor: Colors.blue),
              title: Text((state as AuthenticationSuccess).displayName!),
            ),
            body: BlocConsumer<DatabaseBloc, DatabaseState>(
              listener: (context, state) {
                if (state is SelectedEntryLoaded) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SelectedEntryView()));
                }
              },
              builder: (context, state) {
                String? displayName = (context.read<AuthenticationBloc>().state
                        as AuthenticationSuccess)
                    .displayName;
                if (state is DatabaseSuccess &&
                    displayName !=
                        (context.read<DatabaseBloc>().state as DatabaseSuccess)
                            .displayName) {
                  context.read<DatabaseBloc>().add(DatabaseFetched(displayName)); //Original
                  // context.read<DatabaseBloc>().add(DatabaseFetched(displayName, state.listOfUserData.first));
                }
                if (state is DatabaseInitial) {
                  context.read<DatabaseBloc>().add(DatabaseFetched(displayName)); //Original
                  // context.read<DatabaseBloc>().add(DatabaseFetched(displayName, state.)); // TODO
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DatabaseSuccess) {
                  if (state.listOfEntryData.isEmpty) {
                    return const Center(
                      child: Text(Constants.textNoData),
                    );
                  } else {
                    return _buildListView(context, state); // Original
                    // return _buildFirestoreListView(context, state); // From the third-part package
                    // return _buildPaginatingListView(context, state); //My attempt for pagination
                  }
                } else if (state is SelectedEntryLoaded) {
                    return _buildListView(context, state);
                }
                else {
                  return const Center(child: CircularProgressIndicator());
                }

              },
            ),
            floatingActionButton: FloatingActionButton (
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewEntryView()),
                );
              },
              backgroundColor: Colors.blue,
              child: const Icon(Icons.add),
            )
        );
      },
    );
  }


  _buildListView(BuildContext context, state) {
    return Center(
      child: ListView.builder(
        itemCount: state.listOfEntryData.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(
                  state.listOfEntryData[index].title!),
              subtitle:
              Text(state.listOfEntryData[index].date!),
              trailing:
              // const Icon(Icons.delete),
              IconButton(onPressed: () {
                context.read<DatabaseBloc>().add(EntryDeleteRequest(state.listOfEntryData[index].uid));
                  String? displayName = (context.read<AuthenticationBloc>().state
                  as AuthenticationSuccess)
                      .displayName;
                  context.read<DatabaseBloc>().add(DatabaseFetched(displayName));
              }, icon: const Icon(Icons.delete)),

              onTap: () {
                context.read<DatabaseBloc>().add(EntrySelected(index)); // Original
                AppMetrica.reportEvent('The index of EntrySelected is $index');
              },
            ),
          );
        },
      ),
    );
  }



  //My attempt for pagination
  // _buildPaginatingListView(BuildContext context, state) {
  //   final db = FirebaseFirestore.instance;
  //
  //   final first = db.collection('zizix@mail.ru').orderBy('date').limit(10);
  //
  //
  //   // Construct query for first 25 cities, ordered by population
  //   // final first = db.collection("cities").orderBy("population").limit(25);
  //
  //   first.get().then(
  //         (documentSnapshots) {
  //       // Get the last visible document
  //       final lastVisible = documentSnapshots.docs[documentSnapshots.size - 1];
  //
  //       // Construct a new query starting at this document,
  //       // get the next 25 cities.
  //       final next = db
  //           .collection("zizix@mail.ru")
  //           .orderBy("date")
  //           .startAfter([lastVisible]).limit(10);
  //
  //       // Use the query for pagination
  //       // ...
  //     },
  //     onError: (e) => print("Error completing: $e"),
  //   );
  //
  //
  //   return Center(
  //     child: ListView.builder(
  //       // itemCount: state.listOfEntryData.length,
  //       itemCount: first.
  //       state.listOfEntryData.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Card(
  //           child: ListTile(
  //             title: Text(
  //                 state.listOfEntryData[index].title!),
  //             subtitle:
  //             Text(state.listOfEntryData[index].date!),
  //             trailing:
  //             // const Icon(Icons.delete),
  //             IconButton(onPressed: () {
  //               //TODO Event for deleting this entry
  //               print('I want to delete this entry');
  //               print('uid of this entry is ${state.listOfEntryData[index].uid}');
  //
  //               context.read<DatabaseBloc>().add(EntryDeleteRequest(state.listOfEntryData[index].uid));
  //
  //               // onPressed: () async {
  //               String? displayName = (context.read<AuthenticationBloc>().state
  //               as AuthenticationSuccess)
  //                   .displayName;
  //               context.read<DatabaseBloc>().add(DatabaseFetched(displayName));
  //               // })
  //
  //
  //
  //
  //             }, icon: const Icon(Icons.delete)),
  //
  //             onTap: () {
  //               context.read<DatabaseBloc>().add(EntrySelected(index)); // Original
  //               // context.read<DatabaseBloc>().add(EntrySelected(state.listOfUserData.first, index));
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }


  // ListView with pagination using the third-part package
  // _buildFirestoreListView(BuildContext context, state) {
  //   final usersQuery = FirebaseFirestore.instance.collection('zizix@mail.ru').orderBy('date');
  //   return Center(
  //     child:
  //     FirestoreListView<Map<String, dynamic>>(
  //       query: usersQuery,
  //       pageSize: 10,
  //       itemBuilder: (context, snapshot) {
  //         Map<String, dynamic> user = snapshot.data();
  //         return Card(
  //           child: ListTile(
  //             title: Text(
  //                 // state.listOfEntryData[index].title!
  //                 user['title']
  //             ),
  //             subtitle:
  //             Text(
  //                 // state.listOfEntryData[index].date!
  //                 user['date']
  //             ),
  //             trailing:
  //             // const Icon(Icons.delete),
  //             IconButton(onPressed: () {
  //               //TODO Event for deleting this entry
  //               // print('I want to delete this entry');
  //               // print('uid of this entry is ${state.listOfEntryData[index].uid}');
  //               //
  //               // context.read<DatabaseBloc>().add(EntryDeleteRequest(state.listOfEntryData[index].uid));
  //               //
  //               // // onPressed: () async {
  //               // String? displayName = (context.read<AuthenticationBloc>().state
  //               // as AuthenticationSuccess)
  //               //     .displayName;
  //               // context.read<DatabaseBloc>().add(DatabaseFetched(displayName));
  //               // // })
  //             }, icon: const Icon(Icons.delete)),
  //
  //             onTap: () {
  //               // context.read<DatabaseBloc>().add(EntrySelected(index)); // Original
  //               print('usersQuery is $usersQuery');
  //               print('user is $user');
  //               print('snapshot is $snapshot');
  //               print('snapshot.data().entries is ${snapshot.data().entries}');
  //
  //
  //             },
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

}
