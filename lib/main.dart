import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/webrtc/display_media.dart';
import 'src/route_item.dart';

void main() {
  if (WebRTC.platformIsDesktop) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }
  if (WebRTC.platformIsAndroid) {
    WidgetsFlutterBinding.ensureInitialized();
  }
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

enum DialogDemoAction {
  cancel,
  connect,
}

class _MyAppState extends State<MyApp> {
  List<RouteItem> items = [];
  String _server = '';
  String _name = '';
  late SharedPreferences _prefs;

  @override
  initState() {
    super.initState();
    _initData();
    _initItems();
  }

  _buildRow(context, item) {
    return ListBody(children: [
      ListTile(
        title: Text(item.title),
        onTap: () => item.push(context),
        trailing: Icon(Icons.arrow_right),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('WebRTC'),
        ),
        body: ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0.0),
            itemCount: items.length,
            itemBuilder: (context, i) {
              return _buildRow(context, items[i]);
            }),
      ),
    );
  }

  _initData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _server = _prefs.getString('server') ?? 'demo.cloudwebrtc.com';
      _name = _prefs.getString('name') ?? '';
    });
  }

  void showDemoDialog<T>(
      {required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
      if (value != null) {
        if (value == DialogDemoAction.connect) {
          _prefs.setString('server', _server);
        }
      }
    });
  }

  _showAddressDialog(context, {void Function(BuildContext)? connect}) {
    showDemoDialog<DialogDemoAction>(
      context: context,
      child: AlertDialog(
        title: const Text('Адрес сервера:'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _server,
              onChanged: (String text) {
                setState(() {
                  _server = text;
                });
              },
              decoration: InputDecoration(
                hintText: "Сервер",
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(),
            TextFormField(
              initialValue: _name,
              onChanged: (String text) {
                setState(() {
                  _name = text;
                });
              },
              decoration: InputDecoration(
                hintText: "Имя",
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.pop(context, DialogDemoAction.cancel);
              }),
          TextButton(
            child: const Text('Коннект'),
            onPressed: () {
              if (connect != null) {
                connect(context);
              } else {
                Navigator.pop(context, DialogDemoAction.connect);
              }
            },
          )
        ],
      ),
    );
  }

  _initItems() {
    items = <RouteItem>[
      // RouteItem(
      //     title: 'P2P звонок',
      //     subtitle: 'P2P звонок.',
      //     push: (BuildContext context) {
      //       _datachannel = false;
      //       _showAddressDialog(context);
      //     }),
      RouteItem(
        title: 'Звонок тест',
        subtitle: '',
        push: (BuildContext context) async {
          await _showAddressDialog(
            context,
            connect: (context) {
              _prefs.setString('server', _server);
              _prefs.setString('name', _name);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => GetUserMediaSample(
                  host: _server,
                  name: _name,
                ),
              ));
            },
          );
        },
      ),
    ];
  }
}
