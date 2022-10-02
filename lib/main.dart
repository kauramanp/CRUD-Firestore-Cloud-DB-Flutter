import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Users.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('users');
  List<Users> usersList = [];

  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getData();
    });
  }

  Future<void> getData() async {
    Map<String, dynamic> map;
    _users.get().then(
          (res) => {
            if (res.docs.isNotEmpty)
              {
                for (int i = 0; i < res.docs.length; i++)
                  {
                    map = res.docs[i].data() as Map<String, dynamic>,
                    usersList.add(Users.fromJson(map))
                  },
//_users.add(res)
              },
            setState(() {})
          },
          onError: (e) => print("Error completing: $e"),
        );
  }

  Future<void> _showMyDialog() async {
    TextEditingController name = new TextEditingController();
    TextEditingController address = new TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add/update info"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: name,
                ),
                TextField(
                  controller: address,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                if (name.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Enter name'),
                  ));
                } else if (address.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Enter address'),
                  ));
                } else {
                  var users = Users(
                      name: name.text.toString(),
                      address: address.text.toString());
                  _users.add(users.toJson());
                  Navigator.of(context).pop();
                  getData();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: usersList.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(usersList[index].name)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete))
                  ],
                ),
                Text(usersList[index].address)
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: getData,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
