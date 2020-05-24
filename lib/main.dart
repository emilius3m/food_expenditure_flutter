import 'package:Spesa/blocs/list/list_event.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/authentication_bloc/authentication_bloc.dart';
import 'package:Spesa/blocs/blocs.dart';
import 'package:Spesa/user_repository.dart';

import 'package:Spesa/home_screen.dart';
import 'package:Spesa/login/login.dart';
import 'package:Spesa/simple_bloc_delegate.dart';
import 'package:Spesa/screens/add_edit_screen.dart';
import 'package:Spesa/screens/splash_page.dart';
import 'package:Spesa/repository/item_repository.dart';

import 'package:Spesa/blocs/filters/filters.dart';

import 'package:spesa_repository/spesa_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  final ItemRepository repository = ItemRepository();


  runApp(MainApp(userRepository: userRepository));
  /*runApp(
    BlocProvider(
      create: (context) => AuthenticationBloc(
        userRepository: userRepository,
      )..add(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );*/
}


class MainApp extends StatelessWidget {

    final UserRepository _userRepository;

     String uid;

    MainApp({Key key, @required UserRepository userRepository})
        : assert(userRepository != null),
            _userRepository = userRepository,
            //_itemRepository = itemRepository,
            super(key: key);




    @override
    Widget build(BuildContext context) {
        return MultiBlocProvider(
            providers: [

                BlocProvider<AuthenticationBloc>(
                    create: (context) {
                        return AuthenticationBloc(
                            userRepository: _userRepository,
                        )..add(AppStarted());
                    },
                ),
                BlocProvider<ListBloc>(
                    create: (context) {
                        return ListBloc(
                            itemRepository: FirebaseSpesaRepository(uid),
                        )..add(LoadaList());
                    },
                ),
                BlocProvider<FiltersBloc>(
                    create: (context) => FiltersBloc(
                        listBloc: BlocProvider.of<ListBloc>(context),
                    ),
                ),

            ],
            child: MaterialApp(
                debugShowCheckedModeBanner: false,

                title: 'Spesa ',
                routes: {
                    '/splash': (_) => SplashScreenPage(),
                    '/': (context) {
                        return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, state) {
                                if (state is Authenticated) {
                                    uid=state.uid;
                                    //return HomeScreen(name: state.displayName);
                                    return MultiBlocProvider(
                                        providers: [
                                            BlocProvider<TabBloc>(
                                                create: (context) => TabBloc(),
                                            ),


                                            /*BlocProvider<StatsBloc>(
                                                create: (context) => StatsBloc(
                                                    todosBloc: BlocProvider.of<TodosBloc>(context),
                                                ),
                                            ),

                                             */
                                        ],
                                        child: HomeScreen(name: state.displayName,fbaseuid:state.uid),
                                    );
                                }
                                if (state is Unauthenticated) {
                                    return LoginScreen(userRepository: _userRepository);
                                    /*return Center(
                                        child: Text('Could not authenticate with Firestore'),
                                    );*/
                                }
                                return Center(child: CircularProgressIndicator());
                            },
                        );
                    },
                    '/addItem': (context) {
                        return AddEditScreen(
                            onSave: (product, note,quantity,fileName,selectedType) {
                                print ("$product $note $fileName $selectedType");
                                BlocProvider.of<ListBloc>(context).add(
                                    AddItem(Item( product, note: note,quantity:quantity,type:selectedType,imageurl:fileName )),
                                );
                            },
                            isEditing: false,
                        );
                        //return null;
                    },
                },
                initialRoute: '/splash',
            ),
        );
    }
}


/*
class App extends StatelessWidget {
  final UserRepository _userRepository;

  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is Authenticated) {
            return HomeScreen(name: state.displayName);
          }
          return SplashScreen();
        },
      ),
    );
  }
}
*/
