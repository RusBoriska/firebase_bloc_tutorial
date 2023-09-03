import 'package:firebase_bloc_tutorial/features/authentication/authentication_repository_impl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app.dart';
import 'app_bloc_observer.dart';
import 'features/authentication/bloc/authentication_bloc.dart';
import 'features/database/bloc/database_bloc.dart';
import 'features/database/database_repository_impl.dart';
import 'features/form-validation/bloc/form_bloc.dart';
import 'features/new-entry/bloc/new_entry_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';


void main() async {
  // Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  // OneSignal
  //Remove this method to stop OneSignal Debugging
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("b5c3c333-aed2-4cf5-ae0e-8ae82004bff3");

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);

  // AppMetrica
  AppMetrica.activate(AppMetricaConfig("8584099e-f685-4dab-b51d-13429694eab3"));
  AppMetrica.reportEvent('The user has just launched our application.');


  Bloc.observer = AppBlocObserver();
    runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              AuthenticationBloc(AuthenticationRepositoryImpl())
                ..add(AuthenticationStarted()),
        ),
        BlocProvider(
          create: (context) => FormBloc(
              AuthenticationRepositoryImpl(), DatabaseRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) => DatabaseBloc(AuthenticationRepositoryImpl(), DatabaseRepositoryImpl()),
        ),
        BlocProvider(
          create: (context) => NewEntryBloc(
              AuthenticationRepositoryImpl(), DatabaseRepositoryImpl()),
        )
      ],
      child: const App(),
    ));
}
