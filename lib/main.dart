import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PermissionStatus? per;
  Contact? contact;

  void _incrementCounter() async {
    per = await Permission.contacts.status;
    setState(() {
      debugPrint('permission status $per');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'permission status ',
              // style: Theme.of(context).textTheme.headline6,
            ),
            ElevatedButton(
              child: const Text('Contact'),
              onPressed: () async {
                final req = await Permission.contacts.request();
                if (req.isDenied == false) {
                  final contact = await FlutterContacts.openExternalPick();
                  debugPrint(
                      'FlutterContacts.openExternalPick ${contact?.phones[0].number}');
                  await contact?.delete();
                  // ContactsService.openDeviceContactPicker()
                  //     .then((Contact? value) {
                  //   contact = value ?? contact;
                  //   setState(() {});
                  //   debugPrint(
                  //     'get contact from phone ${value?.phones?[0].value}',
                  //   );
                  //   debugPrint(
                  //     'get contact from phone ${value?.phones?[0].label}',
                  //   );
                  // });
                } else if (req.isDenied == true) {
                  debugPrint('request permission is denied ${req.isDenied}');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content:
                            const Text('to open app settings tab to button'),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                openAppSettings();
                              },
                              child: const Text('open app settings')),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
