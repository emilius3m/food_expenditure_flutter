import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';


//import 'package:betover/ui/widgets/about_dialog.dart';


class SpesaDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * (3/4),
      child: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/icons/app/logo-big.png"),
                      height: 85,
                      width: 85,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 25, 0),
                      child: Text(
                        'Spesa',
                        style: TextStyle(
                          fontFamily: "Pacifico",
                          color: Colors.red,
                          fontSize: 22
                        ),
                      ),
                    )
                  ]
              ),
              decoration: BoxDecoration(
                color: Colors.orange,
              ),
            ),


            ListTile(
              title: Text('Notifications'),
              enabled: false,
              onTap: null,
            ),
            ListTile(
              title: Text('Config'),
              enabled: false,
              onTap: null,
            ),
            Divider(),

            ListTile(
              title: Text('Help'),
              //onTap: () => launch("http://betover.org", forceSafariVC: false),
            ),
            ListTile(
              title: Text('About'),
              //onTap: () => showBetOverAboutDialog(context)
            ),
          ],
        ),
      ),
    );
  }


}



