import 'package:flutter/material.dart';

class LNURLPoSScaffold extends StatelessWidget {
  LNURLPoSScaffold({
    required this.body,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('LNURLPoS')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'LNURLPoS',
              ),
            ),
            ListTile(
              title: Text('Home'),
              onTap: () {
                print("navigator pop");
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      body: this.body,
    );
  }
}
