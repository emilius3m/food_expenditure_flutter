import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Spesa/authentication_bloc/authentication_bloc.dart';
import 'package:Spesa/models/models.dart';
import 'package:Spesa/user_repository.dart';
import 'package:Spesa/simple_bloc_delegate.dart';

import 'package:Spesa/blocs/blocs.dart';
import 'package:Spesa/widgets/widgets.dart';
import 'package:Spesa/screens/screens.dart';
import 'package:Spesa/widgets/spesa_drawer.dart';
import 'package:Spesa/widgets/filters.dart';
import 'package:spesa_repository/spesa_repository.dart';
import 'package:Spesa/blocs/filters/filters.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  final String fbaseuid;

  HomeScreen({Key key, @required this.name,@required this.fbaseuid}) : super(key: key);



   _redirectToPage(BuildContext context, Widget page){
      WidgetsBinding.instance.addPostFrameCallback((_){
          MaterialPageRoute newRoute = MaterialPageRoute(
              builder: (BuildContext context) => page
          );

          Navigator.of(context).pushAndRemoveUntil(newRoute, ModalRoute.withName('/'));
      });
  }

  @override
  Widget build(BuildContext context) {
      //print (name);
      //print (fbaseuid);
      return BlocBuilder<TabBloc, AppTab>(
          builder: (context, activeTab) {
              return Scaffold(
                  ///////drawer: SpesaDrawer(),
                  appBar: AppBar(

                      backgroundColor: Colors.white,
                      title: Text('Hi $name!',
                          style: TextStyle(color:Color(0xFF18D191))
                           ),
                      actions: <Widget>[
                          BlocBuilder<FiltersBloc, FiltersState>(
                              builder: (context, state) =>
                                  IconButton(
                                      icon: state.isEnabled
                                          ? const Icon(Icons.filter_list, color: Colors.red)
                                          : const Icon(Icons.filter_list, color: Colors.green),
                                      tooltip: 'Filtrare',
                                      onPressed: () {
                                          return showGeneralDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              transitionDuration: Duration(milliseconds: 500),
                                              barrierLabel: MaterialLocalizations.of(context).dialogLabel,
                                              pageBuilder: (_, __, ___) => Filters(),
                                              transitionBuilder: (context, animation, secondaryAnimation, child) {
                                                  return SlideTransition(
                                                      position: CurvedAnimation(
                                                          parent: animation,
                                                          curve: Curves.easeOut,
                                                      ).drive(Tween<Offset>(
                                                          begin: Offset(0, -1.0),
                                                          end: Offset.zero,
                                                      )),
                                                      child: child,
                                                  );
                                              },
                                          );
                                      },
                                  )
                          ),
                            BlocBuilder<FiltersBloc, FiltersState>(
                            builder: (context, state) =>
                                IconButton(

                                    icon: Icon(Icons.view_list,color: Color(0xFF18D191)),


                                    onPressed: () {
                                        BlocProvider.of<FiltersBloc>(context).add(UpdateListGrid(!(state as FilteredItemsLoaded).activeFilter));
                                    }
                                    )
                            ),
                          //ExtraActions(),
                          IconButton(
                              icon: Icon(Icons.info,color: Color(0xFF18D191)),
                              onPressed: () {
                                 _redirectToPage(context, AboutPage());
                              }),

                          //LogOutButton(),
                          IconButton(
                              icon: Icon(
                                  Icons.close,
                                  color: Color(0xFF18D191),
                              ),
                              onPressed: () {
                                  BlocProvider.of<AuthenticationBloc>(context).add(
                                      LoggedOut());
                              },
                          ),
                          IconButton(
                              tooltip: "Back",
                              icon: Icon(Icons.backspace,color: Color(0xFF18D191)),
                              onPressed: () {
                                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                                  //Navigator.of(context).pushReplacementNamed('/');
                              })

                      ],



                  ),
                  body: activeTab == AppTab.spesa ? FilteredItems() : AddEditScreen(
                      onSave: (product, note,quantity,fileName,selectedType) {
                          ///print ("$product $note $fileName $selectedType");
                          BlocProvider.of<ListBloc>(context).add(
                              AddItem(Item( product, note: note,quantity:quantity,type:selectedType,imageurl:fileName )),
                          );
                          BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.spesa));
                          Navigator.pushNamed(context, '/');
                      },
                      isEditing: false,
                  ),

                  //body:  FilteredItems() ,

                  /*floatingActionButton: FloatingActionButton(
                      onPressed: () {
                          Navigator.pushNamed(context, '/addItem');
                      },
                      child: Icon(Icons.add),
                      tooltip: 'Add Item',
                  ),*/
                  bottomNavigationBar: TabSelector(
                      activeTab: activeTab,
                      onTabSelected: (tab) =>
                          BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
                  ),
              );
          },
      );
  }
}






