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
import 'package:Spesa/blocs/filters/filters.dart';
import 'package:spesa_repository/spesa_repository.dart';
import 'package:flutter/services.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';




void main() async {
    await _init();
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = SimpleBlocDelegate();
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  final UserRepository userRepository = UserRepository();
  //final ItemRepository repository = ItemRepository();


  runApp(
      MainApp(userRepository: userRepository)
  );

}



Future<void> _init() async {
    WidgetsFlutterBinding.ensureInitialized();
    //await InAppPurchases.initialize();
    //await Database.initialize();
    //Logger.initialize();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: Colors.black,
        statusBarColor: Colors.transparent,
    ));
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
                        )
                            ..add(AppStarted());
                    },
                ),
                BlocProvider<ListBloc>(
                    create: (context) {
                        return ListBloc(
                            itemRepository: FirebaseSpesaRepository(uid),
                        )
                            ..add(LoadaList());
                    },
                ),
                BlocProvider<FiltersBloc>(
                    create: (context) =>
                        FiltersBloc(
                            listBloc: BlocProvider.of<ListBloc>(context),
                        ),
                ),
            ],
            child: BlocProvider(
                create: (context) => ThemeBloc(),
                child: BlocBuilder<ThemeBloc, ThemeState>(
                    builder: _buildWithTheme,
                ),
            ),
        );
    }
            Widget _buildWithTheme(BuildContext context, ThemeState state) {
            return
            MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: state.themeData,
                //darkTheme: Themes.getDarkTheme(),
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
                                        ],
                                        child: HomeScreen(username: state.displayName, fbaseuid:state.uid),
                                    );
                                }
                                if (state is Unauthenticated) {
                                    return LoginScreen(userRepository: _userRepository);
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
                    },
                },
                initialRoute: '/splash',

        );
    }
}


