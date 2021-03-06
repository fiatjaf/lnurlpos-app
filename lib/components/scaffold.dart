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
              title: Text('Point-of-Sale'),
              onTap: () {
                Navigator.of(context).popAndPushNamed('/pos');
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).popAndPushNamed('/settings');
              },
            ),
          ],
        ),
      ),
      body: this.body,
    );
  }
}
